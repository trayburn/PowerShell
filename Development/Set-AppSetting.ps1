function Set-AppSetting {
    param(
        [Parameter(Mandatory=$true)] [string] $Path,
        [Parameter(Mandatory=$true)] [string] $Key,
        [Parameter(Mandatory=$true)] [string] $Value
    )

    $xml = ([xml](Get-Content $Path))
    $foundSettings = $xml.configuration.appSettings.add | ? { $_.key -eq $Key } 
    if ($foundSettings.Count -ne 0) {
        $foundSettings | % { $_.value = $Value } }
    else {
        $el = $xml.CreateElement("add")
        $kat = $xml.CreateAttribute("key")
        $kat.Value = $Key
        $vat = $xml.CreateAttribute("value")
        $vat.Value = $Value
    
        $el.SetAttributeNode($kat) | Out-Null
        $el.SetAttributeNode($vat) | Out-Null
    
        $xml.configuration.appSettings.AppendChild($el) | Out-Null
    }
    Set-Content -Path $Path -Value $xml.OuterXml
}

Export-ModuleMember Set-AppSetting