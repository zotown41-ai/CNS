param(
    [switch]$SkipWeeklyGeneration,
    [switch]$SkipDailyGeneration,
    [switch]$SkipPush,
    [switch]$AllowEmptyCommit,
    [int]$DailyOffset = -1
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
      <p class="muted">此页默认优先打开“昨日”日报；如果昨日不存在，则自动回退到最近一个已发布日期。你也可以手动切换日期查看历史日报。</p>
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

    function applySelection(dateText, options) {
      if (!dateText) {
        frame.hidden = true;
        emptyState.hidden = false;
        statusText.textContent = "当前没有可用日报。";
        return;
      }
      selectEl.value = dateText;
      frame.hidden = false;
      emptyState.hidden = true;
      frame.src = reportUrl(dateText);
      const requestedYesterday = getYesterdayLocal();
      if (dateText === requestedYesterday) {
        statusText.textContent = `当前显示昨日日报：${dateText}`;
      } else if (options.includes(requestedYesterday)) {
        statusText.textContent = `当前显示日报：${dateText}`;
      } else {
        statusText.textContent = `昨日日报不存在，当前回退到最近可用日期：${dateText}`;
      }
    }

    fetch(MANIFEST_URL, { cache: "no-store" })
      .then((resp) => resp.ok ? resp.json() : Promise.reject(new Error(`HTTP ${resp.status}`)))
      .then((data) => {
        const dates = Array.isArray(data.dates) ? data.dates : [];
        selectEl.innerHTML = "";
        dates.forEach((dateText) => {
          const option = document.createElement("option");
          option.value = dateText;
          option.textContent = dateText;
          selectEl.appendChild(option);
        });

        if (!dates.length) {
          applySelection("", dates);
          return;
        }

        const yesterday = getYesterdayLocal();
        const initial = dates.includes(yesterday) ? yesterday : (data.latest || FALLBACK_DATE || dates[0]);
        applySelection(initial, dates);

        openBtn.addEventListener("click", () => applySelection(selectEl.value, dates));
        selectEl.addEventListener("change", () => applySelection(selectEl.value, dates));

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

Require-Path $RepoRoot "发布仓库"
Require-Path $WeeklyProject "周报项目"
Require-Path $DailyProject "日报项目"
Ensure-Dir $WeeklyDest
Ensure-Dir $DailyDest

if (-not (Test-Path -LiteralPath (Join-Path $RepoRoot ".nojekyll"))) {
    Write-Utf8File (Join-Path $RepoRoot ".nojekyll") ""
}

if (-not $SkipWeeklyGeneration) {
    $weeklyBat = Join-Path $WeeklyProject "run_weekly_report.bat"
    Require-Path $weeklyBat "周报生成脚本"
    Invoke-Native "cmd.exe" @("/c", "`"$weeklyBat`"") $WeeklyProject
}

if (-not $SkipDailyGeneration) {
    $dailyScript = Join-Path $DailyProject "scripts\run_daily_report.ps1"
    Require-Path $dailyScript "日报生成脚本"
    Invoke-Native "powershell.exe" @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", $dailyScript,
        "-DayOffset", $DailyOffset.ToString()
    ) $DailyProject
}

$weeklyDir = Get-LatestReportDirectory $WeeklyReportsRoot
$dailyEntries = @(Get-DailyReportEntries $DailyOutputRoot)

if ($dailyEntries.Count -eq 0) {
    throw "未找到可用的单日日报目录：$DailyOutputRoot"
}

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
    latest_markdown = "./daily_report.md"
    dates = @($dailyEntries | ForEach-Object { $_.Date })
}
Write-Utf8File (Join-Path $DailyDest "available_dates.json") (($dailyManifest | ConvertTo-Json -Depth 4) -replace "`n", "`r`n")
Write-Utf8File (Join-Path $DailyDest "index.html") ((Get-DailyLandingHtml -DefaultDate $dailyEntries[0].Date) -replace "`n", "`r`n")

$weeklySourceRelative = "CNS周报/reports/{0}" -f $weeklyDir.Name
$dailySourceRelative = "paper-overview-extractor-RSS/output/{0}" -f $dailyDir.Name

Update-SubReadme $WeeklyDest "周报" $weeklySourceRelative @(
    "- 页面：``index.html``",
    "- Markdown：``weekly_report.md``",
    "- 结构化数据：``weekly_records.json``"
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

- `[周报]/`：CNS 周报项目导出的最新周报
- `[日报]/`：RSS 项目导出的最新日报

## 手机端查看

优先建议开启 GitHub Pages 后，通过浏览器打开仓库首页，再从首页进入：

- `[日报]/`：查看最新日报页面
- `[周报]/`：查看最新周报页面

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
$statusLines = @(git -c "safe.directory=$RepoRoot" -C $RepoRoot status --porcelain)
if ($LASTEXITCODE -ne 0) {
    throw "git status 执行失败"
}

if ($statusLines.Count -eq 0) {
    Write-Success "没有新的文件变化。"
    if ($SkipPush) {
        return
    }
    Write-Info "无需推送，仓库内容未变化。"
    return
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitMessage = "Publish literature tracking site $timestamp"
if ($AllowEmptyCommit) {
    Invoke-Git @("commit", "--allow-empty", "-m", $commitMessage)
} else {
    Invoke-Git @("commit", "-m", $commitMessage)
}

if ($SkipPush) {
    Write-Success "已完成本地提交，未执行推送。"
    return
}

$branchName = @(git -c "safe.directory=$RepoRoot" -C $RepoRoot rev-parse --abbrev-ref HEAD)[0]
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($branchName)) {
    $branchName = "main"
}

Invoke-Git @("push", "origin", $branchName)
Write-Success "一键发布完成。"
