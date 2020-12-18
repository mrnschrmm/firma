Write-Host '### TASK ### RUN ###'
Write-Host

Import-Module '.\run\module\env.psm1'
Update-Composer -Mode 'Init'

gulp
