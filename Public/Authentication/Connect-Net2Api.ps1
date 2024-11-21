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

        [string]$Port,
        [switch]$UseSSL,

        [Parameter(ParameterSetName = "Refresh", Mandatory)]
        [switch]$Refresh
    )
    if ($PSCmdlet.ParameterSetName -eq "Connect") {
        $Script:ComputerName = $ComputerName
        $proto = if ($UseSSL) { 'https' } else { 'http' }
        if (!$PSBoundParameters.ContainsKey('Port')) { $Port = if ($UseSSL) { '8443' } else { '8080' } }
        $Script:Port = $Port
        $Script:BaseUri = "{0}://{1}:{2}" -f $proto, $ComputerName, $Port
        $Script:ClientId = $ClientId
        $body = @{
            "client_id"  = $ClientId
            "username"   = $Credential.UserName
            "password"   = $Credential.GetNetworkCredential().Password
            "grant_type" = "password"
            "scope"      = "offline_access"
        }
    }
    else {
        $body = @{
            "client_id"     = $Script:ClientId
            "refresh_token" = $Script:RefreshToken
            "scope"         = "offline_access"
            "grant_type"    = "refresh_token"
        }
    }
    $endpoint = "$($Script:BaseUri)/api/v1/authorization/tokens"
    $payload = $body | ConvertTo-Json
    $r = Invoke-RestMethod -Method Post -Uri $endpoint -body $payload -ContentType "application/json"
    $Script:BearerToken = $r.access_token
    $Script:RefreshToken = $r.refresh_token
    Write-Output $r
}