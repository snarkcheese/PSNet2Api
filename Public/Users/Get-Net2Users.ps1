<#
.SYNOPSIS
Returns users from the Net2 system

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.PARAMETER DepartmentId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Users {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$UserId,

        [Parameter(ParameterSetName = "Department")]
        [int]$DepartmentId
    )
    $endpoint = "/api/v1/users"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $UserId
    }
    elseif ($PSCmdlet.ParameterSetName -eq "Department") {
        if ($DepartmentId -eq 0) {
            $endpoint = "/api/v1/departments/root/users"
        }
        else {
            $endpoint = "/api/v1/departments/{0}/users" -f $DepartmentId
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}