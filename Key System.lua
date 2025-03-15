-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local KeyLabel = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local SubmitButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 200)
Frame.Position = UDim2.new(0.5, -200, 0.5, -100)

KeyLabel.Parent = Frame
KeyLabel.Size = UDim2.new(0, 200, 0, 50)
KeyLabel.Position = UDim2.new(0.5, -100, 0, 20)
KeyLabel.Text = "Enter your key:"

KeyInput.Parent = Frame
KeyInput.Size = UDim2.new(0, 200, 0, 50)
KeyInput.Position = UDim2.new(0.5, -100, 0, 80)

SubmitButton.Parent = Frame
SubmitButton.Size = UDim2.new(0, 200, 0, 50)
SubmitButton.Position = UDim2.new(0.5, -100, 0, 140)
SubmitButton.Text = "Submit"

-- Loadstring for Key Validation
local validKeys = loadstring("return {\"key1\", \"key2\", \"key3\"}")()  -- List of valid keys

function validateKey(inputKey)
    for _, key in ipairs(validKeys) do
        if key == inputKey then
            return true
        end
    end
    return false
end

-- Loadstring for HWID Validation
local validHWIDs = loadstring("return {123456789, 987654321}")()  -- List of valid UserIds (HWIDs)

function validateHWID(playerUserId)
    for _, hwid in ipairs(validHWIDs) do
        if hwid == playerUserId then
            return true
        end
    end
    return false
end

-- Button Click Logic
SubmitButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text
    local playerUserId = game.Players.LocalPlayer.UserId

    -- Validate key
    if validateKey(enteredKey) then
        print("Key is valid!")

        -- Validate HWID
        if validateHWID(playerUserId) then
            print("HWID is valid!")
            -- Allow access to features or unlock GUI
        else
            print("Invalid HWID!")
            -- Deny access or show error
        end
    else
        print("Invalid key!")
        -- Show error or deny access
    end
end)
