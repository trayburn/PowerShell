$here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
    . "$here\$sut"

    Describe "Set-NuSpecVersion" -tags "wip" {

        $testFile = "$here\..\TestData\Example.nuspec"

        Context "When nuspec exists" {

            $nuspec = "TestDrive:\Example.nuspec"

            if (Test-Path $nuspec) {
                Remove-Item "TestDrive:\Example.nuspec"
            }

            copy $testFile $nuspec

            Set-NuSpecVersion $nuspec 1.0.0-Beta9
            $xml = [xml] (Get-Content $nuspec)

            It "sets version to a new value" {
                $xml.package.metadata.version | should be "1.0.0-Beta9"
            }
        }
    }
