function Get-InstalledApps {
	param (
        [Parameter(ValueFromPipeline=$true)]
		[string[]]$comps = $env:COMPUTERNAME
	)
    
    foreach ($comp in $comps) {
        $keys = '','\Wow6432Node'
        foreach ($key in $keys) {
            $apps = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$comp).OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall").GetSubKeyNames()
            foreach ($app in $apps) {
                $program = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$comp).OpenSubKey("SOFTWARE$key\Microsoft\Windows\CurrentVersion\Uninstall\$app")
                $name = $program.GetValue('DisplayName')
                if ($name) {
                    [pscustomobject]@{
                        ComputerName = $comp
                        DisplayName = $name
                        DisplayVersion = $program.GetValue('DisplayVersion')
                        Publisher = $program.GetValue('Publisher')
                        InstallDate = $program.GetValue('InstallDate')
                        UninstallString = $program.GetValue('UninstallString')
                    }
                }
            }
        }
    }
}