<#
.SYNOPSIS
Removes one or more users from the Net2 system

.PARAMETER UserIds
User Ids of everyone to be removed

.PARAMETER Purge
When true also remove all historic user data

.EXAMPLE
Remove-Net2Users -UserIds 1024

.EXAMPLE
remove-Net2Users -UserIds @(1024,2048,4096,10) -Purge

.NOTES
General notes
#>
function Remove-Net2Users {
    param(
        [parameter(Mandatory, Position = 0)]
        [int[]]$UserIds,

        [switch]$Purge
    )
    $p = if ($Purge) { "true" } else { "false" }
    $endpoint = "/api/v1/users?purge={0}" -f $p
    $body = ConvertTo-Json -InputObject $UserIds
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body -Method "Delete"
}