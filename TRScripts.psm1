@("$PSScriptRoot\General\*.ps1","$PSScriptRoot\Development\*.ps1") | Resolve-Path |
  ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
  % { . $_.ProviderPath }