pcall(function() game.CoreGui:FindFirstChild("MadiHub"):Destroy() end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- GUI setup
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "MadiHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.05, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Madi Hub - Headshot Aimbot"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.BackgroundTransparency = 1
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local AimButton = Instance.new("TextButton", Frame)
AimButton.Text = "Aimbot: OFF"
AimButton.Font = Enum.Font.Gotham
AimButton.TextSize = 16
AimButton.TextColor3 = Color3.new(1,1,1)
AimButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimButton.BorderSizePixel = 0
AimButton.Size = UDim2.new(0, 260, 0, 40)
AimButton.Position = UDim2.new(0, 15, 0, 60)
AimButton.Parent = Frame

local enabled = false

local function toggleAimbot()
    enabled = not enabled
    AimButton.Text = "Aimbot: " .. (enabled and "ON" or "OFF")
end

AimButton.MouseButton1Click:Connect(toggleAimbot)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleAimbot()
    end
end)

-- Tìm mục tiêu gần con trỏ chuột nhất
local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, visible = camera:WorldToViewportPoint(plr.Character.Head.Position)
            if visible then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = plr
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if not enabled then return end

    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local cameraCFrame = camera.CFrame
        local direction = (head.Position - cameraCFrame.Position).Unit
        camera.CFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + direction)
    end
end)
