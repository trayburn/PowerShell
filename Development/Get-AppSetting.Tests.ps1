$here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
    . "$here\$sut"

    Describe "Get-AppSetting" -tag "WIP" {

        Context "When file exists and setting exists" {
            $config = "TestDrive:\Web.config"
            Copy-Item "$here\..\TestData\Web.config" $config
            $val = Get-AppSetting $config "ClientValidationEnabled"

            It "should return the value if present" {
                $val | should not benullorempty
                $val | should be "true"
            }
        }

        Context "When the files does not exist" {
            $config = "TestDrive:\Web.config"
            Remove-Item $config -ErrorAction SilentlyContinue
            $ex = ""

            try {
                $val = Get-AppSetting $config "ClientValidationEnabled"
            }
            catch [Exception] {
                $ex = $_.Exception
            }

            It "should throw a FileNotFoundException" {
                $ex.GetType().Name | should be "FileNotFoundException"
            }
        }

        Context "When file exists and setting exists" {
            $config = "TestDrive:\Web.config"
            Copy-Item "$here\..\TestData\Web.config" $config
            $val = Get-AppSetting $config "SettingThatDoesNotExist"

            It "should return null" {
                $val | should benullorempty
            }
        }

    }
