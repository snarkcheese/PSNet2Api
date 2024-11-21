<#
.SYNOPSIS
Returns a users department

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserDepartments {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $endpoint = "/api/v1/users/{0}/departments" -f $UserId
    Invoke-Net2ApiCall -Endpoint $endpoint
}