# NAME
$id = $Env:APP_NAME

# LOCATION
$baseLocalEntry = 'T:\_sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalConfigPath = 'T:\__configs\M-1\sites\' + $id + '\'
$baseLocalBackup = $baseLocalEntryPath + 'backup' + '\'
$baseLocalContent = $baseLocalEntryPath + 'db' + '\'
$baseLocalStorage = $baseLocalEntryPath + 'dist\storage' + '\'

$baseRemoteEntry = '/'
$baseRemoteContent = $baseRemoteEntry + 'content' + '/'
$baseRemoteStorage = $baseRemoteEntry + 'storage' + '/'

# OPTIONS
$envConfig = $Null
$session = $Null
$done = $false

# DEPENDENCY
$winSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$winSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

try
{
    Write-Host '## RUN ## CLONE'

    Add-Type -Path $winSCPdnet
    Import-Module ($baseLocalEntryPath + 'run\module\env.psm1')

    # Authentication
    $envConfig = GetEnvConfig $baseLocalEntryPath

    $usr = $envConfig.SESSION_USER
    $hsh = $envConfig.SESSION_HASH
    $key = $baseLocalConfigPath + 'auth\production'
    $pw = $($hsh | ConvertTo-SecureString -Key (Get-Content $key))

    # Transfer
    Import-Module ($baseLocalEntryPath + 'run\module\transfer.psm1')

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
        $sssn.SessionLogPath = 'T:\_sync\OneDrive\_mmrhcs\_logs\_winscp\m1.winscp.' + $id + '.clone.log'
        $sssn.DebugLogPath = 'T:\_sync\OneDrive\_mmrhcs\_logs\_winscp\m1.winscp.' + $id + '.clone.debug.log'
        $sssn.Open($options)

        $sssn.add_FileTransferred({LogTransferredFiles($_)})

        return $sssn
    }

    try
    {
        $session = SessionConnect

        do
        {
            $done = FileActionsHandler "clone" $baseLocalEntryPath $baseLocalBackup $baseLocalContent
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = TransferQueueHandler "clone::content" $session $baseRemoteContent $baseLocalContent
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False

        $session = SessionConnect

        do
        {
            $done = TransferQueueHandler "clone::storage" $session $baseRemoteStorage $baseLocalStorage
        }
        while ($done -eq $False)

        $session.Dispose()
        $done = $False
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
    Write-Host "$($_.ScriptStackTrace)"
    Write-Host
    Write-Host '##'

    exit 1
}
