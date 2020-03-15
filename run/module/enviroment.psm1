Function GetEnvConfig {
    $localEnvFile = $args[0] + ".env"
    $configuration = New-Object -TypeName psobject
    Write-Host $localEnvFile

    if (!( Test-Path $localEnvFile)) {
        Write-Host "No .env file"
        return
    }

    $localEnv = Get-Content $localEnvFile -ErrorAction Stop
    Write-Host "Parsed .env file"

    foreach ($line in $localEnv) {
        $kvp = $line -split "=",2
        $configuration | Add-Member -MemberType NoteProperty -Name $kvp[0] -Value $kvp[1]
    }

    return $configuration
}
