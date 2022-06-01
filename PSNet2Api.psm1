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
    $r = Invoke-RestMethod @params
    Write-Output $r
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
access level. Detail returns more information about the access level and its
access.

.PARAMETER AccessLevelId
Id of the access level to return

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
Returns a list of areas from the Net2 server.

.EXAMPLE
Get-Net2Areas
#>
function Get-Net2Areas {
    Invoke-Net2ApiCall -Endpoint "/api/v1/accesslevels/areas"
}

<#
.SYNOPSIS
Returns a list of area groups

.DESCRIPTION
Returns the area groups from the Net2 server. Can be filtered to a single
area group

.PARAMETER AreaGroupId
Id of the area group to return

.EXAMPLE
Get-Net2AreaGroups

.EXAMPLE
Get-Net2AreaGroups -AreaGroupId 3
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
Returns a list of doors

.DESCRIPTION
Returns a list of doors from the Net2 system. Can be limited to a single door or
door group. Use 0 as the door group to see all doors outside a door group

.PARAMETER DoorId
Id of single door

.PARAMETER DoorGroupId
Id of single door group. Use 0 for doors outside a door group

.EXAMPLE
Get-Net2Doors

.EXAMPLE
Get-Net2Doors -DoorId 10

.EXAMPLE
Get-Net2Doors -DoorGroupId 3
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
Returns a list of door groups

.DESCRIPTION
Returns a list of door groups. Canb be limited to a single door group

.PARAMETER DoorGroupId
Id of the door group to return

.EXAMPLE
Get-DoorGroups

.EXAMPLE
Get-DoorGroups -DoorGroupId 3
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
Creates a connection to the Net2 API

.DESCRIPTION
Creates a connection to the Net2 API and saves the details into varibles within
the module. Can be used to refresh the OAuth token after connection is made with
-Refresh

.PARAMETER ComputerName
FQDN of the Net2 Server

.PARAMETER ClientId
Client Id TODO

.PARAMETER Port
Port used to connect to the Net2 server API. Defaults to 8080

.PARAMETER Credential
Credential for the Net2 operator connecting

.PARAMETER Refresh
Specifies to refresh the token instead of creating a new connection.

.EXAMPLE
$Server = net2.example.com
$ClientId = '1188a9e2-6d68-4191-963f-6f962cf2e38d'
$Credential = Get-Credential
Connect-Net2API -ComputerName $Server -ClientId $ClientId -Credential $Credential

.EXAMPLE
Connect-Net2Api -Refresh
#>
function Connect-Net2Api {
    [CmdletBinding(DefaultParameterSetName = "Connect")]
    param(

        [parameter(Mandatory, ParameterSetName = "Connect", Position = 0)]
        [string]$ComputerName,
        [parameter(Mandatory, ParameterSetName = "Connect", Position = 1)]
        [string]$ClientId,
        [Parameter(Mandatory, ParameterSetName = "Connect", Position = 2)]
        [pscredential]$Credential,

        [string]$Port = "8080",

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
    Write-Output $r
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
Returns a list of timezones

.DESCRIPTION
Returns a list of timezones, Can be filtered to a single timezone with
additional details

.PARAMETER TimezoneId
Id of timezone to return

.PARAMETER Detail
Optional switch to return additional details about the timezone

.EXAMPLE
Get-Net2Timezones

.EXAMPLE
Get-Net2Timezones -TiemzoneId 4

.EXAMPLE
Get-Net2Timezones -TimezoneId 4 -Detail
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
Returns the timezone days

.DESCRIPTION
Returns a single or all timezone days

.PARAMETER TimezoneDayId
Id of timezone day to return

.EXAMPLE
Get-Net2TimezoneDays

.EXAMPLE
Get-Net2TimezoneDays -TimezoneDayId 4
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
Returns users from the Net2 system

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
    elseif ($PSCmdlet.ParameterSetName -eq "Department") {
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
Returns the tokens assigned to a user

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
Returns a users department

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
Returns a users image

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

<#
.SYNOPSIS
Returns user departments from the Net2 system

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
Returns a list of token types

.EXAMPLE
Get-Net2TokenTypes
#>
function Get-Net2TokenTypes {
    Invoke-Net2ApiCall -Endpoint "/api/v1/users/token/types"
}

<#
.SYNOPSIS
Returns a list of API versions

.EXAMPLE
Get-Net2ApiVersions
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
        switch ($IoInfo) {
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
            default { break }
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
Remove and invalidate the OAuth refresh token

.EXAMPLE
Remove-Net2ApiToken
#>
function Remove-Net2ApiToken {
    $body = @{
        "refreshToken" = $Script:RefreshToken
    }
    Invoke-Net2ApiCall -Endpoint "/api/v1/authorization/tokens" -Body $body -Method "Delete"
    $Script:RefreshToken = ''
}

<#
.SYNOPSIS
Runs the open door command on the specified door

.DESCRIPTION
Runs the open door command as specified in the doors configuration

.PARAMETER DoorId
Id of the door to open

.EXAMPLE
Invoke-Net2OpenDoor -DoorId 54
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
Run the hold open command on the specified door

.DESCRIPTION
Runs the hold open command which holds the door open until closed

.PARAMETER DoorId
Id of the door to hold open

.EXAMPLE
Invoke-Ne2HoldOpenDoor -DoorId 34
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
Runs the close door command

.DESCRIPTION
Runs the close door command closing a door that has been previously held open

.PARAMETER DoorId
Id of the door to close

.EXAMPLE
Invoke-Net2CloseDoor -DoorId 65
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
Runs the Reset Antipassback command

.PARAMETER UserId
Id of user to reset Antipassback for

.EXAMPLE
Invoke-Net2ResetAntipassback -UserId 22
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

<#
.SYNOPSIS
Removes one or more users from the Net2 system

.PARAMETER UserIds
User Ids of everyone to be removed

.PARAMETER Purge
When true also remove all historic user data

.EXAMPLE
Remove-Net2Users -UserIds 1024

.EXAMPLE
remove-Net2Users -UserIds @(1024,2048,4096,10) -Purge

.NOTES
General notes
#>
function Remove-Net2Users {
    param(
        [parameter(Mandatory, Position = 0)]
        [int[]]$UserIds,

        [switch]$Purge
    )
    $p = if ($Purge) { "true" } else { "false" }
    $endpoint = "/api/v1/users?purge={0}" -f $p
    $body = ConvertTo-Json -InputObject $UserIds
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body -Method "Delete"
}

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
function New-AccessLevel {
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

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER AccessLevelId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-AccessLevel {
    param (
        [parameter(Mandatory, Position = 0)]
        [int]$AccessLevelId
    )
    $endpoint = "/api/v1/accesslevels/{0}" -f $AccessLevelId
    Invoke-Net2ApiCall -Endpoint $endpoint -Method "Delete"
}

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
function Set-AccessLevel {
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

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Query
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Invoke-Net2Query {
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$Query
    )
    $body = @{
        "query" = $query
    }
    Invoke-Net2ApiCall -Endpoint "/api/v1/customquery/querydb" -Method "Get" -Body $body
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER EventId
Parameter description

.PARAMETER ACUAddress
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2AlarmAcknowledged {
    [cmdletbinding(DefaultParameterSetName = "All")]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = "ID")]
        [int]$EventId,

        [parameter(Mandatory, ParameterSetName = "Address")]
        [int]$ACUAddress
    )
    $params = @{
        "Endpoint" = "/api/v1/events/alarms/acknowledge"
        "Method"   = "Post"
    }
    if ($PSCmdlet.ParameterSetName -eq "ID") {
        $params.Add("Body", @{"eventId" = $EventId })
    }
    if ($PSCmdlet.ParameterSetName -eq "Address") {
        $params.add("Body", @{"address" = $ACUAddress })
    }
    Invoke-Net2ApiCall @params
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER TokenType
Parameter description

.PARAMETER TokenNumber
Parameter description

.PARAMETER IsLost
Parameter description

.PARAMETER TokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function New-Net2Token {
    param(
        [ValidateSet('Unspecified', 'ProxCard', 'ProxIsoCard',
            'Keyfob', 'HandsFreeToken', 'Watchprox',
            'ProxIsoCardWithoutMagstripe', 'VehicleNumberPlate', 'HandsFreeKeyCard',
            'FingerprintVerificationCard', 'TelephoneCallerId')]
        [Parameter(Mandatory, Position = 0)]
        [string]$TokenType,

        [Parameter(Mandatory, Position = 1)]
        [string]$TokenValue,

        [switch]$IsLost = $false,

        [int]$TokenId
    )
    $token = @{
        "tokenType"  = $TokenType
        "tokenValue" = $TokenValue
    }
    if ($IsLost) {
        $token.Add("isLost", "true")
    }
    if ($TokenId) {
        $token.Add("id", $TokenId)
    }

    Write-Output $token
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER UserID
Parameter description

.PARAMETER Token
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Add-Net2UserToken {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(Mandatory, Position = 1)]
        [object]$Token
    )
    $endpoint = "/api/v1/users/{0}/tokens" -f $UserId
    $body = ConvertTo-Json -InputObject $Token
    Invoke-Net2ApiCall -Endpoint $endpoint -Body $body -Method "Post"
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
function Remove-Net2UserToken {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(Mandatory, Position = 1)]
        [object]$TokenId
    )
    $endpoint = "/api/v1/users/{0}/tokens/{1}" -f $UserId, $TokenId
    Invoke-Net2ApiCall -Endpoint $endpoint -Method "Delete"
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

.PARAMETER IsLost
Parameter description

.PARAMETER NewTokenType
Parameter description

.PARAMETER NewTokenValue
Parameter description

.PARAMETER NewTokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-Net2UserToken {
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(Mandatory, Position = 1)]
        [int]$TokenId,

        [switch]$IsLost,

        [ValidateSet('Unspecified', 'ProxCard', 'ProxIsoCard',
            'Keyfob', 'HandsFreeToken', 'Watchprox',
            'ProxIsoCardWithoutMagstripe', 'VehicleNumberPlate', 'HandsFreeKeyCard',
            'FingerprintVerificationCard', 'TelephoneCallerId')]
        [string]$NewTokenType,

        [string]$NewTokenValue,

        [int]$NewTokenId
    )
    $endpoint = "/api/v1/users/{0}/tokens/{1}" -f $UserId, $TokenId
    $change = $false
    $token = @{}
    if ($NewTokenType) {
        $token.Add("tokenType", $NewTokenType)
        $change = $true
    }
    if ($NewTokenValue) {
        $token.Add("tokenValue", $NewTokenValue)
        $change = $true
    }
    if ($NewTokenId) {
        $token.Add("id", $NewTokenId)
        $change = $true
    }
    if ($IsLost) {
        $token.Add("isLost", "true")
        $change = $true
    }
    if ($change) {
        $body = ConvertTo-Json  -InputObject $token
        Invoke-Net2ApiCall -Endpoint $endpoint -Method "Put" -Body $body
    }
}

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
function New-Net2Department {
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
        [string]$NewName,
        [int]$NewId
    )
    $endpoint = "/api/v1/departments/{0}" -f $DepartmentId
    $department = @{}
    if ($NewName) {
        $department.Add("name", $NewName)
    }
    if ($NewId) {
        $department.Add("id", $NewId)
    }
    $body = ConvertTo-Json $department
    Invoke-Net2ApiCall -Endpoint $endpoint -Method Put -Body $body
}

function Remove-Net2Department {
    param(

    )
}

function Set-Net2UserDepartment {
    param(

    )
}

function Remove-Net2UserDepartment {
    param(

    )
}

function New-Net2User {
    param(

    )
}

function Set-Net2User {
    param(

    )
}

function Remove-Net2User {
    param(

    )
}