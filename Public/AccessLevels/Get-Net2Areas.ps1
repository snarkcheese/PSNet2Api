<#
.SYNOPSIS
Returns a list of areas from the Net2 server.

.DESCRIPTION
Returns a list of areas from the Net2 server.

Handles

GET /api/v1/accesslevels/areas

.EXAMPLE
Get-Net2Areas
#>
function Get-Net2Areas {
    Invoke-Net2ApiCall -Endpoint "/api/v1/accesslevels/areas"
}