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

        [string]$Port = "8080",
        [swicth]$UseSSL
    )
    $proto = if ($UseSSL) { 'https' } else { 'http' }
    $uri = "{0}://{1}:{2}/api/v1/operators" -f $proto, $ComputerName, $Port
    Invoke-RestMethod -Uri $uri
}