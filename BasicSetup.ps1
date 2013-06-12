function Execute([string] $cmd)
{
    powershell `
        -NoProfile `
        -ExecutionPolicy unrestricted `
        -Command $cmd
}
# Install Chocolatey
Execute "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
sc Env:\Path "$(gc Env:\Path);$(gc Env:\SystemDrive)\chocolatey\bin"

# Install PSGet
Execute "(new-object Net.WebClient).DownloadString('http://psget.net/GetPsGet.ps1') | iex"

# Get PowerShell modules
Install-Module Pester
Install-Module Pscx

# Chocolatey Packages
cinst TimRayburn-GitAliases
cinst ruby
cinst dropbox
cinst paint.net
cinst beyondcompare
cinst 7zip
cinst sysinternals
cinst fiddler
cinst evernote

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