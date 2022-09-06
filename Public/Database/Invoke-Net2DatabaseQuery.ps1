<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Query
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Invoke-Net2DatabaseQuery {
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$Query
    )
    $body = @{
        "query" = $query
    }
    Invoke-Net2ApiCall -Endpoint "/api/v1/customquery/querydb" -Method "Get" -Body $body
}