function New-Dynamic() {
    return New-Object -TypeName PSObject;
}

function With(
    [Parameter(ValueFromPipeline=$true, Mandatory=$true)]$dyn, 
    [Parameter(Position=0)][string] $name, 
    [Parameter(Position=1)]$val) {
    return $dyn | Add-Member -MemberType NoteProperty -Name $name -Value $val -PassThru
}

function Get-NetStat() {
    netstat -ano | 
        % { if ($_ -match "\s*(TCP)\s*([\w.:\*\[\]]*)\s*([\w.:\*\[\]]*)\s*(\w*)\s*(\w*)") {
            New-Dynamic | 
                With Protocol $Matches[1] |
                With Local $Matches[2] |
                With Foreign $Matches[3] |
                With State $Matches[4] |
                With PID $Matches[5]
        } } | ? { $_ -ne $null }
}

function Aggregate-NetStat() {
    $ns = Get-NetStat

    $uniqCount = $ns | 
        ? { $_.Foreign.Trim().Length -ne 0 } | 
        Select-Object -Property Foreign -Unique |
        % {
            $uniq = $_
            New-Dynamic |
                With Type $uniq.Foreign |
                With Count ($ns | ? { $_.Foreign -eq $uniq.Foreign } | measure).Count
        }
    
    $uniqCount += New-Dynamic | With Type Total | With Count ($uniqCount | %{ $_.Count } | Measure-Object -Sum).Sum
    $uniqCount += New-Dynamic | With Type TCP | With Count ($ns | ? { $_.Protocol -eq "TCP" } | Measure-Object).Count

    $temp = $ns | Group-Object State | % {
        $uniqCount += New-Dynamic | With Type $_.Name | With Count $_.Count
    }

    #$uniqCount += New-Dynamic | With Type UDP | With Count ($ns | ? { $_.Protocol -eq "UDP" } | Measure-Object).Count


    # Write-Host $ns
    $uniqCount | Format-Table
}    

while($true) { 
    Aggregate-NetStat
    [System.Threading.Thread]::Sleep(1000)
}