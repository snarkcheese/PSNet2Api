<#
.SYNOPSIS
Returns the access levels from the Net2 server

.DESCRIPTION
Returns the access levels from the Net2 server. Can be filtered to a single
access level. Detail returns more information about the access level and its
access.

Handles

GET /api/v1/accesslevels
GET /api/v1/accesslevels/{id}
GET /api/v1/accesslevels/{id}/detail

.PARAMETER AccessLevelId
Id of the access level to return

.PARAMETER Detail
Returns additional detail for the access level

.EXAMPLE
Get-Net2AccessLevels

.EXAMPLE
Get-Net2AccessLevels -AccessLevelId 73

.EXAMPLE
Get-Net2AccessLevels -AccessLevelId 73 -Detail
#>
function Get-Net2AccessLevels {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$AccessLevelId,

        [parameter(ParameterSetName = "Single")]
        [switch]$Detail
    )
    $endpoint = "/api/v1/accesslevels"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $AccessLevelId
        if ($Detail) {
            $endpoint = "{0}/detail" -f $endpoint
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}