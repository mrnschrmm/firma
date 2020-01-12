# Scope
$id = "firma"
$HostName = "wp1177004.server-he.de"
$UserName = "ftp1177004-s"

# Helper
$timestamp = $(Get-Date -Format "yyyyMMddHHmmss")

# Local
$baseLocalIndex = "E:\Sites"
$baseLocalIndexConfig = "D:\Tools\__config\sites"
$baseLocalContent = "db"
$baseLocalContentPath = $baseLocalIndex + '\' + $id + '\' + $baseLocalContent
$baseLocalEnv = "env"
$baseLocalBackupDirectory = "backup"
$baseLocalBackupPath = $baseLocalIndex + '\' + $id + '\' + $baseLocalBackupDirectory
$baseLocalBackup = $baseLocalBackupPath + "\" + $timestamp
$baseLocalWinSCPexec = $Env:APPS_HOME + '\' + "winscp\current\WinSCP.exe"
$baseLocalWinSCPdnet = $Env:APPS_HOME + '\' + "winscp\current\WinSCPnet.dll"
$baseLocal = $baseLocalIndex + '\' + $id + '\' + $baseLocalContent + '\' + '*'

# Remote
$baseRemoteContent = "content"
$baseRemote = './' + $baseRemoteContent + '/' + '*'

# Authentication
$hsh = $baseLocalIndex + '\' + $id + '\' + $baseLocalEnv + '\' + 'hash.txt'
$key = $baseLocalIndexConfig + '\' + $id + '\' + 'aeskey.txt'
$pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))

Function LogTransferredFiles
{
    param($e)

    if ($e.Error -eq $Null)
    {
        Write-Host "$(Get-Date -Format "HH:mm:ss") - Transfer of $($e.FileName) succeeded"
    }
    else
    {
        Write-Host "$(Get-Date -Format "HH:mm:ss") - Transfer of $($e.FileName) failed: $($e.Error)"
    }
}

try
{
    Write-Host "Init..."
    # Load .NET assembly
    Add-Type -Path $baseLocalWinSCPdnet

    # WinSCP Session
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
      Protocol = [WinSCP.Protocol]::Ftp
      HostName = $HostName
      UserName = $UserName
      Password = [System.Net.NetworkCredential]::new('', $pwd).Password
      FtpSecure = [WinSCP.FtpSecure]::Explicit
      TimeoutInMilliseconds = 3600
    }

    $sessionOptions.AddRawSettings("AddressFamily", "1")
    $sessionOptions.AddRawSettings("FollowDirectorySymlinks", "1")
    $sessionOptions.AddRawSettings("Utf", "1")
    $sessionOptions.AddRawSettings("FtpForcePasvIp2", "0")
    $sessionOptions.AddRawSettings("FtpPingInterval", "10")
    $sessionOptions.AddRawSettings("SslSessionReuse", "0")
    $session = New-Object WinSCP.Session

    # Executable path
    $session.ExecutablePath = $baseLocalWinSCPexec

    # Check local files
    if( !(Get-ChildItem $baseLocalContentPath | Measure-Object).Count -eq 0)
    {
        Write-Host "Backup..."
        # Backup local files
        New-Item -Path $baseLocalBackupPath -Name $timestamp -ItemType "directory" | Out-Null
        Copy-Item $baseLocal $baseLocalBackup -Recurse
    }

    try
    {
        Write-Host "Clone..."
        Write-Host ""
        # Init session
        $session.Open($sessionOptions)
        # Log files
        $session.add_FileTransferred( { LogTransferredFiles($_) } )
        # Init transfer
        $session.GetFiles($baseRemote, $baseLocal).Check()
    }
    finally
    {
        Write-Host ""
        Write-Host "Exit..."
        Write-Host ""
        $session.Dispose()
    }

    exit 0
}
catch
{
    Write-Host "ErrorMessage: $($_.Exception.Message)"
    Write-Host "ScriptStackTrace: $($_.ScriptStackTrace)"

    exit 1
}
