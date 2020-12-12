# BUILD
try {
    Write-Host '## RUN ## BUILD'
    Write-Host

    if (Test-Path '.\app\composer.json') {
        Write-Host 'WORKING...'
        Copy-Item '.\app\composer.json' -Destination '.\dist'
        composer update -d '.\dist'
    }

    Write-Host 'LINT'

    $lint = @(
        { .\dist\vendor\bin\phpcs --standard='.\phpcs.ruleset.xml' --report=summary '.\app' -v },
        { npx stylelint './app/snippets/**/*.scss' './app/resources/**/*.scss' },
        { npx eslint './app/resources/main.js' './app/resources/panel.js' './app/snippets/**/script.js' }
    )

    foreach ($item in $lint) {
        try {
            Write-Host 'WORKING...'
            & $item
        } catch {
            Write-Host 'ERROR'
            $_.Exception.Message
            exit 1
        }
    }

    Write-Host 'BUILD'

    $build = @(
        { gulp },
        { composer install -d '.\dist' --no-dev }
    )

    foreach ($item in $build) {
        try {
            Write-Host 'WORKING...'
            & $item

        } catch {
            Write-Host 'ERROR'
            $_.Exception.Message
            exit 1
        }
    }

    if (Test-Path '.\dist\composer.*') {
        Remove-Item '.\dist\composer.*'
        Write-Host 'CLEANUP...'
    }

    Write-Host 'COMPLETE'
    exit 0

} catch {
    Write-Host 'ERROR'
    $_.Exception.Message
    exit 1
}
