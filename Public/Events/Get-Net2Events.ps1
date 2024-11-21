<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Where
Parameter description

.PARAMETER OrderBy
Parameter description

.PARAMETER RowCount
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Events {
    param(
        [string]$Where,
        [string]$OrderBy,
        [int]$Count = 1000
    )
    $body = @{
        "rowCount" = $Count
    }
    if ($Where) {
        $body.add("where", $Where)
    }
    if ($OrderBy) {
        $body.add(
            "orderBy", $OrderBy)
    }
    $endpoint = "/api/v1/events"
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body
}