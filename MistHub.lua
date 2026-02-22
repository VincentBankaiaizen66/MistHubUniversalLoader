-- misthub.lua (Universal Loader for PC with Fluent UI)
-- PC-only hub loader for multiple games

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local UserInputService = game:GetService("UserInputService")

-- Fluent UI Window Setup
local Window = Fluent:CreateWindow({
    Title = "MistHub - Universal Loader (PC)",
    SubTitle = "by VincentBankaiaizen66",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Main Tab for Game Selection
local MainTab = Window:AddTab({ Title = "Game Loader", Icon = "rbxassetid://4483345998" })
MainTab:AddParagraph({
    Title = "Welcome to MistHub",
    Content = "Select a game to load its specific hub. This loader is for PC only."
})

-- Game Detection and Loader Logic
local Games = {
    { Name = "Hunted", PlaceId = 136431686349723, ScriptUrl = "https://raw.githubusercontent.com/VincentBankaiaizen66/YourHuntedPCRepo/main/HuntedPC.lua" },
    -- Add other games here as needed
    { Name = "Example Game", PlaceId = 123456789, ScriptUrl = "https://raw.githubusercontent.com/YourUsername/YourRepo/main/ExampleScript.lua" }
}

local function LoadGameScript()
    local PlaceId = game.PlaceId
    for _, gameData in ipairs(Games) do
        if PlaceId == gameData.PlaceId then
            Fluent:Notify({
                Title = "Loading Hub",
                Content = "Loading script for " .. gameData.Name .. "...",
                Duration = 3
            })
            loadstring(game:HttpGet(gameData.ScriptUrl))()
            return
        end
    end
    Fluent:Notify({
        Title = "Unsupported Game",
        Content = "No script found for this game (Place ID: " .. tostring(PlaceId) .. ").",
        Duration = 5
    })
end

MainTab:AddButton({
    Title = "Load Game-Specific Hub",
    Description = "Load the hub for the current game.",
    Callback = LoadGameScript
})

-- Ensure PC-only Notification
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    Fluent:Notify({
        Title = "Device Not Supported",
        Content = "MistHub Universal Loader is for PC only. Mobile not supported.",
        Duration = 5
    })
    game.Players.LocalPlayer:Kick("This loader is for PC only. Mobile devices are not supported.")
end

-- Open Window
Window:SelectTab(1)
Fluent:Notify({
    Title = "MistHub Loaded",
    Content = "Universal Loader ready. Click to load game hub.",
    Duration = 3
})
