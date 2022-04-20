$Script:ComputerName = ""
$Script:Port = ""
$Script:BaseUri = ""
$Script:BearerToken = ""
$Script:RefreshToken = ""

<#
.SYNOPSIS
Calls Invoke-RestMethod with appropriate headers and params

.PARAMETER Endpoint
Api endpoint to call

.PARAMETER Body
Body to be sent to endpoint

.PARAMETER Method
POST, GET, PUT or DELETE method

.EXAMPLE
Invoke-Net2ApiCall -Endpoint "/api/v1/users"

.EXAMPLE
$body = @{
    "refreshToken" = "Token123"
}
Invoke-Net2ApiCall -Endpoint "/api/v1/authorization/tokens" -Body $body -Method "Delete"
#>
function Invoke-Net2ApiCall {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Endpoint,

        [System.Object]$Body,

        [ValidateSet(
            "Get",
            "Put",
            "Delete",
            "Post"
        )]
        [string]$Method = "Get"
    )
    $headers = @{
        Authorization  = "Bearer $($Script:BearerToken)"
        "Content-type" = "application/json"
        "Accept"       = "application/json"
    }
    $params = @{
        "Headers" = $headers
        "Method"  = $Method
        "Uri"     = "{0}{1}" -f $Script:BaseUri, $Endpoint
    }
    if ($Body) {
        $params.Add("Body", $Body)
    }
    $resp = Invoke-RestMethod @params
    Write-Output $resp
}

<#
.SYNOPSIS
Returns a list of operators registered on the Net2 server

.PARAMETER ComputerName
Name of the Net2 server

.PARAMETER Port
Port for the api of the server

.EXAMPLE
Get-Net2Operators -ComputerName "ThisIsANet2Server.com"
#>
function Get-Net2Operators {
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$ComputerName,

        [string]$Port = "8080"
    )
    $endpoint = "http://{0}:{1}/api/v1/operators" -f $ComputerName, $Port
    Invoke-RestMethod -Uri $endpoint
}

<#
.SYNOPSIS
Returns the access levels from the Net2 server

.DESCRIPTION
Returns the access levels from the Net2 server. Can be filtered to a single
access level. Detail returns more information

.PARAMETER AccessLevelId
Number of the access level to return

.PARAMETER Detail
Returns additional detail for the access level

.EXAMPLE
Get-Net2AccessLevels

.EXAMPLE
Get-Net2AccessLevels -AccessLevelId 73

.EXAMPLE
Get-Net2AccessLevels -AccessLevelId 73 -Detail
#>
function Get-Net2AccessLevels {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$AccessLevelId,

        [parameter(ParameterSetName = "Single")]
        [switch]$Detail
    )
    $endpoint = "/api/v1/accesslevels"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $AccessLevelId
        if ($Detail) {
            $endpoint = "{0}/detail" -f $endpoint
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Areas {
    Invoke-Net2ApiCall -Endpoint "/api/v1/accesslevels/areas"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AreaGroupId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2AreaGroups {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$AreaGroupId
    )
    $endpoint = "/api/v1/areagroups"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $AreaGroupId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DoorId
Parameter description

.PARAMETER DoorGroupId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Doors {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$DoorId,

        [Parameter(ParameterSetName = "DoorGroup")]
        [int]$DoorGroupId
    )
    $endpoint = "/api/v1/doors"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $AreaGroupId
    }
    elseif ($PSCmdlet.ParameterSetName -eq "DoorGroup") {
        if ($DoorGroupId -eq 0) {
            $endpoint = "/api/v1/doorgroups/root/doors"
        }
        else {
            $endpoint = "/api/v1/doorgroups/{0}/doors" -f $DoorGroupId
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DoorGroupId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2DoorGroups {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$DoorGroupId
    )
    $endpoint = "/api/v1/doorgroups"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $DoorGroupId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ComputerName
Parameter description

.PARAMETER ClientId
Parameter description

.PARAMETER Port
Parameter description

.PARAMETER Credential
Parameter description

.PARAMETER Refresh
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Connect-Net2Api {
    [CmdletBinding(DefaultParameterSetName = "Connect")]
    param(

        [parameter(Mandatory, Position = 0)]
        [string]$ComputerName,
        [parameter(Mandatory, Position = 1)]
        [string]$ClientId,
        [string]$Port = "8080",

        [Parameter(ParameterSetName = "Connect", Mandatory)]
        [pscredential]$Credential,
        [Parameter(ParameterSetName = "Refresh", Mandatory)]
        [string]$Refresh
    )
    $body = @{
        "client_id" = $ClientId
    }
    if ($PSCmdlet.ParameterSetName -eq "Connect") {
        $Script:ComputerName = $ComputerName
        $Script:Port = $Port
        $Script:BaseUri = "http://{0}:{1}" -f $ComputerName, $Port
        $body.add("username", $Credential.UserName)
        $body.add("password", $Credential.GetNetworkCredential().Password)
        $body.add("grant_type", "password")  
    }
    else {
        $body.add("refresh_token", $Script:RefreshToken)
        $body.add("scope", "offline_access")
        $body.add("grant_type", "refresh_token") 
    }
    $endpoint = "$($Script:BaseUri)/api/v1/authorization/tokens"
    $payload = $body | ConvertTo-Json
    $r = Invoke-RestMethod -Method Post -Uri $endpoint -body $payload -ContentType "application/json"
    $Script:BearerToken = $r.access_token
    $Script:RefreshToken = $r.refresh_token
    write-output $r
}

<#
.SYNOPSIS
Return the Net2 server features.

.EXAMPLE
Get-Net2ServerFeatures
#>
function Get-Net2ServerFeatures {
    Invoke-Net2ApiCall -Endpoint "/api/v1/serversettings/features"
}

<#
.SYNOPSIS
Returns the Net2 server properties.

.EXAMPLE
Get-Net2ServerProperties
#>
function Get-Net2ServerProperties {
    Invoke-Net2ApiCall -Endpoint "/api/v1/serversettings/properties"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER TimezoneId
Parameter description

.PARAMETER Detail
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Timezones {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$TimezoneId,

        [parameter(ParameterSetName = "Single")]
        [switch]$Detail
    )
    $endpoint = "/api/v1/timezones"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TimezoneId
        if ($Detail) {
            $endpoint = "{0}/detail" -f $endpoint
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER TimezoneDayId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2TimezoneDays {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$TimezoneDayId
    )
    $endpoint = "/api/v1/timezones/days"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TimeZoneId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

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
    elseif ($PSCmdlet.ParameterSetName -eq "Department"){
        if ($DepartmentId -eq 0) {
            $endpoint = "/api/v1/departments/root/users"
        }
        else {
            $endpoint = "/api/v1/departments/{0}/users" -f $DepartmentId
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.PARAMETER TokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserTokens {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(ParameterSetName = "Single")]
        [int]$TokenId
    )
    $endpoint = "/api/v1/users/{0}/tokens" -f $UserId
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TokenId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserDepartments {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $endpoint = "/api/v1/users/{0}/departments" -f $UserId
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserDoorPermissionSet {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $endpoint = "/api/v1/users/{0}/doorpermissionset" -f $UserId
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserImage {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $endpoint = "/api/v1/users/{0}/image" -f $UserId
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

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
function Get-Net2Departments {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$DepartmentId
    )
    $endpoint = "/api/v1/departments"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $DepartmentId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2TokenTypes {
    Invoke-Net2ApiCall -Endpoint "/api/v1/users/token/types"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2ApiVersions {
    Invoke-Net2ApiCall -Endpoint "/api/v1/versions"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ReportId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2RollCallReports {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$ReportId
    )
    $endpoint = "/api/v1/rollcallreports"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $ReportId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ReportId
Parameter description

.PARAMETER ReportItemId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2RollCallReportItems {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$ReportId,

        [Parameter(ParameterSetName = "Single")]
        [int]$ReportItemId
    )
    $endpoint = "/api/v1/rollcallreports/{0}/reportitems" -f $ReportId
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $ReportItemId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER IoBoardId
Parameter description

.PARAMETER IoInfo
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2IoBoards {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$IoBoardId,

        [Parameter(ParameterSetName = "Single")]
        [ValidateSet("Inputs", "Outputs", "Detailed")]
        [int]$IoInfo
    )
    $endpoint = "/api/v1/ioboards"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $IoBoardId
        switch ($IoInfo){
            "Inputs" {
                $endpoint = "{0}/inputs" -f $endpoint
                break
            }
            "Outputs" {
                $endpoint = "{0}/outputs" -f $endpoint
                break
            }
            "Detailed" {
                $endpoint = "{0}/detail" -f $endpoint
                break
            }
            default {break}
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Where
Parameter description

.PARAMETER OrderBy
Parameter description

.PARAMETER RowCount
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2Events {
    param(
        [string]$Where,
        [string]$OrderBy,
        [int]$Count = 1000
    )
    $body = @{
        "rowCount" = $MaximumCount
    }
    if ($Where) {
        $body.add(
            "where",
            [System.Web.HttpUtility]::UrlEncode($Where)
        )
    }
    if ($OrderBy) {
        $body.add(
            "orderBy",
            [System.Web.HttpUtility]::UrlEncode($OrderBy)
        )
    }
    $endpoint = "/api/v1/events"
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER MaximumCount
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2LatestUnknownTokens {
    param(
        [int]$MaximumCount
    )
    $params = @{
        "Endpoint" = "/api/v1/events/latestunknowntokens"
    }
    if ($MaximumCount) {
        $body = @{
            "max" = $MaximumCount
        }
        $params.Add("Body", $body)
        Invoke-Net2ApiCall @params
    }
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-Net2ApiToken {
    $body = @{
        "refreshToken" = $Script:RefreshToken
    }
    Invoke-Net2ApiCall -Endpoint "/api/v1/authorization/tokens" -Body $body -Method "Delete"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DoorId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Invoke-Net2OpenDoor {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$DoorId
    )
    $body = @{
        "doorId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/open" -Body $body -Method "Post"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DoorId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Invoke-Net2HoldOpenDoor {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$DoorId
    )
    $body = @{
        "doorId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/holdopen" -Body $body -Method "Post"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DoorId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Invoke-Net2CloseDoor {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$DoorId
    )
    $body = @{
        "doorId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/close" -Body $body -Method "Post"
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Invoke-Net2ResetAntipassback {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId
    )
    $body = @{
        "userId" = $DoorId
    } | ConvertTo-Json
    Invoke-Net2ApiCall -Endpoint "/api/v1/commands/door/open" -Body $body -Method "Post"
}