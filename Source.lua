-- Load the GUI Library
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RevampedCity/Revamped.CityV2/refs/heads/main/Library'))()
local Flags = Library.Flags

-- Create the main window and tabs
local Window = Library:Window({
    Text = "Revamped.City | THA BRONX 3🔪"
})

local autofarmTab = Window:Tab({
    Text = "Auto Farm"
})

local playerTab = Window:Tab({
    Text = "Player"
})

-- Create sections for each tab
local autofarmSection = autofarmTab:Section({
    Text = "Auto Farms"
})

local playerSection = playerTab:Section({
    Text = "Player Options"
})

-- Define the player's character and construction objects
local player = game:GetService("Players").LocalPlayer
local constructionStuff = workspace:FindFirstChild("ConstructionStuff")

local startJobPrompt = constructionStuff and constructionStuff:FindFirstChild("Start Job") and constructionStuff["Start Job"]:FindFirstChild("Prompt")
local wall1Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall1 Prompt")
local wall2Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall2 Prompt")
local wall3Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall3 Prompt")
local wall4Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall4 Prompt")

local wall1Label = wall1Prompt and wall1Prompt:FindFirstChild("Attachment") and wall1Prompt.Attachment.Gui.Label
local wall2Label = wall2Prompt and wall2Prompt:FindFirstChild("Attachment") and wall2Prompt.Attachment.Gui.Label
local wall3Label = wall3Prompt and wall3Prompt:FindFirstChild("Attachment") and wall3Prompt.Attachment.Gui.Label
local wall4Label = wall4Prompt and wall4Prompt:FindFirstChild("Attachment") and wall4Prompt.Attachment.Gui.Label

-- Function to teleport player to a specific position
local function teleportTo(position)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Function to check if player has the PlyWood tool
local function hasPlyWood()
    return player.Backpack:FindFirstChild("PlyWood") or (player.Character and player.Character:FindFirstChild("PlyWood"))
end

-- Function to check if a wall label is empty
local function isWallLabelEmpty(label)
    return label and label.Text == ""
end

-- Function to hold a specific tool
local function holdTool(toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = player.Character
    end
end

-- Move to the next available wall based on empty labels
local function moveToNextAvailableWall()
    if isWallLabelEmpty(wall1Label) then
        teleportTo(Vector3.new(-1673.493, 367.842, -1192.850))
    elseif isWallLabelEmpty(wall2Label) then
        teleportTo(Vector3.new(-1704.753, 367.859, -1152.238))
    elseif isWallLabelEmpty(wall3Label) then
        teleportTo(Vector3.new(-1729.988, 367.877, -1151.989))
    elseif isWallLabelEmpty(wall4Label) then
        teleportTo(Vector3.new(-1760.961, 367.859, -1152.124))
    end
end

-- Perform the autofarm actions
local function performAutofarm()
    if startJobPrompt then
        teleportTo(Vector3.new(-1727.957, 370.812, -1171.312))
        startJobPrompt.Triggered:Wait()
    end

    while true do
        teleportTo(Vector3.new(-1727.879, 370.812, -1177.503))
        wait(0.002)

        while not hasPlyWood() do
            wait(0.002)
        end
        holdTool("PlyWood")

        while hasPlyWood() do
            wait(0.002)

            if isWallLabelEmpty(wall1Label) then
                teleportTo(Vector3.new(-1673.493, 367.842, -1192.850))
            elseif isWallLabelEmpty(wall2Label) then
                teleportTo(Vector3.new(-1704.753, 367.859, -1152.238))
            elseif isWallLabelEmpty(wall3Label) then
                teleportTo(Vector3.new(-1729.988, 367.877, -1151.989))
            elseif isWallLabelEmpty(wall4Label) then
                teleportTo(Vector3.new(-1760.961, 367.859, -1152.124))
            end
        end

        repeat wait(0.002) until not hasPlyWood()
    end
end

-- Add Toggle for Autofarm
autofarmSection:Toggle({
    Text = "Construction Farm",
    Callback = function(state)
        if state then
            -- Start autofarm
            performAutofarm()
        else
        end
    end
})

-- Function to delete specific scripts
local function deleteInfiniteScripts()
    -- Delete StaminaBarScript
    local staminaBarScript = player.PlayerGui.Run.Frame.Frame.Frame:FindFirstChild("StaminaBarScript")
    if staminaBarScript then
        staminaBarScript:Destroy()
    end

    -- Delete HungerBarScript
    local hungerBarScript = player.PlayerGui.Hunger.Frame.Frame.Frame:FindFirstChild("HungerBarScript")
    if hungerBarScript then
        hungerBarScript:Destroy()
    end

    -- Delete SleepBar sleepScript
    local sleepBarScript = player.PlayerGui.SleepGui.Frame.sleep.SleepBar:FindFirstChild("sleepScript")
    if sleepBarScript then
        sleepBarScript:Destroy()
    end

    -- Delete HealthOverlayClient inside BloodOverlay
    local bloodOverlayClient = player.PlayerGui.BloodGui.BloodOverlay:FindFirstChild("HealthOverlayClient")
    if bloodOverlayClient then
        bloodOverlayClient:Destroy()
    end

    -- Delete HealthOverlayClient inside second child of BloodGui
    local secondChildHealthOverlay = player.PlayerGui.BloodGui:GetChildren()[2]:FindFirstChild("HealthOverlayClient")
    if secondChildHealthOverlay then
        secondChildHealthOverlay:Destroy()
    end
end

-- Function to restore deleted scripts (optional)
local function restoreInfiniteScripts()
    -- Add your restoration logic here if necessary
    -- For example, you can require the original scripts from ReplicatedStorage or wherever they're stored
end

-- Add Infinite Stamina Toggle in Player Settings Tab
playerSection:Toggle({
    Text = "∞ Stamina",
    Callback = function(state)
        if state then
            deleteInfiniteScripts()
        else
            restoreInfiniteScripts()  -- Optionally restore the scripts if disabled
        end
    end
})

-- Add Infinite Hunger Toggle in Player Settings Tab
playerSection:Toggle({
    Text = "∞ Hunger",
    Callback = function(state)
        if state then
            deleteInfiniteScripts()
        else
            restoreInfiniteScripts()  -- Optionally restore the scripts if disabled
        end
    end
})

-- Add Infinite Sleep Toggle in Player Settings Tab
playerSection:Toggle({
    Text = "∞ Sleep",
    Callback = function(state)
        if state then
            deleteInfiniteScripts()
        else
            restoreInfiniteScripts()  -- Optionally restore the scripts if disabled
        end
    end
})

-- Show the main window
Window:Select()
