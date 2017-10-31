<<<<<<< HEAD:Tesla/Tesla.psm1
﻿function Invoke-TeslaVehicleCommand {
    <#
        .SYNOPSIS
        Executes a command against a Tesla vehicle.
      
        .DESCRIPTION
        Executes a command against a Tesla vehicle via the Tesla customer API.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER Command
        A valid MyTesla API vehicle command.

        .PARAMETER Body
        Valid MyTesla API vehicle command parameters in json format.

        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Execute command 'charge_port_door_close' against vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleCommand -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -Command charge_port_door_close
      
        .EXAMPLE
        Execute command 'set_temps' with parameters 'driver_temp' and 'passenger_temp' for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_temps -Body '{"driver_temp":18.5,"passenger_temp":20}"
      
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,Mandatory,ValueFromPipeline)]
        [string]$Command,

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$Body,

        [Parameter(Position=4,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }
    
        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Executing vehicle command"
        if ($Body) {
            $TeslaCommand = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/command/$Command" -Method Post -Headers $Headers -Body $Body -ContentType 'application/json'| Select-Object -ExpandProperty Response
        } else {
            $TeslaCommand = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/command/$Command" -Method Post -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        }

        Write-Verbose $TeslaCommand
        if ($TeslaCommand.Result -eq $true) {
            Write-Output $true
        } else {
            Write-Error -Message $TeslaCommand.reason
        }
            
    } #PROCESS

    END {

    } #END
}

function Close-TeslaVehicleChargePortDoor {
    <#
        .SYNOPSIS
        Closes the charge port door on a Tesla vehicle.
      
        .DESCRIPTION
        Closes the charge port door on a compatible Tesla vehicle (built after September 2016).  If the charge port door is already closed or a charge cable is plugged in the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following closes the charge port door on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Close-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following closes the charge port door on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Close-TeslaVehicleChargePortDoor -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following closes the charge port door on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Close-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_port_door_close'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_port_door_close
          
    } #PROCESS

    END {

    } #END
}

function Close-TeslaVehicleSunroof {
    <#
        .SYNOPSIS
        Closes the sunroof on a Tesla vehicle.
      
        .DESCRIPTION
        Closes the sunroof on a compatible Tesla vehicle (Model S with panoramic roof).  If the sunroof is already closed the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following closes the sunroof on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Close-TeslaVehicleSunroof -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following closes the sunroof on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Close-TeslaVehicleSunroof -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following closes the sunroof on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Close-TeslaVehicleSunroof -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'sun_roof_control' with paraetmers 'state'=close"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command sun_roof_control -Body "{`"state`":`"close`"}"
          
    } #PROCESS

    END {

    } #END
}

function ConvertFrom-TeslaTimeStamp {
    <#
        .SYNOPSIS
        Converts a Tesla timestamp to a human-readable form.
      
        .DESCRIPTION
        Converts the timestamp property value of the various states (eg. 'climate_state', 'vehicle_state') returned from Tesla API data requests.

        .PARAMETER Timestamp
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .EXAMPLE
        Return a [datetime] object for Tesla timestamp 1508766510148''
    
        ConvertFrom-TeslaTimeStamp -Timestamp 1508766510148
      
        .EXAMPLE
        Return a [datetime] object for the timestamp property of the vehicle state data for vehicle with VIN '5YJSB7E46GF123456'
    
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        $vehicleData = Get-TeslaVehicleummary -Vehicle $vehicle -Token $token
        $vehicleData.vehicle_state | ConvertFrom-TeslaTimeStamp
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [double]$Timestamp
    )

    BEGIN {

    } #BEGIN

    PROCESS {
    
        $TimeOrigin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        $TimeOrigin.AddSeconds($Timestamp / 1000)

    } #PROCESS

    END {

    } #END
}

function Disable-TeslaVehicleValetMode {
    <#
        .SYNOPSIS
        Turns off valet mode for a Tesla vehicle.
      
        .DESCRIPTION
        Turns off valet mode for a Tesla vehicle.  If valet mode is already disabled the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following turns off valet mode for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Disable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following turns off valet mode for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Disable-TeslaVehicleValetMode -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following turns off valet mode for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Disable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'set_valet_mode' with paraetmers 'on'=$false"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_valet_mode -Body "{`"on`":`"false`"}"
          
    } #PROCESS

    END {

    } #END
}

function Enable-TeslaVehicleRemoteStart {
    <#
        .SYNOPSIS
        Turns on remote start for for a Tesla vehicle.
      
        .DESCRIPTION
        Turns on remote start for 2 minutes  for a Tesla vehicle.  If remote start is already enabled the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.

        .PARAMETER Credential
        A valid MyTesla password for the vehicle (the username does not have to match the email address of the MyTesla account, only the password is used).
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following turns on remote start for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234' and prompting for MyTesla credentials.
    
        Enable-TeslaVehicleRemoteStart -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -Credential (Get-Credential)
      
        .EXAMPLE
        The following turns on remote start for vehicle with VIN '1232456'.
        
        $credential = Get-credential
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Enable-TeslaVehicleRemoteStart -Vehicle $vehicle -Token $token -Credential $credential
      
        .EXAMPLE
        The following turns on remote start for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Enable-TeslaVehicleRemoteStart -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api -Credential (Get-Credential)
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,Mandatory,ValueFromPipeline)]
        [PSCredential]$Credential,

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'remote_start_drive' with paraetmers 'password'=<NotDisplayed>"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command remote_start_drive -Body "{`"password`":`"$($Credential.GetNetworkCredential().password)`"}"
          
    } #PROCESS

    END {

    } #END
}

function Enable-TeslaVehicleValetMode {
    <#
        .SYNOPSIS
        Turns on valet mode for a Tesla vehicle.
      
        .DESCRIPTION
        Turns onn valet mode for a Tesla vehicle.  If valet mode is already enabled the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER Pin
        A 4-digit numeric pin to use to disable valet mode from the vehicle dashboard.

        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following turns on valet mode for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Enable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following turns on valet mode with pin '1234' for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Enable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -Pin 1234
      
        .EXAMPLE
        The following turns on valet mode for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Enable-TeslaVehicleValetMode -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following turns on valet mode for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Enable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [ValidateScript({
            if ([int]$_ -ge 0 -and [int]$_ -le 9999) {
                $True
            } else {
                throw "$_ is not between '0000' and '9999'."
            }
        })]
        [string]$Pin,

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($pin) {

            Write-Verbose "Executing 'set_valet_mode' with paraetmers 'on'=$true, 'password'=$pin"
            Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_valet_mode -Body "{`"on`":`"true`",`"password`":`"$pin`"}"

        } else {

            Write-Verbose "Executing 'set_valet_mode' with paraetmers 'on'=$true"
            Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_valet_mode-Body "{`"on`":`"true`"}"

        }
          
    } #PROCESS

    END {

    } #END
}

function Get-TeslaDestinationCharger {
    <#
        .SYNOPSIS
        Gets all Tesla Destination Chargers in a country.
      
        .DESCRIPTION
        Gets all Tesla Destination Chargers in a country from the Tesla website FindUs API.

        .PARAMETER Country
        The country in which to search.
                
        .PARAMETER TeslaSites
        Specify cached data from the Tesla FindUs API instead of fetching live data from ''https://www.tesla.com/js/all-locations?'

        .EXAMPLE
        The following gets all Tesla Destination Charger sites in the UK
    
        Get-TeslaDestinationCharger -Country "United Kingdom"
            
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [ValidateSet("Andorra","Australia","Austria","Belgium","Bosnia","Bosnia and Herzegovina","Bulgaria","Canada","China","Croatia","Czech Republic","Denmark","Estonia","Finland","France","Germany","Gibraltar","Greece","Hong Kong","Hungary","Ireland","Italy","Japan","Jordan","
Latvia","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Mexico","Moldova","Netherlands","New Zealand","Norway","Poland","Portugal","Romania","Russia","San Marino","Scotland","Serbia","Slovakia","Slovenia","South Korea","Spain","Sweden","Switzer
land","Taiwan","Turkey","Ukraine","United Arab Emirates","United Kingdom","United States")]
        [string]$Country,

        [Parameter(Position=1,ValueFromPipeline)]
        [PSCustomObject]$TeslaSites
    )

    BEGIN {
        if (!$TeslaSites) {
            $TeslaSites = Invoke-RestMethod -Uri "https://www.tesla.com/js/all-locations?"
        }
    } #BEGIN
    
    PROCESS {
        $TeslaSites | Where-Object {$_.country -eq $Country -and $_.location_type -contains "destination charger"}
    } #PROCESS

    END {

    } #END
}

function Get-TeslaServiceCenter {
    <#
        .SYNOPSIS
        Gets all Tesla Service Centers in a country.
      
        .DESCRIPTION
        Gets all Tesla Service Centers in a country from the Tesla website FindUs API.

        .PARAMETER Country
        The country in which to search.
                
        .PARAMETER TeslaSites
        Specify cached data from the Tesla FindUs API instead of fetching live data from ''https://www.tesla.com/js/all-locations?'

        .EXAMPLE
        The following gets all Tesla SuperCharger sites in the UK
    
        Get-TeslaServiceCenter -Country "United Kingdom"
            
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [ValidateSet("Andorra","Australia","Austria","Belgium","Bosnia","Bosnia and Herzegovina","Bulgaria","Canada","China","Croatia","Czech Republic","Denmark","Estonia","Finland","France","Germany","Gibraltar","Greece","Hong Kong","Hungary","Ireland","Italy","Japan","Jordan","
Latvia","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Mexico","Moldova","Netherlands","New Zealand","Norway","Poland","Portugal","Romania","Russia","San Marino","Scotland","Serbia","Slovakia","Slovenia","South Korea","Spain","Sweden","Switzer
land","Taiwan","Turkey","Ukraine","United Arab Emirates","United Kingdom","United States")]
        [string]$Country,

        [Parameter(Position=1,ValueFromPipeline)]
        [PSCustomObject]$TeslaSites
    )

    BEGIN {
        if (!$TeslaSites) {
            $TeslaSites = Invoke-RestMethod -Uri "https://www.tesla.com/js/all-locations?"
        }
    } #BEGIN
    
    PROCESS {
        $TeslaSites | Where-Object {$_.country -eq $Country -and $_.location_type -contains "service"}
    } #PROCESS

    END {

    } #END
}

function Get-TeslaSite {
    <#
        .SYNOPSIS
        Gets all Tesla Sites.
      
        .DESCRIPTION
        Gets all Tesla Sites across the world including SuperChargers, Desintation Chargers, Service Centres and Stores.


        .EXAMPLE
        The following gets all Tesla sites
    
        Get-TeslaSite
            
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param()

    BEGIN {

    } #BEGIN
    
    PROCESS {
        Invoke-RestMethod -Uri "https://www.tesla.com/js/all-locations?"
    } #PROCESS

    END {

    } #END
}

function Get-TeslaStore {
    <#
        .SYNOPSIS
        Gets all Tesla Stores in a country.
      
        .DESCRIPTION
        Gets all Tesla Stores in a country from the Tesla website FindUs API.

        .PARAMETER Country
        The country in which to search.
                
        .PARAMETER TeslaSites
        Specify cached data from the Tesla FindUs API instead of fetching live data from ''https://www.tesla.com/js/all-locations?'

        .EXAMPLE
        The following gets all Tesla Stores sites in the UK
    
        Get-TeslaSuperCharger -Country "United Kingdom"
            
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [ValidateSet("Andorra","Australia","Austria","Belgium","Bosnia","Bosnia and Herzegovina","Bulgaria","Canada","China","Croatia","Czech Republic","Denmark","Estonia","Finland","France","Germany","Gibraltar","Greece","Hong Kong","Hungary","Ireland","Italy","Japan","Jordan","
Latvia","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Mexico","Moldova","Netherlands","New Zealand","Norway","Poland","Portugal","Romania","Russia","San Marino","Scotland","Serbia","Slovakia","Slovenia","South Korea","Spain","Sweden","Switzer
land","Taiwan","Turkey","Ukraine","United Arab Emirates","United Kingdom","United States")]
        [string]$Country,

        [Parameter(Position=1,ValueFromPipeline)]
        [PSCustomObject]$TeslaSites
    )

    BEGIN {
        if (!$TeslaSites) {
            $TeslaSites = Invoke-RestMethod -Uri "https://www.tesla.com/js/all-locations?"
        }
    } #BEGIN
    
    PROCESS {
        $TeslaSites | Where-Object {$_.country -eq $Country -and $_.location_type -contains "store"}
    } #PROCESS

    END {

    } #END
}

function Get-TeslaSuperCharger {
    <#
        .SYNOPSIS
        Gets all Tesla SuperChargers in a country.
      
        .DESCRIPTION
        Gets all Tesla SuperChargers in a country from the Tesla website FindUs API.

        .PARAMETER Country
        The country in which to search.
                
        .PARAMETER TeslaSites
        Specify cached data from the Tesla FindUs API instead of fetching live data from ''https://www.tesla.com/js/all-locations?'

        .EXAMPLE
        The following gets all Tesla SuperCharger sites in the UK
    
        Get-TeslaSuperCharger -Country "United Kingdom"
            
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [ValidateSet("Andorra","Australia","Austria","Belgium","Bosnia","Bosnia and Herzegovina","Bulgaria","Canada","China","Croatia","Czech Republic","Denmark","Estonia","Finland","France","Germany","Gibraltar","Greece","Hong Kong","Hungary","Ireland","Italy","Japan","Jordan","
Latvia","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Mexico","Moldova","Netherlands","New Zealand","Norway","Poland","Portugal","Romania","Russia","San Marino","Scotland","Serbia","Slovakia","Slovenia","South Korea","Spain","Sweden","Switzer
land","Taiwan","Turkey","Ukraine","United Arab Emirates","United Kingdom","United States")]
        [string]$Country,

        [Parameter(Position=1,ValueFromPipeline)]
        [PSCustomObject]$TeslaSites
    )

    BEGIN {
        if (!$TeslaSites) {
            $TeslaSites = Invoke-RestMethod -Uri "https://www.tesla.com/js/all-locations?"
        }
    } #BEGIN
    
    PROCESS {
        $TeslaSites | Where-Object {$_.country -eq $Country -and $_.location_type -contains "supercharger"}
    } #PROCESS

    END {

    } #END
}

function Get-TeslaToken {
    <#
        .SYNOPSIS
        Requests a MyTesla token.
      
        .DESCRIPTION
        Requests a MyTesla token from the MyTesla OAUTH provider.

        .PARAMETER Credential
        A valid MyTesla username and password.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/oauth/token' will be used.

        .EXAMPLE
        The following prompts for MyTesla credentials and returns a token
    
        Get-TeslaToken -Credential (Get-Credential)
            
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCredential]$Credential,

        [Parameter(Position=1,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/oauth/token"
    )

    BEGIN {
        $string = "76492d1116743f0423413b16050a5345MgB8AFcATgBuAFcASABCAE8AWQA5AHUAbwArAFoASQBBAEwAOQBLAGwATgAwAHcAPQA9AHwAMQA5ADEAOAA0
AGEAMwBmAGEAMgAzAGUAMAAwAGQAMwAwAGEAMQBhADAAMwBhAGIAYwBlAGUAYwAzADAAMwAxADQANgBjADYAMgAxADkAMwBiADcAOAA3ADQAZQBkADQAMwA5ADkAZQA3A
GUAZQA4AGEAZQAwADIAYQAwADEAYgA5ADkAMwAyAGYAZAA4ADgAMQAxADMAYQA0ADEAOAA3ADAAZABjADIAOQA3AGUAMwA5ADUAMwA4ADIANAA0ADIANwAwAGEAYgBhAG
YAMgA2ADIAZQBjADUANgA1AGYAMAAwADMANwBmADgAOQAwAGEAMABhADAANABlAGYAOAA2ADIAZgA1ADEANwAyADIAZAAxAGEAYQBjADcAYQBiADUAYQBhADUAMgBlADM
AMQA4ADkAYgA4ADMAZgAzADYAZgBlAGUANwA4ADUANQA5ADIAMwBlADIAYwAyADQAMQAxAGYANwBhAGIAZQAwADgAZAA0AGUAZgAzAGYAYQAxADQAMQA5ADYAMQAwADcA
OABiADEAZAA5AGUANwAyADcAZgA0ADkAMABkAGUANwA0AGIANwBhADMAMAA2ADUAOQBiADQAOAA5AGYAOABiAGEAZABiADkAZgBhAGYAZQA0ADQAMQA1AGYANwBkAGQAN
gBlAGMAYQA5ADUANAA3ADEAMwAxADQAYwAxADQAMgA0AGMAOABjADAAZABiADgANwA4ADUAMABmADkANgBiADIAYQA5AGIAOQA3ADkAZQBmADQAMABiADIAYQAxAGEAYQ
BlADEAZgBhAGMANgAzAGEAMgA0ADkAYgA3AGMAMgBlAGIAZgA3ADAAZQA2AGUAOABiADgAZAAxADAAOAA4AGQAMgA4ADEAMwAxAGIAMwAyAGEAMwBjADMAOQAyAGIAMgA
wADYAYwBkADkANgBkADUAYQA3AGUAMgBiAGIANAAwADUANAA3ADQAZAA0AGEAYwA0ADEANwBlADYAOABkADgANgA0AGYANQBhADIAZAA5AGYAZQAzAGEANQBmADAAZQA3
ADQAZgA4AGEAZQA4AGUANwAzAGYAYwAyAGQAMgA0AGUAZgBkAGMAMQBhADkANAA1ADQAMwAyAGEAYQBkAGEAYgAwADAANgAxADAAMwBkADkAYwBjAGUAZAA2ADkAZQAzA
DcAMwBiAGMAMQA0AGIAMAA3ADcAMgBiAGIAOQA2AGQANQBlADcANwBiADYAYQA2ADMAMAA1ADQANQAyADcANQA3ADEAMABlADUANQAzAGMAZgBjADUAZAA1ADQAMQA5AG
IANQA0ADIAYgA4ADQANwAxADgAZQA1AGMAMwBmAGMAMQAzADIAMAAwADQAYgBkADAAMgA0AGQANgA0AGMAOABmAGYAMgAyAGMAOAAzADcANgA3AGIAMgBiAGYAYwBjADQ
ANQA5AGQAYgA2AGQAYgA="
        [byte[]]$key = ('236 231 222 136 19 9 157 113 158 51 236 240 116 17 176 100 91 179 20 162 238 103 10 192 113 251 135 59 95 82 109 114'.Split(' ')) -as [byte[]]
        $ss = ConvertTo-SecureString -String $string -Key $key
        $ClientCreds = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss))
    } #BEGIN

    PROCESS {
    
        $Body = @{
            'grant_type' = 'password'
            'client_id' = ($ClientCreds.Split(',')[0])
            'client_secret' = ($ClientCreds.Split(',')[1])
            'email' = $Credential.UserName
            'password' = $Credential.GetNetworkCredential().password
            }
        
        Invoke-RestMethod -Uri $ApiUri -Method Post -Body $Body
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicle {
    <#
        .SYNOPSIS
        Lists all Tesla vehicles.
      
        .DESCRIPTION
        Lists all Tesla vehicles within a MyTesla account.

        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following lists all Tesla vehicles using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicle -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following looks for a vehicle with VIN '5YJSB7E46GF123456'
        
        $token = Get-TeslaToken
        Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
            
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=1,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }
    
        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicles"
        $dataVehicles = Invoke-RestMethod -Uri "$ApiUri/vehicles/" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        foreach ($dataVehicle in $dataVehicles) {
            $dataVehicle.tokens = $Vehicle.tokens -join ","
        }

        Write-Verbose "Generating output..."
        $dataVehicles
    
    } #PROCESS

    END {

    } #END
}
New-Alias -Name Get-TeslaVehicles -Value Get-TeslaVehicle

function Get-TeslaVehicleDetail {
    <#
        .SYNOPSIS
        Retrieves the state of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the state of a Tesla vehicle.  Further detail is availabe under the properties 'gui_settings', 'cliemate_state', 'vehicle_state', 'charge_state' and 'drive_state'

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ChargeState
        A boolean to specifiy if 'charge_state' shoulwd be returned, by default this is set to $true

        .PARAMETER ClimateState
        A boolean to specifiy if 'climate_state' shoulwd be returned, by default this is set to $true

        .PARAMETER DriveState
        A boolean to specifiy if 'drive_state' shoulwd be returned, by default this is set to $true

        .PARAMETER GuiSettings
        A boolean to specifiy if 'gui_settings' shoulwd be returned, by default this is set to $true

        .PARAMETER VehicleConfig
        A boolean to specifiy if 'vehicle_config' shoulwd be returned, by default this is set to $true

        .PARAMETER VehicleState
        A boolean to specifiy if 'vehicle_state' shoulwd be returned, by default this is set to $true

       .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets all available states for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleDetail -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets all available states for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleDetail -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets all available states for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleDetail -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [bool]$ChargeState = $true,

        [Parameter(Position=3,ValueFromPipeline)]
        [bool]$ClimateState = $true,

        [Parameter(Position=4,ValueFromPipeline)]
        [bool]$DriveState = $true,

        [Parameter(Position=5,ValueFromPipeline)]
        [bool]$GuiSettings = $true,

        [Parameter(Position=6,ValueFromPipeline)]
        [bool]$VehicleConfig = $true,

        [Parameter(Position=7,ValueFromPipeline)]
        [bool]$VehicleState = $true,

        [Parameter(Position=8,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        $UriSuffix = ""
        if ($ChargeState) {$UriSuffix += "&charge_state"}
        if ($ClimateSate) {$UriSuffix += "&climate_state"}
        if ($DriveState) {$UriSuffix += "&drive_state"}
        if ($GuiSettings) {$UriSuffix += "&gui_settings"}
        if ($VehicleConfig) {$UriSuffix += "&vehicle_config"}
        if ($VehicleState) {$UriSuffix += "&vehicle_state"}

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary$UriSuffix" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary
    
    } #PROCESS

    END {

    } #END
}
New-Alias -Name Get-TeslaVehicleSummary -Value Get-TeslaVehicleDetail

function Get-TeslaVehicleChargeState {
    <#
        .SYNOPSIS
        Retrieves the charge state of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the charge state of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets charge state for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleChargeState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets charge state for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleChargeState -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets charge state for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleDetail -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&charge_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary.charge_state
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleClimateState {
    <#
        .SYNOPSIS
        Retrieves the climate state of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the climate state of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets climate state for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleClimateState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets climate state for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleClimateState -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets climate state for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleClimateState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&climate_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary.climate_state
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleDriveState {
    <#
        .SYNOPSIS
        Retrieves the drive state of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the drive state of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets drive state for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleDriveState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets drive state for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleDriveState -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets drive state for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleDriveState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&drive_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary.drive_state
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleGuiSettings {
    <#
        .SYNOPSIS
        Retrieves the GUI settings of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the GUI settings of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets GUI settings for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleGuiSettings -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets GUI settings for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleGuiSettings -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets GUI settings for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleGuiSettings -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&gui_settings" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary.gui_settings
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleImage {
    <#
        .SYNOPSIS
        Retrieves the image of the Tesla vehicle from the online configurator
      
        .DESCRIPTION
        Retrieves the image of the Tesla vehicle from the online configurator using the options codes available from the API

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER ImageView
        The angle of the image, choices are 3QTR, REAR, SIDE, SEAT and MARK.
                
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ImageWidth
        An integer in the range of 10 to 999999 denoting how many pixels wide the image is.
                
        .PARAMETER Path
        The path of the downloaoded image.
                
        .EXAMPLE
        Gets vehicle 3QTR image for vehicle with VIN '1232456' and returns base64 encoding.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleImage -Vehicle $vehicle -ImageView 3QTR -Token $token -Path C:\Temp\MyTesla3QTR.jpg
            
        .LINK
        https://github.com/andylyonette/TeslaPSModule
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [ValidateSet("3QTR","SIDE","REAR","SEAT","BADGE")]
        [string]$ImageView,

        [Parameter(Position=2,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=3,ValueFromPipeline)]
        [ValidateRange(10,999999)]
        [int]$ImageWidth = 1000,

        [Parameter(Position=4,Mandatory,ValueFromPipeline)]
        [string]$Path
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle detail"
        $VehicleDetail = Get-TeslaVehicleDetail -Vehicle $Vehicle -Token $Token

        switch ($VehicleDetail.option_codes.Split(",") | Select-Object -First 1) {
            "MDLS" {
                $Model = "ms"
            };
            "MDLX" {
                $Model = "mx"
            };
            "MDL3" {
                $Model = "m3"
            }
        }

        if ($ImageView -eq "BADGE") {
            $badge = $VehicleDetail.vehicle_config.trim_badging
	        if ([bool]$VehicleDetail.vehicle_config.has_ludicrous_mode) {$badge += "l"}
	        $imageUri = "https://www.tesla.com/sites/all/modules/custom/tesla_configurator/images/web/battery/ui_option_battery_$badge.png?20160623"
        } else {
	        $imageUri = "https://www.tesla.com/configurator/compositor/?model=$Model&view=STUD_$ImageView&size=$ImageSize&options=$($VehicleDetail.option_codes)&bkba_opt=1"
	    }

        $wc = New-Object System.Net.WebClient
        try {
            $wc.DownloadFile($imageUri,$Path)
            $true
        } catch {
            Write-Error $Error[0]
            $false
        }
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleLocation {
    <#
        .SYNOPSIS
        Retrieves the location data of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the location data of a Tesla vehicle and provides address and map location URIs using Google services.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets vehicle state for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleLocation -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets vehicle state for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleLocation -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets vehicle state for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleLocation -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&drive_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        
        $latitude = $VehicleSummary.drive_state.latitude
	    $longitude = $VehicleSummary.drive_state.longitude

	    $response = Invoke-WebRequest -Uri "http://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&sensor=true"
	    $address = ConvertFrom-Json $response.Content | Select-Object -ExpandProperty results| Select-Object -First 1 | Select-Object -ExpandProperty formatted_address

        [PSCustomObject] @{
            longitude = $VehicleSummary.drive_state.longitude
            latitude = $VehicleSummary.drive_state.latitude
            address = $address
            map = "https://www.google.com/maps/place/51%C2%B026'36.0%22N+1%C2%B001'21.4%22W/@$latitude,$longitude,620m/data=!3m2!1e3!4b1!4m5!3m4!1s0x0:0x0!8m2!3d51.443329!4d-1.022601"
        }
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleConfig {
    <#
        .SYNOPSIS
        Retrieves the vehicle config of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the vehicle config of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets vehicle config for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleConfig -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets vehicle config for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleConfig -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets vehicle config for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleConfig -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&vehicle_config" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary.vehicle_config
    
    } #PROCESS

    END {

    } #END
}

function Get-TeslaVehicleState {
    <#
        .SYNOPSIS
        Retrieves the vehicle state of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the vehicle state of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets vehicle state for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets vehicle state for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleState -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets vehicle state for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleState -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers =  @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&vehicle_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary.vehicle_state
    
    } #PROCESS

    END {

    } #END
}

function Invoke-TeslaVehicleHorn {
    <#
        .SYNOPSIS
        Honks the horn of a Tesla vehicle.
      
        .DESCRIPTION
        Executes a short honk of the horn for a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following honks the horn for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleHorn -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following honks the horn for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleHorn -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following honks the horn for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Invoke-TeslaVehicleHorn -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'honk_horn'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command honk_horn
          
    } #PROCESS

    END {

    } #END
}

function Invoke-TeslaVehicleLightsFlash {
    <#
        .SYNOPSIS
        Flashes the lights of a Tesla vehicle.
      
        .DESCRIPTION
        Flashes the lights of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following Flashes the lights for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleLightsFlash -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following Flashes the lights for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleLightsFlash -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following Flashes the lights for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Invoke-TeslaVehicleLightsFlash -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'flash_lights'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command flash_lights
          
    } #PROCESS

    END {

    } #END
}

function Invoke-TeslaVehicleWakeUp {
    <#
        .SYNOPSIS
        Wakes up a Tesla vehicle.
      
        .DESCRIPTION
        Wakes up a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following initiates a wakeup for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleWakeUp -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following initiates a wakeup for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleWakeUp -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following initiates a wakeup for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Invoke-TeslaVehicleWakeUp -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'wake_up'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command wake_up
          
    } #PROCESS

    END {

    } #END
}

function Lock-TeslaVehicle {
    <#
        .SYNOPSIS
        Locks a Tesla vehicle.
      
        .DESCRIPTION
        Locks a Tesla vehicle.  If the vehicle is already locked the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Locks vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Lock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Locks vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Lock-TeslaVehicle -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Locks vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Lock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'door_lock'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command door_lock
          
    } #PROCESS

    END {

    } #END
}

function Open-TeslaVehicleChargePortDoor {
    <#
        .SYNOPSIS
        Opens the charge port door on a Tesla vehicle.
      
        .DESCRIPTION
        Opens the charge port door on a Tesla Vehicle.  If the charge port door is already open the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following opens the charge port door on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Open-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following opens the charge port door on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Open-TeslaVehicleChargePortDoor -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following opens the charge port door on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Open-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_port_door_open'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_port_door_open
          
    } #PROCESS

    END {

    } #END
}

function Open-TeslaVehicleSunroofVent {
    <#
        .SYNOPSIS
        Opens the sunroof to the vent position on a Tesla vehicle.
      
        .DESCRIPTION
        Opens the sunroof to the vent position on a compatible Tesla vehicle (Model S with panoramic roof).  If the sunroof is already in the vent position the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following vents the sunroof on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Open-TeslaVehicleSunroofVent -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following vents the sunroof on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Open-TeslaVehicleSunroofVent -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following vents the sunroof on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Open-TeslaVehicleSunroofVent -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'sun_roof_control' with paraetmers 'state'=vent"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command sun_roof_control -Body "{`"state`":`"vent`"}"
          
    } #PROCESS

    END {

    } #END
}

function Remove-TeslaVehicleValetModePin {
    <#
        .SYNOPSIS
        Removes the valet mode pin from a Tesla vehicle.
      
        .DESCRIPTION
        Removes the valet mode pin from a Tesla vehicle.  If valet mode is enabled or there is currently no pin set then the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Removes the valet mode pin from vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Remove-TeslaVehicleValetModePin -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Removes the valet mode pin from vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Remove-TeslaVehicleValetModePin -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Removes the valet mode pin from vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Remove-TeslaVehicleValetModePin -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'reset_valet_pin'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command reset_valet_pin
          
    } #PROCESS

    END {

    } #END
}

function Set-TeslaVehicleChargeLimit {
    <#
        .SYNOPSIS
        Sets the charge limit of a Tesla vehicle.
      
        .DESCRIPTION
        Sets the charge limit of a Tesla vehicle between 50% and 100% (Tesla-recommended: 90%).

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ChageLimit
        An integer between 50 and 100 (inclusive) denoting the percentage charge limit for the verhicle battery.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Sets the charge limit to 50% for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Set-TeslaVehicleChargeLimit -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ChargeLimit 50
      
        .EXAMPLE
        Sets the charge limit to 75% for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Set-TeslaVehicleChargeLimit -Vehicle $vehicle -Token $token -ChargeLimit 75
      
        .EXAMPLE
        Sets the charge limit to 80% for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Set-TeslaVehicleChargeLimit -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ChargeLimit 80 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [int]$ChargeLimit,
        [ValidateRange(50,100)]

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'set_charge_limit' with paraetmers 'percent'=$ChargeLimit"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_charge_limit -Body "{`"percent`":$ChargeLimit}"
          
    } #PROCESS

    END {

    } #END
}

function Set-TeslaVehicleClimateControlTemperature {
    <#
        .SYNOPSIS
        Sets the inside temperature of a Tesla vehicle.
      
        .DESCRIPTION
        Sets the inside driver-side and passenger-side temperatures of a Tesla vehicle between 50% and 100% (Tesla-recommended: 90%).  Either the driver side, passenger side or both can be specified but at least one must be provided.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER DriveTemp
        Driver-side temperature in either Celsius or Fahrenheit.  Valid values are 0.5 increments between 15 and 28 (inclusive) for Celsius and integers between 59 and 82 (inclusive)for Fahrenheit.

        .PARAMETER PassengerTemp
        Passenger-side temperature in either Celsius or Fahrenheit.  Valid values are 0.5 increments between 15 and 28 (inclusive) for Celsius and integers between 59 and 82 (inclusive)for Fahrenheit.
        
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Sets the driver-side temperature to 20 degrees Celsius for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Set-TeslaVehicleClimateControlTemperature -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -DriverTemp 20
      
        .EXAMPLE
        Sets the driver-side temperature to 20 degrees Celsius and passenger-side temperature to 78 degreees Fahrenheit for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Set-TeslaVehicleClimateControlTemperature -Vehicle $vehicle -Token $token -DriverTemp 20 -PassengerTemp 78
      
        .EXAMPLE
        Sets the driver-side temperature to 16.5 degrees Celsius and passenger-side temperature to 20 degrees Celsius for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Set-TeslaVehicleClimateControlTemperature -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -DriverTemp 16.5 -PassengerTemp 20 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [ValidateScript({
            if (($_ -ge 15 -and $_ -le 28 -and ($_ % 1 -eq 0 -or $_ % 1 -eq 0.5)) -or ($_ -ge 59 -and $_ -le 82 -and $_ % 1 -eq 0)) {
                $True
            } else {
                throw "$_ is not a multiple of 0.5 between 15 and 28 degrees Celsius or between 59 and 82 degrees Fahrenheit."
            }
        })]
        [string]$DriverTemp,

        [Parameter(Position=3,ValueFromPipeline)]
        [ValidateScript({
            if (($_ -ge 15 -and $_ -le 28 -and ($_ % 1 -eq 0 -or $_ % 1 -eq 0.5)) -or ($_ -ge 59 -and $_ -le 82 -and $_ % 1 -eq 0)) {
                $True
            } else {
                throw "$_ is not a multiple of 0.5 between 15 and 28 degrees Celsius or between 59 and 82 degrees Fahrenheit."
            }
        })]
        [string]$PassengerTemp,

        [Parameter(Position=4,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($DriverTemp -le 28) {
            Write-Verbose "DriverTemp specified in Celsius"
        } else {
            Write-Verbose "DriverTemp specified in Fahrenheit, converting to Celsius"
            [decimal]$DriverTemp2 = [int](($DriverTemp - 32) * (5 / 9))
            Write-Verbose "DriverTemp in Celsius: $DriverTemp2"
            [string]$DriverTemp =  [math]::Round($DriverTemp2)
        }

        if ($PassengerTemp -le 28) {
            Write-Verbose "PassengerTemp specified in Celsius"
        } else {
            Write-Verbose "PassengerTemp specified in Fahrenheit, converting to Celsius"
            [decimal]$PassengerTemp2 = [int](($PassengerTemp - 32) * (5 / 9))
            Write-Verbose "PassengerTemp in Celsius: $PassengerTemp2"
            [string]$PassengerTemp =  [math]::Round($PassengerTemp2)
        }

        if (!$DriverTemp -and !$PassengerTemp) {
        
            throw "At least one temperature must be provided."
        
        } else {
            
            if (!$DriverTemp -or !$PassengerTemp) {
                if ($Token.psobject.Properties.Name -contains "access_token") {
                    $Token = $Token.access_token
                }
    
                $Headers =  @{
                    "Authorization" = "Bearer $Token"
                    "Accept-Encoding" = "gzip,deflate"
                }

                Write-Verbose "Getting current climate temperature settings"
                $ClimateState = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data_request/climate_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
                Write-Verbose $ClimateState

                if ($DriverTemp -and !$PassengerTemp) {
                    $PassengerTemp = $ClimateState.passenger_temp_setting.ToString()
                }

                if ($DriverTemp -and !$PassengerTemp) {
                    $DriverTemp = $ClimateState.driver_temp_setting.ToString()
                }
            }

            Write-Verbose "Executing 'set_temps' with paraetmers 'driver_temp'=$DriverTemp, 'passenger_temp'=$PassengerTemp"
            Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_temps -Body "{`"driver_temp`":$DriverTemp,`"passenger_temp`":$PassengerTemp}"

        }
          
    } #PROCESS

    END {

    } #END
}

function Start-TeslaVehicleCharging {
    <#
        .SYNOPSIS
        Starts charging a Tesla vehicle.
      
        .DESCRIPTION
        Starts charging a Tesla vehicle.  If the vehicle is not plugged into a charger or is already charging the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Start charging vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Start-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Start charging vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Start-TeslaVehicleCharging -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Start charging vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Start-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_start'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_start
          
    } #PROCESS

    END {

    } #END
}

function Start-TeslaVehicleClimateControl {
    <#
        .SYNOPSIS
        Starts the HVAC in a Tesla vehicle.
      
        .DESCRIPTION
        Starts the HVAC in a Tesla vehicle.  If the HVAC is already running the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Start HVAC for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Start-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Start HVAC for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Start-TeslaVehicleClimateControl -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Start HVAC for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Start-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'auto_conditioning_start'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command auto_conditioning_start
          
    } #PROCESS

    END {

    } #END
}

function Stop-TeslaVehicleCharging {
    <#
        .SYNOPSIS
        Stops charging a Tesla vehicle.
      
        .DESCRIPTION
        Stops charging a Tesla vehicle.  If the vehicle is not currently charging the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Stop charging for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Stop-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Stop charging for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Stop-TeslaVehicleCharging -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Stop charging for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Stop-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_stop'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_stop
          
    } #PROCESS

    END {

    } #END
}

function Stop-TeslaVehicleClimateControl {
    <#
        .SYNOPSIS
        Stops the HVAC in a Tesla vehicle.
      
        .DESCRIPTION
        Stops the HVAC in a Tesla vehicle.  If the HVAC is already off the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Stop HVAC for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Stop-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Stop HVAC for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Stop-TeslaVehicleClimateControl -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Stop HVAC for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Stop-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'auto_conditioning_stop'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command auto_conditioning_stop
          
    } #PROCESS

    END {

    } #END
}

function Unlock-TeslaVehicle {
    <#
        .SYNOPSIS
        Unlocks a Tesla vehicle.
      
        .DESCRIPTION
        Unlocks a Tesla vehicle.  If the vehicle is already unlocked the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicle' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Unlock vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Unock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Unock vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicle -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Unock-TeslaVehicle -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Unlock vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Unock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'door_unlock'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command door_unlock
          
    } #PROCESS

    END {

    } #END
}


=======
﻿function Invoke-TeslaVehicleCommand {
    <#
        .SYNOPSIS
        Executes a command against a Tesla vehicle.
      
        .DESCRIPTION
        Executes a command against a Tesla vehicle via the Tesla customer API.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER Command
        A valid MyTesla API vehicle command.

        .PARAMETER Body
        Valid MyTesla API vehicle command parameters in json format.

        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Execute command 'charge_port_door_close' against vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleCommand -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -Command charge_port_door_close
      
        .EXAMPLE
        Execute command 'set_temps' with parameters 'driver_temp' and 'passenger_temp' for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_temps -Body '{"driver_temp":18.5,"passenger_temp":20}"
      
        .LINK
        https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,Mandatory,ValueFromPipeline)]
        [string]$Command,

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$Body,

        [Parameter(Position=4,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }
    
        $Headers = @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Executing vehicle command"
        if ($Body) {
            $TeslaCommand = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/command/$Command" -Method Post -Headers $Headers -Body $Body -ContentType 'application/json'| Select-Object -ExpandProperty Response
        } else {
            $TeslaCommand = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/command/$Command" -Method Post -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        }

        Write-Verbose $TeslaCommand
        if ($TeslaCommand.Result -eq $true) {
            Write-Output $true
        } else {
            Write-Error -Message $TeslaCommand.reason
        }
            
    } #PROCESS

    END {

    } #END
}


function Close-TeslaVehicleChargePortDoor {
    <#
        .SYNOPSIS
        Closes the charge port door on a Tesla vehicle.
      
        .DESCRIPTION
        Closes the charge port door on a compatible Tesla vehicle (built after September 2016).  If the charge port door is already closed or a charge cable is plugged in the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following closes the charge port door on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Close-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following closes the charge port door on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Close-TeslaVehicleChargePortDoor -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following closes the charge port door on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Close-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_port_door_close'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_port_door_close
          
    } #PROCESS

    END {

    } #END
}


function Close-TeslaVehicleSunroof {
    <#
        .SYNOPSIS
        Closes the sunroof on a Tesla vehicle.
      
        .DESCRIPTION
        Closes the sunroof on a compatible Tesla vehicle (Model S with panoramic roof).  If the sunroof is already closed the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following closes the sunroof on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Close-TeslaVehicleSunroof -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following closes the sunroof on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Close-TeslaVehicleSunroof -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following closes the sunroof on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Close-TeslaVehicleSunroof -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'sun_roof_control' with parameters 'state'=close"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command sun_roof_control -Body "{`"state`":`"close`"}"
          
    } #PROCESS

    END {

    } #END
}


function ConvertFrom-TeslaTimeStamp {
    <#
        .SYNOPSIS
        Converts a Tesla timestamp to a human-readable form.
      
        .DESCRIPTION
        Converts the timestamp property value of the various states (e.g. 'climate_state', 'vehicle_state') returned from Tesla API data requests.

        .PARAMETER Timestamp
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .EXAMPLE
        Return a [datetime] object for Tesla timestamp 1508766510148''
    
        ConvertFrom-TeslaTimeStamp -Timestamp 1508766510148
      
        .EXAMPLE
        Return a [datetime] object for the timestamp property of the vehicle state data for vehicle with VIN '5YJSB7E46GF123456'
    
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        $vehicleData = Get-TeslaVehicleSummary -Vehicle $vehicle -Token $token
        $vehicleData.vehicle_state | ConvertFrom-TeslaTimeStamp
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [double]$Timestamp
    )

    BEGIN {

    } #BEGIN

    PROCESS {
    
        $TimeOrigin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        $TimeOrigin.AddSeconds($Timestamp / 1000)

    } #PROCESS

    END {

    } #END
}


function Disable-TeslaVehicleValetMode {
    <#
        .SYNOPSIS
        Turns off valet mode for a Tesla vehicle.
      
        .DESCRIPTION
        Turns off valet mode for a Tesla vehicle.  If valet mode is already disabled the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following turns off valet mode for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Disable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following turns off valet mode for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Disable-TeslaVehicleValetMode -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following turns off valet mode for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Disable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'set_valet_mode' with parameters 'on'=$false"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_valet_mode -Body "{`"on`":`"false`"}"
          
    } #PROCESS

    END {

    } #END
}


function Enable-TeslaVehicleRemoteStart {
    <#
        .SYNOPSIS
        Turns on remote start for a Tesla vehicle.
      
        .DESCRIPTION
        Turns on remote start for 2 minutes for a Tesla vehicle.  If remote start is already enabled the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.

        .PARAMETER Credential
        A valid MyTesla password for the vehicle (the username does not have to match the email address of the MyTesla account, only the password is used).
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following turns on remote start for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234' and prompting for MyTesla credentials.
    
        Enable-TeslaVehicleRemoteStart -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -Credential (Get-Credential)
      
        .EXAMPLE
        The following turns on remote start for vehicle with VIN '1232456'.
        
        $credential = Get-credential
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Enable-TeslaVehicleRemoteStart -Vehicle $vehicle -Token $token -Credential $credential
      
        .EXAMPLE
        The following turns on remote start for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Enable-TeslaVehicleRemoteStart -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api -Credential (Get-Credential)
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,Mandatory,ValueFromPipeline)]
        [PSCredential]$Credential,

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'remote_start_drive' with parameters 'password'=<NotDisplayed>"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command remote_start_drive -Body "{`"password`":`"$($Credential.GetNetworkCredential().password)`"}"
          
    } #PROCESS

    END {

    } #END
}


function Enable-TeslaVehicleValetMode {
    <#
        .SYNOPSIS
        Turns on valet mode for a Tesla vehicle.
      
        .DESCRIPTION
        Turns on valet mode for a Tesla vehicle.  If valet mode is already enabled the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER Pin
        A 4-digit numeric pin to use to disable valet mode from the vehicle dashboard.

        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following turns on valet mode for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Enable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following turns on valet mode with pin '1234' for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Enable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -Pin 1234
      
        .EXAMPLE
        The following turns on valet mode for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Enable-TeslaVehicleValetMode -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following turns on valet mode for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Enable-TeslaVehicleValetMode -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [ValidateScript({
            if ([int]$_ -ge 0 -and [int]$_ -le 9999) {
                $True
            } else {
                throw "$_ is not between '0000' and '9999'."
            }
        })]
        [string]$Pin,

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($pin) {

            Write-Verbose "Executing 'set_valet_mode' with parameters 'on'=$true, 'password'=$pin"
            Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_valet_mode -Body "{`"on`":`"true`",`"password`":`"$pin`"}"

        } else {

            Write-Verbose "Executing 'set_valet_mode' with parameters 'on'=$true"
            Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_valet_mode-Body "{`"on`":`"true`"}"

        }
          
    } #PROCESS

    END {

    } #END
}


function Get-TeslaToken {
    <#
        .SYNOPSIS
        Requests a MyTesla token.
      
        .DESCRIPTION
        Requests a MyTesla token from the MyTesla OAUTH provider.

        .PARAMETER Credential
        A valid MyTesla username and password.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/oauth/token' will be used.

        .EXAMPLE
        The following prompts for MyTesla credentials and returns a token
    
        Get-TeslaToken -Credential (Get-Credential)
            
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCredential]$Credential,

        [Parameter(Position=1,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/oauth/token"
    )

    BEGIN {
        $string = "76492d1116743f0423413b16050a5345MgB8AFcATgBuAFcASABCAE8AWQA5AHUAbwArAFoASQBBAEwAOQBLAGwATgAwAHcAPQA9AHwAMQA5ADEAOAA0
AGEAMwBmAGEAMgAzAGUAMAAwAGQAMwAwAGEAMQBhADAAMwBhAGIAYwBlAGUAYwAzADAAMwAxADQANgBjADYAMgAxADkAMwBiADcAOAA3ADQAZQBkADQAMwA5ADkAZQA3A
GUAZQA4AGEAZQAwADIAYQAwADEAYgA5ADkAMwAyAGYAZAA4ADgAMQAxADMAYQA0ADEAOAA3ADAAZABjADIAOQA3AGUAMwA5ADUAMwA4ADIANAA0ADIANwAwAGEAYgBhAG
YAMgA2ADIAZQBjADUANgA1AGYAMAAwADMANwBmADgAOQAwAGEAMABhADAANABlAGYAOAA2ADIAZgA1ADEANwAyADIAZAAxAGEAYQBjADcAYQBiADUAYQBhADUAMgBlADM
AMQA4ADkAYgA4ADMAZgAzADYAZgBlAGUANwA4ADUANQA5ADIAMwBlADIAYwAyADQAMQAxAGYANwBhAGIAZQAwADgAZAA0AGUAZgAzAGYAYQAxADQAMQA5ADYAMQAwADcA
OABiADEAZAA5AGUANwAyADcAZgA0ADkAMABkAGUANwA0AGIANwBhADMAMAA2ADUAOQBiADQAOAA5AGYAOABiAGEAZABiADkAZgBhAGYAZQA0ADQAMQA1AGYANwBkAGQAN
gBlAGMAYQA5ADUANAA3ADEAMwAxADQAYwAxADQAMgA0AGMAOABjADAAZABiADgANwA4ADUAMABmADkANgBiADIAYQA5AGIAOQA3ADkAZQBmADQAMABiADIAYQAxAGEAYQ
BlADEAZgBhAGMANgAzAGEAMgA0ADkAYgA3AGMAMgBlAGIAZgA3ADAAZQA2AGUAOABiADgAZAAxADAAOAA4AGQAMgA4ADEAMwAxAGIAMwAyAGEAMwBjADMAOQAyAGIAMgA
wADYAYwBkADkANgBkADUAYQA3AGUAMgBiAGIANAAwADUANAA3ADQAZAA0AGEAYwA0ADEANwBlADYAOABkADgANgA0AGYANQBhADIAZAA5AGYAZQAzAGEANQBmADAAZQA3
ADQAZgA4AGEAZQA4AGUANwAzAGYAYwAyAGQAMgA0AGUAZgBkAGMAMQBhADkANAA1ADQAMwAyAGEAYQBkAGEAYgAwADAANgAxADAAMwBkADkAYwBjAGUAZAA2ADkAZQAzA
DcAMwBiAGMAMQA0AGIAMAA3ADcAMgBiAGIAOQA2AGQANQBlADcANwBiADYAYQA2ADMAMAA1ADQANQAyADcANQA3ADEAMABlADUANQAzAGMAZgBjADUAZAA1ADQAMQA5AG
IANQA0ADIAYgA4ADQANwAxADgAZQA1AGMAMwBmAGMAMQAzADIAMAAwADQAYgBkADAAMgA0AGQANgA0AGMAOABmAGYAMgAyAGMAOAAzADcANgA3AGIAMgBiAGYAYwBjADQ
ANQA5AGQAYgA2AGQAYgA="
        [byte[]]$key = ('236 231 222 136 19 9 157 113 158 51 236 240 116 17 176 100 91 179 20 162 238 103 10 192 113 251 135 59 95 82 109 114'.Split(' ')) -as [byte[]]
        $ss = ConvertTo-SecureString -String $string -Key $key
        $ClientCreds = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ss))
    } #BEGIN

    PROCESS {
    
        $Body = @{
            'grant_type' = 'password'
            'client_id' = ($ClientCreds.Split(',')[0])
            'client_secret' = ($ClientCreds.Split(',')[1])
            'email' = $Credential.UserName
            'password' = $Credential.GetNetworkCredential().password
            }
        
        Invoke-RestMethod -Uri $ApiUri -Method Post -Body $Body
    
    } #PROCESS

    END {

    } #END
}


function Get-TeslaVehicles {
    <#
        .SYNOPSIS
        Lists all Tesla vehicles.
      
        .DESCRIPTION
        Lists all Tesla vehicles within a MyTesla account.

        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following lists all Tesla vehicles using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicles -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following looks for a vehicle with VIN '5YJSB7E46GF123456'
        
        $token = Get-TeslaToken
        Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
            
        .LINK
                https://github.com/andylyonette/TeslaPSModule
                
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=1,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }
    
        $Headers = @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicles"
        $dataVehicles = Invoke-RestMethod -Uri "$ApiUri/vehicles/" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        foreach ($dataVehicle in $dataVehicles) {
            $dataVehicle.tokens = $Vehicle.tokens -join ","
        }

        Write-Verbose "Generating output..."
        $dataVehicles
    
    } #PROCESS

    END {

    } #END
}


function Get-TeslaVehicleSummary {
    <#
        .SYNOPSIS
        Retrieves the state of a Tesla vehicle.
      
        .DESCRIPTION
        Retrieves the state of a Tesla vehicle.  Further detail is available under the properties 'gui_settings', 'cliemate_state', 'vehicle_state', 'charge_state' and 'drive_state'

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Gets vehicle state for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Get-TeslaVehicleSummary -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Gets vehicle state for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Get-TeslaVehicleSummary -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Gets vehicle state for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Get-TeslaVehicleSummary -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.RuntimeType>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($Vehicle.psobject.Properties.Name -notcontains "id") {
            $VehicleTemp = @{}
            $VehicleTemp.id = $Vehicle
            $Vehicle = $VehicleTemp
        }

        if ($Token.psobject.Properties.Name -contains "access_token") {
            $Token = $Token.access_token
        }

        $Headers = @{
            "Authorization" = "Bearer $Token"
            "Accept-Encoding" = "gzip,deflate"
        }

        Write-Verbose "Getting vehicle summary"
        $VehicleSummary = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data?vehicle_summary&climate_state&charge_state&drive_state&gui_settings&vehicle_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
        $VehicleSummary.tokens = $VehicleSummary.tokens -join ","
        $VehicleSummary
    
    } #PROCESS

    END {

    } #END
}


function Invoke-TeslaVehicleHorn {
    <#
        .SYNOPSIS
        Honks the horn of a Tesla vehicle.
      
        .DESCRIPTION
        Executes a short honk of the horn for a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following honks the horn for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleHorn -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following honks the horn for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleHorn -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following honks the horn for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Invoke-TeslaVehicleHorn -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'honk_horn'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command honk_horn
          
    } #PROCESS

    END {

    } #END
}


function Invoke-TeslaVehicleLightsFlash {
    <#
        .SYNOPSIS
        Flashes the lights of a Tesla vehicle.
      
        .DESCRIPTION
        Flashes the lights of a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following Flashes the lights for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleLightsFlash -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following Flashes the lights for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleLightsFlash -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following Flashes the lights for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Invoke-TeslaVehicleLightsFlash -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'flash_lights'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command flash_lights
          
    } #PROCESS

    END {

    } #END
}


function Invoke-TeslaVehicleWakeUp {
    <#
        .SYNOPSIS
        Wakes up a Tesla vehicle.
      
        .DESCRIPTION
        Wakes up a Tesla vehicle.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following initiates a wakeup for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Invoke-TeslaVehicleWakeUp -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following initiates a wakeup for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Invoke-TeslaVehicleWakeUp -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following initiates a wakeup for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Invoke-TeslaVehicleWakeUp -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'wake_up'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command wake_up
          
    } #PROCESS

    END {

    } #END
}


function Lock-TeslaVehicle {
    <#
        .SYNOPSIS
        Locks a Tesla vehicle.
      
        .DESCRIPTION
        Locks a Tesla vehicle.  If the vehicle is already locked the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Locks vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Lock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Locks vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Lock-TeslaVehicle -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Locks vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Lock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'door_lock'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command door_lock
          
    } #PROCESS

    END {

    } #END
}


function Open-TeslaVehicleChargePortDoor {
    <#
        .SYNOPSIS
        Opens the charge port door on a Tesla vehicle.
      
        .DESCRIPTION
        Opens the charge port door on a Tesla Vehicle.  If the charge port door is already open the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following opens the charge port door on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Open-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following opens the charge port door on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Open-TeslaVehicleChargePortDoor -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following opens the charge port door on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Open-TeslaVehicleChargePortDoor -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_port_door_open'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_port_door_open
          
    } #PROCESS

    END {

    } #END
}


function Open-TeslaVehicleSunroofVent {
    <#
        .SYNOPSIS
        Opens the sunroof to the vent position on a Tesla vehicle.
      
        .DESCRIPTION
        Opens the sunroof to the vent position on a compatible Tesla vehicle (Model S with panoramic roof).  If the sunroof is already in the vent position the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        The following vents the sunroof on vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Open-TeslaVehicleSunroofVent -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        The following vents the sunroof on vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Open-TeslaVehicleSunroofVent -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        The following vents the sunroof on vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Open-TeslaVehicleSunroofVent -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'sun_roof_control' with parameters 'state'=vent"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command sun_roof_control -Body "{`"state`":`"vent`"}"
          
    } #PROCESS

    END {

    } #END
}


function Remove-TeslaVehicleValetModePin {
    <#
        .SYNOPSIS
        Removes the valet mode pin from a Tesla vehicle.
      
        .DESCRIPTION
        Removes the valet mode pin from a Tesla vehicle.  If valet mode is enabled or there is currently no pin set then the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Removes the valet mode pin from vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Remove-TeslaVehicleValetModePin -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Removes the valet mode pin from vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Remove-TeslaVehicleValetModePin -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Removes the valet mode pin from vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Remove-TeslaVehicleValetModePin -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'reset_valet_pin'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command reset_valet_pin
          
    } #PROCESS

    END {

    } #END
}


function Set-TeslaVehicleChargeLimit {
    <#
        .SYNOPSIS
        Sets the charge limit of a Tesla vehicle.
      
        .DESCRIPTION
        Sets the charge limit of a Tesla vehicle between 50% and 100% (Tesla-recommended: 90%).

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ChargeLimit
        An integer between 50 and 100 (inclusive) denoting the percentage charge limit for the vehicle battery.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Sets the charge limit to 50% for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Set-TeslaVehicleChargeLimit -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ChargeLimit 50
      
        .EXAMPLE
        Sets the charge limit to 75% for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Set-TeslaVehicleChargeLimit -Vehicle $vehicle -Token $token -ChargeLimit 75
      
        .EXAMPLE
        Sets the charge limit to 80% for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Set-TeslaVehicleChargeLimit -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ChargeLimit 80 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [int]$ChargeLimit,
        [ValidateRange(50,100)]

        [Parameter(Position=3,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'set_charge_limit' with parameters 'percent'=$ChargeLimit"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_charge_limit -Body "{`"percent`":$ChargeLimit}"
          
    } #PROCESS

    END {

    } #END
}


function Set-TeslaVehicleClimateControlTemperature {
    <#
        .SYNOPSIS
        Sets the inside temperature of a Tesla vehicle.
      
        .DESCRIPTION
        Sets the inside driver-side and passenger-side temperatures of a Tesla vehicle between 50% and 100% (Tesla-recommended: 90%).  Either the driver side, passenger side or both can be specified but at least one must be provided.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER DriveTemp
        Driver-side temperature in either Celsius or Fahrenheit.  Valid values are 0.5 increments between 15 and 28 (inclusive) for Celsius and integers between 59 and 82 (inclusive)for Fahrenheit.

        .PARAMETER PassengerTemp
        Passenger-side temperature in either Celsius or Fahrenheit.  Valid values are 0.5 increments between 15 and 28 (inclusive) for Celsius and integers between 59 and 82 (inclusive)for Fahrenheit.
        
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Sets the driver-side temperature to 20 degrees Celsius for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Set-TeslaVehicleClimateControlTemperature -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -DriverTemp 20
      
        .EXAMPLE
        Sets the driver-side temperature to 20 degrees Celsius and passenger-side temperature to 78 degrees Fahrenheit for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Set-TeslaVehicleClimateControlTemperature -Vehicle $vehicle -Token $token -DriverTemp 20 -PassengerTemp 78
      
        .EXAMPLE
        Sets the driver-side temperature to 16.5 degrees Celsius and passenger-side temperature to 20 degrees Celsius for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Set-TeslaVehicleClimateControlTemperature -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -DriverTemp 16.5 -PassengerTemp 20 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [ValidateScript({
            if (($_ -ge 15 -and $_ -le 28 -and ($_ % 1 -eq 0 -or $_ % 1 -eq 0.5)) -or ($_ -ge 59 -and $_ -le 82 -and $_ % 1 -eq 0)) {
                $True
            } else {
                throw "$_ is not a multiple of 0.5 between 15 and 28 degrees Celsius or between 59 and 82 degrees Fahrenheit."
            }
        })]
        [string]$DriverTemp,

        [Parameter(Position=3,ValueFromPipeline)]
        [ValidateScript({
            if (($_ -ge 15 -and $_ -le 28 -and ($_ % 1 -eq 0 -or $_ % 1 -eq 0.5)) -or ($_ -ge 59 -and $_ -le 82 -and $_ % 1 -eq 0)) {
                $True
            } else {
                throw "$_ is not a multiple of 0.5 between 15 and 28 degrees Celsius or between 59 and 82 degrees Fahrenheit."
            }
        })]
        [string]$PassengerTemp,

        [Parameter(Position=4,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        if ($DriverTemp -le 28) {
            Write-Verbose "DriverTemp specified in Celsius"
        } else {
            Write-Verbose "DriverTemp specified in Fahrenheit, converting to Celsius"
            [decimal]$DriverTemp2 = [int](($DriverTemp - 32) * (5 / 9))
            Write-Verbose "DriverTemp in Celsius: $DriverTemp2"
            [string]$DriverTemp = [math]::Round($DriverTemp2)
        }

        if ($PassengerTemp -le 28) {
            Write-Verbose "PassengerTemp specified in Celsius"
        } else {
            Write-Verbose "PassengerTemp specified in Fahrenheit, converting to Celsius"
            [decimal]$PassengerTemp2 = [int](($PassengerTemp - 32) * (5 / 9))
            Write-Verbose "PassengerTemp in Celsius: $PassengerTemp2"
            [string]$PassengerTemp = [math]::Round($PassengerTemp2)
        }

        if (!$DriverTemp -and !$PassengerTemp) {
        
            throw "At least one temperature must be provided."
        
        } else {
            
            if (!$DriverTemp -or !$PassengerTemp) {
                if ($Token.psobject.Properties.Name -contains "access_token") {
                    $Token = $Token.access_token
                }
    
                $Headers = @{
                    "Authorization" = "Bearer $Token"
                    "Accept-Encoding" = "gzip,deflate"
                }

                Write-Verbose "Getting current climate temperature settings"
                $ClimateState = Invoke-RestMethod -Uri "$ApiUri/vehicles/$($Vehicle.Id)/data_request/climate_state" -Method Get -Headers $Headers -ContentType 'application/json'| Select-Object -ExpandProperty Response
                Write-Verbose $ClimateState

                if ($DriverTemp -and !$PassengerTemp) {
                    $PassengerTemp = $ClimateState.passenger_temp_setting.ToString()
                }

                if ($DriverTemp -and !$PassengerTemp) {
                    $DriverTemp = $ClimateState.driver_temp_setting.ToString()
                }
            }

            Write-Verbose "Executing 'set_temps' with parameters 'driver_temp'=$DriverTemp, 'passenger_temp'=$PassengerTemp"
            Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command set_temps -Body "{`"driver_temp`":$DriverTemp,`"passenger_temp`":$PassengerTemp}"

        }
          
    } #PROCESS

    END {

    } #END
}


function Start-TeslaVehicleCharging {
    <#
        .SYNOPSIS
        Starts charging a Tesla vehicle.
      
        .DESCRIPTION
        Starts charging a Tesla vehicle.  If the vehicle is not plugged into a charger or is already charging the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Start charging vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Start-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Start charging vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Start-TeslaVehicleCharging -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Start charging vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Start-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_start'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_start
          
    } #PROCESS

    END {

    } #END
}


function Start-TeslaVehicleClimateControl {
    <#
        .SYNOPSIS
        Starts the HVAC in a Tesla vehicle.
      
        .DESCRIPTION
        Starts the HVAC in a Tesla vehicle.  If the HVAC is already running the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Start HVAC for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Start-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Start HVAC for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Start-TeslaVehicleClimateControl -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Start HVAC for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Start-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'auto_conditioning_start'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command auto_conditioning_start
          
    } #PROCESS

    END {

    } #END
}


function Stop-TeslaVehicleCharging {
    <#
        .SYNOPSIS
        Stops charging a Tesla vehicle.
      
        .DESCRIPTION
        Stops charging a Tesla vehicle.  If the vehicle is not currently charging the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Stop charging for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Stop-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Stop charging for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Stop-TeslaVehicleCharging -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Stop charging for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Stop-TeslaVehicleCharging -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'charge_stop'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command charge_stop
          
    } #PROCESS

    END {

    } #END
}


function Stop-TeslaVehicleClimateControl {
    <#
        .SYNOPSIS
        Stops the HVAC in a Tesla vehicle.
      
        .DESCRIPTION
        Stops the HVAC in a Tesla vehicle.  If the HVAC is already off the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Stop HVAC for vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Stop-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Stop HVAC for vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Stop-TeslaVehicleClimateControl -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Stop HVAC for vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Stop-TeslaVehicleClimateControl -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'auto_conditioning_stop'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command auto_conditioning_stop
          
    } #PROCESS

    END {

    } #END
}


function Unlock-TeslaVehicle {
    <#
        .SYNOPSIS
        Unlocks a Tesla vehicle.
      
        .DESCRIPTION
        Unlocks a Tesla vehicle.  If the vehicle is already unlocked the operation will fail.

        .PARAMETER Vehicle
        A valid Tesla vehicle.  This can be obtained using the 'Get-TeslaVehicles' cmdlet.  Instead of supplying an entire Tesla vehicle object just the 'id' from the vehicle (this not the 'vehicle_id' or 'vin') can be supplied instead.
      
        .PARAMETER Token
        A valid MyTesla token with access to the specified vehicle.  This can be obtained using the 'Get-TeslaToken' cmdlet. Instead of supplying an entire Tesla token object just the 'access_token' from the token can be supplied instead.
                
        .PARAMETER ApiUri
        The URI for the Tesla public customer API.  If not specified then 'https://owner-api.teslamotors.com/api/1' will be used.

        .EXAMPLE
        Unlock vehicle ID '12345678901234567' using access token '1234567890123456789012345678901234567890123456789012345678901234'.
    
        Unlock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234
      
        .EXAMPLE
        Unlock vehicle with VIN '1232456'.
        
        $token = Get-TeslaToken
        $vehicle = Get-TeslaVehicles -Token $token | Where-Object {$_.vin -eq "5YJSB7E46GF123456"}
        Unlock-TeslaVehicle -Vehicle $vehicle -Token $token
      
        .EXAMPLE
        Unlock vehicle ID 12345678901234567 using access token '1234567890123456789012345678901234567890123456789012345678901234' using API URI 'https://test.mymockteslaapi.com/api'
    
        Unlock-TeslaVehicle -Vehicle 12345678901234567 -Token 1234567890123456789012345678901234567890123456789012345678901234 -ApiUri https://test.mymockteslaapi.com/api
      
        .LINK
                https://github.com/andylyonette/TeslaPSModule
        
        .OUTPUTS
        <System.Boolean>
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Vehicle,

        [Parameter(Position=1,Mandatory,ValueFromPipeline)]
        [PSCustomObject]$Token,

        [Parameter(Position=2,ValueFromPipeline)]
        [string]$ApiUri = "https://owner-api.teslamotors.com/api/1"
    )

    BEGIN {

    } #BEGIN

    PROCESS {

        Write-Verbose "Executing 'door_unlock'"
        Invoke-TeslaVehicleCommand -Vehicle $Vehicle -Token $Token -Command door_unlock
          
    } #PROCESS

    END {

    } #END
}

>>>>>>> 66dc56146c8d348e4faf0aefeeb96041905d1477:Tesla.psm1
