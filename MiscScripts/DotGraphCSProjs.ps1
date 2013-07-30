
function Get-AlkamiReferences($path) {
    [xml](Get-Content $path) | 
        Select-Xml -XPath "//*[local-name() = 'Reference']" | 
        % { 
            if ($_.Node.Include -match "^(Alkami[\w\.]*)") {
                $matches[0]
            }
        }
}

$dotFile = "digraph {$([Environment]::NewLine)"

Get-ChildItem -Recurse -Force *.csproj | % {
    $proj = $_
    $refs = Get-AlkamiReferences $proj
    @{
        Project=$proj.Name.Replace(".csproj","");
        References=$refs
    }
} | % {
    $proj = $_
    $proj.References | % {
        $dotFile += "`"$($proj.Project)`" -> `"$($_)`""
        $dotFile += [Environment]::NewLine
    }
}

$dotFile += "$([Environment]::NewLine)}"

Set-Content -Path .\temp.dot -value $dotFile