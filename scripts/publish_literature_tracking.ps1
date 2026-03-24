param(
    [switch]$SkipWeeklyGeneration,
    [switch]$SkipDailyGeneration,
    [switch]$SkipPush,
    [switch]$AllowEmptyCommit,
    [int]$DailyOffset = 0
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
$dailyDir = Get-LatestReportDirectory $DailyOutputRoot

$weeklyHtml = Get-LatestFileByExtension $weeklyDir.FullName ".html"
$weeklyMd = Get-LatestFileByExtension $weeklyDir.FullName ".md"
$weeklyJson = Get-LatestFileByExtension $weeklyDir.FullName ".json"

$dailyHtml = Get-LatestFileByExtension $dailyDir.FullName ".html"
$dailyMd = Get-LatestFileByExtension $dailyDir.FullName ".md"
$dailyJson = Get-LatestFileByExtension $dailyDir.FullName ".json"

Copy-ReportFile $weeklyHtml.FullName (Join-Path $WeeklyDest "index.html")
Copy-ReportFile $weeklyMd.FullName (Join-Path $WeeklyDest "weekly_report.md")
Copy-ReportFile $weeklyJson.FullName (Join-Path $WeeklyDest "weekly_records.json")

Copy-ReportFile $dailyHtml.FullName (Join-Path $DailyDest "index.html")
Copy-ReportFile $dailyMd.FullName (Join-Path $DailyDest "daily_report.md")
Copy-ReportFile $dailyJson.FullName (Join-Path $DailyDest "daily_records.json")

$weeklySourceRelative = "CNS周报/reports/{0}" -f $weeklyDir.Name
$dailySourceRelative = "paper-overview-extractor-RSS/output/{0}" -f $dailyDir.Name

Update-SubReadme $WeeklyDest "周报" $weeklySourceRelative @(
    "- 页面：``index.html``",
    "- Markdown：``weekly_report.md``",
    "- 结构化数据：``weekly_records.json``"
)

Update-SubReadme $DailyDest "日报" $dailySourceRelative @(
    "- 页面：``index.html``",
    "- Markdown：``daily_report.md``",
    "- 结构化数据：``daily_records.json``"
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
