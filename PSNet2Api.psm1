$Script:ComputerName = ""
$Script:Port = ""
$Script:BaseUri = ""
$Script:BearerToken = ""
$Script:RefreshToken = ""
# $Script:ClientId = ""

function Invoke-Net2ApiCall {
    param(
        $Endpoint,
        $Body
    )
    $headers = @{
        Authorization = "Bearer $($Script:BearerToken)"
        "Content-type" = "application/json"
    }
}

function Connect-Net2Api {
    [PSCmdletBinding(ParameterSetName = "Connect")]
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
        "client_id"  = "ab78a3ca-4541-4c27-8462-b15bd9b8a839"
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