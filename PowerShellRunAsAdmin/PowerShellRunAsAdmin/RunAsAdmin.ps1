
[CmdletBinding()]
Param(
	[switch] $Elevate = $true
)

Function Test-IsAdmin {
 <#
    .Synopsis
        Tests if the user is an administrator
    .Description
        Returns true if a user is an administrator, false if the user is not an administrator       
    .Example
        Test-IsAdmin
    #>
 $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
 $principal = New-Object Security.Principal.WindowsPrincipal $identity
 $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}



if ($false) {
$PSScriptRoot # PS 3.0 and up
$PSCommandPath # PS 3.0 and up
$script:MyInvocation.MyCommand.Definition
$script:MyInvocation.MyCommand.Path
}

$scriptPath = $PSCommandPath
$scriptDir = $PSScriptRoot
if (-not (Test-IsAdmin) -and $Elevate -and (Test-Path $scriptPath)) {
	Write-Verbose "Elevating..."

	$args = "${scriptPath}"

	# Avoid recursion with -Elevate:$false
	$args += " -Elevate:`$false"

	$myVerbose = ($PSBoundParameters['Verbose'] -eq $true)
	if ($myVerbose) {
		$args += " -Verbose"
	}

	if ($false) {
		# Use "-noexit" if you want the powershell.exe to hang around
		$args += " -noexit" 
	}
	#Write-Host "powershell.exe ${args}"
	$oShell = New-Object -ComObject Shell.Application
	$oShell.ShellExecute("powershell.exe", $args, $scriptDir, "runas")
	return
} else {
	Write-Verbose "Not elevating."
	if ((Test-IsAdmin)) {
		Write-Verbose "Success! We are an admin!"
		Write-Host "Doing stuff"
	} else {
		Write-Error "Failure!  We are not an admin!"
	}
	Write-Host $PSBoundParameters
	Start-Sleep 5
	Write-Verbose "Done sleeping"
}
