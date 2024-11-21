<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER MaximumCount
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2LatestUnknownTokens {
    param(
        [int]$MaximumCount
    )
    $params = @{
        "Endpoint" = "/api/v1/events/latestunknowntokens"
    }
    if ($MaximumCount) {
        $body = @{
            "max" = $MaximumCount
        }
        $params.Add("Body", $body)
        Invoke-Net2ApiCall @params
    }
}