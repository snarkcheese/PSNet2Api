Powershell Module for interacting with the Paxton Net2 via the rest api. Module only supports working with a single server at a time.

Basic Usage:
```
Import-Module PSNet2Api

$Server = "Server Address"
$Credential = [pscredential]::new(
    "Username",
    (ConvertTo-SecureString -string "Password" -AsPlainText -Force)
)
$ClientId = "Client ID for API here"
$Connection = Connect-Net2Api -ComputerName $Server -ClientId $ClientId -Credential $Credential

Get-Net2Doors
```