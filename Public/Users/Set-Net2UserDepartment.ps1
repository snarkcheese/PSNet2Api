<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.PARAMETER DepartmentName
Parameter description

.PARAMETER DepartmentId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2UserDepartment {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,
        [Parameter(Mandatory, Position = 1)]
        [int]$DepartmentId,
        [string]$DepartmentName
    )
    $endpoint = "/api/v1/users/{0}/departments" -f $UserId
    $department = @{
        "id" = $DepartmentId
    }
    if ($PSBoundParameters.ContainsKey('DepartmentName')) {
        $department.Add("name", $DepartmentName)
    }
    $body = ConvertTo-Json -InputObject $department
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body -Method Put
}