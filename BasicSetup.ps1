function Execute([string] $cmd)
{
    powershell `
        -NoProfile `
        -ExecutionPolicy unrestricted `
        -Command $cmd
}

Function Test-RegistryValue 
{
    param(
        [Alias("RegistryPath")]
        [Parameter(Position = 0)]
        [String]$Path
        ,
        [Alias("KeyName")]
        [Parameter(Position = 1)]
        [String]$Name
    )

    process 
    {
        if (Test-Path $Path) 
        {
            $Key = Get-Item -LiteralPath $Path
            if ($Key.GetValue($Name, $null) -ne $null)
            {
                if ($PassThru)
                {
                    Get-ItemProperty $Path $Name
                }       
                else
                {
                    $true
                }
            }
            else
            {
                $false
            }
        }
        else
        {
            $false
        }
    }
}

Function Disable-UAC
{
    $EnableUACRegistryPath = "REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $EnableUACRegistryKeyName = "EnableLUA"
    $UACKeyExists = Test-RegistryValue -RegistryPath $EnableUACRegistryPath -KeyName $EnableUACRegistryKeyName 
    if ($UACKeyExists)
    {
        Set-ItemProperty -Path $EnableUACRegistryPath -Name $EnableUACRegistryKeyName -Value 0
    }
    else
    {
        New-ItemProperty -Path $EnableUACRegistryPath -Name $EnableUACRegistryKeyName -Value 0 -PropertyType "DWord"
    }
}

# Install Chocolatey
Execute "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
sc Env:\Path "$(gc Env:\Path);$(gc Env:\SystemDrive)\chocolatey\bin"

# Install PSGet
Execute "(new-object Net.WebClient).DownloadString('http://psget.net/GetPsGet.ps1') | iex"

# Get PowerShell modules
Import-Module PSGet
Install-Module Pester
Install-Module Pscx
Install-Module Psake

# .NET Framework
cwindowsfeatures NetFx3

# Chocolatey Packages
cinst TimRayburn.GitAliases
cinst ruby
cinst dropbox # Problem with running as Admin, skip for now
cinst paint.net
cinst beyondcompare
cinst 7zip
cinst sysinternals
cinst fiddler
cinst evernote
cinst Git-TF

# Windows Features

cWindowsFeatures IIS-WebServerRole
cWindowsFeatures IIS-ISAPIFilter
cWindowsFeatures IIS-ISAPIExtensions
cWindowsFeatures IIS-NetFxExtensibility
cWindowsFeatures IIS-ASPNET45
cWindowsFeatures TelnetClient
cWindowsFeatures WCF-Services45
cWindowsFeatures WCF-TCP-PortSharing45
cwindowsfeatures IIS-WebServerManagementTools

# Add Visual Studio 2012
cinst VisualStudio2012Ultimate

# Disable UAC & Reboot
# Disable-UAC
# Restart-Computer -Force -Confirm:$false