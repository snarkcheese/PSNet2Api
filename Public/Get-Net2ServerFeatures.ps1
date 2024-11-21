<#
.SYNOPSIS
Return the Net2 server features.

.EXAMPLE
Get-Net2ServerFeatures
#>
function Get-Net2ServerFeatures {
    Invoke-Net2ApiCall -Endpoint "/api/v1/serversettings/features"
}