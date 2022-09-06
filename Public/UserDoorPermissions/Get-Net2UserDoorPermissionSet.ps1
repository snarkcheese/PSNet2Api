<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserDoorPermissionSet {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $endpoint = "/api/v1/users/{0}/doorpermissionset" -f $UserId
    Invoke-Net2ApiCall -Endpoint $endpoint
}