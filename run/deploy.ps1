# Scope
$id = "firma"
$HostName = 'wp1177004.server-he.de'
$UserName = 'ftp1177004-s'

# Helper
$suffix = '_update'

# Remote
$baseRemoteEntry = '/'

# Local
$baseLocalEntry = 'E:\Sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalDist = $baseLocalEntryPath + 'dist' + '\'
$baseLocalConfigPath = 'D:\Tools\__config\sites\' + $id + '\'

# WinSCP
$baseLocalWinSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$baseLocalWinSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

Function TransferQueueSite()
{
    # Site Directory Queue
    $transferQueue = $session.PutFiles($baseLocalDist + 'site', ($baseRemoteEntry + 'site' + $suffix), $False, $transferOptions)
    $transferQueue.Check()
}

Function TransferQueueKirby()
{
    # Kirby Directory Queue
    $transferQueue = $session.PutFiles($baseLocalDist + 'kirby', ($baseRemoteEntry + 'kirby' + $suffix), $False, $transferOptions)
    $transferQueue.Check()
}

Function TransferQueuePublic()
{
    # Public Directory Queue
    $transferQueueHtaccess = $session.PutFiles($baseLocalDist + 'public\.htaccess', ($baseRemoteEntry + 'public/*' + $suffix), $False, $transferOptions)
    $transferQueuePHP = $session.PutFiles($baseLocalDist + 'public\*.php', ($baseRemoteEntry + 'public/*' + $suffix), $False, $transferOptions)
    $transferQueueJS = $session.PutFiles($baseLocalDist + 'public\*.js', ($baseRemoteEntry + 'public/*' + $suffix), $False, $transferOptions)
    $transferQueueCSS = $session.PutFiles($baseLocalDist + 'public\*.css', ($baseRemoteEntry + 'public/*' + $suffix), $False, $transferOptions)
    $transferQueueHtaccess.Check()
    $transferQueuePHP.Check()
    $transferQueueJS.Check()
    $transferQueueCSS.Check()
}

Function FileLocationHandler()
{
    Write-Host 'Activate: Site Directory'
    $session.MoveFile('site', 'site_trash')
    $session.MoveFile('site_update', 'site')

    Write-Host "Activate: Kirby Directory"
    $session.MoveFile('kirby', 'kirby_trash')
    $session.MoveFile('kirby_update', 'kirby')

    Write-Host "Activate: Public Directory"
    $session.MoveFile(($baseRemoteEntry + 'public/.htaccess'), ($baseRemoteEntry + 'public/.htaccess_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/index.php'), ($baseRemoteEntry + 'public/index.php_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/main.min.css'), ($baseRemoteEntry + 'public/main.min.css_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/main.min.js'), ($baseRemoteEntry + 'public/main.min.js_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/panel.min.css'), ($baseRemoteEntry + 'public/panel.min.css_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/panel.min.js'), ($baseRemoteEntry + 'public/panel.min.js_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/vendor.head.min.js'), ($baseRemoteEntry + 'public/vendor.head.min.js_trash'))
    $session.MoveFile(($baseRemoteEntry + 'public/vendor.min.js'), ($baseRemoteEntry + 'public/vendor.min.js_trash'))

    $session.MoveFile(($baseRemoteEntry + 'public/.htaccess_update'), ($baseRemoteEntry + 'public/.htaccess'))
    $session.MoveFile(($baseRemoteEntry + 'public/index.php_update'), ($baseRemoteEntry + 'public/index.php'))
    $session.MoveFile(($baseRemoteEntry + 'public/main.min.css_update'), ($baseRemoteEntry + 'public/main.min.css'))
    $session.MoveFile(($baseRemoteEntry + 'public/main.min.js_update'), ($baseRemoteEntry + 'public/main.min.js'))
    $session.MoveFile(($baseRemoteEntry + 'public/panel.min.css_update'), ($baseRemoteEntry + 'public/panel.min.css'))
    $session.MoveFile(($baseRemoteEntry + 'public/panel.min.js_update'), ($baseRemoteEntry + 'public/panel.min.js'))
    $session.MoveFile(($baseRemoteEntry + 'public/vendor.head.min.js_update'), ($baseRemoteEntry + 'public/vendor.head.min.js'))
    $session.MoveFile(($baseRemoteEntry + 'public/vendor.min.js_update'), ($baseRemoteEntry + 'public/vendor.min.js'))

    Write-Host ""
    Write-Host "Cleanup Session..."

    $session.RemoveFiles('*_trash')
    $session.RemoveFiles($baseRemoteEntry + 'public/*_trash')
}

Function LogTransferredFiles
{
    param($e)

    if ($e.Error -eq $Null)
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Transfer: $($e.Destination)"
    }
    else
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Error: $($e.Error) - $($e.Destination)"
    }
}

try
{
    Write-Host 'Init Session...'
    Add-Type -Path $baseLocalWinSCPdnet

    # Authentication
    $hsh = $baseLocalEntryPath + 'env\hash.txt'
    $key = $baseLocalConfigPath + 'aeskey.txt'
    $pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))

    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
      Protocol = [WinSCP.Protocol]::Ftp
      HostName = $HostName
      UserName = $UserName
      Password = [System.Net.NetworkCredential]::new('', $pwd).Password
      FtpSecure = [WinSCP.FtpSecure]::Explicit
      TimeoutInMilliseconds = 3600
    }

    $sessionOptions.AddRawSettings('AddressFamily', '1')
    $sessionOptions.AddRawSettings('FollowDirectorySymlinks', '1')
    $sessionOptions.AddRawSettings('Utf', '1')
    $sessionOptions.AddRawSettings('FtpForcePasvIp2', '0')
    $sessionOptions.AddRawSettings('FtpPingInterval', '10')
    $sessionOptions.AddRawSettings('SslSessionReuse', '0')
    $session = New-Object WinSCP.Session
    $session.ExecutablePath = $baseLocalWinSCPexec

    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.ResumeSupport.State = [WinSCP.TransferResumeSupportState]::On

    try
    {
        Write-Host 'Init Deployment...'
        Write-Host ''
        $session.Open($sessionOptions)
        $session.add_FileTransferred( { LogTransferredFiles($_) } )

        Write-Host 'Transfer: Kirby Directory'
        Write-Host ''
        TransferQueueKirby

        Write-Host ''
        Write-Host 'Transfer: Site Directory'
        Write-Host ''
        TransferQueueSite

        Write-Host ''
        Write-Host 'Transfer: Public Directory'
        Write-Host ''
        TransferQueuePublic

        Write-Host ''
        Write-Host 'Upload complete...'
        FileLocationHandler
    }
    finally
    {
        Write-Host ''
        Write-Host 'Exit...'
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
