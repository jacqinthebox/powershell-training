Configuration Main
{

Param ( [string] $nodeName )

Import-DscResource -ModuleName PSDesiredStateConfiguration

Node $nodeName
  {
   
    Script InitialConfig
    {
        TestScript = {
            return $True
        }
        SetScript ={
            Invoke-WebRequest https://raw.githubusercontent.com/jacqinthebox/presentations/master/win10devbox.ps1  | Invoke-Expression
        }
        GetScript = {@{Result = "Initialized"}}
        
    }
      }
}