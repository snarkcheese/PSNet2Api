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
    }
    $params = @{
        "Headers" = $headers
        "Method"  = $Method
        "Uri"     = "{0}{1}" -f $Script:BaseUri, $Endpoint
    }
    if ($Body) {
        $params.Add("Body", $Body)
    }
    Invoke-RestMethod @params
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

function Get-Net2AccessLevels {
    [CmdletBinding()]
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