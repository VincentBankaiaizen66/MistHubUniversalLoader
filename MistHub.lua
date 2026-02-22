-- Mist Hub Loader (Multi-Game Hub with Key System)
-- Supports PC and Mobile versions of Hunted with selection prompt
-- Single Key System in Loader; Game Scripts Bypass Their Own After Validation

-- Safety and Error Handling Wrapper
local function safeLoad(func)
    local success, result = pcall(func)
    if not success then
        warn("Mist Hub Error: " .. tostring(result) .. ". Falling back to basic mode.")
        return nil
    end
    return result
end

-- Load Fluent UI Library for Loader (with fallback)
local Fluent = safeLoad(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

local Window
if Fluent then
    local Options = Fluent.Options
    Window = Fluent:CreateWindow({
        Title = "Mist Hub Loader",
        SubTitle = "Multi-Game Hub",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,  -- Enable animations on PC
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })
    print("Mist Hub: Fluent UI loaded successfully.")
else
    warn("Mist Hub: Fluent UI failed to load. Using console feedback only.")
end

-- Key System Variables
local KeyValidated = false
local ValidatedKey = nil
local PersonalPermanentKeys = {["MY_PERSONAL_KEY_123"] = true}  -- Replace with your keys

local function ValidateKey(inputKey)  -- Placeholder validation logic
    if PersonalPermanentKeys[inputKey] or inputKey == "VALID_KEY" then
        KeyValidated = true
        ValidatedKey = inputKey
        _G.MistHubKeyValidated = true  -- Set global flag for game scripts to check
        return true, "Key validated! Access granted."
    end
    return false, "Invalid key. Get a new key from Linkvertise."
end

-- Key System GUI
local function SetupKeySystem()
    if not Fluent then
        print("Key system unavailable. Access granted for testing.")
        KeyValidated = true
        _G.MistHubKeyValidated = true  -- Set flag even in fallback
        SetupGameSelection()
        return
    end

    local KeyTab = Window:AddTab({ Title = "Key System", Icon = "key" })
    local KeySect = KeyTab:AddSection({ Title = "Access Validation" })
    KeySect:AddParagraph({ Title = "Enter Key", Content = "Input your key to unlock Mist Hub." })
    
    KeySect:AddButton({
        Title = "Get Key from Linkvertise",
        Description = "Click to copy link for temporary key",
        Callback = function()
            local link = "https://link-target.net/3097614/ZAIAZeMRBPSb"
            if setclipboard then setclipboard(link) end
            Fluent:Notify({ Title = "Link Copied", Content = "Paste in browser: " .. link })
        end
    })
    
    KeySect:AddInput("KeyInput", {
        Title = "Enter Key",
        Callback = function(txt)
            local valid, message = ValidateKey(txt)
            Fluent:Notify({ Title = "Validation", Content = message })
            if valid then
                KeyTab:Destroy()
                SetupGameSelection()
            end
        end
    })
end

-- Supported Games Table (Updated with PC and Mobile for Hunted)
local SupportedGames = {
    ["Hunted (PC)"] = {
        ScriptURL = "https://gist.githubusercontent.com/VincentBankaiaizen66/4d27b8d683225d2e858320edf5ef5ea4/raw/MistHubhuntedpc.lua",  -- PC script URL (with Fluent + animations)
        Description = "Load Mist Hub for Hunted (PC version with animations).",
        PlaceId = 13643168649723  -- PlaceId for HUNTED
    },
    ["Hunted (Mobile)"] = {
        ScriptURL = "https://gist.githubusercontent.com/VincentBankaiaizen66/5a1cb8dc8d88c43d7dc3457aa6594ba4/raw/2c94c276a205ebc5d9a80c9f96155cb01346937c/HuntedMobile.lua",  -- Mobile script URL (with Kavo, no animations)
        Description = "Load Mist Hub for Hunted (Mobile version without animations).",
        PlaceId = 13643168649723  -- Same PlaceId for HUNTED
    }
}

-- Game Selection GUI
local function SetupGameSelection()
    if not Fluent then
        print("Game selection unavailable. Load a script manually.")
        return
    end

    local GameTab = Window:AddTab({ Title = "Game Selection", Icon = "gamepad" })
    local GameSect = GameTab:AddSection({ Title = "Supported Games" })
    GameSect:AddParagraph({ Title = "Select Game", Content = "Choose a game to load Mist Hub. PC versions have animations; Mobile do not." })

    local currentPlaceId = game.PlaceId
    for gameName, data in pairs(SupportedGames) do
        local isCurrentGame = (data.PlaceId == currentPlaceId)
        GameSect:AddButton({
            Title = gameName .. (isCurrentGame and " (Current Game)" or ""),
            Description = data.Description,
            Callback = function()
                Fluent:Notify({ Title = "Loading", Content = "Loading " .. gameName .. "..." })
                local success, err = pcall(function()
                    loadstring(game:HttpGet(data.ScriptURL))()
                end)
                if not success then
                    warn("Mist Hub Load Error: " .. tostring(err) .. ". Check URL or syntax.")
                else
                    print("Mist Hub: " .. gameName .. " loaded successfully.")
                end
            end
        })
    end
end

-- Script Entry Point
if _G.MistHubKeyValidated then
    SetupGameSelection()
else
    SetupKeySystem()
end

print("Mist Hub Loader initialized on " .. os.date("%B %d, %Y") .. ".")
