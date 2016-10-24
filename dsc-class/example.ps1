Configuration HostfileConfig
{
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Import-DSCResource -ModuleName 'cHostfileEntryResource'


      HostFileEntry file
      {
        Ip = "192.168.56.3"
        Hostname = "sql.dev.local"
        Ensure = "Present"
      }

}

HostfileConfig -Outputpath C:\dsc
Start-DscConfiguration -Path c:\dsc -Wait -Verbose -Force


<#
    $ip = '192.168.56.10'
    $hostname = 'draak.ellende.nl'
    Add-Content C:\Windows\System32\drivers\etc\hosts "$ip `t `t $hostname"

    #Get-Control

    $contents = get-Content C:\Windows\System32\drivers\etc\hosts
    #if ($contents -match $ip -and $contents -match $) {
    $test = $contents -match $ip
    $test


    $ip = '192.168.56.10'
    $hostfile =  "C:\Windows\System32\drivers\etc\hosts"
    Get-Content $hostfile | Where { $_ -notmatch "^$ip" } | Set-Content c:\temp\hosts
    Copy-Item C:\temp\hosts $hostfile -Force

   $hostfile =  "C:\Windows\System32\drivers\etc\hosts"
   Get-Content $hostfile | Where-Object { $_ -notmatch "^($this.Ip)" } | Set-Content c:\temp\hosts
   Copy-Item C:\temp\hosts $hostfile -Force
#>
