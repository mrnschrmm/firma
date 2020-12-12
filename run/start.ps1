# START
try {
    Write-Host '## RUN ## START'
    Write-Host
    Write-Host 'WORKING...'

    $run = @(
        { composer update -d '.\' --root-reqs },
        { gulp }
    )

    foreach ($item in $run) {
        try {
            & $item
        } catch {
            Write-Host 'ERROR'
            $_.Exception.Message
            exit 1
        }
    }
    exit 0

} catch {
    Write-Host 'ERROR'
    $_.Exception.Message
    exit 1
}
