# Scope
$id = "firma"
$HostName = 'wp1177004.server-he.de'
$UserName = 'ftp1177004-s'

# Locations
$baseLocalEntry = 'E:\Sites\'
$baseLocalEntryPath = $baseLocalEntry + $id + '\'
$baseLocalDist = $baseLocalEntryPath + 'dist' + '\'
$baseLocalConfigPath = 'D:\Tools\__config\sites\' + $id + '\'
$baseRemoteEntry = '/'

$winSCPexec = $Env:APPS_HOME + '\' + 'winscp\current\WinSCP.exe'
$winSCPdnet = $Env:APPS_HOME + '\' + 'winscp\current\WinSCPnet.dll'

# Authentication
$hsh = $baseLocalEntryPath + 'env\hash.txt'
$key = $baseLocalConfigPath + 'aeskey.txt'
$pwd = $(Get-Content $hsh | ConvertTo-SecureString -Key (Get-Content $key))

$action = $false
$session = $null
$sessionOptions = $null

try
{
    Add-Type -Path $winSCPdnet

    Import-Module ($baseLocalEntryPath + 'run\module\session.psm1')
    Import-Module ($baseLocalEntryPath + 'run\module\transfer.psm1')

    $sessionOptions = SessionSettings $HostName $UserName $pwd

    $session = New-Object WinSCP.Session
    $session.ExecutablePath = $winSCPexec

    $session.Open($sessionOptions)
    $session.add_FileTransferred({LogTransferredFiles($_)})

    $transferOptions = New-Object WinSCP.TransferOptions
    $transferOptions.ResumeSupport.State = [WinSCP.TransferResumeSupportState]::On

    try
    {
        do
        {
            $action = TransferQueueHandler "public" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }

        while ($action -ne $true)

        $action = $false

        do
        {
            $action = TransferQueueHandler "site" $session $transferOptions $baseLocalDist $baseRemoteEntry
        }

        while ($action -ne $true)

        $action = $false

        if ($args -eq "-full")
        {
            do
            {
                $action = TransferQueueHandler "kirby" $session $transferOptions $baseLocalDist $baseRemoteEntry
            }

            while($action -ne $true)

            $action = $false

            Write-Host
            Write-Host "Starting...File Actions"

            FileActionHandler $session $baseRemoteEntry $true
        }

        else
        {
            Write-Host
            Write-Host "Starting...File Actions"

            FileActionHandler $session $baseRemoteEntry $false
        }
    }

    finally
    {
        $session.Dispose()
    }

    exit 0
}

catch
{
    Write-Host '///'
    Write-Host "$($_.Exception.Message)"
    Write-Host '///'
    Write-Host "$($_.ScriptStackTrace)"
    Write-Host '///'

    exit 1
}
