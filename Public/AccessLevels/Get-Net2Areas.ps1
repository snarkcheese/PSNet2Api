<#
.SYNOPSIS
Returns a list of areas from the Net2 server.

.EXAMPLE
Get-Net2Areas
#>
function Get-Net2Areas {
    Invoke-Net2ApiCall -Endpoint "/api/v1/accesslevels/areas"
}