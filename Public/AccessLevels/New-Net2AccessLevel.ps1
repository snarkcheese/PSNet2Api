<#
.SYNOPSIS
Creates a new access level

.DESCRIPTION
Creates a new access level on the Net2 Server

.PARAMETER AccessLevelName
Name for the access level

.PARAMETER AccessLevelDetail
An array of AccessLevelDetailRow

.PARAMETER AccessLevelId
optional id for the access level

.EXAMPLE
New-Net2AccessLevel -AccessLevelName "NewAccessLevel"

.EXAMPLE
$AccessLevelDetail = @(
    @{
        "areaID" = 1
        "timezoneID" = 1
    },
    @{
        "areaID" = 2
        "timezoneID" = 1
    }
)
New-Net2AccessLevel -AccessLevelName "NewAccessLevel" -AccessLevelDetail $AccessLevelDetail
#>
function New-Net2AccessLevel {
    param (
        [parameter(Position = 0, Mandatory)]
        [string]$AccessLevelName,

        [parameter(Position = 1)]
        [object[]]$AccessLevelDetail,

        [int]$AccessLevelId
    )
    $t = @{ "name" = $AccessLevelName }
    if ($AccessLevelId) {
        $t.add("id", $AccessLevelId)
    }
    if ($AccessLevelDetail) {
        $t.add("detailRows", $AccessLevelDetail)
    }
    $body = ConvertTo-Json -InputObject $t -Depth 5 -Compress
    Invoke-Net2ApiCall -Endpoint "/api/v1/accesslevels" -Method "Post" -Body $body
}