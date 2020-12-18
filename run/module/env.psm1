Function GetEnvConfig {

    $localEnvFile = ".env"
    $conf = New-Object -TypeName psobject

    if (!(Test-Path $localEnvFile)) {

        Write-Host ".env missing"
        return
    }

    $localEnv = Get-Content $localEnvFile -ErrorAction Stop

    foreach ($line in $localEnv) {

        $kvp = $line -split "=",2
        $conf | Add-Member -MemberType NoteProperty -Name $kvp[0] -Value $kvp[1]
    }

    return $conf
}

function Update-Composer {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory)] [ValidateSet('Clear','Init')] [String]$Mode
    )

    if ($Mode -eq 'Init') {

        Write-Host 'INITIALIZE'

        if ($Env:NODE_ENV -ne 'development') {

            if (Test-Path '.\app\composer.json') {

                Write-Host 'WORKING..'

                Copy-Item '.\app\composer.json' -Destination '.\dist'
            }

            composer update -d '.\dist'

        } else {

            Write-Host 'WORKING..'

            composer update -d '.\' --root-reqs
        }

        return
    }

    if ($Mode -eq 'Clear') {

        Write-Host 'CLEANUP'

        composer install -d '.\dist' --no-dev

        if (Test-Path '.\dist\composer.*') {

            Write-Host 'WORKING..'

            Remove-Item '.\dist\composer.*'
        }

        return
    }
}
