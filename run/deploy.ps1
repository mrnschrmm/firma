# Scope
$id = "firma"
$HostName = "wp1177004.server-he.de"
$UserName = "ftp1177004-s"

# Helper
$suffix = "_new"

# Local
$baseLocalEntry = "E:\Sites\"
$baseLocalEntryPath = $baseLocalEntry + $id + '\'

$baseLocalConfig = "D:\Tools\__config\sites\"
$baseLocalConfigPath = $baseLocalConfig + $id + '\'

$baseLocalWinSCPexec = $Env:APPS_HOME + '\' + "winscp\current\WinSCP.exe"
$baseLocalWinSCPdnet = $Env:APPS_HOME + '\' + "winscp\current\WinSCPnet.dll"

$baseLocalEnv = $baseLocalEntryPath + 'env' + '\'
$baseLocalDist = $baseLocalEntryPath + 'dist' + '\'

$baseLocalPublic = $baseLocalDist + 'public' + '\'
$baseLocalKirby = $baseLocalDist + 'kirby' + '\'
$baseLocalSite = $baseLocalDist + 'site' + '\'

# Remote
$baseRemoteEntry = "/"

$baseRemoteSite = $baseRemoteEntry + "site"
$baseRemoteKirby = $baseRemoteEntry + "kirby"
$baseRemotePublic = $baseRemoteEntry + "public"

# Authentication
$hsh = $baseLocalEnv + 'hash.txt'
$key = $baseLocalConfigPath + 'aeskey.txt'
$pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))

Function TransferQueueSite()
{
    # Queue
    $transferQueue = $session.PutFiles($baseLocalSite, ($baseRemoteSite + $suffix), $False, $transferOptions)
    # Error handler
    $transferQueue.Check()
}

Function TransferQueueKirby()
{
    # Queue
    $transferQueue = $session.PutFiles($baseLocalKirby, ($baseRemoteKirby + $suffix), $False, $transferOptions)
    # Error handler
    $transferQueue.Check()
}

Function TransferQueuePublic()
{
    # Queue
    $transferQueueHtaccess = $session.PutFiles($baseLocalPublic + '/.htaccess', ($baseRemotePublic + '/*' + $suffix), $False, $transferOptions)
    $transferQueuePHP = $session.PutFiles($baseLocalPublic + '/*.php', ($baseRemotePublic + '/*' + $suffix), $False, $transferOptions)
    $transferQueueJS = $session.PutFiles($baseLocalPublic + '/*.js', ($baseRemotePublic + '/*' + $suffix), $False, $transferOptions)
    $transferQueueCSS = $session.PutFiles($baseLocalPublic + '/*.css', ($baseRemotePublic + '/*' + $suffix), $False, $transferOptions)
    # Error handler
    $transferQueueHtaccess.Check()
    $transferQueuePHP.Check()
    $transferQueueJS.Check()
    $transferQueueCSS.Check()
}

Function FileLocationHandler()
{
    Write-Host "Rename: Site Directory"
    $session.MoveFile('site', 'site_old')
    $session.MoveFile('site_new', 'site')

    Write-Host "Rename: Kirby Directory"
    $session.MoveFile('kirby', 'kirby_old')
    $session.MoveFile('kirby_new', 'kirby')

    Write-Host "Rename: Public Directory Files"
    $session.MoveFile(($baseRemotePublic + '/.htaccess'), ($baseRemotePublic + '/.htaccess_old'))
    $session.MoveFile(($baseRemotePublic + '/index.php'), ($baseRemotePublic + '/index.php_old'))
    $session.MoveFile(($baseRemotePublic + '/main.min.css'), ($baseRemotePublic + '/main.min.css_old'))
    $session.MoveFile(($baseRemotePublic + '/main.min.js'), ($baseRemotePublic + '/main.min.js_old'))
    $session.MoveFile(($baseRemotePublic + '/panel.min.css'), ($baseRemotePublic + '/panel.min.css_old'))
    $session.MoveFile(($baseRemotePublic + '/panel.min.js'), ($baseRemotePublic + '/panel.min.js_old'))
    $session.MoveFile(($baseRemotePublic + '/vendor.head.min.js'), ($baseRemotePublic + '/vendor.head.min.js_old'))
    $session.MoveFile(($baseRemotePublic + '/vendor.min.js'), ($baseRemotePublic + '/vendor.min.js_old'))

    $session.MoveFile(($baseRemotePublic + '/.htaccess_new'), ($baseRemotePublic + '/.htaccess'))
    $session.MoveFile(($baseRemotePublic + '/index.php_new'), ($baseRemotePublic + '/index.php'))
    $session.MoveFile(($baseRemotePublic + '/main.min.css_new'), ($baseRemotePublic + '/main.min.css'))
    $session.MoveFile(($baseRemotePublic + '/main.min.js_new'), ($baseRemotePublic + '/main.min.js'))
    $session.MoveFile(($baseRemotePublic + '/panel.min.css_new'), ($baseRemotePublic + '/panel.min.css'))
    $session.MoveFile(($baseRemotePublic + '/panel.min.js_new'), ($baseRemotePublic + '/panel.min.js'))
    $session.MoveFile(($baseRemotePublic + '/vendor.head.min.js_new'), ($baseRemotePublic + '/vendor.head.min.js'))
    $session.MoveFile(($baseRemotePublic + '/vendor.min.js_new'), ($baseRemotePublic + '/vendor.min.js'))

    Write-Host "Cleanup"
    $session.RemoveFiles('site_old')
    $session.RemoveFiles('kirby_old')
    $session.RemoveFiles($baseRemotePublic + '/*_old')
}

Function LogTransferredFiles
{
    param($e)

    if ($e.Error -eq $Null)
    {
        Write-Host "$(Get-Date -Format "HH:mm:ss") - Transfer of $($e.Destination) succeeded"
    }
    else
    {
        Write-Host "$(Get-Date -Format "HH:mm:ss") - Transfer of $($e.Destination) failed: $($e.Error)"
    }
}

try
{
    Write-Host "Init Session..."
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

    # Session options
    $sessionOptions.AddRawSettings("AddressFamily", "1")
    $sessionOptions.AddRawSettings("FollowDirectorySymlinks", "1")
    $sessionOptions.AddRawSettings("Utf", "1")
    $sessionOptions.AddRawSettings("FtpForcePasvIp2", "0")
    $sessionOptions.AddRawSettings("FtpPingInterval", "10")
    $sessionOptions.AddRawSettings("SslSessionReuse", "0")
    $session = New-Object WinSCP.Session

    # Transfer options
    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.ResumeSupport.State = [WinSCP.TransferResumeSupportState]::On

    # Executable path
    $session.ExecutablePath = $baseLocalWinSCPexec

    try
    {
        Write-Host "Init Deployment..."
        Write-Host ""
        # Init session
        $session.Open($sessionOptions)

        # Log transfers
        $session.add_FileTransferred( { LogTransferredFiles($_) } )

        Write-Host ""
        Write-Host "Transfer: Kirby Directory"
        Write-Host ""
        TransferQueueKirby

        Write-Host ""
        Write-Host "Transfer: Site Directory"
        Write-Host ""
        TransferQueueSite

        Write-Host ""
        Write-Host "Transfer: Public Directory Files"
        Write-Host ""
        TransferQueuePublic

        Write-Host ""
        Write-Host "Location: Activate Uploads"
        Write-Host ""
        FileLocationHandler
    }
    finally
    {
        Write-Host ""
        Write-Host "Exit..."
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
