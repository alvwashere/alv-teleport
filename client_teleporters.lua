Config = {
    TeleporterZones = {
        ["Cocaine Lab"] = {
            EnterMarker = vector3(988.77, -434.63, 63.74),
            EnterLanding = vector3(1088.636, -3188.551, -37.993),
            ExitMarker = vector3(1103.613, -3196.25, -38.9),
            ExitLanding = vector3(989.23, -438.8, 64.75)
        },
        ["Weed Farm"] = {
            EnterMarker = vector3(-255.35, -1543.58, 31.99),
            EnterLanding = vector3(1066.009, -3183.386, -38.164),
            ExitMarker = vector3(1040.91, -3195.94, -38.10),
            ExitLanding = vector3(260.85, -1535.96, 32.93)
        },
        ["Meth Factory"] = {
            EnterMarker = vector3(-1737.856, 218.842, 62.443),
            EnterLanding = vector3(997.260, -3200.844, -35.393),
            ExitMarker = vector3(1011.831, -3201.996, -37.993),
            ExitLanding = vector3(-1741.047, 216.514, 62.443)
        }
    },
    EnterTeleport = false, -- Teleports the player as soon as they enter the marker, command + button recommended as marker/text don't have time to appear in most cases.
    EnableCommand = true, -- Should the player be able to use a command while on the marker?
    CommandName = 'teleport_interact', -- The command name, feel free to make it less complicated if you're not using the Keybind
    EnableKeybind = true, -- Should the player be able to use a keybind while on the marker? -- COMMAND REQURED
    Keybind = 'e',  -- The key the player should use to interact with the teleport. -- COMMAND REQUIRED
    EnableFloatingText = true, -- Draw a floating help notification over the marker? requires ESX Legacy unless you rewrite the function
    EnableMarker = true, -- Enable a Marker which will guide the player into the teleporter
    Marker = { -- If you have the line above as false, you can disregard this.
        Type = 2, -- Marker Types: https://docs.fivem.net/docs/game-references/markers/
        Scale = {
            X = 0.3, 
            Y = 0.25,
            Z = 0.15
        },
        Color = {
            R = 188, 
            G = 0, 
            B = 0,
            A = 200
        },
        BobUpAndDown = true,
        FaceCamera = true,
        Rotate = false
    },
    Language = {
        EnterMarker = 'Press  ~INPUT_CONTEXT~ to enter the %s', -- For Floating Text
        ExitMarker = 'Press  ~INPUT_CONTEXT~ to exit the %s', -- For Floating Text
        KeybindDescription = 'Teleport to a different area.' -- For toggleable keybind
    },
    Distance = 2.0 -- Distance required to use marker
}

for k, v in pairs(Config.TeleporterZones) do
    local Entering = lib.points.new({
        coords = v.EnterMarker, 
        distance = Config.Distance
    })

    local Exiting = lib.points.new({
        coords = v.ExitMarker,
        distance = Config.Distance
    })

    if Config.EnableMarker or Config.EnableFloatingText then
        function Entering:nearby()
            if Config.Marker then
                DrawMarker(Config.Marker.Type, v.EnterMarker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Scale.X, Config.Marker.Scale.Y, Config.Marker.Scale.Z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.A, Config.Marker.BobUpAndDown, Config.Marker.FaceCamera, 2, Config.Marker.Rotate)
            end

            if Config.EnableFloatingText then
                ESX.ShowFloatingHelpNotification(Config.Language.EnterMarker:format(k), v.EnterMarker)
            end
        end

        function Exiting:nearby()
            if Config.Marker then
                DrawMarker(Config.Marker.Type, v.ExitMarker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Scale.X, Config.Marker.Scale.Y, Config.Marker.Scale.Z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, Config.Marker.Color.A, Config.Marker.BobUpAndDown, Config.Marker.FaceCamera, 2, Config.Marker.Rotate)
            end

            if Config.EnableFloatingText then
                ESX.ShowFloatingHelpNotification(Config.Language.ExitMarker:format(k), v.ExitMarker)
            end
        end
    end


    if Config.EnterTeleport then
        function Entering:onEnter()
            SetEntityCoords(cache.ped, v.EnterLanding)
        end

        function Exiting:onEnter()
            SetEntityCoords(cache.ped, v.ExitLanding)
        end
    end
end

if Config.EnableCommand then
    RegisterCommand(Config.CommandName, function()
        for k, v in pairs(Config.TeleporterZones) do
            if GetDistanceBetweenCoords(cache.coords, v.EnterMarker) < Config.Distance then
                SetEntityCoords(cache.ped, v.EnterLanding)
            elseif GetDistanceBetweenCoords(cache.coords, v.ExitMarker) < Config.Distance then
                SetEntityCoords(cache.ped, v.ExitLanding)
            end
        end
    end)

    if Config.EnableKeybind then
        RegisterKeyMapping(Config.CommandName, Config.Language.KeybindDescription, 'keyboard', Config.Keybind)
    end
end
