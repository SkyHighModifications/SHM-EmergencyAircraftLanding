local lastNotificationTime = 0
local isFollowing = false
local followPlane = nil
local followPilot = nil
local resource = GetCurrentResourceName()

Citizen.CreateThread(function()
        local resource = GetCurrentResourceName()
    if resource == "SHM-EmergencyAircraftLanding" then
        StartResource(resource)
        print(resource .. " has started and is fully working!")
    else
        StopResource(GetCurrentResourceName())
        print(GetCurrentResourceName() .. " is incorrect and has stopped working due to an incorrect name (SHM-EmergencyAircraftLanding)")
    end
end)

RegisterNetEvent(resource.."Manual")
AddEventHandler(resource.."Manual", function(playerPed)
    if IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed) then
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)
        local altitudeInUnits = GetEntityCoords(playerVehicle).z
        local altitudeInUnit = altitudeInUnits * Config.AltitudeUnits
        local altitudeThresholdInFeet = Config.AltitudeHeight

        if altitudeInUnit > altitudeThresholdInFeet then
            if not isFollowing then
                StartFollowingPlane(playerPed)
                TriggerNotification()
            end
        elseif isFollowing then
            StopFollowingPlane()
        end
    elseif isFollowing then
        StopFollowingPlane()
    end
end)

RegisterNetEvent(resource.."Auto")
AddEventHandler(resource.."Auto", function(playerPed)
    if IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed) then
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleHealth = GetEntityHealth(playerVehicle)
        local altitudeInUnits = GetEntityCoords(playerVehicle).z
        local altitudeInUnit = altitudeInUnits * Config.AltitudeUnits
        local altitudeThresholdInFeet = Config.AltitudeHeight

        if vehicleHealth < 1000 and altitudeInUnit > altitudeThresholdInFeet then
            if not isFollowing then
                StartFollowingPlane(playerPed)
                TriggerNotification()
            end
        elseif isFollowing then
            StopFollowingPlane()
        end
    elseif isFollowing then
        StopFollowingPlane()
    end
end)

function StartFollowingPlane(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    local playerCoords = GetEntityCoords(playerVehicle)
    local altitudeInUnits = GetEntityCoords(playerVehicle).z
    local altitudeInUnit = altitudeInUnits * Config.AltitudeUnits

-- Calculate the position at the back of the player's vehicle with a 5-feet distance
local offset = 5.0
local npcPlaneX = playerCoords.x - (offset * math.sin(math.rad(GetEntityHeading(playerVehicle))))
local npcPlaneY = playerCoords.y + (offset * math.cos(math.rad(GetEntityHeading(playerVehicle))))

-- Create the escort plane and pilot
local npcPlane = CreateVehicle(GetHashKey(Config.EscortPlane), npcPlaneX, npcPlaneY, playerCoords.z, GetEntityHeading(playerVehicle), true, false)
local npcPed = CreatePed(GetHashKey(Config.EscortPilot), npcPlaneX, npcPlaneY, playerCoords.z, GetEntityHeading(playerVehicle), true, false) 

-- Task for the plane behind
TaskPlaneMission(npcPed, npcPlane, playerVehicle, 0, 0, npcPlaneX, npcPlaneY, playerCoords.z + 2.0, 10, 100.0, -1.0, -1.0, GetEntityHeading(playerVehicle), 200.0)

-- Task for the plane next to the left
TaskPlaneMission(npcPed, npcPlane, playerVehicle, 0, 0, npcPlaneX - 10.0, npcPlaneY, playerCoords.z + 2.0, 10, 100.0, -1.0, -1.0, GetEntityHeading(playerVehicle), 200.0)

-- Task for the plane next to the right
TaskPlaneMission(npcPed, npcPlane, playerVehicle, 0, 0, npcPlaneX + 10.0, npcPlaneY, playerCoords.z + 2.0, 10, 100.0, -1.0, -1.0, GetEntityHeading(playerVehicle), 200.0)

-- Additional tasks based on altitude condition
if altitudeInUnit >= 300.0 and altitudeInUnit <= 100.0 then
    TaskPlaneMission(npcPed, npcPlane, playerVehicle, 0, 0, npcPlaneX, npcPlaneY, playerCoords.z + 2.0, 9, 100.0, -1.0, -1.0, GetEntityHeading(playerVehicle), 200.0)
    TaskPlaneMission(npcPed, npcPlane, playerVehicle, 0, 0, npcPlaneX - 10.0, npcPlaneY, playerCoords.z + 2.0, 9, 100.0, -1.0, -1.0, GetEntityHeading(playerVehicle), 200.0)
    TaskPlaneMission(npcPed, npcPlane, playerVehicle, 0, 0, npcPlaneX + 10.0, npcPlaneY, playerCoords.z + 2.0, 9, 100.0, -1.0, -1.0, GetEntityHeading(playerVehicle), 200.0)
end

    isFollowing = true
    followPlane = npcPlane
    followPilot = npcPed
end

function StopFollowingPlane()
    if DoesEntityExist(followPlane) or DoesEntityExist(followPilot) then
        local nearestRunwayCoords = GetNearestRunway(GetEntityCoords(followPlane)).coords
        TaskPlaneLand(followPilot, followPlane, 0.0, 0.0, 0.0)
        Citizen.Wait(5000) -- Wait for the NPC plane to land (adjust timing as needed)
        DeleteEntity(followPlane)
        DeleteEntity(followPilot)
    end

    isFollowing = false
    followPlane = nil
    followPilot = nil
end


function TriggerNotification()
    local ped = PlayerId()
    local name = GetPlayerName(ped)
    local vehicle = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(ped, false)))
    local currentTime = GetGameTimer()
    local coords = GetEntityCoords(ped)
    local notificationMessage = ""

    if currentTime - lastNotificationTime > Config.Notifications.Cooldown * 1000 then
        if IsPedInAnyPlane(ped) or IsPedInAnyHeli(ped) then
            local location = GetLocationName(coords)

            if location ~= Config.Runways.UnknownLocation then
                notificationMessage = name .. " in " .. vehicle .. " has declared an emergency landing at " .. location
            else
                notificationMessage = name .. " in " .. vehicle .. " has declared an emergency landing"
                NotifyCrashLocation(coords)
            end

            NewNoti(notificationMessage, true, true)
            lastNotificationTime = currentTime
        end
    end
end

function NotifyCrashLocation(coords)
    local playerPed = PlayerId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    local isPlane = IsThisModelAPlane(GetEntityModel(playerVehicle))
    local isHeli = IsThisModelAHeli(GetEntityModel(playerVehicle))

    local blipSprite = isPlane and Config.Blips.PlaneBlip or (isHeli and Config.Blips.HeliBlip or Config.Blips.CrashBlip)  -- Plane, Heli, or default blip sprite
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, blipSprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, Config.Blips.Scale)
    SetBlipColour(blip, Config.Blips.Color) -- Adjust blip color as needed

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.Name)
    EndTextCommandSetBlipName(blip)

    Citizen.Wait(120000)
    RemoveBlip(blip)
end

function GetLocationName(coords)
    local nearestRunway = GetNearestRunway(coords)
    return nearestRunway and nearestRunway.name or Config.Runways.UnknownLocation
end

function GetNearestRunway(coords)
    local nearestRunway = nil
    local altitudeInUnits = coords.z
    local altitudeInUnit = altitudeInUnits * Config.AltitudeUnits
    local minDistance = Config.Runways.Distance

    for _, rway in pairs(Config.Runways) do
        local distance = Vdist(coords.x, coords.y, coords.z, rway.coords.x, rway.coords.y, rway.coords.z)
        
        if distance < minDistance then
            minDistance = distance
            nearestRunway = rway
        end
    end

    return nearestRunway
end

-- Draws notification on client's screen
function NewNoti(text, flash, beep)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostMessagetext(Config.Notifications.PostMsg)
    if Config.Notifications.Flash then
    if flash then
        ThefeedNextPostBackgroundColor(Config.Notifications.FlashColor) -- Flashing color (adjust as needed)
        end
    end
    if Config.Notifications.Beep then
    if beep then
        PlaySoundFrontend(-1, Config.Notifications.BeepSound, true)
        end
    end
    EndTextCommandThefeedPostTicker(false, true)
end

-- Add this to your main loop or tick function
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local player = PlayerId()  -- Use PlayerId() directly
        TriggerEvent(resource.."Auto", player)
    end
end)
    
    

RegisterCommand(Config.ManualCommand, function()
    local player = PlayerId()

    if IsPedInAnyPlane(player) or IsPedInAnyHeli(player) then
        TriggerEvent(resource.."Manual", player)
    end
end)
