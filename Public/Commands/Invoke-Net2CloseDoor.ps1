<#
.SYNOPSIS
Runs the close door command

.DESCRIPTION
Runs the close door command closing a door that has been previously held open

.PARAMETER DoorId
Id of the door to close

.EXAMPLE
Invoke-Net2CloseDoor -DoorId 65
#>
function Invoke-Net2CloseDoor {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$DoorId
    )
    $body = @{
        "doorId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/close" -Body $body -Method "Post"
}