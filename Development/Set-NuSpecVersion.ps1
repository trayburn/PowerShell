function Set-NuSpecVersion {
    param(
        [Parameter(Mandatory=$true)] [string] $Path,
        [Parameter(Mandatory=$true)] [string] $Version
    )

    $xml = [xml] (Get-Content $Path)
    $xml.package.metadata.version = $Version
    $xml.Save((Get-Item $Path).FullName)
}

Export-ModuleMember Set-NuSpecVersion