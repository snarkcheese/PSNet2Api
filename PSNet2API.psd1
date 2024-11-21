#
# Module manifest for module 'PSNet2API'
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '0.0.2'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '8dc87b7a-2497-450e-8473-464b0b445874'

# Author of this module
Author = 'Snarkcheese'

# Company or vendor of this module
# CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) Snarkcheese. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module provides a powershell wrapper around the Net2 Rest API'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    "Get-Net2AccessLevels","Get-Net2AreaGroups","Get-Net2Areas",
    "New-Net2AccessLevel","Remove-Net2AccessLevel","Set-Net2AccessLevel",
    "Connect-Net2Api","Get-Net2Operators","Remove-Net2ApiToken",
    "Invoke-Net2CloseDoor","Invoke-Net2HoldOpenDoor","Invoke-Net2OpenDoor",
    "Invoke-Net2ResetAntipassback","Invoke-Net2DatabaseQuery","Add-Net2Department",
    "Get-Net2Departments","Remove-Net2Department","Set-Net2Department",
    "Get-Net2DoorGroups","Get-Net2Doors","Get-Net2Events",
    "Get-Net2LatestUnknownTokens","Set-Net2AlarmAcknowledged","Get-Net2IoBoards",
    "Get-Net2RollCallReportItems","Get-Net2RollCallReports","Get-Net2TimezoneDays",
    "Get-Net2Timezones","Get-Net2UserDoorPermissionSet","New-Net2UserDoorPermission",
    "New-Net2UserDoorPermissionSet","Add-Net2User","Get-Net2UserCustomFieldNames",
    "Get-Net2UserDepartments","Get-Net2UserImage","Get-Net2Users",
    "New-Net2UserCustomField","Remove-Net2Users","Set-Net2UserDepartment",
    "Add-Net2UserToken","Get-Net2TokenTypes","Get-Net2UserTokens",
    "New-Net2Token","Remove-Net2UserToken","Set-Net2UserToken",
    "Get-Net2ApiVersions","Get-Net2ServerFeatures","Get-Net2ServerProperties"
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

