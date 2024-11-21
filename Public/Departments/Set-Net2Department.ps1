<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DepartmentId
Parameter description

.PARAMETER NewName
Parameter description

.PARAMETER NewId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2Department {
    param(
        [parameter(Mandatory, Position = 0)]
        [int]$DepartmentId,
        [Parameter(Mandatory, Position = 1)]
        [string]$NewName,
        [int]$NewId
    )
    $endpoint = "/api/v1/departments/{0}" -f $DepartmentId
    $department = @{
        "name" = $NewName
    }
    if ($NewId) {
        $department.Add("id", $NewId)
    }
    $body = ConvertTo-Json $department
    Invoke-Net2ApiCall -Endpoint $endpoint -Method Put -Body $body
}