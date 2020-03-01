Function SessionSettings
{
    $options = New-Object WinSCP.SessionOptions -Property @{
      Protocol = [WinSCP.Protocol]::Ftp
      FtpSecure = [WinSCP.FtpSecure]::Explicit
      HostName = $args[0]
      UserName = $args[1]
      Password = [System.Net.NetworkCredential]::new('', $args[2]).Password
    }

    $options.AddRawSettings('AddressFamily', '1')
    $options.AddRawSettings('ResolveSymlinks', '1')
    $options.AddRawSettings('FollowDirectorySymlinks', '1')

    return $options
}
