local Zones = {}
local CurrentCarWash = nil

for i, zone_data in pairs(Config.Locations) do

    zone_data.onEnter = function(zone)
        CurrentCarWash = zone -- set the current carwash to the zone we are in
        if cache.vehicle then 
            lib.notify({ description = ("Welcome to the %s Carwash"):format(zone.name) })
            lib.showTextUI("Press E to wash your vehicle.")
        end
    end

    zone_data.onExit = function(zone)
        CurrentCarWash = nil -- we dont have a current carwash anymore
        if cache.vehicle then
            lib.notify({ description = ("Thanks for visiting %s Carwash"):format(zone.name) })
            lib.hideTextUI()
        end
    end

    Zones[i] = lib.zones.poly(zone_data) -- this is creating the polyzone.
end

local function washCar()
    assert(IsPedInAnyVehicle(PlayerPedId(), false), "Player not in a vehicle")
    local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    
    local initialDirtLevel = GetVehicleDirtLevel(playerVeh)
    local targetDirtLevel = 0.0
    local currentTime = 0
    local totalTime = Config.Settings.wash_time * 800 
    
    while currentTime < totalTime do
        Citizen.Wait(800)  
        
        
        local progress = currentTime / totalTime
        
        
        local currentDirtLevel = initialDirtLevel * (1 - progress) + targetDirtLevel * progress

        SetVehicleDirtLevel(playerVeh, currentDirtLevel)
        
        currentTime = currentTime + 800  
    end
end

lib.addKeybind({
    name = 'wash_vehicle',
    description = 'press E to wash your vehicle',
    defaultKey = E,
    onReleased = function(self)
        if not CurrentCarWash then return end -- this is an early exit/guard clause to prevent use if not in a carwash
        if not cache.vehicle then return end -- this is an early exit/guard clause to prevent use if not in vehicle
        washCar(cache.vehicle)
    end
})


RegisterCommand('dirty', function()    
    SetVehicleDirtLevel(cache.vehicle, 15.0)
end)