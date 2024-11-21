<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ReportId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2RollCallReports {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$ReportId
    )
    $endpoint = "/api/v1/rollcallreports"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $ReportId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}