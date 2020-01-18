Function TransferQueueHandler
{
    $scope = (Get-Culture).TextInfo

    if ($args[0] -eq 'kirby' -OR $args[0] -eq 'site')
    {
        Write-Host
        Write-Host "## TransferQueue ##" $scope.ToTitleCase($args[0])
        Write-Host

        $transfer = $args[1].PutFiles($args[3] + $args[0], ($args[4] + $args[0] + '__up'), $False, $args[2])
        $transfer.Check()

        return $True
    }

    if ($args[0] -eq 'public')
    {
        Write-Host
        Write-Host "## TransferQueue ##" $scope.ToTitleCase($args[0])
        Write-Host

        $masks = '.*', '*.php', '*.js', '*.css'
        $done = $False

        Function TransferQueue()
        {
            foreach ($mask in $masks)
            {
                $transfer = $args[1].PutFiles($args[3] + $args[0] + '\' + $mask, ($args[4] + $args[0] + '/*__up'), $False, $args[2])
                $transfer.Check()
            }

            return $True
        }

        do
        {
            $done = TransferQueue $args[0] $args[1] $args[2] $args[3] $args[4]
        }

        while ($done -eq $False)

        return $True
    }

    if ($args[0] -eq 'clone')
    {
        Write-Host
        Write-Host '## TransferQueue ## Content'
        Write-Host

        $transfer = $args[1].GetFiles($args[2] + '*', $args[3] + '*')
        $transfer.Check()

        return $True
    }
}

Function FileActionsHandler
{
    if ($args[0] -eq 'clone')
    {
        if ( !(Test-Path $args[3] -PathType container) )
        {
            New-Item -Path $args[1] -Name "db" -ItemType "directory" | Out-Null
        }

        elseif ( !(Get-ChildItem $args[3] | Measure-Object).Count -eq 0 )
        {
            Write-Host
            Write-Host "## TransferQueue ## Backup"
            Write-Host

            $timestamp = $(Get-Date -Format "yyyyMMddHHmmss")

            if ( !(Test-Path $args[2] -PathType container) )
            {
                New-Item -Path $args[1] -Name "backup" -ItemType "directory" | Out-Null
            }

            Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Prepare Backup Folder"
            New-Item -Path $args[2] -Name $timestamp -ItemType "directory" | Out-Null

            if (Test-Path ($args[2] + $timestamp) -PathType container)
            {
                Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Backup Content Data"
                Copy-Item ($args[3] + '*') ($args[2] + $timestamp) -Recurse
            }
        }

        return $True
    }

    if ($args[0] -eq 'deploy')
    {
        Write-Host
        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Activate Public Upload"

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

        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Activate Site Upload"

        $args[1].MoveFile('site', 'site__del')
        $args[1].MoveFile('site__up', 'site')

        if ($args[3] -eq $True)
        {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Activate Kirby Upload"

            $args[1].MoveFile('kirby', 'kirby__del')
            $args[1].MoveFile('kirby__up', 'kirby')
        }

        Write-Host
        Write-Host -NoNewLine "$(Get-Date -Format 'HH:mm:ss') Working... Remove Outdated Folders"

        $args[1].RemoveFiles('*__del')

        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Remove Outdated Files"
        Write-Host

        $args[1].RemoveFiles($args[2] + 'public/*__del')

        return $True
    }
}

Function LogTransferredFiles
{
    param($e)

    if ($e.Error -eq $Null)
    {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... $($e.Destination)"
    }

    else
    {
        Write-Host "## Error $($e.Error) ##  $($e.Destination)"
    }
}
