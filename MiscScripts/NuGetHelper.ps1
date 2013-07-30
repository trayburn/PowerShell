function Get-NuGetConfig {
    [xml] (Get-Content -Path "$Env:APPDATA\NuGet\NuGet.config")
}

$nug = Get-NuGetConfig

$nug.configuration.packageRestore.add
