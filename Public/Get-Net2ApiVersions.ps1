<#
.SYNOPSIS
Returns a list of API versions

.EXAMPLE
Get-Net2ApiVersions
#>
function Get-Net2ApiVersions {
    Invoke-Net2ApiCall -Endpoint "/api/v1/versions"
}