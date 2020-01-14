Function TransferQueueHandler
{
    $scope = (Get-Culture).TextInfo

    if ($args[0] -eq 'kirby' -OR $args[0] -eq 'site')
    {
        Write-Host
        Write-Host "Starting...TransferQueue:" $scope.ToTitleCase($args[0])
        Write-Host

        $transfer = $args[1].PutFiles($args[3] + $args[0], ($args[4] + $args[0] + '__up'), $False, $args[2])
        $transfer.Check()

        return $true
    }

    if ($args[0] -eq 'public')
    {
        Write-Host
        Write-Host "Starting...TransferQueue:" $scope.ToTitleCase($args[0])
        Write-Host

        $transferHtaccess = $args[1].PutFiles($args[3] + $args[0] + '\.htaccess', ($args[4] + $args[0] + '/*__up'), $False, $args[2])
        $transferPHP = $args[1].PutFiles($args[3] + $args[0] + '\*.php', ($args[4] + $args[0] + '/*__up'), $False, $args[2])
        $transferJS = $args[1].PutFiles($args[3] + $args[0] + '\*.js', ($args[4] + $args[0] + '/*__up'), $False, $args[2])
        $transferCSS = $args[1].PutFiles($args[3] + $args[0] + '\*.css', ($args[4] + $args[0] + '/*__up'), $False, $args[2])

        $transferHtaccess.Check()
        $transferPHP.Check()
        $transferJS.Check()
        $transferCSS.Check()

        return $true
    }
}

Function FileActionHandler
{
    Write-Host

    if ($args[2] -eq $true)
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Renaming...Kirby"

        $args[0].MoveFile('kirby', 'kirby__del')
        $args[0].MoveFile('kirby__up', 'kirby')
    }

    Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Renaming...Site"

    $args[0].MoveFile('site', 'site__del')
    $args[0].MoveFile('site__up', 'site')

    Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Renaming...Public"

    $args[0].MoveFile(($args[1] + 'public/.htaccess'), ($args[1] + 'public/.htaccess__del'))
    $args[0].MoveFile(($args[1] + 'public/index.php'), ($args[1] + 'public/index.php__del'))
    $args[0].MoveFile(($args[1] + 'public/main.min.css'), ($args[1] + 'public/main.min.css__del'))
    $args[0].MoveFile(($args[1] + 'public/main.min.js'), ($args[1] + 'public/main.min.js__del'))
    $args[0].MoveFile(($args[1] + 'public/panel.min.css'), ($args[1] + 'public/panel.min.css__del'))
    $args[0].MoveFile(($args[1] + 'public/panel.min.js'), ($args[1] + 'public/panel.min.js__del'))
    $args[0].MoveFile(($args[1] + 'public/vendor.head.min.js'), ($args[1] + 'public/vendor.head.min.js__del'))
    $args[0].MoveFile(($args[1] + 'public/vendor.min.js'), ($args[1] + 'public/vendor.min.js__del'))

    $args[0].MoveFile(($args[1] + 'public/.htaccess__up'), ($args[1] + 'public/.htaccess'))
    $args[0].MoveFile(($args[1] + 'public/index.php__up'), ($args[1] + 'public/index.php'))
    $args[0].MoveFile(($args[1] + 'public/main.min.css__up'), ($args[1] + 'public/main.min.css'))
    $args[0].MoveFile(($args[1] + 'public/main.min.js__up'), ($args[1] + 'public/main.min.js'))
    $args[0].MoveFile(($args[1] + 'public/panel.min.css__up'), ($args[1] + 'public/panel.min.css'))
    $args[0].MoveFile(($args[1] + 'public/panel.min.js__up'), ($args[1] + 'public/panel.min.js'))
    $args[0].MoveFile(($args[1] + 'public/vendor.head.min.js__up'), ($args[1] + 'public/vendor.head.min.js'))
    $args[0].MoveFile(($args[1] + 'public/vendor.min.js__up'), ($args[1] + 'public/vendor.min.js'))

    Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Deleting...Folder"

    $args[0].RemoveFiles('*__del')

    Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Deleting...Files"

    Write-Host
    $args[0].RemoveFiles($args[1] + 'public/*__del')

    return $true
}

Function LogTransferredFiles
{
    param($e)

    if ($e.Error -eq $Null)
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Working... $($e.Destination)"
    }
    else
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Error... $($e.Error) - $($e.Destination)"
    }
}
