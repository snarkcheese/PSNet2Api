$Script:ComputerName = ""
$Script:Port = ""
$Script:BaseUri = ""
$Script:BearerToken = ""
$Script:RefreshToken = ""
# $Script:ClientId = ""

function Invoke-Net2ApiCall {
    param(
        $Endpoint,
        $Body,
        $Method = "Get"
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

function Get-Net2Operators {
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$ComputerName,

        [string]$Port = "8080"
    )
    $endpoint = "http://{0}:{1}/api/v1/operators" -f $ComputerName, $Port
    Invoke-RestMethod -Uri $endpoint
}

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

function Get-Net2Areas {
    $endpoint = "/api/v1/accesslevels/areas"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

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

function Get-Net2ServerFeatures {
    Invoke-Net2ApiCall -Endpoint "/api/v1/serversettings/features"
}

function Get-Net2ServerProperties {
    Invoke-Net2ApiCall -Endpoint "/api/v1/serversettings/properties"
}

function Get-Net2TimeZones {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$TimeZoneId,

        [parameter(ParameterSetName = "Single")]
        [switch]$Detail
    )
    $endpoint = "/api/v1/timezones"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TimeZoneId
        if ($Detail) {
            $endpoint = "{0}/detail" -f $endpoint
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2TimezoneDays {
    $endpoint = "/api/v1/timezones/days"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2Users {
    $endpoint = "/api/v1/users"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2Departments {
    $endpoint = "/api/v1/departments"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2TokenTypes {
    $endpoint = "/api/v1/users/token/types"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2ApiVersions {
    $endpoint = "/api/v1/versions"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2RollCallReports {
    $endpoint = "/api/v1/rollcallreports"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2IoBoards {
    $endpoint = "/api/v1/ioboards"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Get-Net2Events {
    $endpoint = "/api/v1/events"
    Invoke-Net2ApiCall -Endpoint $endpoint
}

function Remove-Net2ApiToken {
    $body = @{
        "refreshToken" = $Script:RefreshToken
    }
    Invoke-Net2ApiCall -Endpoint "/api/v1/authorization/tokens" -Body $body -Method "Delete"
}