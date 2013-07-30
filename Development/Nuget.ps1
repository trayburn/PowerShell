function Get-NuGetConfig {
    [xml](Get-Content "$Env:APPDATA\NuGet\NuGet.config")
}

function Set-NuGetConfig {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [xml]$Config
    )
    Set-Content -Path "$Env:APPDATA\NuGet\NuGet.config" -Value $config.OuterXml
}

function Enable-NuGetPackageRestore {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [xml]$Config
    )

    $add = '<add key="enabled" value="True" />'
    $pr = "<packageRestore>$add</packageRestore>"

    if ($config.configuration.packageRestore -eq $null) {
        $config.configuration.InnerXml += $pr
    }

    if ($config.configuration.packageRestore.add -eq $null) {
        $Config.configuration["packageRestore"].InnerXml += $add
    }

    if (($config.configuration.packageRestore.add | 
                ? { $_.key -eq "enabled" } |
                Measure-Object).Count -eq 0) {
        $Config.configuration["packageRestore"].InnerXml += $add
    }

    if ($config.configuration.packageRestore.add | 
                ? { $_.key -eq "enabled" } |
                % { $_.value -eq $false }) {
        $config.configuration.packageRestore.add | 
                ? { $_.key -eq "enabled" } |
                % { $_.value = "True" }
    }


    $config
}
