<#
.SYNOPSIS
Returns custom fields for a user

.DESCRIPTION
Long description

.PARAMETER CustomFieldId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserCustomFieldNames {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$CustomFieldId
    )
    $endpoint = "/api/v1/users/customfieldnames"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $CustomFieldId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}