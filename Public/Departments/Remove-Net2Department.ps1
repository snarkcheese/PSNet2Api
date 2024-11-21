<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DepartmentId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-Net2Department {
    param(
        [parameter(Mandatory, Position = 0)]
        [int]$DepartmentId
    )
    $endpoint = "/api/v1/departments/{0}" -f $DepartmentId
    Invoke-Net2ApiCall -Endpoint $endpoint -Method Delete
}