<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AccessLevelName
Parameter description

.PARAMETER AccessLevelDetail
Parameter description

.PARAMETER AccessLevelId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-Net2AccessLevel {
    param (
        [parameter(Position = 0)]
        [string]$AccessLevelName,

        [parameter(Position = 1)]
        [object[]]$AccessLevelDetail,

        [int]$AccessLevelId
    )
    $new = $false
    $t = @{}
    if ($AccessLevelName) {
        $t.add("name", $AccessLevelName)
        $new = $true
    }
    if ($AccessLevelId) {
        $t.add("id", $AccessLevelId)
        $new = $true
    }
    if ($AccessLevelDetail) {
        $t.add("detailRows", $AccessLevelDetail)
        $new = $true
    }
    if ($new) {
        $body = ConvertTo-Json -InputObject $t -Depth 5 -Compress
        Invoke-Net2ApiCall -Endpoint "/api/v1/accesslevels" -Method "Post" -Body $body
    }
}