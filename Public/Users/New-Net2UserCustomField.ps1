<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER CustomFieldId
Parameter description

.PARAMETER Value
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-Net2UserCustomField {
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(1, 14)]
        [int]$CustomFieldId,

        [Parameter(Position = 1)]
        [string]$Value = ''
    )
    $field = Get-Net2UserCustomFieldNames -CustomFieldId $CustomFieldId
    if ($value.Length -gt $field.maxLength) {
        Write-Error -Message "Value too long for field" -Category InvalidData
        return
    }
    @{
        "id"    = $CustomFieldId
        "value" = $Value
    }
}