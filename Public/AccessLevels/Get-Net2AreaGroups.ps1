<#
.SYNOPSIS
Returns a list of area groups

.DESCRIPTION
Returns the area groups from the Net2 server. Can be filtered to a single
area group

Handles

GET /api/v1/areagroups
GET /api/v1/areagroups/{id}

.PARAMETER AreaGroupId
Id of the area group to return

.EXAMPLE
Get-Net2AreaGroups

.EXAMPLE
Get-Net2AreaGroups -AreaGroupId 3
#>
function Get-Net2AreaGroups {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$AreaGroupId
    )
    $endpoint = "/api/v1/areagroups"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $AreaGroupId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}