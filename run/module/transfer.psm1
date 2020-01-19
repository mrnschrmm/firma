Function TransferQueueHandler
{
    $scope = (Get-Culture).TextInfo
    $done = $False

    Function TransferHandler()
    {
        foreach ($filemask in $args[5])
        {
            $transfer = $args[1].PutFiles($args[3] + $args[0] + '\' + $filemask, ($args[4] + $args[0] + '/*__up'), $False, $args[2])
            $transfer.Check()
        }

        return $True
    }

    if ($args[0] -eq 'public')
    {
        Write-Host
        Write-Host "## TransferQueue ##" $scope.ToTitleCase($args[0])
        Write-Host

        $filemasks = '.*', '*.php', '*.js', '*.css'

        do
        {
            $done = TransferHandler $args[0] $args[1] $args[2] $args[3] $args[4] $filemasks
        }

        while ($done -eq $False)
        $done = $False

        return $True
    }

    if ($args[0] -eq 'kirby' -OR $args[0] -eq 'site')
    {
        Write-Host
        Write-Host "## TransferQueue ##" $scope.ToTitleCase($args[0])
        Write-Host

        $transfer = $args[1].PutFiles($args[3] + $args[0], ($args[4] + $args[0] + '__up'), $False, $args[2])
        $transfer.Check()

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
        if (!(Test-Path $args[3] -PathType container))
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
        Write-Host

        $path = $args[2] + 'public'
        $done = $False

        Function ActionHandler()
        {
            if ($args[0] -eq 'del')
            {
                $files = $args[1].EnumerateRemoteFiles($args[2], '*', [WinSCP.EnumerationOptions]::None)

                foreach ($file in $files)
                {
                    if ($file.FullName -notmatch "__up$")
                    {
                        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... $($file.FullName) => $($file.FullName)__del"
                        $args[1].MoveFile($file.FullName, $file.FullName + '__del')
                    }
                }

                return $True
            }

            if ($args[0] -eq 'up')
            {
                $files = $args[1].EnumerateRemoteFiles($args[2], '*', [WinSCP.EnumerationOptions]::None)

                foreach ($file in $files)
                {
                    if ($file.FullName -notmatch "__del$")
                    {
                        $filename = $file.FullName -replace "__up"
                        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... $($file.FullName) => $filename"
                        $args[1].MoveFile($file.FullName, $filename)
                    }
                }

                return $True
            }
        }

        if ($args[1].FileExists($path))
        {
            do
            {
                $done = ActionHandler "del" $args[1] $path
            }

            while($done -eq $False)
            $done = $False

            do
            {
                $done = ActionHandler "up" $args[1] $path
            }

            while($done -eq $False)
            $done = $False
        }

        Write-Host
        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Move New Site Files"

        $args[1].MoveFile('site', 'site__del')
        $args[1].MoveFile('site__up', 'site')

        if ($args[3] -eq $True)
        {
            Write-Host
            Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Move New Kirby Files"

            $args[1].MoveFile('kirby', 'kirby__del')
            $args[1].MoveFile('kirby__up', 'kirby')

            Write-Host
            Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Remove Outdated Kirby Files"

            $args[1].RemoveFiles('kirby__del')
        }

        Write-Host
        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Remove Outdated Site Files"

        $args[1].RemoveFiles('site__del')

        Write-Host
        Write-Host "$(Get-Date -Format 'HH:mm:ss') Working... Remove Outdated Public Files"

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
        Write-Host "## Error $($e.Error) ## $($e.Destination)"
    }
}
