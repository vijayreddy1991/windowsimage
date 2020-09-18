$ErrorActionPreference = "Stop"

# Install choco
Set-ExecutionPolicy Bypass -Scope Process -Force
$env:chocolateyUseWindowsCompression = 'true'
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

choco config set --name="'stopOnFirstPackageFailure'" --value="'true'"

function Write-PackageInstall($package) {
  Write-Output ""
  Write-Output "----------------------------------------------"
  Write-Output "Installing $package"
  Write-Output "----------------------------------------------"
  Write-Output ""
}
function Install-ChocoPackage($package, $options) {
  Write-PackageInstall $package
  choco install -y $package $options
  if ($LastExitCode -ne 0) {
     throw 'Error installing with Chocolatey'
  }
}

# Installing Python 3
Install-ChocoPackage python3

refreshenv

# Installing Git
$GIT_VERSION = "2.27.0"
Install-ChocoPackage  -package git -options --version=$GIT_VERSION
Update-SessionEnvironment


