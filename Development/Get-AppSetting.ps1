function Get-AppSetting {
    param(
        [string] $path,
        [string] $key
    )

    if (Test-Path $path) {
        $config = [xml](Get-Content $path)
        $settings = $config.configuration.appSettings.add
        return $settings | ? { $_.key -eq $key } | Select-Object -First 1 | %{ $_.value }
    } else {
        throw (New-Object "System.IO.FileNotFoundException" $path)
    }
}

Export-ModuleMember Get-AppSetting
