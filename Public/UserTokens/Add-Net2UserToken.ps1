<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserID
Parameter description

.PARAMETER Token
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Add-Net2UserToken {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(Mandatory, Position = 1)]
        [object]$Token
    )
    $endpoint = "/api/v1/users/{0}/tokens" -f $UserId
    $body = ConvertTo-Json -InputObject $Token
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body -Method "Post"
}