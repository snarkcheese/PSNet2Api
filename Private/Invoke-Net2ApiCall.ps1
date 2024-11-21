<#
.SYNOPSIS
Makes a rest API call to the specified endpoint

.DESCRIPTION
Calls Invoke-RestMethod with appropriate headers and params. Automatically adds common headers.

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