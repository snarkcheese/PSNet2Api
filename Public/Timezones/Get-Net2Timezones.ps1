<#
.SYNOPSIS
Returns a list of timezones

.DESCRIPTION
Returns a list of timezones, Can be filtered to a single timezone with
additional details

.PARAMETER TimezoneId
Id of timezone to return

.PARAMETER Detail
Optional switch to return additional details about the timezone

.EXAMPLE
Get-Net2Timezones

.EXAMPLE
Get-Net2Timezones -TiemzoneId 4

.EXAMPLE
Get-Net2Timezones -TimezoneId 4 -Detail
#>
function Get-Net2Timezones {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$TimezoneId,

        [parameter(ParameterSetName = "Single")]
        [switch]$Detail
    )
    $endpoint = "/api/v1/timezones"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TimezoneId
        if ($Detail) {
            $endpoint = "{0}/detail" -f $endpoint
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}