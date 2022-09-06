<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-Net2UserDoorPermission {
    param {
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({ $_ -ge 0 })]
        [int]$DoorId,

        [Parameter(Mandatory, Position = 1)]
        [ValidateScript({ $_ -ge 0 })]
        [int]$TimezoneId
    }
    @{
        'id'         = $DoorId
        'timezoneId' = $TimezoneId
    }
}