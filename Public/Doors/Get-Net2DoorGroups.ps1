<#
.SYNOPSIS
Returns a list of door groups

.DESCRIPTION
Returns a list of door groups. Canb be limited to a single door group

.PARAMETER DoorGroupId
Id of the door group to return

.EXAMPLE
Get-DoorGroups

.EXAMPLE
Get-DoorGroups -DoorGroupId 3
#>
function Get-Net2DoorGroups {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$DoorGroupId
    )
    $endpoint = "/api/v1/doorgroups"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $DoorGroupId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}