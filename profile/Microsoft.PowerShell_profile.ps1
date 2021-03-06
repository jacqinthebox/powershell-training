. $env:USERPROFILE\Documents\WindowsPowerShell\Get-MOTD.ps1
Get-MOTD
write-host ""
write-host ""
$fc = ((Invoke-WebRequest https://gdgnoco-fortune.appspot.com/api/fortune).content) | ConvertFrom-Json
write-host `t `"$($fc.fortune)`"
write-host ""

Function Start-TestShell {
    cd '$env:USERPROFILE\Documents\Visual Studio 2015\Projects\MyCmdlets\MyCmdlets\bin\Debug'

    Powershell -NoExit -NoProfile `
    -command {
        function prompt {
        Write-Host -NoNewline `
        -ForegroundColor Red `
        "$($pwd.Path.Substring($pwd.Path.LastIndexOf("\"))) Test";
        return "> "

        }

    }

}

Set-Alias -Name sts -Value Start-TestShell

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
# Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module posh-git


# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Pop-Location

Start-SshAgent -Quiet

cd ~