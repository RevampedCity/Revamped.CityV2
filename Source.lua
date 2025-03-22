-- Load Library --
    local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/RevampedCity/Revamped.CityV2/refs/heads/main/Library.lua'))()
    local Window = Library:Window({ Text = "Revamped.City | 🐍THA BRONX 3🔪" })

-- Combat -- 

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
    local movementSection = playerTab:Section({ Text = "Movement", Side = "Right"})
    local isWalkspeedEnabled = false
    local walkspeedValue = 16  -- Default WalkSpeed value
    getgenv().FreeFallMethod = false
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local function toggleFreeFall(state)
    if state then
    getgenv().FreeFallMethod = true
    task.wait(0.8)
    local originalPosition = hrp.Position
    if hrp then
    hrp.CFrame = CFrame.new(originalPosition)  -- Teleport to the current position
    end
    humanoid.WalkSpeed = walkspeedValue
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    else
    getgenv().FreeFallMethod = false
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)  -- Stop freefall
    local currentPosition = hrp.Position
    if hrp then
    hrp.CFrame = CFrame.new(currentPosition)  -- Teleport back to the original location
    end
    humanoid.WalkSpeed = 16
    end
    end
    movementSection:Toggle({
    Text = "Enable Freefall",
    Callback = function(state)
    isWalkspeedEnabled = state
    toggleFreeFall(isWalkspeedEnabled)
    end
    })
    movementSection:Slider({
    Text = "Walkspeed",
    Min = 16,
    Max = 100,
    Default = walkspeedValue,
    Callback = function(value)
    walkspeedValue = value
    if humanoid then
    humanoid.WalkSpeed = walkspeedValue  -- Dynamically update WalkSpeed when the slider is adjusted
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

-- Dupe --
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local Player = Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local BackpackRemote = ReplicatedStorage:WaitForChild("BackpackRemote")
    local Inventory = ReplicatedStorage:WaitForChild("Inventory")
    getgenv().FreeFallMethod = false
    local dupeCooldown = false
    task.spawn(function()
    while task.wait() do
    if getgenv().FreeFallMethod then
    if Character and Character:FindFirstChild("Humanoid") then
    Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end
    end
    end
    end)
    local DupeTab = Window:Tab({ Text = "Dupe" })
    local GunsSection = DupeTab:Section({ Text = "Guns Section" })
    local HowToDupeSection = DupeTab:Section({ Text = "How To Dupe", Side = "Right"})
    local function showDupeScreen()
    local PlayerGui = Player:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DupeScreen"
    ScreenGui.Parent = PlayerGui
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.new(0, 0, 0)
    Background.Parent = ScreenGui
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 0.1, 0)
    Title.Position = UDim2.new(0.2, 0, 0.3, 0)
    Title.Text = "Revamped.City"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextScaled = true
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundTransparency = 1
    Title.Parent = Background
    local DupeText = Instance.new("TextLabel")
    DupeText.Size = UDim2.new(0.6, 0, 0.1, 0)
    DupeText.Position = UDim2.new(0.2, 0, 0.45, 0)
    DupeText.Text = "Duping."
    DupeText.TextColor3 = Color3.fromRGB(173, 216, 230) -- Light blue
    DupeText.TextScaled = true
    DupeText.Font = Enum.Font.SourceSansBold
    DupeText.BackgroundTransparency = 1
    DupeText.Parent = Background
    task.spawn(function()
    while ScreenGui.Parent do
    DupeText.Text = "Duping."
    task.wait(0.5)
    DupeText.Text = "Duping.."
    task.wait(0.5)
    DupeText.Text = "Duping..."
    task.wait(0.5)
    end
    end)
    return ScreenGui
    end
    local function getHeldTool()
    return Character:FindFirstChildOfClass("Tool") -- Gets the currently held gun/tool
    end
    local function freefallTeleport(position)
    getgenv().FreeFallMethod = true
    task.wait(1) -- Wait 1 second in Freefall
    Character.HumanoidRootPart.CFrame = CFrame.new(position) -- Teleport
    getgenv().FreeFallMethod = false -- Disable Freefall
    end
    local function dupeGun()
    if dupeCooldown then
    game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Dupe Gun",
    Text = "Dupe Gun is on cooldown! Please wait for 35 seconds.",
    Duration = 5
    })
    return
    end
    local tool = getHeldTool()
    if tool then
    local toolName = tool.Name
    local originalPos = Character.HumanoidRootPart.CFrame
    local safeStorage = Workspace["1# Map"]["2 Crosswalks"].Safes:GetChildren()[5] -- Safe for inventory dupe
    local DupeScreen = showDupeScreen()
    Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
    freefallTeleport(safeStorage.Union.CFrame.Position)
    task.wait(1.5) -- Wait a bit after teleporting to ensure stability
    task.spawn(function()
    BackpackRemote:InvokeServer("Store", toolName)
    end)
    task.spawn(function()
    Inventory:FireServer("Change", toolName, "Backpack", safeStorage)
    end)
    task.wait(0.5)
    freefallTeleport(originalPos.Position)
    task.wait(1.2)
    BackpackRemote:InvokeServer("Grab", toolName)
    if DupeScreen then
    DupeScreen:Destroy()
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Dupe Gun",
    Text = "Duplication Complete!",
    Duration = 5
    })
    dupeCooldown = true
    local countdown = 35
    for i = countdown, 1, -1 do
    if i % 5 == 0 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Dupe Gun Cooldown",
    Text = "Cooldown: " .. i .. " seconds remaining.",
    Duration = 5
    })
    end
    task.wait(1)
    end
     dupeCooldown = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Dupe Gun Cooldown",
    Text = "You can now use the Dupe Gun again!",
    Duration = 5
    })
    else
    game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Dupe Gun",
    Text = "No Gun Found!",
    Duration = 5
    })
    end
    end
    GunsSection:Button({
    Text = "Dupe Gun",
    Callback = function()
    dupeGun()
    end
    })
    HowToDupeSection:Button({
    Text = "How To Dupe",
    Callback = function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "How To Dupe",
    Text = "1. Equip the gun you want to duplicate.\n2. Press 'Dupe Gun' to begin the duplication process.",
    Duration = 5
    })
    end
    })

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
  
-- Open GUI's --
    local guiTab = Window:Tab({ Text = "GUI's" })
    local guiSection = guiTab:Section({ Text = "GUI" })
    local bronxClothingButton = guiSection:Button({
    Text = "Bronx Clothing",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx CLOTHING"].Enabled = true  -- Enable the "Bronx CLOTHING" GUI
    end
    })
    local bronxMarketButton = guiSection:Button({
    Text = "Bronx Market",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx Market 2"].Enabled = true  -- Enable Bronx Market 2
    end
    })
    local bronxPawningButton = guiSection:Button({
    Text = "Bronx Pawning",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx PAWNING"].Enabled = true  -- Enable the "Bronx PAWNING" GUI
    end
    })
    local bronxTattoosButton = guiSection:Button({
    Text = "Bronx Tattoos",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui["Bronx TATTOOS"].Enabled = true  -- Enable the "Bronx TATTOOS" GUI
    end
    })
    local bronxCraftingButton = guiSection:Button({
    Text = "Bronx Crafting",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui.CraftGUI.Main.Visible = true  -- Make the "CraftGUI Main" visible
    end
    })
    local bronxGarageButton = guiSection:Button({
    Text = "Bronx Garage",
    Callback = function()
    local Plr = game.Players.LocalPlayer  -- Get the local player
    Plr.PlayerGui.ColorWheel.Enabled = true  -- Enable the "Bronx Garage" (ColorWheel)
    local Notification = Instance.new("ScreenGui")
    Notification.Name = "Notification"
    Notification.Parent = game.Players.LocalPlayer.PlayerGui
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Notification
    TextLabel.Text = "Press 'Back' Unless You Have The Game Pass"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 0.5
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Position = UDim2.new(0.5, -150, 0, 20)  -- Position at the top middle of the screen
    TextLabel.Size = UDim2.new(0, 300, 0, 50)
    TextLabel.TextScaled = true
    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
    wait(3)
    Notification:Destroy()
    end
    })
    local clonedATMGui = nil
    local bronxATMToggle = guiSection:Toggle({
    Text = "Bronx ATM",
    Callback = function(isToggled)
    local Plr = game.Players.LocalPlayer  -- Get the local player
    local lighting = game:GetService("Lighting")
    local atmGui = lighting:FindFirstChild("Assets"):FindFirstChild("GUI"):FindFirstChild("ATMGui")  -- Get the ATMGui
    if isToggled then
    if atmGui then
    clonedATMGui = atmGui:Clone()
    clonedATMGui.Parent = Plr:WaitForChild("PlayerGui")
    else
    warn("ATM not found.")
    end
    else
    if clonedATMGui then
    clonedATMGui:Destroy()
    clonedATMGui = nil
    end
    end
    end
    })

-- AutoFarm --
    local autoFarmTab = Window:Tab({ Text = "Auto Farm" })
    local autoFarmSection = autoFarmTab:Section({ Text = "Auto Farms" })
    local player = game:GetService("Players").LocalPlayer
    local function teleportTo(position)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    getgenv().FreeFallMethod = true
    task.wait(0.8) -- Wait for 0.8 seconds to simulate freefall
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    getgenv().FreeFallMethod = false
    end
    end
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
    getgenv().FreeFallMethod = false
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
    local function hasPlyWood()
    return player.Backpack:FindFirstChild("PlyWood") or (player.Character and player.Character:FindFirstChild("PlyWood"))
    end
    local function isWallLabelEmpty(label)
    return label and label.Text == ""
    end
    local function holdTool(toolName)
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
    tool.Parent = player.Character
    end
    end
    local function setProximityPromptHoldDuration()
    for _, object in pairs(workspace.ConstructionStuff:GetDescendants()) do
    if object:IsA("ProximityPrompt") then
    object.HoldDuration = 0
    end
    end
    end
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
    autoFarmSection:Toggle({
    Text = "Construction Farm",
    Callback = function(state)
    if state then
    performAutofarm()
    end
    end
    })
    local isAutoFarming = false
    function hasItem(itemName)
    local backpack = game:GetService("Players").LocalPlayer.Backpack
    for _, item in ipairs(backpack:GetChildren()) do
    if item.Name == itemName then
    return true
    end
    end
    return false
    end
    function purchaseItems()
    local itemsNeeded = { "FreshWater", "Ice-Fruit Bag", "FijiWater", "Ice-Fruit Cupz" }
    for _, itemName in ipairs(itemsNeeded) do
    if not hasItem(itemName) then
    game:GetService("ReplicatedStorage"):WaitForChild("ExoticShopRemote"):InvokeServer(itemName)
    task.wait(0.5) -- Small delay to ensure item gets added
    end
    end
    end
    function setHoldDurationToZero()
    for _, obj in ipairs(workspace.CookingPots:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
     obj.HoldDuration = 0
    end
    end
    end
    function teleportWithFreeFall(targetPosition)
    getgenv().FreeFallMethod = true
    task.wait(0.8)
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
    getgenv().FreeFallMethod = false
    end
    function holdToolUntilRemoved(toolName)
    local player = game:GetService("Players").LocalPlayer
    while isAutoFarming and not hasItem(toolName) do
    task.wait(0.2)
    end
    local tool = player.Backpack:FindFirstChild(toolName)
    if tool then
    tool.Parent = player.Character -- Equip the tool
    print("Holding: " .. toolName)
    end
    while isAutoFarming and (hasItem(toolName) or player.Character:FindFirstChild(toolName)) do
    task.wait(0.2)
    end
    print(toolName .. " removed")
    end
    function teleportToSellLocationWhenCupzPressed()
    local player = game:GetService("Players").LocalPlayer
    local prompt = workspace.CookingPots.CookingPot.CookPart.ProximityPrompt
    prompt.Triggered:Wait()  -- Wait until the prompt is triggered (i.e., the player presses "E")
    teleportWithFreeFall(Vector3.new(-83.105, 286.721, -338.175))
    end
    function autoFarm()
    while isAutoFarming do
    setHoldDurationToZero()
    purchaseItems()
    teleportWithFreeFall(Vector3.new(-134.003, 283.379, -575.231))
    holdToolUntilRemoved("FreshWater")
    task.wait(0.2) -- Small buffer to ensure smooth transition
    holdToolUntilRemoved("Ice-Fruit Bag")
    task.wait(0.2)
    holdToolUntilRemoved("FijiWater")
    task.wait(0.2)
    holdToolUntilRemoved("Ice-Fruit Cupz")
    teleportToSellLocationWhenCupzPressed()
    task.wait(62)
    while isAutoFarming and hasItem("Ice-Fruit Cupz") do
    task.wait(0.2)
    end
    teleportWithFreeFall(Vector3.new(-134.003, 283.379, -575.231))
    end
    end
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
    local garbageFarmEnabled = false
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    getgenv().FreeFallMethod = false  -- Used to control FreeFall state
    task.spawn(function()
    while task.wait() do
    if getgenv().FreeFallMethod then
    if character and character:FindFirstChild("Humanoid") then
    character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end
    end
    end
    end)
    local function getAllDumpsters()
    local dumpsters = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Part") and obj.Name == "DumpsterPromt" and obj:FindFirstChildOfClass("ProximityPrompt") then
    table.insert(dumpsters, obj)
    end
    end
    return dumpsters
    end
    local function freefallTeleport(position)
    getgenv().FreeFallMethod = true  -- Enable freefall
    task.wait(0.8)  -- Wait for 0.8 seconds before teleporting
    character.HumanoidRootPart.CFrame = CFrame.new(position)
    getgenv().FreeFallMethod = false  -- Disable freefall
    end
    local function isAtPosition(position)
    return (character.HumanoidRootPart.Position - position).Magnitude < 1  -- Check if close enough
    end
    autoFarmSection:Toggle({
    Text = "Garbage Farm",
    Callback = function(state)
    garbageFarmEnabled = state
    if state then
    task.spawn(function()
    local dumpsters = getAllDumpsters()
    local currentDumpsterIndex = 1  -- Start from the first dumpster
    while garbageFarmEnabled and currentDumpsterIndex <= #dumpsters do
    local currentDumpster = dumpsters[currentDumpsterIndex]
    if currentDumpster then
    local prompt = currentDumpster:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
    prompt.HoldDuration = 0  -- Make prompt activate instantly on press
    freefallTeleport(currentDumpster.Position)
    local attemptCount = 0
    while not isAtPosition(currentDumpster.Position) and attemptCount < 3 do
    task.wait(0.5)  -- Wait a bit before checking again
    freefallTeleport(currentDumpster.Position)  -- Retry teleporting if not at the position
    attemptCount = attemptCount + 1
    end
    if isAtPosition(currentDumpster.Position) then
    prompt.Triggered:Wait()
    currentDumpsterIndex = currentDumpsterIndex + 1
    else
    print("Failed to teleport to dumpster, retrying...")
    end
    end
    end
    task.wait(0.1)  -- Small wait to avoid too fast execution
    end
    end)
    end
    end
    })

-- Money --

-- Shop --
    local shopTab = Window:Tab({ Text = "Shop" })
    local exoticDealerSection = shopTab:Section({ Text = "Exotic Dealer" })
    local function purchaseItem(itemName)
    game:GetService("ReplicatedStorage"):WaitForChild("ExoticShopRemote"):InvokeServer(itemName)
    end
    exoticDealerSection:Button({ Text = "Lemonade $500", Callback = function()
    purchaseItem("Lemonade")
    end })
    exoticDealerSection:Button({ Text = "FakeCard $700", Callback = function()
    purchaseItem("FakeCard")
    end })
    exoticDealerSection:Button({ Text = "G26 $550", Callback = function()
    purchaseItem("G26")
    end })
    exoticDealerSection:Button({ Text = "Shiesty $75", Callback = function()
    purchaseItem("Shiesty")
    end })
    exoticDealerSection:Button({ Text = "RawSteak $10", Callback = function()
    purchaseItem("RawSteak")
    end })
    exoticDealerSection:Button({ Text = "Ice-Fruit Bag $2500", Callback = function()
    purchaseItem("Ice-Fruit Bag")
    end })
    exoticDealerSection:Button({ Text = "Ice-Fruit Cupz $150", Callback = function()
    purchaseItem("Ice-Fruit Cupz")
    end })
    exoticDealerSection:Button({ Text = "FijiWater $48", Callback = function()
    purchaseItem("FijiWater")
    end })
    local backpackShopSection = shopTab:Section({ Text = "Backpack Shop" })
    local player = game:GetService("Players").LocalPlayer
    local userInputService = game:GetService("UserInputService")
    local function teleportTo(position)
    getgenv().FreeFallMethod = true
    task.wait(0.8)  -- Wait 0.8s before teleporting
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
    getgenv().FreeFallMethod = false
    end
    local function waitForEPress()
    return userInputService.InputBegan:Wait().KeyCode == Enum.KeyCode.E
    end
    local function buyBackpack(position)
    local originalPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
    teleportTo(position)  -- Teleport to backpack shop location
    repeat
    local keyPressed = waitForEPress()
    until keyPressed
    if originalPosition then
    repeat
    teleportTo(originalPosition)
    task.wait(0.5)
    until (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position - originalPosition).Magnitude < 5)
    end
    end
    local backpacks = {
    { name = "Red Elite Bag $500", position = Vector3.new(-714.2327, 253.5981, -692.7017) },
    { name = "Black Elite Bag $500", position = Vector3.new(-712.9567, 253.5981, -691.3503) },
    { name = "Blue Elite Bag $500", position = Vector3.new(-709.8685, 253.5981, -689.7072) },
    { name = "Drac Bag $700", position = Vector3.new(-706.9940, 253.5981, -689.7107) },
    { name = "Yellow RCR Bag $2000", position = Vector3.new(-699.8688, 253.5981, -694.0794) },
    { name = "Black RCR Bag $2000", position = Vector3.new(-704.7261, 253.5981, -689.7491) },
    { name = "Red RCR Bag $2000", position = Vector3.new(-702.1082, 253.5981, -691.1790) },
    { name = "Black Designer Bag $2000", position = Vector3.new(-700.9933, 253.5981, -692.5190) }
    }
    for _, bag in ipairs(backpacks) do
    backpackShopSection:Button({
    Text = bag.name,
    Callback = function()
    buyBackpack(bag.position)
    end
    })
    end
    task.spawn(function()
    while task.wait() do
    if getgenv().FreeFallMethod then
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
    local humanoid = player.Character.Humanoid
    humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end
    end
    end
    end)
    local wearablesSection = shopTab:Section({ Text = "Wearables" })
    local shiestyButton = wearablesSection:Button({
    Text = "Shiesty $25",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("Shiesty")
    end
    })
    local bluGlovesButton = wearablesSection:Button({
    Text = "BluGloves $10",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("BluGloves")
    end
    })
    local whiteGlovesButton = wearablesSection:Button({
    Text = "White Gloves $10",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("WhiteGloves")
    end
    })
    local blackGlovesButton = wearablesSection:Button({
    Text = "BlackGloves $10",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("BlackGloves")
    end
    })
    local pinkCamoGlovesButton = wearablesSection:Button({
    Text = "PinkCamoGloves $67",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("PinkCamoGloves")
    end
    })
    local redCamoGlovesButton = wearablesSection:Button({
    Text = "RedCamoGloves $67",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("RedCamoGloves")
    end
    })
    local bluCamoGlovesButton = wearablesSection:Button({
    Text = "BluCamoGloves $67",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("BluCamoGloves")
    end
    })
    local foodSection = shopTab:Section({ Text = "Food" })
    local waterButton = foodSection:Button({
    Text = "Water $10",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("Water")
    end
    })
    local rawSteakButton = foodSection:Button({
    Text = "RawSteak $10",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("RawSteak")
    end
    })
    local rawChickenButton = foodSection:Button({
    Text = "RawChicken $10",
    Callback = function()
    game:GetService("ReplicatedStorage"):WaitForChild("ShopRemote"):InvokeServer("RawChicken")
    end
    })

-- Bypasses --
    bypassTab = Window:Tab({ Text = "Bypasses" })
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
    local function setAllProximityPrompts()
    for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("ProximityPrompt") then
    object.HoldDuration = 0
    end
    end
    end
    workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
    descendant.HoldDuration = 0
    end
    end)
    local noRagdollEnabled = false
    local function toggleNoRagdoll()
    noRagdollEnabled = not noRagdollEnabled
    if noRagdollEnabled then
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

-- Rage -- 
    local RageTab = Window:Tab({ Text = "Rage" })
    local ExploitSection = RageTab:Section({ Text = "Exploit" })
    local deletedParts = {}
    local playerPositions = {}
    local Plr = game:GetService("Players").LocalPlayer
    local Mouse = Plr:GetMouse()
    local deleteEnabled = false
    local bringPlayersActive = false  -- Track bring players toggle state
    Mouse.Button1Down:connect(function()
    if not deleteEnabled then
    return
    end
    if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.C) then
    return
    end
    if not Mouse.Target then
    return
    end
    local deletedPart = Mouse.Target
    table.insert(deletedParts, deletedPart)
    deletedPart:Destroy()
    end)
    local function RestoreDeletedParts()
    for _, part in pairs(deletedParts) do
    if part.Parent == nil then
    local restoredPart = part:Clone()
    restoredPart.Parent = game.Workspace
    end
    end
    deletedParts = {}  -- Clear the list of deleted parts after restoring
    end
    local function BringPlayersInFront()
    local players = game.Players:GetPlayers()
    local angleStep = 360 / math.max(#players, 1)  -- Avoid division by zero
    local radius = 10  -- Radius of the circle around the local player
    for i, player in ipairs(players) do
    if player ~= game.Players.LocalPlayer then
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and not humanoid.SeatPart and humanoid.Health > 0 then
    if not playerPositions[player] then
    playerPositions[player] = humanoidRootPart.Position
    end
    local angle = math.rad(angleStep * i)
    local xOffset = math.cos(angle) * radius
    local zOffset = math.sin(angle) * radius
    humanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(xOffset, 0, zOffset)
    end
    end
    end
    end
    end
    local function ReturnPlayersToOriginalPosition()
    for player, originalPosition in pairs(playerPositions) do
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
    character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
    end
    end
    playerPositions = {}  -- Clear the stored positions
    end
    local DeleteToggle = ExploitSection:Toggle({
    Text = "Enable C + Delete",  -- Text for the toggle
    Callback = function(toggleState)
    deleteEnabled = toggleState
    if not deleteEnabled then
    RestoreDeletedParts()
    end
    end
    })
    local BringPlayersToggle = ExploitSection:Toggle({
    Text = "Bring All Players in Circle",  -- Text for the toggle
    Callback = function(toggleState)
    bringPlayersActive = toggleState  -- Update the tracking variable
    if bringPlayersActive then
    task.spawn(function()  -- Run in a separate thread to prevent UI lag
    while bringPlayersActive do
    BringPlayersInFront()
    wait(0.1)  -- Adjust the loop speed as needed
    end
    end)
    else
    ReturnPlayersToOriginalPosition()
    end
    end
    })

