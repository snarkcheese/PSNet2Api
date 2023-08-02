# PSNet2API

Powershell Module for interacting with the Paxton Net2 via the rest api. Module only supports working with a single server at a time.

### Basic Usage:
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
## Net2 API
Taken from the Net2 API webpage

In order to use the API a licence is required to be granted from Paxton Access.

The API runs on a Nginx service (Net2Nginx). From Net2 6.6 SR5 this service has been disabled by default. This service can be controlled via the security tab in the Net2 Configuration Utility.

### Licensing
You can request a licence by contacting the paxton support department with the following information:
- Company Name
- Contact Name
- Contact Email Address
- Contact Phone Number
- Type of planned Integration (Visitor Management, Time & Attendance etc.)

If the request is via email then please include the following in the subject "Request for Net2 API licence". Pending approval, you will then be sent a licence file from the integrations manager.

You must not rename the file or edit the contents as this will cause the licence to be invalidated.

This file will need to be placed in this location:
```
[INSTALL_LOCATION]\Access Control\ApiLicences
```
The default location on Windows 10 is "C:\Program Files (x86)\Paxton Access\Access Control\ApiLicences".

Once the file has been placed into this location the LocalAPI needs to be enabled. The LocalAPI is disabled by default. Open the Net2 Configuration Utility, Login, and click on security and then Ok. You will be asked to restart the Net2 services. Once this has been completed the Net2 Local API is now ready to use.

After placing the file in this location, you must restart the Net2 Service to enable the ClientID.

Note, the name of the file is your ClientID which is used for authentication