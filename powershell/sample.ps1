<#
    Puppet Relay parameter passing result ouput script
#>

$now = get-date
$uptime = (Get-Uptime).TotalMilliseconds #linux only
$env = Get-ChildItem -Path env:
$commands = get-command
$modules = Get-Module
$runTimeSec = [math]::Round((New-TimeSpan -Start $now -End (get-date)).TotalMilliseconds,2)

Write-host "----- script start: $now`n"
Write-host "----- uptime ms: $uptime`n"
Write-host "----- psHost: $($psversiontable|out-string)`n"
Write-host "----- script env vars: $($env|out-string)`n"
Write-host "----- PS modules: $($modules|out-string)`n"
Write-host "----- PS commands: $($commands|out-string)`n"
Write-host "----- PS error log: $($Error | Select-Object * | Out-String)`n"

Write-host "----- Relay step input input1: $(Relay-Interface get -p '{ .input1 }')`n"
Write-host "----- Relay step input param1: $(Relay-Interface get -p '{ .param1 }')`n"
Write-host "----- Relay step secret mySecret: $(Relay-Interface get -p '{ .secret }')`n"

Write-host "----- runtime ms: $runTimeSec"

<# Set the runtime as output #>
Relay-Interface output set --key 'runTime' --value $runTimeSec
