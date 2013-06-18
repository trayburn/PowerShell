function Get-NuGet([string] $name, [string] $ver) {
    Invoke-RestMethod -Uri "http://nuget.org/api/v2/Packages(Id='$name',Version='$ver')" |
        %{ $_.entry }
}

# Find all packages.config files recursively
$pconfigs = gci -r packages.config

# Pull out all package nodes with their relevant data
$allPackages = $pconfigs | % {
    $filePath = $_
    $dir = $filePath.Directory
    ([xml] (gc $filePath.FullName)).packages.package | % {  
        $node = $_
        New-Object -TypeName PSObject |
            Add-Member Name $node.id -PassThru |
            Add-Member Version $node.version -PassThru | 
            Add-Member Framework $node.targetFramework -PassThru |
            Add-Member Project (Split-Path $dir -Leaf) -PassThru
    }
}

# Group by name, and summarize the remaining data
$allPackages | Select-Object Name -Unique | % {
    $loop = $_
    $entries = $allPackages | ? { $_.Name -eq $loop.Name } 

    $versions = ($entries | Select-Object Version -Unique | % { 
        $verInfo = $_
        $verInfo |
            Add-Member NuGet (Get-NuGet $loop.Name $verInfo.Version) -PassThru
    })

    $projects = ($entries | Select-Object Project -Unique | % { $_.Project })
    $frameworks = ($entries | Select-Object Framework -Unique | % { $_.Framework })

    $count = ($projects | measure).Count
    $verCount = ($versions | measure).Count
    $frameCount = ($frameworks | measure).Count

    $loop | 
        Add-Member ProjectCount $count -PassThru |
        Add-Member VersionCount $verCount -PassThru |
        Add-Member FrameworkCount $frameCount -PassThru |
        Add-Member Versions $versions -PassThru |
        Add-Member Projects $projects -PassThru | 
        Add-Member Frameworks $frameworks -PassThru |
        Add-Member Tags @() -PassThru | 
        Add-Member Description "" -PassThru
} | Sort-Object Count -Descending