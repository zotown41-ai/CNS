param(
    [string]$DailyTaskName = "LiteratureTrackingPublishDaily",
    [string]$WeeklyTaskName = "LiteratureTrackingPublishWeekly",
    [string]$DailyPrimaryTime = "04:20",
    [string]$DailyCheckTime = "09:15",
    [string]$WeeklyTime = "03:20"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$publishScript = Join-Path $scriptDir "publish_literature_tracking.ps1"

if (-not (Test-Path -LiteralPath $publishScript)) {
    throw "Publish script not found: $publishScript"
}

$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$principal = New-ScheduledTaskPrincipal -UserId $currentUser -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -MultipleInstances IgnoreNew `
    -ExecutionTimeLimit (New-TimeSpan -Hours 72)

$dailyAction = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$publishScript`" -SkipWeeklyGeneration"

$dailyTriggers = @(
    (New-ScheduledTaskTrigger -Daily -At $DailyPrimaryTime),
    (New-ScheduledTaskTrigger -Daily -At $DailyCheckTime)
)

$weeklyAction = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$publishScript`" -SkipDailyGeneration"

$weeklyTrigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Sunday -At $WeeklyTime

Register-ScheduledTask `
    -TaskName $DailyTaskName `
    -Action $dailyAction `
    -Trigger $dailyTriggers `
    -Principal $principal `
    -Settings $settings `
    -Force | Out-Null

Register-ScheduledTask `
    -TaskName $WeeklyTaskName `
    -Action $weeklyAction `
    -Trigger $weeklyTrigger `
    -Principal $principal `
    -Settings $settings `
    -Force | Out-Null

Write-Output "Registered daily publish task: $DailyTaskName"
Write-Output "  - triggers: $DailyPrimaryTime and $DailyCheckTime"
Write-Output "  - action: publish_literature_tracking.ps1 -SkipWeeklyGeneration"
Write-Output "Registered weekly publish task: $WeeklyTaskName"
Write-Output "  - trigger: Sunday $WeeklyTime"
Write-Output "  - action: publish_literature_tracking.ps1 -SkipDailyGeneration"
