<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Name
Parameter description

.PARAMETER Id
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Add-Net2Department {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,
        [int]$Id
    )
    $department = @{
        "name" = $Name
    }
    if ($Id) {
        $department.Add("id", $Id)
    }
    $body = ConvertTo-Json -InputObject $Department
    Invoke-Net2ApiCall -Endpoint "/api/v1/departments" -Method Post -Body $body
}