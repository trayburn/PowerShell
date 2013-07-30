$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Set-NuGetConfig" {

    Setup -Dir "NuGet"
    Setup -File "NuGet\NuGet.config"
    
    $OrigAppData = Get-Content -Path Env:\APPDATA

    try {
        Set-Content -Path Env:\APPDATA -Value $TestDrive

        it "should start empty" {
            Get-NuGetConfig | Should BeNullOrEmpty
        }

        $testStr = "<node></node>"
        ([xml]$testStr) | Set-NuGetConfig

        it "should contain test string" {
            (Get-NuGetConfig).OuterXml | Should Be $testStr
        }
    } finally {
        Set-Content -Path Env:\APPDATA -Value $OrigAppData
    }
}


Describe "Get-NuGetConfig" {
    
    Context "Get-NuGetConfig" {

        $nuget = Get-NuGetConfig

        It "should have the xml from the NuGet.config file" {
            $nuget.InnerText | Should Be ([xml](Get-Content "$Env:APPDATA\NuGet\NuGet.config")).InnerText
        }

    }
}

Describe "Enable-NuGetPackageRestore" {

    $itShouldLookRight = {
        it "should be an XML document" {
            $res.GetType().Name | 
                Should Be "XmlDocument"
        }

        it "should have a packageRestore node" {
            $res.configuration.packageRestore.GetType().Name | 
                Should Be "XmlElement"
        }

        it "should have a value attribute set to True" {
            $res.configuration.packageRestore.add | 
                ? { $_.key -eq "enabled" } | 
                % { $_.value | Should Be "True" }
        }
        
        it "should have a key attribute set to enabled" {
            ($res.configuration.packageRestore.add | 
                ? { $_.key -eq "enabled" } |
                measure).Count -ge 1 | 
                Should Be $true
        }
    }

    Context "Enable-NuGetPackageRestore without PackageRestore Node" {
        $nuget = [xml](gc ".\TestData\NugetConfig-WithoutPackageRestoreNode.config")
        $res = $nuget | Enable-NuGetPackageRestore

        . $itShouldLookRight
    }

    Context "Enable-NuGetPackageRestore without PackageRestore Add Node" {
        $nuget = [xml](gc ".\TestData\NugetConfig-WithoutPackageRestoreAddNode.config")
        $res = $nuget | Enable-NuGetPackageRestore

        . $itShouldLookRight
    }

    Context "Enable-NuGetPackageRestore with unknown PackageRestore Add Node" {
        $nuget = [xml](gc ".\TestData\NugetConfig-WithUnknownPackageRestoreAddNode.config")
        $res = $nuget | Enable-NuGetPackageRestore

        . $itShouldLookRight
    }

    Context "Enable-NuGetPackageRestore with all nodes present" {
        $nuget = [xml](gc ".\TestData\NugetConfig-Good.config")
        $res = $nuget | Enable-NuGetPackageRestore

        . $itShouldLookRight
    }
}

