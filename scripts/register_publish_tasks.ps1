param(
    [string]$CombinedDailyTaskName = "LiteratureTrackingPublishDailyFull",
    [string]$PrimaryTime = "06:00",
    [string]$BackupTime = "09:15",
    [string[]]$LegacyTaskNames = @(
        "LiteratureTrackingPublishDaily",
        "LiteratureTrackingPublishWeekly"
    )
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
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

$combinedDailyAction = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$publishScript`""

$combinedDailyTriggers = @(
    (New-ScheduledTaskTrigger -Daily -At $PrimaryTime),
    (New-ScheduledTaskTrigger -Daily -At $BackupTime)
)

Register-ScheduledTask `
    -TaskName $CombinedDailyTaskName `
    -Action $combinedDailyAction `
    -Trigger $combinedDailyTriggers `
    -Principal $principal `
    -Settings $settings `
    -Force | Out-Null

foreach ($legacyTaskName in $LegacyTaskNames) {
    $legacyTask = Get-ScheduledTask -TaskName $legacyTaskName -ErrorAction SilentlyContinue
    if ($legacyTask) {
        Unregister-ScheduledTask -TaskName $legacyTaskName -Confirm:$false
        Write-Output "Removed legacy task: $legacyTaskName"
    }
}

Write-Output "Registered combined daily task: $CombinedDailyTaskName"
Write-Output "  - triggers: $PrimaryTime and $BackupTime"
Write-Output "  - action: publish_literature_tracking.ps1"
