<#
.SYNOPSIS
Returns user departments from the Net2 system

.DESCRIPTION
Long description

.PARAMETER DepartmentId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Departments {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$DepartmentId
    )
    $endpoint = "/api/v1/departments"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $DepartmentId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}