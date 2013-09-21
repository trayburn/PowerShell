function Get-ChildProjects($sln) {

    $pattern = '^Project\(\"\{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC\}\"\) = .*, \"(.*)\",.*'

    Get-Content -Path $sln |

        Select-String -Pattern $pattern -AllMatches |

        % { $_ -replace $pattern,'$1' } | % {

            $match = Get-Item $_

            New-Dynamic |

                With Name $match.Name.Replace(".csproj","") |

                With Path $match.Directory

        }
}

function Get-References() {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        $path
    )
    $refs = [xml](Get-Content $path) | 
        Select-Xml -XPath "//*[local-name() = 'Reference']" | 
        % { 
            if ($_.Node.Include -match "^([\w\.]*)") {
                $matches[0]
            }
        }

        $proj = Get-Item -Path $path
        @{
            Project=$proj.Name.Replace(".csproj","");
            References=$refs
        }
}

function ConvertTo-Digraph() {
    param (
        [Parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        $files
    )
    PROCESS {
        $files | % {
            $proj = $_
            Get-References $proj | % {
                $proj = $_
                $proj.References | % {
                    "`"$($proj.Project)`" -> `"$($_)`""
                }
            } 
        }
    }
}

Get-ChildItem -Recurse -Force Alkami.Tools.SymConnect*.csproj | 
    Get-References