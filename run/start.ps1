Write-Host '## RUN ## START'
Write-Host

Import-Module '.\run\module\env.psm1'
Update-Composer -Mode 'Init'

gulp
