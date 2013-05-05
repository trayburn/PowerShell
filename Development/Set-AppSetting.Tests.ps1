$here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
    . "$here\$sut"

    Describe "Set-AppSetting" {
        $config = "TestDrive:\Web.config"
        $results = @{}

        Context "When AppSetting already exists" {
            
            Copy-Item "$here\..\TestData\Web.config" $config
            Set-AppSetting $config "ClientValidationEnabled" 123456
            $xml = [xml] (Get-Content $config)

            It "Should ident and tabify xml" {
                (Get-Content $config | Select-String -Pattern "\t").Count | should not be 0
            }

            It "Should have changed setting value" {
                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "ClientValidationEnabled" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be 123456 }
            }

            It "Should not have changed other settings" {
                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "UnobtrusiveJavaScriptEnabled" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be "true" }

                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "webpages:Version" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be "1.0.0.0" }
            }
        }

        Context "When AppSetting does not exist" {

            Copy-Item "$here\..\TestData\Web.config" $config
            Set-AppSetting $config "BrandNewSetting" 123456
            $xml = [xml] (Get-Content $config)

            It "Should create the new setting" {
                $xml.configuration.appSettings.add.Count | should be 4
            }

            It "Should have changed setting value" {
                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "BrandNewSetting" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be 123456 }
            }

            It "Should not have changed other settings" {
                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "ClientValidationEnabled" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be "true" }

                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "UnobtrusiveJavaScriptEnabled" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be "true" }

                $xml.configuration.appSettings.add | ? { 
                    $_.key -eq "webpages:Version" } | % {
                    $_.value | should not benullorempty
                    $_.value | should be "1.0.0.0" }
            }
        }
    }
