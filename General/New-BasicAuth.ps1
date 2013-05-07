function New-BasicAuth {
    param([string] $user, [string] $pass)
    $auth64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($user+":"+$pass ))
    return @{ Authorization="Basic $auth64" }
}