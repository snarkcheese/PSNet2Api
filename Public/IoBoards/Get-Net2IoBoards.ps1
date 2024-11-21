<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER IoBoardId
Parameter description

.PARAMETER IoInfo
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-Net2IoBoards {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "Single")]
        [int]$IoBoardId,

        [Parameter(ParameterSetName = "Single")]
        [ValidateSet("Inputs", "Outputs", "Detailed")]
        [int]$IoInfo
    )
    $endpoint = "/api/v1/ioboards"
    if ($PSCmdlet.ParameterSetName -eq "Single") {
        $endpoint = "{0}/{1}" -f $endpoint, $IoBoardId
        switch ($IoInfo) {
            "Inputs" {
                $endpoint = "{0}/inputs" -f $endpoint
                break
            }
            "Outputs" {
                $endpoint = "{0}/outputs" -f $endpoint
                break
            }
            "Detailed" {
                $endpoint = "{0}/detail" -f $endpoint
                break
            }
            default { break }
        }
    }
    Invoke-Net2ApiCall -Endpoint $endpoint
}