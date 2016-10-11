#works with SQL Server 2016 Express

Set-ExecutionPolicy Bypass
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco install sql-server-express -force -yes

$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\130\Tools\PowerShell\Modules"
Import-Module SQLPS

New-Item 'c:\temp' -ItemType Directory -Force 
Set-Location C:\temp
choco install 7zip.commandline --yes --force
wget https://msftdbprodsamples.codeplex.com/downloads/get/880661# -OutFile adventureworksdb.zip
7z e .\adventureworksdb.zip

$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\130\Tools\PowerShell\Modules"
Import-Module SQLPS

$RelocateData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("AdventureWorks2014_Data", 
    "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\AdventureWorks2014.mdf") 
$RelocateLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("AdventureWorks2014_Log", 
    "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\Log\AdventureWorks2014.ldf")


#Invoke-Sqlcmd -ServerInstance '.\sqlexpress' -Query "DROP DATABASE AdventureWorks2014"
Restore-SqlDatabase -ServerInstance localhost\sqlexpress -BackupFile C:\temp\AdventureWorks2014.bak -Database AdventureWorks2014 -RelocateFile @($RelocateData,$RelocateLog)


$srv = New-Object 'Microsoft.SqlServer.Management.SMO.Server' ".\sqlexpress"
$srv.Databases | select name
