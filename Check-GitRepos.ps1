function gitBranchName {
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

function Check-CurrentBranch {
    $branchName = gitBranchName

    # check repo current branch has no work in progress or untracked files
    $status = git status -s
    if ($status -ne $null -and $status.Trim() -ne "") {
        Write-Host "UNCOMMITED : $branchName in $repoPath" -ForegroundColor Red
    }

    $logOfDiffs = git log --branches --not --remotes=origin --oneline
    if ($logOfDiffs -ne $null -and $logOfDiffs.Trim() -ne "") {
        Write-Host "UNPUSHED : $repoPath" -ForegroundColor Red
        git log --branches --not --remotes=origin --oneline
    }
}

if (($allRepos | measure).Count -eq 0) {
    Write-Host "Scanning for repositories, and cacheing in `$allRepos"
    $allRepos = Get-ChildItem -Directory -Recurse -Hidden ".git"
} else {
    Write-Host "Using cached GIT repos from `$allRepos"
}

$startLocation = Get-Location

$allRepos | % {
    cd $_.FullName
    cd ..

    $repoPath = Get-Location

    Check-CurrentBranch

    cd $startLocation
}