$Script:ClientId = ""
$Script:ComputerName = ""
$Script:Port = 8080
$Script:BaseUri = ""
$Script:BearerToken = ""
$Script:RefreshToken = ""


$Private = Get-ChildItem "$PSScriptRoot\Private\*.ps1" -Recurse -File
$Public = Get-ChildItem "$PSScriptRoot\Public\*.ps1" -Recurse -File

foreach ($import in $Private) {
    . $import.FullName
}

foreach ($import in $Public) {
    . $import.FullName
}

Export-ModuleMember -Function $Public.BaseName