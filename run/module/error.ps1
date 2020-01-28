param (
    $localPath = "C:\backup\",
    $remotePath = "/home/user/data/"
)

try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "WinSCPnet.dll"

    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "example.com"
        UserName = "user"
        Password = "mypassword"
        SshHostKeyFingerprint = "ssh-rsa 2048 xxxxxxxxxxx...="
    }

    $session = New-Object WinSCP.Session

    try
    {
        # Connect
        $session.Open($sessionOptions)

        # Synchronize files to local directory, collect results
        $synchronizationResult = $session.SynchronizeDirectories(
            [WinSCP.SynchronizationMode]::Local, $localPath, $remotePath, $False)

        # Deliberately not calling $synchronizationResult.Check
        # as that would abort our script on any error.
        # We will find any error in the loop below
        # (note that $synchronizationResult.Downloads is the only operation
        # collection of SynchronizationResult that can contain any items,
        # as we are not removing nor uploading anything)

        # Iterate over every download
        foreach ($download in $synchronizationResult.Downloads)
        {
            # Success or error?
            if ($download.Error -eq $Null)
            {
                Write-Host "Download of $($download.FileName) succeeded, removing from source"
                # Download succeeded, remove file from source
                $filename = [WinSCP.RemotePath]::EscapeFileMask($download.FileName)
                $removalResult = $session.RemoveFiles($filename)

                if ($removalResult.IsSuccess)
                {
                    Write-Host "Removing of file $($download.FileName) succeeded"
                }
                else
                {
                    Write-Host "Removing of file $($download.FileName) failed"
                }
            }
            else
            {
                Write-Host (
                    "Download of $($download.FileName) failed: $($download.Error.Message)")
            }
        }
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
