param(
    [Parameter(ValueFromPipeline=$true)]
    [PSObject[]]$pipe 
)

$osData = $input

$tags = . .\TaggedComponents.ps1

# Add Trusted
$tags += @{
    Name="Trusted";
    Description="These libraries are included in the trusted list for this project.  The default definition of trusted is any packages Microsoft includes is Visual Studio templates.";
    InfoUrl=$null
}

# Add Download Tags
$tags += @{
    Name="1K-Downloads";
    Description="This project has over 1,000 Downloads from NuGet.org";
    InfoUrl=$null
}
$tags += @{
    Name="10K-Downloads";
    Description="This project has over 10,000 Downloads from NuGet.org";
    InfoUrl=$null
}
$tags += @{
    Name="100K-Downloads";
    Description="This project has over 100,000 Downloads from NuGet.org";
    InfoUrl=$null
}
$tags += @{
    Name="1M-Downloads";
    Description="This project has over 1,000,000 Downloads from NuGet.org";
    InfoUrl=$null
}

function Lookup-TrustedComponents([Parameter(ValueFromPipeline=$true)] $pipe) {
    $pipe | Add-Member TrustedComponents (. .\TrustedComponents.ps1) -PassThru
}

function Lookup-Tags([Parameter(ValueFromPipeline=$true)] $pipe) {
    $pipe | Add-Member TagData $tags -PassThru
}

function Summary-NumberOfPackages([Parameter(ValueFromPipeline=$true)] $pipe) {
    $pipe | Add-Member NumberOfPackages ($rep.Lookup | measure).Count -PassThru
}

function Summary-NumberOfTrustedPackages([Parameter(ValueFromPipeline=$true)] $pipe) {
    $pipe | Add-Member NumberOfTrustedPackages `
        ($rep.RawData | `
            ? { $_.Name -in $rep.Lookup.TrustedComponents } | `
            %{ $_.Tags += "Trusted" } | `
            measure).Count -PassThru
}

function Tag-Components([Parameter(ValueFromPipeline=$true)] $pipe) {
    $pipe | %{
        $lib = $_
        $t = $tags | ? { $lib.Name -in $_.Packages }
        ForEach( $i in $t ) {
            $lib.Tags += $i.Name
        }
        return $lib
    }
}

function Tag-DownloadCounts([Parameter(ValueFromPipeline=$true)] $pipe) {
    $pipe | % { 
        $lib = $_
        $count = [int]($lib.Versions | Select-Object -First 1 | %{ $_.NuGet.properties.DownloadCount.InnerText })
        
        $lib | Add-Member "DownloadCount" $count -PassThru | 
            %{ if ($_.DownloadCount -ge 1000) { $_.Tags += "1K-Downloads" }; $_ } |
            %{ if ($_.DownloadCount -ge 10000) { $_.Tags += "10K-Downloads" }; $_ } |
            %{ if ($_.DownloadCount -ge 100000) { $_.Tags += "100K-Downloads" }; $_ } |
            %{ if ($_.DownloadCount -ge 1000000) { $_.Tags += "1M-Downloads" }; $_ } 
    }
}

$analysis = New-Object -TypeName PSObject | 
    Add-Member Summary (New-Object -TypeName PSObject) -PassThru | 
    Add-Member RawData $osData -PassThru |
    Add-Member Lookup (New-Object -TypeName PSObject) -PassThru | % {
        $rep = $_
        $rep.Lookup = $rep.Lookup | 
            Lookup-TrustedComponents |
            Lookup-Tags
        $rep.Summary = $rep.Summary | 
            Summary-NumberOfPackages |
            Summary-NumberOfTrustedPackages
        $rep.RawData = $rep.RawData | %{ $_ |
            Tag-DownloadCounts | 
            Tag-Components
            }
        return $rep
    }

$analysis