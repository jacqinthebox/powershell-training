enum Ensure
{
    Absent
    Present
}

[DscResource()]
class HostFileEntry {

  [DscProperty(Key)]
    [string]$Ip

  [DscProperty(Key)]
    [string]$Hostname

  [DscProperty(Mandatory)]
  [Ensure]$Ensure


  [void] Set()
    {
        $entryExists = $this.TestHostFileEntry()

        if ($this.ensure -eq [Ensure]::Present)
        {
            if (-not $entryExists)
            {
               $this.AddHostFileEntry()
            }
        }
        else
        {
            if ($entryExists)
            {
                #this runs if ensure = absent
                #here we should remove the entry if it was there.
            }
        }
    }

  [bool] Test()
    {
        $desiredstate = $this.TestHostFileEntry()
        #ensure present = true and $present should also be true
        if ($this.Ensure -eq [Ensure]::Present)
        {
            return $desiredstate
        }
        else
        {
            return -not $desiredstate
        }
    }

  [HostfileEntry] Get()
    {
        $present = $this.TestHostFileEntry()

        if ($present)
        {
            $this.Ensure = [Ensure]::Present
        }
        else
        {
            $this.Ensure = [Ensure]::Absent
        }

        return $this
    }

  [bool] TestHostFileEntry()
    {

        $desiredstate = $false
        $hosts = get-Content C:\Windows\System32\drivers\etc\hosts
        $res = ($hosts | Where-Object { $_ -match $this.Hostname }).Count

        Write-Verbose $this.Hostname

        if ($res -ge 1  ) {
          Write-Verbose "Already there, desired state is true"
          $desiredstate = $true
        }


        return $desiredstate

    }

  [void] AddHostFileEntry()
    {
       $ipaddress = $this.Ip
       $hostn = $this.Hostname

       Add-Content C:\Windows\System32\drivers\etc\hosts "$ipaddress `t `t $hostn"

    }
 }
