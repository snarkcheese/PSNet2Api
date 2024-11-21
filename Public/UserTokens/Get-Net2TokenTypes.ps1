<#
.SYNOPSIS
Returns a list of token types

.EXAMPLE
Get-Net2TokenTypes
#>
function Get-Net2TokenTypes {
    Invoke-Net2ApiCall -Endpoint "/api/v1/users/token/types"
}