-- Load Library --
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RevampedCity/Revamped.CityV2/refs/heads/main/Library.lua'))()
local Window = Library:Window({ Text = "Revamped.City | 🐍THA BRONX 3🔪" })

-- Main --
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RevampedCity/Revamped.CityV2/refs/heads/main/Library.lua'))()
local Window = Library:Window({ Text = "Revamped.City | 🐍THA BRONX 3🔪" })
-- Player --
local playerTab = Window:Tab({ Text = "Player" })
local playerSection = playerTab:Section({ Text = "Player Options" })
local player = game:GetService("Players").LocalPlayer
local function deleteInfiniteScripts()
local gui = player.PlayerGui
local scriptsToDelete = {
gui.Run.Frame.Frame.Frame:FindFirstChild("StaminaBarScript"),
gui.Hunger.Frame.Frame.Frame:FindFirstChild("HungerBarScript"),
gui.SleepGui.Frame.sleep.SleepBar:FindFirstChild("sleepScript"),
gui.BloodGui.BloodOverlay:FindFirstChild("HealthOverlayClient"),
gui.BloodGui:GetChildren()[2] and gui.BloodGui:GetChildren()[2]:FindFirstChild("HealthOverlayClient")
}
for _, script in pairs(scriptsToDelete) do
if script then script:Destroy() end
end
end
playerSection:Toggle({ Text = "∞ Stamina", Callback = function(state)
if state then deleteInfiniteScripts() end
end
})
playerSection:Toggle({ Text = "∞ Hunger", Callback = function(state)
if state then deleteInfiniteScripts() end
end
})
playerSection:Toggle({ Text = "∞ Sleep", Callback = function(state)
if state then deleteInfiniteScripts() end
end
})
local movementSection = playerTab:Section({ Text = "Movement" })
local isWalkspeedEnabled = false
local walkspeedValue = 16
getgenv().FreeFallMethod = false
local function toggleFreeFall(state)
if state then
getgenv().FreeFallMethod = true
local player = game:GetService("Players").LocalPlayer
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
local humanoid = player.Character.Humanoid
humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end
else
getgenv().FreeFallMethod = false
local player = game:GetService("Players").LocalPlayer
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
local humanoid = player.Character.Humanoid
humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end
end
end
movementSection:Toggle({
Text = "Enable Freefall",
Callback = function(state)
isWalkspeedEnabled = state
toggleFreeFall(isWalkspeedEnabled)
if isWalkspeedEnabled then
while isWalkspeedEnabled do
local player = game:GetService("Players").LocalPlayer
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
local humanoid = player.Character.Humanoid
humanoid.WalkSpeed = walkspeedValue
end
wait(0.1)  -- Small delay to prevent too frequent updates
end
end
end
})
movementSection:Slider({
Text = "Walkspeed",
Min = 16,
Max = 100,
Default = walkspeedValue,
Callback = function(value)
walkspeedValue = value
if isWalkspeedEnabled then
local player = game:GetService("Players").LocalPlayer
if player and player.Character and player.Character:FindFirstChild("Humanoid") then
local humanoid = player.Character.Humanoid
humanoid.WalkSpeed = walkspeedValue
end
end
end
})
-- Visuals --
local VisualTab = Window:Tab({ Text = "Visual" })
local ESPSection = VisualTab:Section({ Text = "ESP Options" })
local Players = game:GetService("Players")
local Camera = game.Workspace.CurrentCamera
local boxEspEnabled = false  -- Separate variable for Box ESP
local nameEspEnabled = false  -- Separate variable for Name ESP
local healthEspEnabled = false  -- Separate variable for Health ESP
local EspList = {}
local yOffset = 33  -- Default Y-offset

-- Box ESP
local function createESP(Player)
local Box = Drawing.new("Square")
Box.Thickness = 1
Box.Filled = false
Box.Color = Color3.fromRGB(44, 84, 212) -- Baby blue color

local function update()
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Humanoid.Health > 0 then
            local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
            if OnScreen then
                Box.Size = Vector2.new(2450 / Pos.Z, 3850 / Pos.Z)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 9)
                Box.Visible = boxEspEnabled  -- Only show the box if Box ESP is enabled
                return
            end
        end
    end
    Box.Visible = false
end

update()
local Connection1 = Player.CharacterAdded:Connect(update)
local Connection2 = Player.CharacterRemoving:Connect(function() Box.Visible = false end)

return {
    update = update,
    disconnect = function()
        Box:Remove()
        Connection1:Disconnect()
        Connection2:Disconnect()
    end
}
end

-- Names ESP
local function createNameESP(Player)
local Name = Drawing.new("Text")
Name.Text = Player.Name
Name.Size = 10
Name.Outline = true
Name.Center = true
Name.Color = Color3.fromRGB(44, 84, 212)

local function update()
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Humanoid.Health > 0 then
            local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
            if OnScreen then
                local X = Pos.X
                local Y = Pos.Y
                Name.Position = Vector2.new(X, Y - yOffset)  -- Apply Y-offset
                Name.Visible = nameEspEnabled  -- Only show the name if Name ESP is enabled
                return
            end
        end
    end
    Name.Visible = false
end

update()
local Connection1 = Player.CharacterAdded:Connect(update)
local Connection2 = Player.CharacterRemoving:Connect(function() Name.Visible = false end)

return {
    update = update,
    disconnect = function()
        Name:Remove()
        Connection1:Disconnect()
        Connection2:Disconnect()
    end,
    Name = Name
}
end

-- Health ESP
local function createHealthBar(player)
if player == game.Players.LocalPlayer then
    return
end
local humanoid = player.Character:WaitForChild("Humanoid")
local gui = Instance.new("BillboardGui")
gui.Name = "HealthBar"
gui.Adornee = player.Character.Head
gui.Size = UDim2.new(5, 0, .3, 0)
gui.StudsOffset = Vector3.new(0, -5.7, 0)
gui.AlwaysOnTop = true
gui.Parent = player.Character.Head           
local frame = Instance.new("Frame")
frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(44, 84, 212)
frame.BorderSizePixel = 0
frame.Parent = gui
humanoid.HealthChanged:Connect(function()
    frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
end)
player.CharacterAdded:Connect(function(character)
    humanoid = character:WaitForChild("Humanoid")
    gui.Adornee = character.Head
    frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
end)
end

-- Toggle ESPs
ESPSection:Toggle({
Text = "Enable Box ESP",
State = false,
Callback = function(state)
    boxEspEnabled = state
    for _, espInstance in ipairs(EspList) do
        espInstance.update()
    end
end
})

ESPSection:Toggle({
Text = "Enable Names ESP",
State = false,
Callback = function(state)
    nameEspEnabled = state
    for _, espInstance in ipairs(EspList) do
        espInstance.Name.Visible = state
    end
end
})

-- Toggle Health ESP
ESPSection:Toggle({
Text = "Enable Health ESP",
State = false,
Callback = function(state)
    healthEspEnabled = state
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if state then
                createHealthBar(player)
            else
                local healthBar = player.Character and player.Character:FindFirstChild("Head"):FindFirstChild("HealthBar")
                if healthBar then
                    healthBar:Destroy()
                end
            end
        end
    end
end
})

-- Slider for adjusting name size
local function sliderCallback(value, sliderType)
if sliderType == "Size" then
    for _, espInstance in ipairs(EspList) do
        espInstance.Name.Size = value
    end
elseif sliderType == "YOffset" then
    yOffset = value  -- Update yOffset for name position
end
end

-- Create ESP for all players
local function createAllESP()
for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= Players.LocalPlayer then
        table.insert(EspList, createESP(Player))  -- Add Box ESP for the player
        table.insert(EspList, createNameESP(Player))  -- Add Name ESP for the player
        if healthEspEnabled then
            createHealthBar(Player)  -- Add Health ESP for the player
        end
    end
end
end

Players.PlayerAdded:Connect(function(player)
if player ~= Players.LocalPlayer then
    table.insert(EspList, createESP(player))  -- Add Box ESP for the player
    table.insert(EspList, createNameESP(player))  -- Add Name ESP for the player
    if healthEspEnabled then
        createHealthBar(player)  -- Add Health ESP for the player
    end
end
end)

createAllESP()

game:GetService("RunService").RenderStepped:Connect(function()
for _, espInstance in ipairs(EspList) do
    espInstance.update()
end
end)

-- Teleports --
local TeleportTab = Window:Tab({ Text = "Teleport" })
local TeleportSection = TeleportTab:Section({ Text = "Teleport Options" })
local player = game:GetService("Players").LocalPlayer
local locations = {
{name = "Studio", position = Vector3.new(93432.28125, 14484.7421875, 565.5982666015625)},
{name = "Studio Guns", position = Vector3.new(72422.1171875, 128855.6328125, -1086.7322998046875)},
{name = "Gun Shop 1", position = Vector3.new(92993.046875, 122097.953125, 17026.3515625)},
{name = "Gun Shop 2", position = Vector3.new(66201.1875, 123615.703125, 5749.68115234375)},
{name = "Gun Shop 3", position = Vector3.new(60841.60546875, 87609.140625, -352.474609375)},
{name = "Bank Tools", position = Vector3.new(-420.06304931640625, 340.34051513671875, -557.3113403320312)},
{name = "DealerShip", position = Vector3.new(-408.208984375, 253.25640869140625, -1248.583251953125)},
{name = "Bank", position = Vector3.new(-236.5049591064453, 283.626708984375, -1236.29052734375)},
{name = "Icebox", position = Vector3.new(-246.49212646484375, 283.515380859375, -1265.6380615234375)},
{name = "Penthouse", position = Vector3.new(-150.90985107421875, 417.2039794921875, -567.7549438476562)},
{name = "Safe", position = Vector3.new(68515.65625, 52941.5, -796.0286865234375)},
{name = "Backpack", position = Vector3.new(-707.6212768554688, 253.59808349609375, -681.1074829101562)},
{name = "Money Wash", position = Vector3.new(-990.2910766601562, 253.6531524658203, -688.8972778320312)},
{name = "Cooking Pot", position = Vector3.new(-133.5728302001953, 283.62255859375, -577.8919677734375)},
{name = "Cooking Van", position = Vector3.new(-83.11944580078125, 289.0430603027344, -336.2181396484375)},
{name = "Exotic Dealer", position = Vector3.new(-1523.944091796875, 273.97296142578125, -993.6229858398438)}
}
getgenv().FreeFallMethod = false
task.spawn(function()
while task.wait() do
if getgenv().FreeFallMethod then
local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end
end
end
end)
local function teleportTo(position)
local screen = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
screen.Name = "TeleportScreen"
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "Teleporting."
label.TextColor3 = Color3.fromRGB(173, 216, 230)
label.TextScaled = true
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
local dotCounter = 1
local function updateDots()
while screen.Parent do
label.Text = "Teleporting." .. string.rep(".", dotCounter)
dotCounter = (dotCounter % 3) + 1
task.wait(1)
end
end
task.spawn(updateDots)
local function updateTextSize()
while screen.Parent do
label.TextSize = math.random(40, 60)
task.wait(0.1)
end
end
task.spawn(updateTextSize)
local revText = Instance.new("TextLabel", frame)
revText.Size = UDim2.new(0.5, 0, 0.1, 0)
revText.Position = UDim2.new(0.25, 0, 0.8, 0)
revText.Text = "Revamped.City"
revText.TextColor3 = Color3.fromRGB(255, 255, 255)
revText.TextScaled = true
revText.BackgroundTransparency = 1
revText.Font = Enum.Font.GothamBold
getgenv().FreeFallMethod = true
wait(1)
player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
getgenv().FreeFallMethod = false
screen:Destroy()
end
for _, location in ipairs(locations) do
TeleportSection:Button({
Text = location.name,
Callback = function()
teleportTo(location.position)
end
})
end
-- AutoFarm --
local autoFarmTab = Window:Tab({ Text = "Auto Farm" })
local autoFarmSection = autoFarmTab:Section({ Text = "Auto Farms" })
local player = game:GetService("Players").LocalPlayer

-- Function to teleport player after waiting for freefall method to activate
local function teleportTo(position)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Activate freefall method for 0.8 seconds before teleporting
        getgenv().FreeFallMethod = true
        task.wait(0.8) -- Wait for 0.8 seconds to simulate freefall

        -- Then teleport the player to the new position
        player.Character.HumanoidRootPart.CFrame = CFrame.new(position)

        -- Deactivate freefall method after teleporting
        getgenv().FreeFallMethod = false
    end
end

-- Studio farm functionality
local function studioFarm()
    local cashPickupLocations = {
        {name = "StudioPay1", position = Vector3.new(93418.6640625, 14486.2060546875, 564.9903564453125)},
        {name = "StudioPay2", position = Vector3.new(93427.578125, 14487.21484375, 577.8220825195312)},
        {name = "StudioPay3", position = Vector3.new(93435.3828125, 14486.7900390625, 563.5308837890625)}
    }
    for _, cashPickup in ipairs(cashPickupLocations) do
        teleportTo(cashPickup.position)
        local studioPayFolder = workspace:FindFirstChild("StudioPay")
        if studioPayFolder then
            for _, child in ipairs(studioPayFolder:GetDescendants()) do
                if child:IsA("ProximityPrompt") then
                    child.HoldDuration = 0
                end
            end
        end
        local pickupObject = workspace:FindFirstChild("StudioPay"):FindFirstChild("Money"):FindFirstChild(cashPickup.name)
        if pickupObject and pickupObject:FindFirstChild("Prompt") then
            local prompt = pickupObject:FindFirstChild("Prompt")
            if prompt then
                prompt.Triggered:Fire()
            end
        end
        wait(1)
    end
end

-- Toggle for Studio Farm
local isStudioFarmActive = false
autoFarmSection:Toggle({
    Text = "Studio Farm",
    Callback = function(state)
        isStudioFarmActive = state
        while isStudioFarmActive do
            studioFarm()
            wait(0.5)
        end
    end
})

-- Construction Farm Functionality
local constructionStuff = workspace:FindFirstChild("ConstructionStuff")
local startJobPrompt = constructionStuff and constructionStuff:FindFirstChild("Start Job") and constructionStuff["Start Job"]:FindFirstChild("Prompt")
local wall1Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall1 Prompt")
local wall2Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall2 Prompt")
local wall3Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall3 Prompt")
local wall4Prompt = constructionStuff and constructionStuff:FindFirstChild("Wall4 Prompt")

-- Labels for Wall Prompts
local wall1Label = wall1Prompt and wall1Prompt:FindFirstChild("Attachment") and wall1Prompt.Attachment.Gui.Label
local wall2Label = wall2Prompt and wall2Prompt:FindFirstChild("Attachment") and wall2Prompt.Attachment.Gui.Label
local wall3Label = wall3Prompt and wall3Prompt:FindFirstChild("Attachment") and wall3Prompt.Attachment.Gui.Label
local wall4Label = wall4Prompt and wall4Prompt:FindFirstChild("Attachment") and wall4Prompt.Attachment.Gui.Label

getgenv().FreeFallMethod = false

-- Freefall method functionality
task.spawn(function()
    while task.wait() do
        if getgenv().FreeFallMethod then
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end
    end
end)

-- Check for PlyWood
local function hasPlyWood()
    return player.Backpack:FindFirstChild("PlyWood") or (player.Character and player.Character:FindFirstChild("PlyWood"))
end

-- Check if Wall Label is empty
local function isWallLabelEmpty(label)
    return label and label.Text == ""
end

-- Equip the tool
local function holdTool(toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = player.Character
    end
end

-- Set ProximityPrompt hold duration
local function setProximityPromptHoldDuration()
    for _, object in pairs(workspace.ConstructionStuff:GetDescendants()) do
        if object:IsA("ProximityPrompt") then
            object.HoldDuration = 0
        end
    end
end

-- Move to next available wall
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

-- Main autofarm function for construction
local function performAutofarm()
    setProximityPromptHoldDuration()
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
            moveToNextAvailableWall()
        end
    end
end

-- Toggle for Construction Farm
autoFarmSection:Toggle({
    Text = "Construction Farm",
    Callback = function(state)
        if state then
            performAutofarm()
        end
    end
})


-- Toggle state
local isAutoFarming = false

-- Function to check if the player has an item
function hasItem(itemName)
    local backpack = game:GetService("Players").LocalPlayer.Backpack
    for _, item in ipairs(backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    return false
end

-- Function to purchase missing items
function purchaseItems()
    local itemsNeeded = { "FreshWater", "Ice-Fruit Bag", "FijiWater", "Ice-Fruit Cupz" }
    for _, itemName in ipairs(itemsNeeded) do
        if not hasItem(itemName) then
            game:GetService("ReplicatedStorage"):WaitForChild("ExoticShopRemote"):InvokeServer(itemName)
            task.wait(0.5) -- Small delay to ensure item gets added
        end
    end
end

-- Function to set all CookingPot prompts hold duration to 0
function setHoldDurationToZero()
    for _, obj in ipairs(workspace.CookingPots:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end
end

-- Function to teleport using FreeFallMethod
function teleportWithFreeFall(targetPosition)
    getgenv().FreeFallMethod = true
    task.wait(0.8)
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
    getgenv().FreeFallMethod = false
end

-- Function to equip and hold a tool until it's removed
function holdToolUntilRemoved(toolName)
    local player = game:GetService("Players").LocalPlayer

    -- Wait for the tool to exist in the backpack
    while isAutoFarming and not hasItem(toolName) do
        task.wait(0.2)
    end

    -- Equip the tool
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = player.Character -- Equip the tool
        print("Holding: " .. toolName)
    end

    -- Wait until tool is removed from both backpack & character
    while isAutoFarming and (hasItem(toolName) or player.Character:FindFirstChild(toolName)) do
        task.wait(0.2)
    end

    print(toolName .. " removed")
end

-- Function to teleport to the sell location after pressing "E" while holding Ice-Fruit Cupz
function teleportToSellLocationWhenCupzPressed()
    local player = game:GetService("Players").LocalPlayer
    local prompt = workspace.CookingPots.CookingPot.CookPart.ProximityPrompt

    -- Wait for the player to press "E" while holding Ice-Fruit Cupz
    prompt.Triggered:Wait()  -- Wait until the prompt is triggered (i.e., the player presses "E")

    -- Teleport to the sell location after pressing "E"
    teleportWithFreeFall(Vector3.new(-83.105, 286.721, -338.175))
end

-- Function to execute auto-farm
function autoFarm()
    while isAutoFarming do
        setHoldDurationToZero()
        
        -- Purchase missing items
        purchaseItems()

        -- Teleport to cooking station
        teleportWithFreeFall(Vector3.new(-134.003, 283.379, -575.231))

        -- Hold tools in the correct order, strictly waiting for removal before moving on
        holdToolUntilRemoved("FreshWater")
        task.wait(0.2) -- Small buffer to ensure smooth transition

        holdToolUntilRemoved("Ice-Fruit Bag")
        task.wait(0.2)

        holdToolUntilRemoved("FijiWater")
        task.wait(0.2)

        holdToolUntilRemoved("Ice-Fruit Cupz")

        -- Now that Ice-Fruit Cupz is being held, wait for the prompt to be fired
        teleportToSellLocationWhenCupzPressed()

        -- Wait 1 min 2 sec after clicking "E"
        task.wait(62)

        -- Wait for Ice-Fruit Cupz to be removed after selling
        while isAutoFarming and hasItem("Ice-Fruit Cupz") do
            task.wait(0.2)
        end

        -- Return to start position
        teleportWithFreeFall(Vector3.new(-134.003, 283.379, -575.231))
    end
end

-- Toggle button for AutoFarm
local koolaidFarmToggle = autoFarmSection:Toggle({
    Text = "Koolaid Farm",
    Default = false,
    Callback = function(state)
        isAutoFarming = state
        if state then
            autoFarm()
        end
    end
})


-- Bypasses --
local bypassTab = Window:Tab({ Text = "Bypasses" })
local bypassSection = bypassTab:Section({ Text = "Bypass" })
local function setAllProximityPrompts()
for _, object in pairs(workspace:GetDescendants()) do
if object:IsA("ProximityPrompt") then
object.HoldDuration = 0
end
end
end
bypassSection:Button({ Text = "Instant Prompts", Callback = function()
setAllProximityPrompts()
end
})
workspace.DescendantAdded:Connect(function(descendant)
if descendant:IsA("ProximityPrompt") then
descendant.HoldDuration = 0
end
end)


-- Function to set all proximity prompts to instant
local function setAllProximityPrompts()
    for _, object in pairs(workspace:GetDescendants()) do
        if object:IsA("ProximityPrompt") then
            object.HoldDuration = 0
        end
    end
end


-- Keep all newly added proximity prompts with instant hold duration
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        descendant.HoldDuration = 0
    end
end)

-- No Ragdoll toggle
local noRagdollEnabled = false
local function toggleNoRagdoll()
    noRagdollEnabled = not noRagdollEnabled
    if noRagdollEnabled then
        -- Delete ragdoll objects every 5 seconds
        while noRagdollEnabled do
            if workspace.localPlayer and workspace.localPlayer.Character then
                local ragdollHeadshot = workspace.localPlayer.Character:FindFirstChild("Ragdoll Headshot")
                local fallDamageRagdoll = workspace.localPlayer.Character:FindFirstChild("FallDamageRagdoll")
                
                if ragdollHeadshot then
                    ragdollHeadshot:Destroy()
                end
                
                if fallDamageRagdoll then
                    fallDamageRagdoll:Destroy()
                end
            end
            wait(5)
        end
    end
end

bypassSection:Toggle({
    Text = "No Ragdoll",
    Callback = function(state)
        if state then
            toggleNoRagdoll() -- Enable No Ragdoll
        else
            noRagdollEnabled = false -- Disable No Ragdoll
        end
    end
})
--
--
--
--
