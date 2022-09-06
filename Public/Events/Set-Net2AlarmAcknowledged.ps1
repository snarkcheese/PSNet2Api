<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER EventId
Parameter description

.PARAMETER ACUAddress
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2AlarmAcknowledged {
    [cmdletbinding(DefaultParameterSetName = "All")]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = "ID")]
        [int]$EventId,

        [parameter(Mandatory, ParameterSetName = "Address")]
        [int]$ACUAddress
    )
    $params = @{
        "Endpoint" = "/api/v1/events/alarms/acknowledge"
        "Method"   = "Post"
    }
    if ($PSCmdlet.ParameterSetName -eq "ID") {
        $params.Add("Body", @{"eventId" = $EventId })
    }
    if ($PSCmdlet.ParameterSetName -eq "Address") {
        $params.add("Body", @{"address" = $ACUAddress })
    }
    Invoke-Net2ApiCall @params
}