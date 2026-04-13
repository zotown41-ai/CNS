param(
    [switch]$SkipWeeklyGeneration,
    [switch]$SkipDailyGeneration,
    [switch]$SkipPush,
    [switch]$AllowEmptyCommit,
    [int]$DailyOffset = -1,
    [switch]$ScheduledPublish,
    [ValidateSet("Manual", "Auto", "Primary", "VerifyRetry")]
    [string]$PublishPhase = "Manual",
    [string]$TimezoneId = "China Standard Time"
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$env:PYTHONIOENCODING = "utf-8"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$WorkspaceRoot = Split-Path -Parent $RepoRoot
$WeeklyProject = Join-Path $WorkspaceRoot "CNS周报"
$DailyProject = Join-Path $WorkspaceRoot "paper-overview-extractor-RSS"
$WeeklyReportsRoot = Join-Path $WeeklyProject "reports"
$DailyOutputRoot = Join-Path $DailyProject "output"
$WeeklyDest = Join-Path $RepoRoot "[周报]"
$DailyDest = Join-Path $RepoRoot "[日报]"
$NoBomUtf8 = [System.Text.UTF8Encoding]::new($false)

function Write-Info([string]$Message) {
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success([string]$Message) {
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Require-Path([string]$Path, [string]$Label) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Label 不存在：$Path"
    }
}

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Get-LocalNow([string]$ZoneId) {
    try {
        $tz = [System.TimeZoneInfo]::FindSystemTimeZoneById($ZoneId)
        return [System.TimeZoneInfo]::ConvertTime([datetimeoffset]::UtcNow, $tz).DateTime
    } catch {
        return Get-Date
    }
}

function Resolve-PublishPhase([datetime]$Now, [string]$RequestedPhase, [bool]$IsScheduledMode) {
    if (-not $IsScheduledMode -and $RequestedPhase -eq "Manual") {
        return "Manual"
    }

    if ($RequestedPhase -eq "Primary" -or $RequestedPhase -eq "VerifyRetry") {
        return $RequestedPhase
    }

    if ($Now.TimeOfDay -ge ([TimeSpan]::FromHours(8))) {
        return "VerifyRetry"
    }
    return "Primary"
}

function Get-ExpectedWeeklyRange([datetime]$Now) {
    $today = $Now.Date
    $monday = $today.AddDays(-[int]$today.DayOfWeek + 1)
    if ($today.DayOfWeek -eq [System.DayOfWeek]::Sunday) {
        $start = $monday
        $end = $monday.AddDays(6)
    } else {
        $end = $monday.AddDays(-1)
        $start = $end.AddDays(-6)
    }

    return [PSCustomObject]@{
        StartDate = $start.ToString("yyyy-MM-dd")
        EndDate = $end.ToString("yyyy-MM-dd")
        Id = "{0}_{1}" -f $start.ToString("yyyy-MM-dd"), $end.ToString("yyyy-MM-dd")
        Label = "{0} ~ {1}" -f $start.ToString("yyyy-MM-dd"), $end.ToString("yyyy-MM-dd")
    }
}

function Write-Utf8File([string]$Path, [string]$Content) {
    $dir = Split-Path -Parent $Path
    if ($dir) {
        Ensure-Dir $dir
    }
    [System.IO.File]::WriteAllText($Path, $Content, $NoBomUtf8)
}

function Invoke-Native([string]$FilePath, [string[]]$Arguments, [string]$WorkingDirectory) {
    Push-Location $WorkingDirectory
    try {
        $renderedArgs = if ($Arguments) { $Arguments -join " " } else { "" }
        Write-Info ("运行：{0} {1}" -f $FilePath, $renderedArgs)
        & $FilePath @Arguments
        $exitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }

    if ($null -eq $exitCode) {
        $exitCode = 0
    }
    if ($exitCode -ne 0) {
        throw "命令执行失败（exit=$exitCode）：$FilePath"
    }
}

function Get-LatestReportDirectory([string]$Root) {
    Require-Path $Root "报告根目录"
    $dir = Get-ChildItem -LiteralPath $Root -Directory |
        Sort-Object LastWriteTime -Descending |
        Where-Object {
            (Get-ChildItem -LiteralPath $_.FullName -File -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
        } |
        Select-Object -First 1

    if (-not $dir) {
        throw "未找到可用报告目录：$Root"
    }
    return $dir
}

function Reset-Dir([string]$Path) {
    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
    New-Item -ItemType Directory -Path $Path | Out-Null
}

function Get-DailyReportEntries([string]$Root) {
    Require-Path $Root "日报输出目录"
    $pattern = '^文献追踪报告-(\d{4}-\d{2}-\d{2})-(\d{4}-\d{2}-\d{2})-多期刊(?:-v(\d+))?$'
    $candidates = foreach ($dir in Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue) {
        if ($dir.Name -match $pattern -and $matches[1] -eq $matches[2]) {
            $html = Join-Path $dir.FullName "weekly_report.html"
            $md = Join-Path $dir.FullName "weekly_report.md"
            $json = Join-Path $dir.FullName "weekly_records.json"
            if ((Test-Path -LiteralPath $html) -and (Test-Path -LiteralPath $md) -and (Test-Path -LiteralPath $json)) {
                [PSCustomObject]@{
                    Date = $matches[1]
                    Version = if ($matches[3]) { [int]$matches[3] } else { 1 }
                    FullName = $dir.FullName
                    Name = $dir.Name
                    LastWriteTime = $dir.LastWriteTime
                }
            }
        }
    }

    $result = @()
    foreach ($group in ($candidates | Group-Object Date)) {
        $selected = $group.Group |
            Sort-Object @{ Expression = 'Version'; Descending = $true }, @{ Expression = 'LastWriteTime'; Descending = $true } |
            Select-Object -First 1
        if ($selected) {
            $result += $selected
        }
    }

    return @($result | Sort-Object Date -Descending)
}

function Get-DailyEntryByDate([object[]]$Entries, [string]$DateText) {
    return @(
        $Entries |
        Where-Object { $_.Date -eq $DateText } |
        Sort-Object @{ Expression = 'Version'; Descending = $true }, @{ Expression = 'LastWriteTime'; Descending = $true } |
        Select-Object -First 1
    )[0]
}

function Get-WeeklyReportEntries([string]$Root) {
    Require-Path $Root "周报输出目录"
    $pattern = '^文献追踪报告-(\d{4}-\d{2}-\d{2})-(\d{4}-\d{2}-\d{2})-(.+?)(?:-(\d+))?$'
    $candidates = foreach ($dir in Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue) {
        if ($dir.Name -match $pattern) {
            $html = Get-ChildItem -LiteralPath $dir.FullName -File -Filter *.html -ErrorAction SilentlyContinue | Select-Object -First 1
            $md = Get-ChildItem -LiteralPath $dir.FullName -File -Filter *.md -ErrorAction SilentlyContinue | Select-Object -First 1
            $json = Get-ChildItem -LiteralPath $dir.FullName -File -Filter *.json -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($html -and $md -and $json) {
                $startDate = $matches[1]
                $endDate = $matches[2]
                [PSCustomObject]@{
                    Id = "{0}_{1}" -f $startDate, $endDate
                    StartDate = $startDate
                    EndDate = $endDate
                    Label = "{0} ~ {1}" -f $startDate, $endDate
                    Version = if ($matches[4]) { [int]$matches[4] } else { 1 }
                    FullName = $dir.FullName
                    Name = $dir.Name
                    LastWriteTime = $dir.LastWriteTime
                }
            }
        }
    }

    $result = @()
    foreach ($group in ($candidates | Group-Object Id)) {
        $selected = $group.Group |
            Sort-Object @{ Expression = 'Version'; Descending = $true }, @{ Expression = 'LastWriteTime'; Descending = $true } |
            Select-Object -First 1
        if ($selected) {
            $result += $selected
        }
    }

    return @($result | Sort-Object @{ Expression = 'EndDate'; Descending = $true }, @{ Expression = 'StartDate'; Descending = $true })
}

function Get-WeeklyEntryByRange([object[]]$Entries, [string]$StartDate, [string]$EndDate) {
    return @(
        $Entries |
        Where-Object { $_.StartDate -eq $StartDate -and $_.EndDate -eq $EndDate } |
        Sort-Object @{ Expression = 'Version'; Descending = $true }, @{ Expression = 'LastWriteTime'; Descending = $true } |
        Select-Object -First 1
    )[0]
}

function Get-DailyLandingHtml([string]$DefaultDate) {
    $template = @'
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>日报</title>
  <style>
    :root {
      --bg: #f4f8fc;
      --text: #0f172a;
      --muted: #64748b;
      --card: rgba(255,255,255,.94);
      --border: rgba(148,163,184,.24);
      --shadow: 0 16px 38px rgba(15,23,42,.08);
      --accent: #2563eb;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      color: var(--text);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", sans-serif;
      background:
        radial-gradient(circle at top left, rgba(37,99,235,.15), transparent 30%),
        linear-gradient(180deg, #f8fbff 0%, var(--bg) 100%);
    }
    .wrap {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px 14px 34px;
    }
    .hero {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 22px;
      padding: 18px;
      box-shadow: var(--shadow);
    }
    h1 {
      margin: 0 0 10px;
      font-size: clamp(28px, 5vw, 40px);
    }
    .muted {
      color: var(--muted);
      line-height: 1.8;
      margin: 0;
    }
    .controls {
      display: grid;
      grid-template-columns: 1fr auto auto;
      gap: 10px;
      margin-top: 16px;
      align-items: center;
    }
    select, button, a.btn {
      min-height: 44px;
      border-radius: 12px;
      border: 1px solid var(--border);
      font-size: 15px;
    }
    select {
      width: 100%;
      padding: 0 12px;
      background: #fff;
    }
    button, a.btn {
      padding: 0 15px;
      background: #fff;
      color: var(--text);
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
    }
    .primary {
      background: var(--accent);
      color: #fff;
      border-color: var(--accent);
    }
    .tips {
      margin-top: 12px;
      color: var(--muted);
      font-size: 14px;
      line-height: 1.7;
    }
    .frame-wrap {
      margin-top: 16px;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 20px;
      overflow: hidden;
      box-shadow: var(--shadow);
    }
    iframe {
      width: 100%;
      min-height: 78vh;
      border: 0;
      background: #fff;
    }
    .empty {
      padding: 22px 18px;
      color: var(--muted);
    }
    @media (max-width: 760px) {
      .controls { grid-template-columns: 1fr; }
      iframe { min-height: 72vh; }
    }
  </style>
</head>
<body>
  <main class="wrap">
    <section class="hero">
      <h1>日报</h1>
      <p class="muted">此页默认优先打开“昨日”日报；如果昨日不存在，则自动回退到最近一个已发布日期。你也可以手动切换日期查看历史日报。顶部会显示当前页面对应的日期与版本号。</p>
      <div class="controls">
        <select id="dateSelect" aria-label="选择日报日期"></select>
        <button id="openSelected" class="primary" type="button">打开所选日期</button>
        <a id="openMarkdown" class="btn" href="./daily_report.md">查看最新 Markdown</a>
      </div>
      <div class="tips" id="statusText">正在加载可用日期…</div>
    </section>
    <section class="frame-wrap">
      <iframe id="reportFrame" title="日报内容"></iframe>
      <div id="emptyState" class="empty" hidden>当前没有可用日报。</div>
    </section>
  </main>

  <script>
    const FALLBACK_DATE = "__DEFAULT_DATE__";
    const MANIFEST_URL = "./available_dates.json";
    const selectEl = document.getElementById("dateSelect");
    const openBtn = document.getElementById("openSelected");
    const markdownBtn = document.getElementById("openMarkdown");
    const frame = document.getElementById("reportFrame");
    const statusText = document.getElementById("statusText");
    const emptyState = document.getElementById("emptyState");

    function formatDate(date) {
      const y = date.getFullYear();
      const m = String(date.getMonth() + 1).padStart(2, "0");
      const d = String(date.getDate()).padStart(2, "0");
      return `${y}-${m}-${d}`;
    }

    function getYesterdayLocal() {
      const now = new Date();
      now.setHours(12, 0, 0, 0);
      now.setDate(now.getDate() - 1);
      return formatDate(now);
    }

    function reportUrl(dateText) {
      return `./by-date/${dateText}/`;
    }

    function getVersionSuffix(meta) {
      return meta && Number.isFinite(Number(meta.version)) ? `（v${meta.version}）` : "";
    }

    function getEntryLabel(meta, dateText) {
      if (meta && meta.label) {
        return meta.label;
      }
      return `${dateText}${getVersionSuffix(meta)}`;
    }

    function applySelection(dateText, options, metaMap) {
      if (!dateText) {
        frame.hidden = true;
        emptyState.hidden = false;
        statusText.textContent = "当前没有可用日报。";
        return;
      }
      const meta = metaMap.get(dateText) || null;
      selectEl.value = dateText;
      frame.hidden = false;
      emptyState.hidden = true;
      frame.src = reportUrl(dateText);
      const requestedYesterday = getYesterdayLocal();
      const currentLabel = getEntryLabel(meta, dateText);
      if (dateText === requestedYesterday) {
        statusText.textContent = `当前显示昨日日报：${currentLabel}`;
      } else if (options.includes(requestedYesterday)) {
        statusText.textContent = `当前显示日报：${currentLabel}`;
      } else {
        statusText.textContent = `昨日日报不存在，当前回退到最近可用日期：${currentLabel}`;
      }
    }

    fetch(MANIFEST_URL, { cache: "no-store" })
      .then((resp) => resp.ok ? resp.json() : Promise.reject(new Error(`HTTP ${resp.status}`)))
      .then((data) => {
        const dates = Array.isArray(data.dates) ? data.dates : [];
        const entries = Array.isArray(data.entries)
          ? data.entries.filter((item) => item && item.date)
          : dates.map((dateText) => ({ date: dateText }));
        const metaMap = new Map();
        selectEl.innerHTML = "";

        entries.forEach((item) => {
          metaMap.set(item.date, item);
          const option = document.createElement("option");
          option.value = item.date;
          option.textContent = getEntryLabel(item, item.date);
          selectEl.appendChild(option);
        });

        const optionDates = entries.map((item) => item.date);
        if (!optionDates.length) {
          applySelection("", optionDates, metaMap);
          return;
        }

        const yesterday = getYesterdayLocal();
        const initial = optionDates.includes(yesterday) ? yesterday : (data.latest || FALLBACK_DATE || optionDates[0]);
        applySelection(initial, optionDates, metaMap);

        openBtn.addEventListener("click", () => applySelection(selectEl.value, optionDates, metaMap));
        selectEl.addEventListener("change", () => applySelection(selectEl.value, optionDates, metaMap));

        if (data.latest_markdown) {
          markdownBtn.href = data.latest_markdown;
        }
      })
      .catch((err) => {
        statusText.textContent = `加载日期列表失败：${err.message}`;
        frame.hidden = true;
        emptyState.hidden = false;
      });
  </script>
</body>
</html>
'@
    return $template.Replace("__DEFAULT_DATE__", $DefaultDate)
}

function Get-WeeklyLandingHtml([string]$DefaultRangeId) {
    $template = @'
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>周报</title>
  <style>
    :root {
      --bg: #f4f8fc;
      --text: #0f172a;
      --muted: #64748b;
      --card: rgba(255,255,255,.94);
      --border: rgba(148,163,184,.24);
      --shadow: 0 16px 38px rgba(15,23,42,.08);
      --accent: #2563eb;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      color: var(--text);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", sans-serif;
      background:
        radial-gradient(circle at top left, rgba(37,99,235,.15), transparent 30%),
        linear-gradient(180deg, #f8fbff 0%, var(--bg) 100%);
    }
    .wrap {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px 14px 34px;
    }
    .hero {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 22px;
      padding: 18px;
      box-shadow: var(--shadow);
    }
    h1 {
      margin: 0 0 10px;
      font-size: clamp(28px, 5vw, 40px);
    }
    .muted {
      color: var(--muted);
      line-height: 1.8;
      margin: 0;
    }
    .controls {
      display: grid;
      grid-template-columns: 1fr auto auto;
      gap: 10px;
      margin-top: 16px;
      align-items: center;
    }
    select, button, a.btn {
      min-height: 44px;
      border-radius: 12px;
      border: 1px solid var(--border);
      font-size: 15px;
    }
    select {
      width: 100%;
      padding: 0 12px;
      background: #fff;
    }
    button, a.btn {
      padding: 0 15px;
      background: #fff;
      color: var(--text);
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
    }
    .primary {
      background: var(--accent);
      color: #fff;
      border-color: var(--accent);
    }
    .tips {
      margin-top: 12px;
      color: var(--muted);
      font-size: 14px;
      line-height: 1.7;
    }
    .frame-wrap {
      margin-top: 16px;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 20px;
      overflow: hidden;
      box-shadow: var(--shadow);
    }
    iframe {
      width: 100%;
      min-height: 78vh;
      border: 0;
      background: #fff;
    }
    .empty {
      padding: 22px 18px;
      color: var(--muted);
    }
    @media (max-width: 760px) {
      .controls { grid-template-columns: 1fr; }
      iframe { min-height: 72vh; }
    }
  </style>
</head>
<body>
  <main class="wrap">
    <section class="hero">
      <h1>周报</h1>
      <p class="muted">此页默认打开最新周报；你也可以手动切换历史周报区间，方便在手机上查看不同周次的追踪结果。</p>
      <div class="controls">
        <select id="rangeSelect" aria-label="选择周报区间"></select>
        <button id="openSelected" class="primary" type="button">打开所选周报</button>
        <a id="openMarkdown" class="btn" href="./weekly_report.md">查看最新 Markdown</a>
      </div>
      <div class="tips" id="statusText">正在加载可用周报…</div>
    </section>
    <section class="frame-wrap">
      <iframe id="reportFrame" title="周报内容"></iframe>
      <div id="emptyState" class="empty" hidden>当前没有可用周报。</div>
    </section>
  </main>

  <script>
    const FALLBACK_RANGE_ID = "__DEFAULT_RANGE_ID__";
    const MANIFEST_URL = "./available_weeks.json";
    const selectEl = document.getElementById("rangeSelect");
    const openBtn = document.getElementById("openSelected");
    const markdownBtn = document.getElementById("openMarkdown");
    const frame = document.getElementById("reportFrame");
    const statusText = document.getElementById("statusText");
    const emptyState = document.getElementById("emptyState");

    function reportUrl(rangeId) {
      return `./by-range/${rangeId}/`;
    }

    function applySelection(rangeId, ranges, labels) {
      if (!rangeId) {
        frame.hidden = true;
        emptyState.hidden = false;
        statusText.textContent = "当前没有可用周报。";
        return;
      }
      selectEl.value = rangeId;
      frame.hidden = false;
      emptyState.hidden = true;
      frame.src = reportUrl(rangeId);
      statusText.textContent = `当前显示周报：${labels.get(rangeId) || rangeId}`;
    }

    fetch(MANIFEST_URL, { cache: "no-store" })
      .then((resp) => resp.ok ? resp.json() : Promise.reject(new Error(`HTTP ${resp.status}`)))
      .then((data) => {
        const ranges = Array.isArray(data.ranges) ? data.ranges : [];
        const labels = new Map();
        selectEl.innerHTML = "";

        ranges.forEach((item) => {
          if (!item || !item.id) {
            return;
          }
          labels.set(item.id, item.label || item.id);
          const option = document.createElement("option");
          option.value = item.id;
          option.textContent = item.label || item.id;
          selectEl.appendChild(option);
        });

        if (!ranges.length) {
          applySelection("", [], labels);
          return;
        }

        const rangeIds = ranges.map((item) => item.id);
        const initial = rangeIds.includes(data.latest) ? data.latest : (FALLBACK_RANGE_ID || rangeIds[0]);
        applySelection(initial, ranges, labels);

        openBtn.addEventListener("click", () => applySelection(selectEl.value, ranges, labels));
        selectEl.addEventListener("change", () => applySelection(selectEl.value, ranges, labels));

        if (data.latest_markdown) {
          markdownBtn.href = data.latest_markdown;
        }
      })
      .catch((err) => {
        statusText.textContent = `加载周报列表失败：${err.message}`;
        frame.hidden = true;
        emptyState.hidden = false;
      });
  </script>
</body>
</html>
'@
    return $template.Replace("__DEFAULT_RANGE_ID__", $DefaultRangeId)
}

function Get-LatestFileByExtension([string]$DirectoryPath, [string]$Extension) {
    $file = Get-ChildItem -LiteralPath $DirectoryPath -File |
        Where-Object { $_.Extension -ieq $Extension } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $file) {
        throw "目录中缺少 $Extension 文件：$DirectoryPath"
    }
    return $file
}

function Copy-ReportFile([string]$SourcePath, [string]$DestinationPath) {
    Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
    Write-Info ("复制：{0} -> {1}" -f $SourcePath, $DestinationPath)
}

function Update-SubReadme([string]$DestDir, [string]$Title, [string]$SourceRelative, [string[]]$FileLines) {
    $body = @(
        "# $Title",
        "",
        "来源目录：``$SourceRelative``",
        ""
    )
    $body += $FileLines
    $body += ""
    $body += "由 ``scripts/publish_literature_tracking.ps1`` 自动更新。"
    $body += ""
    Write-Utf8File (Join-Path $DestDir "README.md") (($body -join "`r`n"))
}

function Invoke-Git([string[]]$GitArguments) {
    $gitArgs = @("-c", "safe.directory=$RepoRoot", "-C", $RepoRoot) + $GitArguments
    & git @gitArgs
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "git 命令失败（exit=$exitCode）：git $($GitArguments -join ' ')"
    }
}

function Invoke-GitCapture([string[]]$GitArguments) {
    $gitArgs = @("-c", "safe.directory=$RepoRoot", "-C", $RepoRoot) + $GitArguments
    $output = & git @gitArgs 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "git 命令失败（exit=$exitCode）：git $($GitArguments -join ' ')`n$($output -join [Environment]::NewLine)"
    }
    return @($output)
}

function Read-JsonFile([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    $raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $null
    }

    return $raw | ConvertFrom-Json
}

function Test-DailyPublishedState([string]$DestDir, [string]$ExpectedDate) {
    $manifest = Read-JsonFile (Join-Path $DestDir "available_dates.json")
    $archiveDir = Join-Path $DestDir ("by-date\{0}" -f $ExpectedDate)
    if (-not $manifest) {
        return $false
    }
    if ($manifest.latest -ne $ExpectedDate) {
        return $false
    }
    if (-not $manifest.dates -or ($manifest.dates -notcontains $ExpectedDate)) {
        return $false
    }

    foreach ($required in @(
        (Join-Path $DestDir "index.html"),
        (Join-Path $DestDir "daily_report.md"),
        (Join-Path $DestDir "daily_records.json"),
        (Join-Path $archiveDir "index.html"),
        (Join-Path $archiveDir "daily_report.md"),
        (Join-Path $archiveDir "daily_records.json")
    )) {
        if (-not (Test-Path -LiteralPath $required)) {
            return $false
        }
    }

    return $true
}

function Test-WeeklyPublishedState([string]$DestDir, [object]$ExpectedRange) {
    if (-not $ExpectedRange) {
        return $true
    }

    $manifest = Read-JsonFile (Join-Path $DestDir "available_weeks.json")
    $archiveDir = Join-Path $DestDir ("by-range\{0}" -f $ExpectedRange.Id)
    if (-not $manifest) {
        return $false
    }
    if ($manifest.latest -ne $ExpectedRange.Id) {
        return $false
    }
    $hasRange = @($manifest.ranges | Where-Object { $_.id -eq $ExpectedRange.Id }).Count -gt 0
    if (-not $hasRange) {
        return $false
    }

    foreach ($required in @(
        (Join-Path $DestDir "index.html"),
        (Join-Path $DestDir "weekly_report.md"),
        (Join-Path $DestDir "weekly_records.json"),
        (Join-Path $archiveDir "index.html"),
        (Join-Path $archiveDir "weekly_report.md"),
        (Join-Path $archiveDir "weekly_records.json")
    )) {
        if (-not (Test-Path -LiteralPath $required)) {
            return $false
        }
    }

    return $true
}

function Test-GitWorkingTreeDirty() {
    return @(Invoke-GitCapture @("status", "--porcelain")).Count -gt 0
}

function Get-GitAheadCount() {
    try {
        $countText = @(Invoke-GitCapture @("rev-list", "--count", "@{u}..HEAD"))[0]
        if ([string]::IsNullOrWhiteSpace($countText)) {
            return 0
        }
        return [int]$countText
    } catch {
        Write-Info "未检测到上游分支，无法判断 push 是否已完成。"
        return -1
    }
}

Ensure-Dir (Join-Path $WorkspaceRoot "运行日志\发布")
$PublishLog = Join-Path (Join-Path $WorkspaceRoot "运行日志\发布") ("publish-{0}.log" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$TranscriptStarted = $false

try {
    Start-Transcript -LiteralPath $PublishLog -Force | Out-Null
    $TranscriptStarted = $true
    Write-Info "日志：$PublishLog"

    Require-Path $RepoRoot "发布仓库"
    Require-Path $WeeklyProject "周报项目"
    Require-Path $DailyProject "日报项目"
    Ensure-Dir $WeeklyDest
    Ensure-Dir $DailyDest

    if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot ".nojekyll"))) {
        Write-Utf8File (Join-Path $RepoRoot ".nojekyll") ""
    }

    $localNow = Get-LocalNow $TimezoneId
    $isScheduledMode = $ScheduledPublish -or $PublishPhase -ne "Manual"
    $resolvedPhase = Resolve-PublishPhase -Now $localNow -RequestedPhase $PublishPhase -IsScheduledMode $isScheduledMode
    $expectedDailyDate = $localNow.Date.AddDays($DailyOffset).ToString("yyyy-MM-dd")
    $expectedWeeklyRange = if ($isScheduledMode -and $localNow.DayOfWeek -eq [System.DayOfWeek]::Monday) {
        Get-ExpectedWeeklyRange $localNow
    } else {
        $null
    }

    Write-Info ("发布模式：{0}" -f $(if ($isScheduledMode) { "计划发布/$resolvedPhase" } else { "手动发布" }))
    Write-Info ("目标日报日期：{0}" -f $expectedDailyDate)
    if ($expectedWeeklyRange) {
        Write-Info ("目标周报区间：{0}" -f $expectedWeeklyRange.Label)
    }

    if ($resolvedPhase -eq "VerifyRetry") {
        $publishedDailyOk = Test-DailyPublishedState -DestDir $DailyDest -ExpectedDate $expectedDailyDate
        $publishedWeeklyOk = Test-WeeklyPublishedState -DestDir $WeeklyDest -ExpectedRange $expectedWeeklyRange
        $gitDirtyBeforePublish = Test-GitWorkingTreeDirty
        $aheadCountBeforePublish = Get-GitAheadCount
        Write-Info ("二次发布校验：日报已发布={0}，周报已发布={1}，工作区有变更={2}，待推送提交数={3}" -f $publishedDailyOk, $publishedWeeklyOk, $gitDirtyBeforePublish, $aheadCountBeforePublish)
        if ($publishedDailyOk -and $publishedWeeklyOk -and (-not $gitDirtyBeforePublish) -and $aheadCountBeforePublish -eq 0) {
            Write-Success "目标日报/周报均已发布，且无待推送提交，本次跳过重复发布。"
            return
        }
        Write-Info "校验未通过，进入补偿发布流程。"
    }

    $weeklyBat = Join-Path $WeeklyProject "run_weekly_report.bat"
    $dailyScript = Join-Path $DailyProject "scripts\run_daily_report.ps1"
    Require-Path $weeklyBat "周报生成脚本"
    Require-Path $dailyScript "日报生成脚本"

    if ($isScheduledMode) {
        $dailyEntries = @(Get-DailyReportEntries $DailyOutputRoot)
        $targetDailyEntry = if ($dailyEntries.Count -gt 0) {
            Get-DailyEntryByDate -Entries $dailyEntries -DateText $expectedDailyDate
        }
        if (-not $targetDailyEntry) {
            if ($SkipDailyGeneration) {
                throw "目标日报缺失，但已指定跳过日报生成：$expectedDailyDate"
            }
            Write-Info "目标日报缺失，触发日报补生成。"
            Invoke-Native "powershell.exe" @(
                "-NoProfile",
                "-ExecutionPolicy", "Bypass",
                "-File", $dailyScript,
                "-DayOffset", $DailyOffset.ToString()
            ) $DailyProject
            $dailyEntries = @(Get-DailyReportEntries $DailyOutputRoot)
            $targetDailyEntry = if ($dailyEntries.Count -gt 0) {
                Get-DailyEntryByDate -Entries $dailyEntries -DateText $expectedDailyDate
            }
        }

        if ($expectedWeeklyRange) {
            $weeklyEntries = @(Get-WeeklyReportEntries $WeeklyReportsRoot)
            $targetWeeklyEntry = if ($weeklyEntries.Count -gt 0) {
                Get-WeeklyEntryByRange -Entries $weeklyEntries -StartDate $expectedWeeklyRange.StartDate -EndDate $expectedWeeklyRange.EndDate
            }
            if (-not $targetWeeklyEntry) {
                if ($SkipWeeklyGeneration) {
                    throw "目标周报缺失，但已指定跳过周报生成：$($expectedWeeklyRange.Label)"
                }
                Write-Info "目标周报缺失，触发周报补生成。"
                Invoke-Native "cmd.exe" @("/c", "`"$weeklyBat`"") $WeeklyProject
                $weeklyEntries = @(Get-WeeklyReportEntries $WeeklyReportsRoot)
                $targetWeeklyEntry = if ($weeklyEntries.Count -gt 0) {
                    Get-WeeklyEntryByRange -Entries $weeklyEntries -StartDate $expectedWeeklyRange.StartDate -EndDate $expectedWeeklyRange.EndDate
                }
            }
        }
    } else {
        if (-not $SkipWeeklyGeneration) {
            Invoke-Native "cmd.exe" @("/c", "`"$weeklyBat`"") $WeeklyProject
        }

        if (-not $SkipDailyGeneration) {
            Invoke-Native "powershell.exe" @(
                "-NoProfile",
                "-ExecutionPolicy", "Bypass",
                "-File", $dailyScript,
                "-DayOffset", $DailyOffset.ToString()
            ) $DailyProject
        }
    }

    $weeklyEntries = @(Get-WeeklyReportEntries $WeeklyReportsRoot)
    $dailyEntries = @(Get-DailyReportEntries $DailyOutputRoot)

    if ($weeklyEntries.Count -eq 0) {
        throw "未找到可用的周报目录：$WeeklyReportsRoot"
    }

    if ($dailyEntries.Count -eq 0) {
        throw "未找到可用的单日日报目录：$DailyOutputRoot"
    }

    if ($isScheduledMode) {
        $targetDailyEntry = Get-DailyEntryByDate -Entries $dailyEntries -DateText $expectedDailyDate
        if (-not $targetDailyEntry) {
            throw "补生成后仍未找到目标日报：$expectedDailyDate"
        }
        $dailyEntries = @($targetDailyEntry) + @($dailyEntries | Where-Object { $_.Date -ne $expectedDailyDate })

        if ($expectedWeeklyRange) {
            $targetWeeklyEntry = Get-WeeklyEntryByRange -Entries $weeklyEntries -StartDate $expectedWeeklyRange.StartDate -EndDate $expectedWeeklyRange.EndDate
            if (-not $targetWeeklyEntry) {
                throw "补生成后仍未找到目标周报：$($expectedWeeklyRange.Label)"
            }
            $weeklyEntries = @($targetWeeklyEntry) + @($weeklyEntries | Where-Object { $_.Id -ne $expectedWeeklyRange.Id })
        }
    }

    $weeklyDir = Get-Item -LiteralPath $weeklyEntries[0].FullName
    $dailyDir = Get-Item -LiteralPath $dailyEntries[0].FullName

    $weeklyHtml = Get-LatestFileByExtension $weeklyDir.FullName ".html"
    $weeklyMd = Get-LatestFileByExtension $weeklyDir.FullName ".md"
    $weeklyJson = Get-LatestFileByExtension $weeklyDir.FullName ".json"

    $dailyHtml = Get-LatestFileByExtension $dailyDir.FullName ".html"
    $dailyMd = Get-LatestFileByExtension $dailyDir.FullName ".md"
    $dailyJson = Get-LatestFileByExtension $dailyDir.FullName ".json"

    Copy-ReportFile $weeklyHtml.FullName (Join-Path $WeeklyDest "index.html")
    Copy-ReportFile $weeklyMd.FullName (Join-Path $WeeklyDest "weekly_report.md")
    Copy-ReportFile $weeklyJson.FullName (Join-Path $WeeklyDest "weekly_records.json")

    $weeklyArchiveRoot = Join-Path $WeeklyDest "by-range"
    Reset-Dir $weeklyArchiveRoot

    foreach ($entry in $weeklyEntries) {
        $entryDir = $entry.FullName
        $destDir = Join-Path $weeklyArchiveRoot $entry.Id
        Ensure-Dir $destDir

        Copy-ReportFile (Get-LatestFileByExtension $entryDir ".html").FullName (Join-Path $destDir "index.html")
        Copy-ReportFile (Get-LatestFileByExtension $entryDir ".md").FullName (Join-Path $destDir "weekly_report.md")
        Copy-ReportFile (Get-LatestFileByExtension $entryDir ".json").FullName (Join-Path $destDir "weekly_records.json")
    }

    $weeklyManifest = [ordered]@{
        generated_at = (Get-Date).ToString("s")
        latest = $weeklyEntries[0].Id
        latest_label = $weeklyEntries[0].Label
        latest_markdown = "./weekly_report.md"
        ranges = @(
            $weeklyEntries | ForEach-Object {
                [ordered]@{
                    id = $_.Id
                    start = $_.StartDate
                    end = $_.EndDate
                    label = $_.Label
                }
            }
        )
    }
    Write-Utf8File (Join-Path $WeeklyDest "available_weeks.json") (($weeklyManifest | ConvertTo-Json -Depth 5) -replace "`n", "`r`n")
    Write-Utf8File (Join-Path $WeeklyDest "index.html") ((Get-WeeklyLandingHtml -DefaultRangeId $weeklyEntries[0].Id) -replace "`n", "`r`n")

    Copy-ReportFile $dailyMd.FullName (Join-Path $DailyDest "daily_report.md")
    Copy-ReportFile $dailyJson.FullName (Join-Path $DailyDest "daily_records.json")

    $dailyArchiveRoot = Join-Path $DailyDest "by-date"
    Reset-Dir $dailyArchiveRoot

    foreach ($entry in $dailyEntries) {
        $entryDir = $entry.FullName
        $destDir = Join-Path $dailyArchiveRoot $entry.Date
        Ensure-Dir $destDir

        Copy-ReportFile (Join-Path $entryDir "weekly_report.html") (Join-Path $destDir "index.html")
        Copy-ReportFile (Join-Path $entryDir "weekly_report.md") (Join-Path $destDir "daily_report.md")
        Copy-ReportFile (Join-Path $entryDir "weekly_records.json") (Join-Path $destDir "daily_records.json")
    }

    $dailyManifest = [ordered]@{
        generated_at = (Get-Date).ToString("s")
        latest = $dailyEntries[0].Date
        latest_version = $dailyEntries[0].Version
        latest_label = ("{0} (v{1})" -f $dailyEntries[0].Date, $dailyEntries[0].Version)
        latest_markdown = "./daily_report.md"
        dates = @($dailyEntries | ForEach-Object { $_.Date })
        entries = @(
            $dailyEntries | ForEach-Object {
                [ordered]@{
                    date = $_.Date
                    version = $_.Version
                    label = ("{0} (v{1})" -f $_.Date, $_.Version)
                    source_name = $_.Name
                }
            }
        )
    }
    Write-Utf8File (Join-Path $DailyDest "available_dates.json") (($dailyManifest | ConvertTo-Json -Depth 4) -replace "`n", "`r`n")
    Write-Utf8File (Join-Path $DailyDest "index.html") ((Get-DailyLandingHtml -DefaultDate $dailyEntries[0].Date) -replace "`n", "`r`n")

    if ($isScheduledMode) {
        if (-not (Test-DailyPublishedState -DestDir $DailyDest -ExpectedDate $expectedDailyDate)) {
            throw "发布前自检失败：日报目标内容未正确写入发布目录：$expectedDailyDate"
        }
        if (-not (Test-WeeklyPublishedState -DestDir $WeeklyDest -ExpectedRange $expectedWeeklyRange)) {
            throw "发布前自检失败：周报目标内容未正确写入发布目录。"
        }
    }

    $weeklySourceRelative = "CNS周报/reports/{0}" -f $weeklyDir.Name
    $dailySourceRelative = "paper-overview-extractor-RSS/output/{0}" -f $dailyDir.Name

    Update-SubReadme $WeeklyDest "周报" $weeklySourceRelative @(
        "- 入口页面：``index.html``（默认最新，支持切换历史周报）",
        "- 历史归档：``by-range/YYYY-MM-DD_YYYY-MM-DD/``",
        "- Markdown：``weekly_report.md``",
        "- 结构化数据：``weekly_records.json``",
        "- 区间清单：``available_weeks.json``"
    )

    Update-SubReadme $DailyDest "日报" $dailySourceRelative @(
        "- 入口页面：``index.html``（默认昨日，支持切换日期）",
        "- 历史归档：``by-date/YYYY-MM-DD/``",
        "- 最新 Markdown：``daily_report.md``",
        "- 结构化数据：``daily_records.json``",
        "- 日期清单：``available_dates.json``"
    )

    $rootReadme = @'
# 文献追踪

用于静态发布文献追踪报告。

当前仓库公开以下目录：

- `[周报]/`：CNS 周报项目导出的周报入口页（支持切换历史周报）
- `[日报]/`：RSS 项目导出的日报入口页（支持切换历史日报）

## 手机端查看

优先建议开启 GitHub Pages 后，通过浏览器打开仓库首页，再从首页进入：

- `[日报]/`：默认昨日报告，并可切换历史日报
- `[周报]/`：默认最新周报，并可切换历史周报

如果只想在手机上快速查看：

1. 打开 GitHub Pages 首页
2. 使用浏览器“添加到主屏幕”
3. 以后直接点首页，再进入日报或周报

如果需要看原始 Markdown：

- `[日报]/daily_report.md`
- `[周报]/weekly_report.md`

## 一键发布

双击运行：

```text
一键发布.bat
```

等价命令：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish_literature_tracking.ps1
```

仅同步已有结果、不重新生成：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\publish_literature_tracking.ps1 -SkipWeeklyGeneration -SkipDailyGeneration
```
'@
    Write-Utf8File (Join-Path $RepoRoot "README.md") ($rootReadme -replace "`n", "`r`n")

    Write-Info "检查 Git 变更"
    Invoke-Git @("add", "-A")
    $statusLines = @(Invoke-GitCapture @("status", "--porcelain"))

    if ($statusLines.Count -eq 0) {
        Write-Success "没有新的文件变化。"
        if ($SkipPush) {
            return
        }
        $aheadCount = Get-GitAheadCount
        if ($aheadCount -gt 0) {
            Write-Info ("检测到已有 {0} 个本地提交尚未推送，继续补推。" -f $aheadCount)
        } else {
            Write-Info "无需推送，仓库内容未变化。"
            return
        }
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($statusLines.Count -gt 0) {
        $commitMessage = "Publish literature tracking site $timestamp"
        if ($AllowEmptyCommit) {
            Invoke-Git @("commit", "--allow-empty", "-m", $commitMessage)
        } else {
            Invoke-Git @("commit", "-m", $commitMessage)
        }
    }

    if ($SkipPush) {
        Write-Success "已完成本地提交，未执行推送。"
        return
    }

    $branchName = @(Invoke-GitCapture @("rev-parse", "--abbrev-ref", "HEAD"))[0]
    if ([string]::IsNullOrWhiteSpace($branchName)) {
        $branchName = "main"
    }

    Write-Info ("推送分支：{0}" -f $branchName)
    Invoke-Git @("push", "origin", $branchName)
    $aheadCountAfterPush = Get-GitAheadCount
    Write-Info ("推送后待推送提交数：{0}" -f $aheadCountAfterPush)
    Write-Success "一键发布完成。"
}
finally {
    if ($TranscriptStarted) {
        Stop-Transcript | Out-Null
    }
}
