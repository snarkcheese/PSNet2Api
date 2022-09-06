<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AccessLevelId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-Net2AccessLevel {
    param (
        [parameter(Mandatory, Position = 0)]
        [int]$AccessLevelId
    )
    $endpoint = "/api/v1/accesslevels/{0}" -f $AccessLevelId
    Invoke-Net2ApiCall -Endpoint $endpoint -Method "Delete"
}