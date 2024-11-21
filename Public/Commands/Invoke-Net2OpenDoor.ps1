<#
.SYNOPSIS
Runs the open door command on the specified door

.DESCRIPTION
Runs the open door command as specified in the doors configuration

.PARAMETER DoorId
Id of the door to open

.EXAMPLE
Invoke-Net2OpenDoor -DoorId 54
#>
function Invoke-Net2OpenDoor {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$DoorId
    )
    $body = @{
        "doorId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/open" -Body $body -Method "Post"
}