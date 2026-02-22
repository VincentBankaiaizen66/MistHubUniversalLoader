-- Mist Hub Mobile for Hunted (Roblox)
-- Optimized for Mobile Executors: Lightweight ESP, Speedhack, Speed Immunity
-- Integrated Key System GUI for Access Validation (Bypassed if Loader Validates)

-- Key System Variables
local KeyValidated = false
local ValidatedKey = nil

-- Hardcoded Permanent Keys for Personal Use
local PersonalPermanentKeys = {
    ["MY_PERSONAL_KEY_123"] = true  -- Replace with your unique permanent key
}

-- Placeholder for Key Validation Function (Expand with Remote Database if Needed)
local function ValidateKey(inputKey)
    local currentUserId = tostring(game.Players.LocalPlayer.UserId)
    if PersonalPermanentKeys[inputKey] then
        ValidatedKey = inputKey
        KeyValidated = true
        return true, "Personal permanent key validated! Unlimited access granted."
    elseif inputKey == "VALID_KEY" then
        ValidatedKey = inputKey
        KeyValidated = true
        return true, "Temporary key validated! Access granted (test mode)."
    else
        return false, "Invalid key. Get a new key from Linkvertise or purchase a permanent one."
    end
end

local function IsKeyStillValid()
    return KeyValidated or (_G.MistHubKeyValidated == true)  -- Check loader's global flag
end

-- Load UI Library (Kavo UI)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

local Window
if success then
    Window = Library.CreateLib("Mist Hub Mobile - Hunted", "Ocean")
    print("Mist Hub Mobile: UI Library loaded successfully.")
else
    print("Mist Hub Mobile: UI Library failed to load. Using console feedback.")
end

-- Key System GUI Setup
local function SetupKeySystem()
    if not success then
        print("Mist Hub Mobile: UI not loaded. Key system unavailable. Access granted for testing.")
        KeyValidated = true
        SetupFeatureTabs()
        return
    end

    local KeyTab = Window:NewTab("Key System")
    local KeySect = KeyTab:NewSection("Access Validation")
    KeySect:NewLabel("Enter your key below to unlock features.")
    
    KeySect:NewButton("Get Key from Linkvertise", "Click to get a temporary key", function()
        local link = "https://link-target.net/3097614/ZAIAZeMRBPSb"
        if setclipboard then
            setclipboard(link)
            print("Mist Hub Mobile: Link copied to clipboard! Paste in browser.")
        else
            print("Mist Hub Mobile: Visit " .. link .. " for a key.")
        end
    end)
    
    KeySect:NewTextBox("Enter Key", "Input your key here", function(txt)
        local inputKey = txt
        local valid, message = ValidateKey(inputKey)
        if valid then
            print("Mist Hub Mobile: " .. message)
            -- Hide Key Tab and Show Features
            KeyTab:Destroy()
            SetupFeatureTabs()
        else
            print("Mist Hub Mobile: " .. message)
        end
    end)
end

-- Features Setup (ESP, Speedhack, Invincibility)
local function SetupFeatureTabs()
    -- Variables
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local RunService = game:GetService("RunService")

    -- ESP Section (Lightweight)
    local ESPEnabled = false
    local ESPColor = Color3.fromRGB(255, 0, 0)
    local ESPBoxes = {}

    local function CreateESP(player)
        if player == LocalPlayer or not player.Character then return end
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local success, err = pcall(function()
            -- Use simpler BillboardGui for mobile, no BoxHandleAdornment
            local nameTag = Instance.new("BillboardGui")
            nameTag.Adornee = root
            nameTag.Size = UDim2.new(0, 80, 0, 20)
            nameTag.StudsOffset = Vector3.new(0, 1.5, 0)
            nameTag.AlwaysOnTop = true
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = ESPColor
            nameLabel.BackgroundTransparency = 1
            nameLabel.Parent = nameTag
            nameTag.Parent = root
            ESPBoxes[player] = nameTag
        end)
        if not success then
            print("Mist Hub Mobile ESP Error for " .. player.Name .. ": " .. tostring(err))
        end
    end

    local function RemoveESP(player)
        if ESPBoxes[player] then
            ESPBoxes[player]:Destroy()
            ESPBoxes[player] = nil
        end
    end

    local function UpdateESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if ESPEnabled then
                if not ESPBoxes[player] then
                    CreateESP(player)
                end
            else
                RemoveESP(player)
            end
        end
    end

    if success then
        local ESPTab = Window:NewTab("ESP")
        local ESPSect = ESPTab:NewSection("Player ESP")
        ESPSect:NewToggle("Enable ESP", "Highlights players with name tags", function(state)
            ESPEnabled = state
            UpdateESP()
            print("Mist Hub Mobile: ESP " .. (state and "Enabled" or "Disabled"))
        end)
    else
        print("Mist Hub Mobile: ESP Toggle not available without UI. Set ESPEnabled = true in script to enable manually.")
    end

    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            CreateESP(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        RemoveESP(player)
    end)

    -- Speedhack Section
    local SpeedEnabled = false
    local SpeedValue = 16

    local function UpdateSpeed()
        if Humanoid then
            Humanoid.WalkSpeed = SpeedEnabled and SpeedValue or 16
            print("Mist Hub Mobile: Speed set to " .. Humanoid.WalkSpeed)
        end
    end

    if success then
        local SpeedTab = Window:NewTab("Speedhack")
        local SpeedSect = SpeedTab:NewSection("Speed Controls")
        SpeedSect:NewToggle("Enable Speedhack", "Adjusts your walk speed", function(state)
            SpeedEnabled = state
            UpdateSpeed()
        end)
        SpeedSect:NewSlider("Speed Value", "Set custom speed", 16, 50, function(value)
            SpeedValue = value
            UpdateSpeed()
        end)
    else
        print("Mist Hub Mobile: Speedhack Toggle not available without UI. Set SpeedEnabled = true and SpeedValue manually in script.")
    end

    -- Invincibility (Reduced Speed Immunity) Section
    local InvincEnabled = false

    local function BlockSpeedEffects()
        if not InvincEnabled or not Humanoid then return end
        if Humanoid.WalkSpeed < 16 then
            Humanoid.WalkSpeed = SpeedEnabled and SpeedValue or 16
            print("Mist Hub Mobile: Speed reduction blocked. Reset to " .. Humanoid.WalkSpeed)
        end
    end

    if success then
        local InvincTab = Window:NewTab("Invincibility")
        local InvincSect = InvincTab:NewSection("Speed Effect Immunity")
        InvincSect:NewToggle("Enable Immunity", "Prevents reduced speed effects", function(state)
            InvincEnabled = state
            print("Mist Hub Mobile: Speed Immunity " .. (state and "Enabled" or "Disabled"))
        end)
    else
        print("Mist Hub Mobile: Immunity Toggle not available without UI. Set InvincEnabled = true in script to enable manually.")
    end

    -- Heartbeat Connection (Less Frequent for Mobile)
    local HeartbeatCounter = 0
    RunService.Heartbeat:Connect(function()
        HeartbeatCounter = HeartbeatCounter + 1
        if HeartbeatCounter >= 5 then -- Check every 5 ticks to reduce mobile load
            if InvincEnabled then
                BlockSpeedEffects()
            end
            if ESPEnabled then
                UpdateESP()
            end
            HeartbeatCounter = 0
        end
    end)

    -- Character Reset Handling
    LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        Humanoid = char:WaitForChild("Humanoid")
        RootPart = char:WaitForChild("HumanoidRootPart")
        UpdateSpeed()
        print("Mist Hub Mobile: Character reloaded, speed settings updated.")
    end)

    print("Mist Hub Mobile features loaded successfully for Hunted!")
end

-- Script Entry Point
if IsKeyStillValid() then
    SetupFeatureTabs()
else
    SetupKeySystem()
end
