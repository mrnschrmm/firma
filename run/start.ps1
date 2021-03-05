Write-Host '### TASK ### RUN ###'
Write-Host

$env:NODE_ENV=$Args[1]

if ($Args[2] -match 'debug') {
    $env:NODE_DEBUG="*"
}

Import-Module '.\run\module\env.psm1'
Update-Composer -Mode 'Init'

gulp
