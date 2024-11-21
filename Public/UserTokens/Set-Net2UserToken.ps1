<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.PARAMETER TokenId
Parameter description

.PARAMETER IsLost
Parameter description

.PARAMETER NewTokenType
Parameter description

.PARAMETER NewTokenValue
Parameter description

.PARAMETER NewTokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2UserToken {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(Mandatory, Position = 1)]
        [int]$TokenId,

        [switch]$IsLost,

        [ValidateSet('Unspecified', 'ProxCard', 'ProxIsoCard',
            'Keyfob', 'HandsFreeToken', 'Watchprox',
            'ProxIsoCardWithoutMagstripe', 'VehicleNumberPlate', 'HandsFreeKeyCard',
            'FingerprintVerificationCard', 'TelephoneCallerId')]
        [string]$NewTokenType,

        [string]$NewTokenValue,

        [int]$NewTokenId
    )
    $endpoint = "/api/v1/users/{0}/tokens/{1}" -f $UserId, $TokenId
    $change = $false
    $token = @{}
    if ($NewTokenType) {
        $token.Add("tokenType", $NewTokenType)
        $change = $true
    }
    if ($NewTokenValue) {
        $token.Add("tokenValue", $NewTokenValue)
        $change = $true
    }
    if ($NewTokenId) {
        $token.Add("id", $NewTokenId)
        $change = $true
    }
    if ($IsLost) {
        $token.Add("isLost", "true")
        $change = $true
    }
    if ($change) {
        $body = ConvertTo-Json  -InputObject $token
        Invoke-Net2ApiCall -Endpoint $endpoint -Method "Put" -Body $body
    }
}