param (
    $sessionUrl = "sftp://user:password;fingerprint=ssh-rsa-xxxxxxxxxxx...=@example.com/",
    $remotePath = "/home/user/",
    $localPath = "c:\downloaded\",
    $batches = 3
)

try
{
    $dllPath = (Join-Path $PSScriptRoot "WinSCPnet.dll")
    # Load WinSCP .NET assembly
    Add-Type -Path $dllPath

    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions
    $sessionOptions.ParseUrl($sessionUrl)

    $started = Get-Date

    try
    {
        # Connect
        Write-Host "Connecting..."
        $session = New-Object WinSCP.Session
        $session.Open($sessionOptions)

        # Retrieve list of files and sort them from larges to smallest
        [array]$files =
            $session.ListDirectory($remotePath).Files |
            Where-Object { -Not $_.IsDirectory } |
            Sort-Object Length -Descending

        # Calculate total size of all files
        $total = ($files | Measure-Object -Property Length -Sum).Sum

        # And batch size
        $batch = [int]($total / $batches)

        Write-Host (
            "Will download $($files.Count) files totaling $total bytes in " +
            "$batches parallel batches, $batch bytes on average in each")

        $start = 0
        $sum = 0
        $no = 0

        for ($i = 0; $i -lt $files.Count; $i++)
        {
            $sum += $files[$i].Length

            # Found enough files for the next batch
            if (($sum -ge $batch) -or ($i -eq $files.Count - 1))
            {
                Write-Host "Starting batch $no to download $($i - $start + 1) files totaling $sum"

                $fileList = $files[$start..$i] -join ";"

                # Start the background job for the batch
                Start-Job -Name "Batch $no" `
                    -ArgumentList $dllPath, $sessionUrl, $remotePath, $localPath, $no, $fileList {
                    param (
                        [Parameter(Position = 0)]
                        $dllPath,
                        [Parameter(Position = 1)]
                        $sessionUrl,
                        [Parameter(Position = 2)]
                        $remotePath,
                        [Parameter(Position = 3)]
                        $localPath,
                        [Parameter(Position = 4)]
                        $no,
                        [Parameter(Position = 5)]
                        $fileList
                    )

                    try
                    {
                        Write-Host "Starting batch $no"

                        # Load WinSCP .NET assembly.
                        # Need to use an absolute path as the Job is started
                        # from user's documents folder.
                        Add-Type -Path $dllPath

                        # Setup session options
                        $sessionOptions = New-Object WinSCP.SessionOptions
                        $sessionOptions.ParseUrl($sessionUrl)

                        try
                        {
                            Write-Host "Connecting batch $no..."
                            $session = New-Object WinSCP.Session

                            $session.Open($sessionOptions)

                            $files = $fileList -split ";"

                            # Download the files selected for this batch
                            foreach ($file in $files)
                            {
                                $remoteFilePath = "$remotePath/$file"
                                $localFilePath = "$localPath\$file"
                                Write-Host "Downloading $remoteFilePath to $localFilePath in $no"

                                $session.GetFiles(
                                    [WinSCP.RemotePath]::EscapeFileMask($remoteFilePath),
                                    $localFilePath).Check()
                            }
                        }
                        finally
                        {
                            # Disconnect, clean up
                            $session.Dispose()
                        }

                        Write-Host "Batch $no done"
                    }
                    catch
                    {
                        Write-Host "Error: $($_.Exception.Message)"
                        exit 1
                    }
                } | Out-Null

                # Reset for the next batch
                $no++
                $sum = 0
                $start = $i + 1
            }
        }

        Write-Host "Waiting for batches to complete"
        Get-Job | Receive-Job -Wait

        Write-Host "Done"

        $ended = Get-Date
        Write-Host "Took $(New-TimeSpan -Start $started -End $ended)"
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }

    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
