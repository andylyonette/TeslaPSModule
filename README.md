# Tesla PowerShell Module
Interact with your Tesla Model S, X or 3 using PowerShell over the Tesla customer API

## Prerequisites
PowerShell 3.0



## Installation
1. Create folder C:\Users\<username>\Documents\WindowsPowerShell\Modules\Tesla
2. Copy Tesla.ps1 and Tesla.psm1 into that directory.
3. Unblock Tesla.ps1 and Tesla.psm1 by right clicking each file and going to properties or using the cmdlet 'Unlock-File'



## Usage
### Connecting to Tesla
In order to retrieve data and send commands to a Tesla vehicle each time you open a new PowerShell session you first need to tet a token from the Tesla customer API OATH service and get the ID used by the API to identify the vehicle you wish to affect.  This can be achieved with the following commands:

`$token = Get-TeslaToken -Credential (Get-Credential)`

`$vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -like "*123456"}`


If you only have one active Tesla vehicle in your MyTesla account you just can use :

`$token = Get-TeslaToken -Credential (Get-Credential)`

`$vehicle = Get-TeslaVehicles -Token $token`


### Vehicle Operations
All vehicle cmdlets require that the -vehicle and -token paremters are specified, use the $vehicle and $token varibles created above.  Eg. `Invoke-TeslaVehicleLightsFlash -Vehicle $vehicle -Token $token`
Pipeline support is implemented in each of the cmdlets so you could also use:
`@{vehicle=$vehicle;token=$token} | Invoke-TeslaVehicleLightsFlash`


### Cmdlet Reference
The following cmdlets are available in the module complete with full comment-based help.  In order to find out more about any cmdlet use the Get-Help cmdlet.

Eg. `Get-Help Set-TeslaVehicleClimateControlTemprature -Detailed` or `Get-Help Set-TeslaVehicleClimateControlTemprature -Examples`


#### Vehicle cmdlets
* Close-TeslaVehicleChargePortDoor
* Close-TeslaVehicleSunroof
* Disable-TeslaVehicleValetMode
* Enable-TeslaVehicleRemoteStart
* Enable-TeslaVehicleValetMode
* Get-TeslaVehicleSummary
* Invoke-TeslaVehicleCommand
* Invoke-TeslaVehicleHornHonk
* Invoke-TeslaVehicleLightsFlash
* Invoke-TeslaVehicleWakeUp
* Lock-TeslaVehicle
* Open-TeslaVehicleChargePortDoor
* Open-TeslaVehicleSunroofVent
* Remove-TeslaVehicleValetModePin
* Set-TeslaVehicleChargeLimit
* Set-TeslaVehicleClimateControlTemperature
* Start-TeslaVehicleCharging
* Start-TeslaVehicleClimateControl
* Stop-TeslaVehicleCharging
* Stop-TeslaVehicleClimateControl
* Unlock-TeslaVehicle

#### Initialisation cmdlets
* Get-TeslaToken
* Get-TeslaVehicles

#### Utility cmdlets
* ConvertFrom-TeslaTimeStamp



## Limitations
* Only vehicle commands implemented
* Testing only performed against an EU-spec Model S P100D (HW2) built October 2016 running firmware 2017.36.x
* Logic for Celsius/Fahrenheit conversion is implemented setting inside temperature but not tested on a non-EU vehicle
* Cmdlets exist only for known vehicle commands, however `Invoke-TeslaVehicleCommand` can be used to execute additional API commands as they are discovered



## Next Steps
* Test with other vehicles, including Model 3
* Add PowerWall support



## Notes
Inspiration drawn from:
* http://docs.timdorr.apiary.io/#reference/vehicle-commands/set-temperature/set-temperature
* https://github.com/JonnMsft/TeslaPSModule

**Suggestions, improvements and fixes are all welcome!**
