# NAME
$id = $Env:APP_NAME

# LOCATION
$baseLocalEntry = 'E:\Sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalConfigPath = 'D:\Tools\__configs\M-1\sites\' + $id + '\'
$baseLocalBackup = $baseLocalEntryPath + 'backup' + '\'
$baseLocalContent = $baseLocalEntryPath + 'db' + '\'
$baseLocalStorage = $baseLocalEntryPath + 'dist\storage' + '\'

$baseRemoteEntry = '/'
$baseRemoteContent = $baseRemoteEntry + 'content' + '/'
$baseRemoteStorage = $baseRemoteEntry + 'storage' + '/'

# OPTIONS
$done = $false

# SESSION
$session = $Null
$sessionOptions = $Null
$sessionLogPath = 'D:\Sync\OneDrive\_mmrhcs\_logs\_winscp\m1.winscp.' + $id + '.clone.log'
$sessionDebugPath = 'D:\Sync\OneDrive\_mmrhcs\_logs\_winscp\m1.winscp.' + $id + '.clone.debug.log'

# DEPENDENCY
$winSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$winSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

try
{
    Write-Host '## RUN ## CLONE'

    Add-Type -Path $winSCPdnet

    Import-Module ($baseLocalEntryPath + 'run\module\env.psm1')
    Import-Module ($baseLocalEntryPath + 'run\module\session.psm1')
    Import-Module ($baseLocalEntryPath + 'run\module\transfer.psm1')

    # Enviroment
    $envConfig = GetEnvConfig $baseLocalEntryPath

    # Authentication
    $usr = $envConfig.SESSION_USER
    $hsh = $envConfig.SESSION_HASH
    $key = $baseLocalConfigPath + 'auth\production'
    $pwd = $($hsh | ConvertTo-SecureString -Key (Get-Content $key))

    # Session
    $sessionOptions = SessionSettings $envConfig.SESSION_HOST $usr $pwd

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
