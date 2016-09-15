
# opruimen en voorbereiden
If (Test-Path .\dump-computers.txt) {
  Clear-Content .\dump-computers.txt
}

$hostname = HOSTNAME.EXE
for ($i=0;$i -lt 5; $i++) {  Add-Content .\dump-computers.txt $hostname }
$computers = Get-Content .\dump-computers.txt



#declare de array
$output = @();

foreach($entry in $computers) {

  #properties ophalen
  $info = Get-WmiObject -Class Win32_OperatingSystem -Computername $entry
  $bios = Get-WmiObject -Class Win32_Bios -Computername $entry
  $environment = [System.Environment]::GetEnvironmentVariables();
    
    
  $hash = [ordered]@{ 
    name = $entry; 
    fabrikant = $bios.manufacturer;
    serial = $info.serialnumber;
    registratienaam = $info.registereduser;
    datum = (Get-Date);
    company = 'Contoso';
    logonserver = $environment.Item('LOGONSERVER');
  }


  $object = [pscustomobject]$hash
  
  #concatenate de array 
  $output += $object
  
  Write-Output "added $($object.name)"
}


$output | Export-Csv dump-inventory.csv -NoTypeInformation