# Scope
$nameLocal = "firma"
$nameRemote = "s"

# Remote
$baseRemote = "/www"
$baseRemoteContent = "content"

# Local
$baseLocal = "E:\Sites"
$baseLocalConfig = "D:\Tools\__config\sites"
$baseLocalBackup = "backup"
$baseLocalEnv = "env"
$baseLocalContent = "db"

$baseLocalWinSCPexec = "C:\Apps\_m\apps\winscp\current\WinSCP.exe"
$baseLocalWinSCPdnet = "C:\Apps\_m\apps\winscp\current\WinSCPnet.dll"

# Credential
$hsh = $baseLocal + '\' + $nameLocal + '\' + $baseLocalEnv + '\' + 'hash.txt'
$key = $baseLocalConfig + '\' + $nameLocal + '\' + 'aeskey.txt'
$pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))

# Helper
$timestamp = $(Get-Date -Format "yyyyMMddHHmmss")

# Path
$backupBase = $baseLocal + '\' + $nameLocal + '\' + $baseLocalBackup
$backupPath = $backupBase + "\" + $timestamp

$local = $baseLocal + '\' + $nameLocal + '\' + $baseLocalContent + '\' + '*'
$remote = $baseRemote + '/' + $nameRemote + '/' + $baseRemoteContent + '/' + '*'

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
    Write-Host ""
    Write-Host "Init..."

    # Load .NET assembly
    Add-Type -Path $baseLocalWinSCPdnet

    # WinSCP Session
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
      Protocol = [WinSCP.Protocol]::Ftp
      HostName = "wp1177004.server-he.de"
      UserName = 'ftp1177004-global'
      Password = [System.Net.NetworkCredential]::new('', $pwd).Password
      FtpSecure = [WinSCP.FtpSecure]::Explicit
      TimeoutInMilliseconds = 5000
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

    Write-Host "Backup..."

    # Backup local files
    New-Item -Path $backupBase -Name $timestamp -ItemType "directory" | Out-Null
    Copy-Item $local $backupPath -Recurse

    try
    {
        Write-Host "Clone..."
        Write-Host ""

        # Init session
        $session.Open($sessionOptions)
        # Log files
        $session.add_FileTransferred( { LogTransferredFiles($_) } )
        # Init transfer
        $session.GetFiles($remote, $local).Check()
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
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Trace: $($_.ScriptStackTrace)"

    exit 1
}
