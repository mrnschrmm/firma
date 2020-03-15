# NAME
$id = 'firma'

# LOCATION
$baseLocalEntry = 'E:\Sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalConfigPath = 'D:\Tools\__configs\M-1\sites\' + $id + '\'
$baseLocalDist = $baseLocalEntryPath + 'dist' + '\'
$baseRemoteEntry = '/'

# DEPENDENCY
$winSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$winSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

# CONFIG
$full = if ($args -eq '-full') { $True } else { $False }
$done = $False
$envConfig = $Null
$session = $Null
$sessionOptions = $Null

try
{
    Write-Host '## RUN ## DEPLOY'

    Add-Type -Path $winSCPdnet

    Import-Module ($baseLocalEntryPath + 'run\module\enviroment.psm1')
    Import-Module ($baseLocalEntryPath + 'run\module\session.psm1')
    Import-Module ($baseLocalEntryPath + 'run\module\transfer.psm1')

    # Enviroment
    $envConfig = GetEnvConfig $baseLocalEntryPath

    # Authentication
    $hst = $envConfig.SESSION_HOST
    $usr = $(if ($args -eq '-preview') { $envConfig.SESSION_USER_PREVIEW } else { $envConfig.SESSION_USER })
    $hsh = $(if ($args -eq '-preview') { $envConfig.SESSION_HASH_PREVIEW } else { $envConfig.SESSION_HASH })
    # $key = $(if ($args -eq '-preview') { $envConfig.SESSION_KEY_PREVIEW } else { $envConfig.SESSION_KEY })
    # $pwd = $($hsh | ConvertTo-SecureString -Key $key)
    $hsh = $baseLocalEntryPath + $(if ($args -eq '-preview') { "env\preview" } else { "env\prod" })
    $key = $baseLocalConfigPath + $(if ($args -eq '-preview') { "auth\preview" } else { "auth\prod" })
    $pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))
    # $pwd = $($hsh | ConvertTo-SecureString -Key (Get-Content $key))

    # Session
    $sessionOptions = SessionSettings $hst $usr $pwd

    $session = New-Object WinSCP.Session
    $session.ExecutablePath = $winSCPexec
    $session.SessionLogPath = $baseLocalEntry + '_logs\winscp.' + $id + '.deploy.log'
    $session.DebugLogPath = $baseLocalEntry + '_logs\winscp.' + $id + '.deploy.debug.log'

    $session.Open($sessionOptions)
    $session.add_FileTransferred({LogTransferredFiles($_)})

    $transferOptions = New-Object WinSCP.TransferOptions

    try
    {
        do
        {
            $done = TransferQueueHandler "public" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }
        while ($done -eq $False)

        $done = $False

        do
        {
            $done = TransferQueueHandler "site" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }
        while ($done -eq $False)

        $done = $False

        if ($full)
        {
            do
            {
                $done = TransferQueueHandler "kirby" $session $transferOptions $baseLocalDist $baseRemoteEntry
            }
            while ($done -eq $False)

            $done = $False

            do
            {
                $done = TransferQueueHandler "vendor" $session $transferOptions $baseLocalDist $baseRemoteEntry
            }
            while ($done -eq $False)

            $done = $False
        }

        do
        {
            $done = FileActionsHandler "public" $session $baseRemoteEntry
        }
        while ($done -eq $False)

        $done = $False

        do
        {
            $done = FileActionsHandler "site" $session $baseRemoteEntry
        }
        while ($done -eq $False)

        $done = $False

        if ($full)
        {
            do
            {
                $done = FileActionsHandler "kirby" $session $baseRemoteEntry
            }
            while ($done -eq $False)

            $done = $False

            do
            {
                $done = FileActionsHandler "vendor" $session $baseRemoteEntry
            }
            while ($done -eq $False)

            $done = $False
        }
    }
    finally
    {
        $session.Dispose()
        Write-Host
        Write-Host '## Complete ##'
        Write-Host
    }

    exit 0
}
catch
{
    Write-Host
    Write-Host '## Error ##'
    Write-Host
    Write-Host "$($_.Exception.Message)"
    Write-Host
    Write-Host "$($e.Destination)"
    Write-Host
    Write-Host '##'

    exit 1
}
