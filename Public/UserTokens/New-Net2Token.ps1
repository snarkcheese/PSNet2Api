<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER TokenType
Parameter description

.PARAMETER TokenNumber
Parameter description

.PARAMETER IsLost
Parameter description

.PARAMETER TokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-Net2Token {
    param(
        [ValidateSet('Unspecified', 'ProxCard', 'ProxIsoCard',
            'Keyfob', 'HandsFreeToken', 'Watchprox',
            'ProxIsoCardWithoutMagstripe', 'VehicleNumberPlate', 'HandsFreeKeyCard',
            'FingerprintVerificationCard', 'TelephoneCallerId')]
        [Parameter(Mandatory, Position = 0)]
        [string]$TokenType,

        [Parameter(Mandatory, Position = 1)]
        [string]$TokenValue,

        [switch]$IsLost = $false,

        [int]$TokenId
    )
    $token = @{
        "tokenType"  = $TokenType
        "tokenValue" = $TokenValue
    }
    if ($IsLost) {
        $token.Add("isLost", "true")
    }
    if ($TokenId) {
        $token.Add("id", $TokenId)
    }
    Write-Output $token
}