<#
.SYNOPSIS
Run the hold open command on the specified door

.DESCRIPTION
Runs the hold open command which holds the door open until closed

.PARAMETER DoorId
Id of the door to hold open

.EXAMPLE
Invoke-Ne2HoldOpenDoor -DoorId 34
#>
function Invoke-Net2HoldOpenDoor {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$DoorId
    )
    $body = @{
        "doorId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/holdopen" -Body $body -Method "Post"
}