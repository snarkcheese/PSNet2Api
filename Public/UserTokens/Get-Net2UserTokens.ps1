<#
.SYNOPSIS
Returns the tokens assigned to a user

.DESCRIPTION
Long description

.PARAMETER UserId
Parameter description

.PARAMETER TokenId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2UserTokens {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(Mandatory, Position = 0)]
        [int]$UserId,

        [Parameter(ParameterSetName = "Single")]
        [int]$TokenId
    )
    $endpoint = "/api/v1/users/{0}/tokens" -f $UserId
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $TokenId
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}