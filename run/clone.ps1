$id = "firma"
$HostName = 'wp1177004.server-he.de'
$UserName = 'ftp1177004-s'

# Location
$baseLocalEntry = 'E:\Sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalConfigPath = 'D:\Tools\__configs\M-1\sites\' + $id + '\'
$baseLocalBackup = $baseLocalEntryPath + 'backup' + '\'
$baseLocalContent = $baseLocalEntryPath + 'db' + '\'
$baseLocalStorage = $baseLocalEntryPath + 'dist\storage' + '\'

$baseRemoteEntry = '/'
$baseRemoteContent = $baseRemoteEntry + 'content' + '/'
$baseRemoteStorage = $baseRemoteEntry + 'storage' + '/'

# WinSCP
$winSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$winSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

# Authentication
$hsh = $baseLocalEntryPath + 'env\prod'
$key = $baseLocalConfigPath + 'auth\prod'
$pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))

# Session
$session = $Null
$sessionOptions = $Null
$sessionLogPath = $baseLocalEntry + '_logs\_winscp.deploy.log'
$sessionDebugPath = $baseLocalEntry + '_logs\_winscp.deploy.debug.log'

# Helper
$done = $false

try
{
    Write-Host '## RUN ## CLONE'

    Add-Type -Path $winSCPdnet

    Import-Module ($baseLocalEntryPath + 'run\module\session.psm1')
    Import-Module ($baseLocalEntryPath + 'run\module\transfer.psm1')

    $sessionOptions = SessionSettings $HostName $UserName $pwd

    $session = New-Object WinSCP.Session
    $session.ExecutablePath = $winSCPexec
    $session.SessionLogPath = $sessionLogPath
    $session.DebugLogPath = $sessionDebugPath

    $session.Open($sessionOptions)
    $session.add_FileTransferred({LogTransferredFiles($_)})

    try
    {
        do
        {
            $done = FileActionsHandler "clone" $baseLocalEntryPath $baseLocalBackup $baseLocalContent
        }
        while ($done -eq $False)

        $done = $False

        do
        {
            $done = TransferQueueHandler "clone::content" $session $baseRemoteContent $baseLocalContent
        }
        while ($done -eq $False)

        $done = $False

        do
        {
            $done = TransferQueueHandler "clone::storage" $session $baseRemoteStorage $baseLocalStorage
        }
        while ($done -eq $False)

        $done = $False
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
    Write-Host "$($_.ScriptStackTrace)"
    Write-Host
    Write-Host '##'

    exit 1
}
