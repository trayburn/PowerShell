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