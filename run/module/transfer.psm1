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

    if ($args[0] -eq 'clone')
    {
        Write-Host
        Write-Host 'Starting...TransferQueue: Content Remote'
        Write-Host

        $clone = $args[1].GetFiles($args[2] + '*', $args[3] + '*')
        $clone.Check()

        Write-Host

        return $true
    }
}

Function FileActionsHandler
{

    if ($args[0] -eq 'clone')
    {
        if( !(Get-ChildItem $args[2] | Measure-Object).Count -eq 0)
        {
            Write-Host "Starting...TransferQueue: Content Local Backup"
            Write-Host

            $timestamp = $(Get-Date -Format "yyyyMMddHHmmss")

            Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Working...Prepare"
            New-Item -Path $args[1] -Name $timestamp -ItemType "directory" | Out-Null
            Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Working...Process"
            Copy-Item ($args[2] + '*') ($args[1] + $timestamp) -Recurse
        }

        return $true
    }

    if ($args[0] -eq 'deploy')
    {
        if ($args[3] -eq $true)
        {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Renaming...Kirby"

            $args[1].MoveFile('kirby', 'kirby__del')
            $args[1].MoveFile('kirby__up', 'kirby')
        }

        Write-Host "$(Get-Date -Format 'HH:mm:ss') ...Renaming...Site"

        $args[1].MoveFile('site', 'site__del')
        $args[1].MoveFile('site__up', 'site')

        Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Renaming...Public"

        $args[1].MoveFile(($args[2] + 'public/.htaccess'), ($args[2] + 'public/.htaccess__del'))
        $args[1].MoveFile(($args[2] + 'public/index.php'), ($args[2] + 'public/index.php__del'))
        $args[1].MoveFile(($args[2] + 'public/main.min.css'), ($args[2] + 'public/main.min.css__del'))
        $args[1].MoveFile(($args[2] + 'public/main.min.js'), ($args[2] + 'public/main.min.js__del'))
        $args[1].MoveFile(($args[2] + 'public/panel.min.css'), ($args[2] + 'public/panel.min.css__del'))
        $args[1].MoveFile(($args[2] + 'public/panel.min.js'), ($args[2] + 'public/panel.min.js__del'))
        $args[1].MoveFile(($args[2] + 'public/vendor.head.min.js'), ($args[2] + 'public/vendor.head.min.js__del'))
        $args[1].MoveFile(($args[2] + 'public/vendor.min.js'), ($args[2] + 'public/vendor.min.js__del'))

        $args[1].MoveFile(($args[2] + 'public/.htaccess__up'), ($args[2] + 'public/.htaccess'))
        $args[1].MoveFile(($args[2] + 'public/index.php__up'), ($args[2] + 'public/index.php'))
        $args[1].MoveFile(($args[2] + 'public/main.min.css__up'), ($args[2] + 'public/main.min.css'))
        $args[1].MoveFile(($args[2] + 'public/main.min.js__up'), ($args[2] + 'public/main.min.js'))
        $args[1].MoveFile(($args[2] + 'public/panel.min.css__up'), ($args[2] + 'public/panel.min.css'))
        $args[1].MoveFile(($args[2] + 'public/panel.min.js__up'), ($args[2] + 'public/panel.min.js'))
        $args[1].MoveFile(($args[2] + 'public/vendor.head.min.js__up'), ($args[2] + 'public/vendor.head.min.js'))
        $args[1].MoveFile(($args[2] + 'public/vendor.min.js__up'), ($args[2] + 'public/vendor.min.js'))

        Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Deleting...Folder"

        $args[1].RemoveFiles('*__del')

        Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Deleting...Files"

        Write-Host
        $args[1].RemoveFiles($args[2] + 'public/*__del')

        return $true
    }


}

Function LogTransferredFiles
{
    param($e)

    if ($e.Error -eq $Null)
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Working... $($e.Destination)"
    }
    else
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') .. Error... $($e.Error) - $($e.Destination)"
    }
}
