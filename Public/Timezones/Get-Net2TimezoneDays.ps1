<#
.SYNOPSIS
Returns the timezone days

.DESCRIPTION
Returns a single or all timezone days

.PARAMETER TimezoneDayId
Id of timezone day to return

.EXAMPLE
Get-Net2TimezoneDays

.EXAMPLE
Get-Net2TimezoneDays -TimezoneDayId 4
#>
function Get-Net2TimezoneDays {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$TimezoneDayId
    )
    $endpoint = "/api/v1/timezones/days"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TimeZoneId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}