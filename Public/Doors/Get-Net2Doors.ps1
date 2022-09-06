<#
.SYNOPSIS
Returns a list of doors

.DESCRIPTION
Returns a list of doors from the Net2 system. Can be limited to a single door or
door group. Use 0 as the door group to see all doors outside a door group

.PARAMETER DoorId
Id of single door

.PARAMETER DoorGroupId
Id of single door group. Use 0 for doors outside a door group

.EXAMPLE
Get-Net2Doors

.EXAMPLE
Get-Net2Doors -DoorId 10

.EXAMPLE
Get-Net2Doors -DoorGroupId 3
#>
function Get-Net2Doors {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$DoorId,

        [Parameter(ParameterSetName = "DoorGroup")]
        [int]$DoorGroupId
    )
    $endpoint = "/api/v1/doors"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $AreaGroupId
    }
    elseif ($PSCmdlet.ParameterSetName -eq "DoorGroup") {
        if ($DoorGroupId -eq 0) {
            $endpoint = "/api/v1/doorgroups/root/doors"
        }
        else {
            $endpoint = "/api/v1/doorgroups/{0}/doors" -f $DoorGroupId
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}