function Test-Item {
    param(
        [Parameter(Mandatory=$true, Position=1)]
        $item,
        [Parameter(Mandatory=$false, Position=2)]
        $Yes,
        [Parameter(Mandatory=$false, Position=3)]
        $No,
        [Parameter(Mandatory=$false, Position=4)]
        $Always
    )
    if ((Get-Item $item -ea si) -ne $null) {
        if ($Yes -ne $null) {
            $item | &{ PROCESS { &$Yes } }
        }
    } else {
        if ($No -ne $null) {
            $item | &{ PROCESS { &$No } }
        }
    }
    if ($Always -ne $null) {
        $item | &{ PROCESS { &$Always } }
    }
}

Export-ModuleMember Test-Item