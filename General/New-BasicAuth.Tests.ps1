$here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
    . "$here\$sut"

    Describe "New-BasicAuth" {

        $outVal = New-BasicAuth "user" "password"

        It "returns a hashtable" {
            $outVal.GetType().Name | should be "Hashtable"
        }

        It "should have an Authorization key" {
            $outVal.Authorization | should not benullorempty
        }

        It "should start Authorization value with 'Basic '" {
            $outVal.Authorization.StartsWith("Basic ") | should be $true
        }

        It "should encode username and password into Base64" {
            $base64 = $outVal.Authorization.TrimStart("Basic ");
            [System.Text.ASCIIEncoding]::ASCII.GetString([System.Convert]::FromBase64String($base64)) | should be "user:password"
            $outVal.Authorization.StartsWith("Basic ") | should be $true
        }
    }
