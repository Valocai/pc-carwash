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
    assert(cache.vehicle, "Player not in a vehicle")
    local success = lib.progressBar({
        duration = (Config?.Settings?.wash_time or 10) * 1000, -- if Config.time is not defined then it defaults to 10000 (10s)
        label = 'Washing Vehicle.',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            vehicle = true,
            combat = true, 
        },
    })
    if not success then return false, lib.notify({description = "Car washing cancelled"}) end
    SetVehicleDirtLevel(cache.vehicle, 0.0)
    return true
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