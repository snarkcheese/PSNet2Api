<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AccessLevelIds
Parameter description

.PARAMETER IndividualPermissions
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-Net2DoorPermissionSet {
    param(
        [int[]]$AccessLevelIds = @(),
        [System.Object[]]$IndividualPermissions = @()
    )
    @{
        "accessLevels"          = $AccessLevelIds
        "individualPermissions" = $IndividualPermissions
    }
}