-- Multi-Game Hub Launcher with Key System GUI
-- Created for Roblox scripting. Loads scripts from permanent URLs after key validation.
-- Key system inspired by Mist Hub: Uses Linkvertise for keys with 12-hour expiration.

-- Table of supported games. Add new games here following the template below.
local SupportedGames = {
    ["Hunted"] = {
        ScriptURL = "https://gist.githubusercontent.com/VincentBankaiaizen66/4d27b8d683225d2e858320edf5ef5ea4/raw/MistHubhuntedpc.lua",
        Description = "Load Mist Hub for Hunted (PC version).",
        PlaceId = 136431686349723  -- Replace with the actual PlaceId for Hunted to enable auto-detection/highlighting.
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

-- Placeholder function for key validation (replace with your actual logic)
local function ValidateKey(inputKey)
    -- Example dummy validation: Accepts "VALID_KEY" for testing. Replace with real checks (e.g., API call, hash, or expiration).
    -- In a real setup, check against a server or use your 12-hour expiration system.
    if inputKey == "VALID_KEY" then  -- TODO: Replace with secure validation
        return true, "Key validated successfully!"
    else
        return false, "Invalid key. Please try again or get a new one from Linkvertise."
    end
end

-- Create the Key System GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "KeySystemGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Multi-Game Hub Key System"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 0, 30)
InfoLabel.Size = UDim2.new(1, 0, 0, 80)
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.Text = "Enter your key (from Linkvertise). Keys expire after 12 hours.\nGet key: [Your Linkvertise Link Here]\nDiscord: [Your Discord Invite Here]"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 14
InfoLabel.TextWrapped = true

local KeyInput = Instance.new("TextBox")
KeyInput.Parent = MainFrame
KeyInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
KeyInput.BorderSizePixel = 0
KeyInput.Position = UDim2.new(0.1, 0, 0.6, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
KeyInput.Font = Enum.Font.SourceSans
KeyInput.PlaceholderText = "Enter key here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14

local SubmitButton = Instance.new("TextButton")
SubmitButton.Parent = MainFrame
SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SubmitButton.BorderSizePixel = 0
SubmitButton.Position = UDim2.new(0.3, 0, 0.8, 0)
SubmitButton.Size = UDim2.new(0.4, 0, 0, 30)
SubmitButton.Font = Enum.Font.SourceSansBold
SubmitButton.Text = "Submit"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 16

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Parent = MainFrame
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Position = UDim2.new(0, 0, 0.9, 0)
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Font = Enum.Font.SourceSans
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
ErrorLabel.TextSize = 12
ErrorLabel.TextWrapped = true

-- Submit button functionality
SubmitButton.MouseButton1Click:Connect(function()
    local inputKey = KeyInput.Text
    local success, message = ValidateKey(inputKey)
    if success then
        -- Key valid: Destroy key GUI and show game selection
        ScreenGui:Destroy()
        ShowGameSelection()
    else
        -- Key invalid: Show error and allow retry
        ErrorLabel.Text = message
    end
end)

-- Function to show Game Selection GUI after key validation
function ShowGameSelection()
    local GameSelectionGui = Instance.new("ScreenGui")
    GameSelectionGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    GameSelectionGui.Name = "GameSelectionGUI"
    GameSelectionGui.ResetOnSpawn = false

    local SelectionFrame = Instance.new("Frame")
    SelectionFrame.Parent = GameSelectionGui
    SelectionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SelectionFrame.BorderSizePixel = 0
    SelectionFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    SelectionFrame.Size = UDim2.new(0, 400, 0, 300)

    local SelectionTitle = Instance.new("TextLabel")
    SelectionTitle.Parent = SelectionFrame
    SelectionTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SelectionTitle.BorderSizePixel = 0
    SelectionTitle.Size = UDim2.new(1, 0, 0, 30)
    SelectionTitle.Font = Enum.Font.SourceSansBold
    SelectionTitle.Text = "Select a Game to Load"
    SelectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectionTitle.TextSize = 18

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = SelectionFrame
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Auto-adjusts

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollingFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    -- Populate game buttons
    local currentPlaceId = game.PlaceId  -- For auto-detection
    for gameName, details in pairs(SupportedGames) do
        local GameButton = Instance.new("TextButton")
        GameButton.Parent = ScrollingFrame
        GameButton.BackgroundColor3 = (currentPlaceId == details.PlaceId) and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 170, 255)  -- Highlight if current game
        GameButton.BorderSizePixel = 0
        GameButton.Size = UDim2.new(1, -10, 0, 50)
        GameButton.Font = Enum.Font.SourceSans
        GameButton.Text = gameName .. "\n" .. details.Description
        GameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GameButton.TextSize = 14
        GameButton.TextWrapped = true

        GameButton.MouseButton1Click:Connect(function()
            -- Load the selected script and close GUI
            loadstring(game:HttpGet(details.ScriptURL))()
            GameSelectionGui:Destroy()
        end)
    end

    -- Auto-adjust scrolling canvas size
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- Show the key system GUI initially
-- (The script starts here when executed via loadstring)
