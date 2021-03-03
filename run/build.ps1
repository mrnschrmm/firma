Write-Host '### TASK ### BUILD ###'
Write-Host

$env:NODE_ENV=$Args[1]

if ($Args[2] -match 'debug') {
    $env:NODE_DEBUG="*"
}

Import-Module '.\run\module\env.psm1'
Update-Composer -Mode 'Init' -ErrorAction Stop

Write-Host 'LINT'

.\dist\vendor\bin\phpcs --standard='.\phpcs.ruleset.xml' --report=summary '.\app' -v
npx stylelint './app/snippets/**/*.scss' './app/resources/**/*.scss'
npx eslint './app/resources/main.js' './app/resources/panel.js' './app/snippets/**/script.js'

Write-Host 'BUILD'

gulp

Update-Composer -Mode 'Clear'
Write-Host 'COMPLETE'
