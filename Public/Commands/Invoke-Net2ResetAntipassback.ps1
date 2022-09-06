<#
.SYNOPSIS
Runs the Reset Antipassback command

.PARAMETER UserId
Id of user to reset Antipassback for

.EXAMPLE
Invoke-Net2ResetAntipassback -UserId 22
#>
function Invoke-Net2ResetAntipassback {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $body = @{
        "userId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/open" -Body $body -Method "Post"
}