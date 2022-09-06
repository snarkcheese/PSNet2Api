function Add-Net2User {
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$FirstName,
        [parameter(Mandatory, Position = 1)]
        [string]$LastName,

        [string]$MiddleName,
        [string]$ExpiryDate,
        [string]$ActivationDate,
        [string]$PIN,
        [string]$Telephone,
        [string]$Extension,
        [string]$Fax,
        [bool]$IsAntiPassbackUser = $false,
        [bool]$IsAlarmUser = $false,
        [bool]$IsLockdownExempt = $false,
        [bool]$HasImage = $false,
        [System.Object[]]$CustomFields,
        [System.Object]$PermissionSet
    )
    $obj = @{
        'firstName'          = $FirstName
        'lastName'           = $LastName
        "isAntiPassbackUser" = $IsAntiPassbackUser
        "isAlarmUser"        = $IsAlarmUser
        "isLockdownExempt"   = $IsLockdownExempt
        "hasImage"           = $HasImage
    }
    if ($PSBoundParameters.ContainsKey('MiddleName')) {
        $obj.Add('middleName', $MiddleName)
    }
    if ($PSBoundParameters.ContainsKey('ExpiryDate')) {
        $obj.Add('expiryDate', $ExpiryDate)
    }
    if ($PSBoundParameters.ContainsKey('ActivationDate')) {
        $obj.Add('activateDate', $ActivationDate)
    }
    if ($PSBoundParameters.ContainsKey('PIN')) {
        $obj.Add('pin', $PIN)
    }
    if ($PSBoundParameters.ContainsKey('Telephone')) {
        $obj.Add('telephone', $Telephone)
    }
    if ($PSBoundParameters.ContainsKey('Extension')) {
        $obj.Add('extension', $Extension)
    }
    if ($PSBoundParameters.ContainsKey('Fax')) {
        $obj.Add('fax', $Fax)
    }
    if ($PSBoundParameters.ContainsKey('CustomFields')) {
        $obj.Add('customFields', $CustomFields)
    }
    if ($PSBoundParameters.ContainsKey('PermissionSet')) {
        $obj.Add('doorAccessPermissionSet', $PermissionSet)
    }
    $body = ConvertTo-Json -InputObject $obj
    Invoke-Net2ApiCall -Endpoint "/api/v1/users" -Method Post -Body $body
}