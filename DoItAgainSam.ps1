.\PowerShell\Photo-Trick.ps1
. .\PowerShell\Photo-Trick.ps1
Set-ExecutionPolicy Default
. .\PowerShell\Photo-Trick.ps1
Set-ExecutionPolicy Unrestricted
man get-process
Get-Help Get-Process
Get-Help Get-Process -Online
Get-Help Get-Process -Online
cls
Get-Content .\app.config
(Get-Content .\app.config).GetType()
(Get-Content .\app.config)[0].GetType()
Get-Content .\app.config
$content = Get-Content .\app.config
$content = [xml] $content
$content | gm
$content.configuration | gm
$content.configuration.appSettings | gm
$content.configuration.appSettings.add | gm
$content.configuration.appSettings.add.key
$content.configuration.appSettings.add.key | gm
$content.configuration.appSettings.add["key"] | gm
$content.configuration.appSettings.add["key"]
$content.configuration.appSettings.add
$content.configuration.appSettings.add.Attributes["key"]
$content.configuration.appSettings.add.Attributes["key"] | gm
$content = [xml] Get-Content .\app.config
$content = [xml] (Get-Content .\app.config)
$content.configuration.appSettings.add
$content.configuration.appSettings.add.key
$content.configuration.appSettings.add.key[0]
$content.configuration.appSettings.add
$content.configuration.appSettings.add | ? { $_.key -eq "Hello2" }
$content.configuration.appSettings.add | ? { $_.key -eq "Hello2" } | % { $_.value }
$content.configuration.appSettings.add | ? { $_.key -eq "Hello2" } | Select-Object -ExpandProperty value
$content.configuration.appSettings.add | ? { $_.key -eq "Hello2" } | % { $_.value = "Awesome Demo Tim" }
$content.configuration.appSettings.add
$content.configuration.appSettings.add | Export-Csv
$content.configuration.appSettings.add | Export-Csv -Path report.csv
cat .\report.csv
$content.configuration.appSettings.add | Add-Member -MemberType NoteProperty -Name "FullName" -Value "Great Demo Tim" -PassThru | Export-Csv -Path report.csv
cat .\report.csv
$content.configuration.appSettings.add | Add-Member -MemberType NoteProperty -Name "FullName" -Value "Great Demo Tim" -PassThru | ConvertTo-Json
$content.configuration.appSettings.add | Add-Member -MemberType NoteProperty -Name "FullName" -Value "Great Demo Tim" -PassThru | Select-Object -First | ConvertTo-Json
$content.configuration.appSettings.add | Select-Object -First | ConvertTo-Json
$content.configuration.appSettings.add | Select-Object -First 1 | ConvertTo-Json
$content.configuration.appSettings.add | ConvertTo-Json
$content.configuration.appSettings.add | Select-Object -Property FullName, key, value | ConvertTo-Json
$jsonPayload = $content.configuration.appSettings.add | Select-Object -Property FullName, key, value | ConvertTo-Json
$jsonPayload | gm
ConvertFrom-Json $jsonPayload
ConvertFrom-Json $jsonPayload | gm
cls
Get-PSDrive
cd alias:
ls
ls
cd env:
ls
cd hklm:
ls
cd .\SOFTWARE
ls
cd .\Microsoft
ls
cd '.\Windows App Certification Kit'
ls
get-acl
(get-acl).Access
Get-PSDrive
cd variable:
ls
Get-ExecutionPolicy
cls
cd c:
cls
Get-Module
Get-Module -ListAvailable
Import-Module webadministration
Get-Module
Get-PSDrive
cd iis:
ls
cd .\AppPools
ls
cp '.\.NET v4.5' ThisIsAwesome
ls
ls | %{ $_.Stop() }
ls
get-history
Get-History | Select-Object -ExpandProperty CommandLine
Get-History | Select-Object -ExpandProperty CommandLine > DoItAgainSam.ps1
cd c:
