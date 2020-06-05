# NAME
$id = $Env:APP_NAME

# LOCATION
$baseLocalEntry = 'E:\Sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalConfigPath = 'D:\Tools\__configs\M-1\sites\' + $id + '\'
$baseLocalDist = $baseLocalEntryPath + 'dist' + '\'
$baseRemoteEntry = '/'

# OPTIONS
$envConfig = $Null
$full = if ($args -eq '-full') { $True } else { $False }
$session = $Null
$done = $False

# DEPENDENCY
$winSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$winSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

try
{
    Write-Host '## RUN ## DEPLOY'

    Add-Type -Path $winSCPdnet
    Import-Module ($baseLocalEntryPath + 'run\module\env.psm1')

    # Authentication
    $envConfig = GetEnvConfig $baseLocalEntryPath

    $usr = $(if ($Env:NODE_ENV -eq 'staging') { $envConfig.SESSION_USER_PREVIEW } else { $envConfig.SESSION_USER })
    $hsh = $(if ($Env:NODE_ENV -eq 'staging') { $envConfig.SESSION_HASH_PREVIEW } else { $envConfig.SESSION_HASH })
    $key = $(if ($Env:NODE_ENV -eq 'staging') { $baseLocalConfigPath + "auth\staging" } else { $baseLocalConfigPath + "auth\production" })
    $pw = $($hsh | ConvertTo-SecureString -Key (Get-Content $key))

    # Transfer
    Import-Module ($baseLocalEntryPath + 'run\module\transfer.psm1')
    $transferOptions = New-Object WinSCP.TransferOptions

    Function SessionConnect
    {
        # Options
        $options = New-Object WinSCP.SessionOptions -Property @{
            Protocol = [WinSCP.Protocol]::Ftp
            FtpSecure = [WinSCP.FtpSecure]::Explicit
            HostName = $envConfig.SESSION_HOST
            UserName = $usr
            Password = [System.Net.NetworkCredential]::new('', $pw).Password
            TimeoutInMilliseconds = '60000'
        }

        $options.AddRawSettings("AddressFamily", "1")
        $options.AddRawSettings("FollowDirectorySymlinks", "1")
        $options.AddRawSettings("Utf", "1")
        $options.AddRawSettings("MinTlsVersion", "12")

        $sssn = New-Object WinSCP.Session
        $sssn.ExecutablePath = $winSCPexec
        $sssn.DebugLogLevel = '0'
        $sssn.SessionLogPath = 'D:\Sync\OneDrive\_mmrhcs\_logs\_winscp\m1.winscp.' + $id + '.deploy.log'
        $sssn.DebugLogPath = 'D:\Sync\OneDrive\_mmrhcs\_logs\_winscp\m1.winscp.' + $id + '.deploy.debug.log'
        $sssn.Open($options)

        $sssn.add_FileTransferred({LogTransferredFiles($_)})

        return $sssn
    }

    try
    {
        $session = SessionConnect

        do
        {
            $done = TransferQueueHandler "dotenv" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = TransferQueueHandler "config" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = TransferQueueHandler "public" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = TransferQueueHandler "site" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        if ($full)
        {
            $session = SessionConnect

            do
            {
                $done = TransferQueueHandler "kirby" $session $transferOptions $baseLocalDist $baseRemoteEntry
            }
            while ($done -eq $False)

            $session.Dispose()
            $done = $False

            $session = SessionConnect

            do
            {
                $done = TransferQueueHandler "vendor" $session $transferOptions $baseLocalDist $baseRemoteEntry
            }
            while ($done -eq $False)

            $session.Dispose()
            $done = $False
        }

        $session = SessionConnect

        do
        {
            $done = FileActionsHandler "dotenv" $session $baseRemoteEntry $baseLocalEntryPath
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = FileActionsHandler "config" $session $baseRemoteEntry
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = FileActionsHandler "public" $session $baseRemoteEntry $baseLocalEntryPath
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = FileActionsHandler "site" $session $baseRemoteEntry
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        if ($full)
        {
            $session = SessionConnect

            do
            {
                $done = FileActionsHandler "kirby" $session $baseRemoteEntry
            }
            while ($done -eq $False)

            $session.Dispose()
            $done = $False

            $session = SessionConnect

            do
            {
                $done = FileActionsHandler "vendor" $session $baseRemoteEntry
            }
            while ($done -eq $False)

            $session.Dispose()
            $done = $False
        }
    }
    finally
    {
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
