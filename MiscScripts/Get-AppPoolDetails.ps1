
function New-Dynamic() {
    return New-Object -TypeName PSObject;
}

function With(
    [Parameter(ValueFromPipeline=$true, Mandatory=$true)]$dyn, 
    [Parameter(Position=0)][string] $name, 
    [Parameter(Position=1)]$val) {
    return $dyn | Add-Member -MemberType NoteProperty -Name $name -Value $val -PassThru
}

function Test-ExactlyOne {
    END {
        return ($input | measure).Count -eq 1
    }
}

function Test-ExactlyZero {
    END {
        return ($input | measure).Count -eq 0
    }
}

if (Get-Module | ? { $_.Name -eq "WebAdministration" } | Test-ExactlyZero) {
    Import-Module WebAdministration
}

$aps = Get-ChildItem IIS:\AppPools

$aps | % {
    New-Dynamic | 
        With AutoStart $_.AutoStart |
        With CLRConfig $_.CLRConfig |
        With CPULimit $_.CPU.Limit |
        With CPUAction $_.CPU.Action |
        With CPUResetInterval $_.CPU.ResetInterval |
        With CPUsmpAffinitized $_.CPU.smpAffinitized |
        With CPUsmpProcessorAffinityMask $_.CPU.smpProcessorAffinityMask |
        With CPUsmpProcessorAffinityMask2 $_.CPU.smpProcessorAffinityMask2 |
        With CPUprocessorGroup $_.CPU.processorGroup |
        With CPUnumaNodeAssignment $_.CPU.numaNodeAssignment |
        With CPUnumaNodeAffinityMode $_.CPU.numaNodeAffinityMode |
        With enable32BitAppOnWin64 $_.enable32BitAppOnWin64 |
        With enableConfigurationOverride $_.enableConfigurationOverride |
        With failureloadBalancerCapabilities $_.failure.loadBalancerCapabilities |
        With failureorphanWorkerProcess $_.failure.orphanWorkerProcess |
        With failureorphanActionExe $_.failure.orphanActionExe |
        With failureorphanActionParams $_.failure.orphanActionParams |
        With failurerapidFailProtection $_.failure.rapidFailProtection |
        With failurerapidFailProtectionInterval $_.failure.rapidFailProtectionInterval |
        With failurerapidFailProtectionMaxCrashes $_.failure.rapidFailProtectionMaxCrashes |
        With failureautoShutdownExe $_.failure.autoShutdownExe |
        With failureautoShutdownParams $_.failure.autoShutdownParams |
        With ItemXPath $_.ItemXPath |
        With managedPipelineMode $_.managedPipelineMode |
        With managedRuntimeLoader $_.managedRuntimeLoader |
        With managedRuntimeVersion $_.managedRuntimeVersion |
        With name $_.name |
        With passAnonymousToken $_.passAnonymousToken |
        With processModelidentityType $_.processModel.identityType |
        With processModeluserName $_.processModel.userName |
        With processModelpassword $_.processModel.password |
        With processModelloadUserProfile $_.processModel.loadUserProfile |
        With processModelsetProfileEnvironment $_.processModel.setProfileEnvironment |
        With processModellogonType $_.processModel.logonType |
        With processModelmanualGroupMembership $_.processModel.manualGroupMembership |
        With processModelidleTimeout $_.processModel.idleTimeout |
        With processModelmaxProcesses $_.processModel.maxProcesses |
        With processModelshutdownTimeLimit $_.processModel.shutdownTimeLimit |
        With processModelstartupTimeLimit $_.processModel.startupTimeLimit |
        With processModelpingingEnabled $_.processModel.pingingEnabled |
        With processModelpingInterval $_.processModel.pingInterval |
        With processModelpingResponseTime $_.processModel.pingResponseTime |
        With processModellogEventOnProcessModel $_.processModel.logEventOnProcessModel |
        With queueLength $_.queueLength |
        With recyclingdisallowOverlappingRotation $_.recycling.disallowOverlappingRotation |
        With recyclingdisallowRotationOnConfigChange $_.recycling.disallowRotationOnConfigChange |
        With recyclinglogEventOnRecycle $_.recycling.logEventOnRecycle |
        With startMode $_.startMode |
        With workerProcesses $_.workerProcesses 
} | Export-Csv -Path c:\source\report.csv