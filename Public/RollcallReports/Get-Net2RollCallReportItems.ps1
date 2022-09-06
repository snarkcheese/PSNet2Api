<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ReportId
Parameter description

.PARAMETER ReportItemId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2RollCallReportItems {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$ReportId,

        [Parameter(ParameterSetName = "Single")]
        [int]$ReportItemId
    )
    $endpoint = "/api/v1/rollcallreports/{0}/reportitems" -f $ReportId
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $ReportItemId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}