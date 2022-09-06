<#
.SYNOPSIS
Returns the Net2 server properties.

.EXAMPLE
Get-Net2ServerProperties
#>
function Get-Net2ServerProperties {
    Invoke-Net2ApiCall -Endpoint "/api/v1/serversettings/properties"
}