<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AccessLevelId
Parameter description

.PARAMETER NewAccessLevelId
Parameter description

.PARAMETER AccessLevelDetail
Parameter description

.PARAMETER NewAccessLevelName
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2AccessLevel {
    param(
        [parameter(Mandatory, Position = 0)]
        [int]$AccessLevelId,

        [int]$NewAccessLevelId,

        [object[]]$AccessLevelDetail,

        [string]$NewAccessLevelName
    )
    $change = $false
    $t = @{}
    if ($NewAccessLevelId) {
        $t.Add("id", $NewAccessLevelId)
        $change = $true
    }
    if ($AccessLevelDetail) {
        $t.Add("detailRows", $AccessLevelDetail)
        $change = $true
    }
    if ($NewAccessLevelName) {
        $t.Add("name", $NewAccessLevelName)
        $change = $true
    }
    if ($change) {
        $endpoint = "/api/v1/accesslevels/{0}" -f $AccessLevelId
        $body = ConvertTo-Json -InputObject $t -Depth 5
        Invoke-Net2ApiCall -Endpoint $endpoint -Body $body -Method "Put"
    }
}