$inData = $input
$rd = $inData.RawData

# Functions
function BuildSummaryLine($data) {
    $url = $data.Versions.NuGet.properties.ProjectUrl | Select-Object -First 1
    $lurl = $data.Versions.NuGet.properties.LicenseUrl | Select-Object -First 1
    $line = "* [$($data.Name)]($url) is used in $($data.ProjectCount) project"

    if ($data.ProjectCount -gt 1) {
        $line += "s"
    }

    if ($data.VersionCount -gt 1) {
        $line += ", and $($data.VersionCount) versions"
    }

    $line += ", under the license [found here]($lurl)"

    return $line
}

# Header
$r = @()
$r += "# Open Source Report"
$r += ""

# Summary
$r += "## Summary "
$r += ""
$rd | Sort-Object Name | % { $r += BuildSummaryLine($_) } | Out-Null
$r += ""


# Summary by Project Count
#$r += "## Summary by Project Count"
#$r += ""
#$rd | Sort-Object @{e="ProjectCount";a=0},"Name" | % { $r += BuildSummaryLine($_) } | Out-Null
#$r += ""

# License URLS
$r += "## Distinct Licenses "
$r += ""
$rd | %{ $_.Versions.NuGet.properties.LicenseUrl } | Select-Object -Unique | % {
    $url = $_
    $count = ($rd | ? { $_.Versions.NuGet.properties.LicenseUrl -eq $url } | measure).Count
    $r += "* $count packages use the license at [$url]($url)"
}

$r