-- Multi-Game Hub Launcher with Key System GUI
-- Created for Roblox scripting. Loads scripts from permanent URLs after key validation.
-- Key system inspired by Mist Hub: Uses Linkvertise for keys with 12-hour expiration.
-- Universal Key: One key works for all games until expiration (12 hours).

-- Table of supported games. Add new games here following the template below.
local SupportedGames = {
    ["Hunted"] = {
        ScriptURL = "https://gist.githubusercontent.com/VincentBankaiaizen66/4d27b8d683225d2e858320edf5ef5ea4/raw/MistHubhuntedpc.lua",
        Description = "Load Mist Hub for Hunted (PC version).",
        PlaceId = 13643168649723  -- Actual PlaceId for HUNTED, enabling auto-detection/highlighting.
    }
    -- Template for adding a new game (copy-paste this block and edit values):
    --[[
    ["NewGameName"] = {
        ScriptURL = "https://example.com/YourNewScript.lua",  -- Replace with raw URL of the script
        Description = "Description for the new game.",        -- Replace with a short description
        PlaceId = 0000000000                                 -- Replace with actual Roblox PlaceId for auto-detection
    }
    --]]
    -- Add more games by copying the template above and pasting here with updated details.
}

-- Variables for key validation state (simulates persistence for current session)
local KeyValidated = false
local ValidatedKey = nil  -- Store the key for potential backend re-check

-- Placeholder function for key validation (replace with your actual logic)
local function ValidateKey(inputKey)
    if inputKey == "VALID_KEY" then
        ValidatedKey = inputKey
        KeyValidated = true
        return true, "Key validated successfully! Access granted to all games for 12 hours."
    else
        ValidatedKey = nil
        KeyValidated = false
        return false, "Invalid key. Please try again or get a new one from Linkvertise."
    end
end

-- Function to check if key is still valid (for future backend implementation)
local function IsKeyStillValid()
    return KeyValidated
end

-- Load Fluent UI Library (replace with the latest raw URL for Fluent)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Library.lua"))()  -- Update this URL if outdated
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Setup Fluent Window
local Window = Fluent:CreateWindow({
    Title = "MistHubUniversalLoader",
    SubTitle = "Multi-Game Hub",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,  -- Enable acrylic blur if supported by executor
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create Tabs for Key System and Game Selection (we'll show based on validation)
local KeySystemTab = Window:AddTab({ Title = "Key System", Icon = "key" })
local GameSelectionTab = Window:AddTab({ Title = "Game Selection", Icon = "gamepad" })

-- Create the Key System GUI using Fluent
local function ShowKeyGUI()
    -- Hide Game Selection Tab initially
    GameSelectionTab:SetVisible(false)
    KeySystemTab:SetVisible(true)
    Window:SelectTab(1)  -- Show Key System tab

    -- Key System Section
    local KeySection = KeySystemTab:AddSection("Key Validation")
    KeySection:AddParagraph({
        Title = "Instructions",
        Content = "Enter your key below. Keys expire after 12 hours. Visit Linkvertise to obtain a new key."
    })

    local LinkvertiseButton = KeySection:AddButton({
        Title = "Get Key from Linkvertise",
        Description = "Click to view the Linkvertise URL for your key.",
        Callback = function()
            local link = "https://link-target.net/3097614/ZAIAZeMRBPSb"
            Fluent:Notify({
                Title = "Linkvertise URL",
                Content = "Visit: " .. link .. "\nCopy this link and open it in your browser.",
                Duration = 10
            })
        end
    })

    local CopyLinkButton = KeySection:AddButton({
        Title = "Copy Link to Clipboard",
        Description = "Copy the Linkvertise URL to your clipboard.",
        Callback = function()
            local link = "https://link-target.net/3097614/ZAIAZeMRBPSb"
            if setclipboard then
                setclipboard(link)
                Fluent:Notify({
                    Title = "Success",
                    Content = "Link copied to clipboard! Paste it in your browser.",
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Clipboard not supported. Manually copy the link from the notification above.",
                    Duration = 5
                })
            end
        end
    })

    local KeyInput = KeySection:AddInput({
        Title = "Enter Key",
        Description = "Input your key here to gain access.",
        Default = "",
        Placeholder = "Enter key here...",
        Callback = function(value)
            -- Store the input if needed, though we'll use the button for submission
        end
    })

    local SubmitButton = KeySection:AddButton({
        Title = "Submit Key",
        Description = "Validate your key to access the game hub.",
        Callback = function()
            local inputKey = KeyInput.Value
            local success, message = ValidateKey(inputKey)
            if success then
                Fluent:Notify({
                    Title = "Success",
                    Content = message,
                    Duration = 5
                })
                KeySystemTab:SetVisible(false)
                ShowGameSelectionContent(GameSelectionTab)
                GameSelectionTab:SetVisible(true)
                Window:SelectTab(2)  -- Switch to Game Selection tab
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = message,
                    Duration = 5
                })
            end
        end
    })
end

-- Function to show Game Selection GUI after key validation using Fluent
function ShowGameSelectionContent(tab)
    local GameSection = tab:AddSection("Select a Game")
    GameSection:AddParagraph({
        Title = "Game Selection",
        Content = "Select a game below to load its script. The current game (if detected) will be highlighted."
    })

    local currentPlaceId = game.PlaceId  -- For auto-detection
    for gameName, details in pairs(SupportedGames) do
        GameSection:AddButton({
            Title = gameName,
            Description = details.Description,
            Callback = function()
                loadstring(game:HttpGet(details.ScriptURL))()
                Fluent:Notify({
                    Title = "Loading",
                    Content = "Loading script for " .. gameName .. "...",
                    Duration = 3
                })
                -- Optionally close the UI after loading, or let user close it
                -- Window:Destroy()
            end
        })
    end
end

-- Script entry point: Check if key is already validated
if IsKeyStillValid() then
    KeySystemTab:SetVisible(false)
    GameSelectionTab:SetVisible(true)
    ShowGameSelectionContent(GameSelectionTab)
    Window:SelectTab(2)  -- Show Game Selection tab
else
    ShowKeyGUI()
end
