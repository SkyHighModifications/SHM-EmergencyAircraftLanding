Config = {
    ManualCommand = "emland", -- Manual Command for Emergency Landing

    AltitudeHeight = 500.0, -- 500 feet
    AltitudeUnits = 3.28084, -- Sets to Feet

    EscortPlane = "lazer",
    EscortPilot = "a_m_m_pilot_01",

Notifications = {
        Beep = true,
        Flash = true,
        FlashColor = 6,
        BeepSound = "Virus_Eradicated", "LESTER1A_SOUNDS",
        PostMsg = "CHAR_PLANESITE",
    },

Runways = {

        Distance = 500.0,
        UnknownLocation = "Unknown Location",

        LSIA = {
            name = "Runway " .. math.random(1, 3) .. " at Heathrow Airport"
            coords = vector3(0.0, 0.0, 0.0), -- Replace with actual LSIA coordinates
        }, 

        FortZancudo = {
            name = "RAF Northolt",
            coords = vector3(0.0, 0.0, 0.0), -- Replace with actual Fort Zancudo coordinates
        },

        AircraftCarrier = {
            name = "USS Luxington (ATT-16)",
            coords = vector3(0.0, 0.0, 0.0), -- Replace with actual Aircraft Carrier coordinates
        },

        Cayo = {
            name = "Cayo Perico",
            coords = vector3(0.0, 0.0, 0.0), -- Replace with actual Cayo Perico coordinates
        },

        Sandy = {
            name = "Sandy Shores Airstrip",
            coords = vector3(0.0, 0.0, 0.0), -- Replace with actual Sandy Shores Airstrip coordinates
        },

        Grapeseed  = {
            name = "Grapeseed Airstrip",
            coords = vector3(0.0, 0.0, 0.0), -- Replace with actual Grapeseed Airstrip coordinates
        },
    },

Blips = {
        Name = "Emergency Landing Location",
        CrashBlip = 305, -- https://docs.fivem.net/docs/game-references/blips/#blips
        HeliBlip = 43,
        PlaneBlip = 307,
        Color = 66, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        Scale = 1.0,
    }
}

--SkyHigh Modifications
