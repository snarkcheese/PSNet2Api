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