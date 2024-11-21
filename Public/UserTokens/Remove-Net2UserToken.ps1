<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.PARAMETER TokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-Net2UserToken {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(Mandatory, Position = 1)]
        [object]$TokenId
    )
    $endpoint = "/api/v1/users/{0}/tokens/{1}" -f $UserId, $TokenId
    Invoke-Net2ApiCall -Endpoint $endpoint -Method "Delete"
}