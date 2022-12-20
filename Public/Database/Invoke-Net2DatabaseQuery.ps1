<#
.SYNOPSIS
Send a query string to query the SDK database.

.DESCRIPTION
Send a custom query to the Net2 database. Database tables can be found on the paxton forums.

.PARAMETER Query
SQL query to send to the database.

.EXAMPLE
Invoke-Net2DatabaseQuery -Query 'select * from AreasEx'
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