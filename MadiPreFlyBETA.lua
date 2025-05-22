-- UI Fly Custom Tự Viết - Không Dùng OrionLib
-- Bảo đảm không crash, hỗ trợ executor yếu

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local flySpeed = 50
local flying = false

-- UI chính
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "MadiFlyUI"
ScreenGui.ResetOnSpawn = false

-- Draggable Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Name = "MainUI"
Main.AnchorPoint = Vector2.new(0.5, 0.5)

-- Bo góc
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

-- Tiêu đề
local Title = Instance.new("TextLabel", Main)
Title.Text = "MadiDepZai (BETA)"
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Nút thu nhỏ và đóng
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 2)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0, 2)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Nội dung UI
local Label = Instance.new("TextLabel", Main)
Label.Text = "Fly Speed: " .. flySpeed
Label.Position = UDim2.new(0.5, -60, 0, 40)
Label.Size = UDim2.new(0, 120, 0, 30)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.Gotham
Label.TextSize = 16
Label.TextScaled = false

local Plus = Instance.new("TextButton", Main)
Plus.Text = "+"
Plus.Size = UDim2.new(0, 50, 0, 30)
Plus.Position = UDim2.new(0.5, -55, 0, 80)
Plus.Font = Enum.Font.GothamBold
Plus.TextSize = 18
Plus.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
Plus.TextColor3 = Color3.fromRGB(255, 255, 255)

local Minus = Instance.new("TextButton", Main)
Minus.Text = "-"
Minus.Size = UDim2.new(0, 50, 0, 30)
Minus.Position = UDim2.new(0.5, 5, 0, 80)
Minus.Font = Enum.Font.GothamBold
Minus.TextSize = 18
Minus.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
Minus.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tăng/giảm speed
Plus.MouseButton1Click:Connect(function()
    flySpeed += 10
    Label.Text = "Fly Speed: " .. flySpeed
end)
Minus.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    Label.Text = "Fly Speed: " .. flySpeed
end)

-- Nút thu nhỏ và đóng UI
MinBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Main:GetChildren()) do
        if v ~= Title and v ~= MinBtn and v ~= CloseBtn then
            v.Visible = not v.Visible
        end
    end
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Thành tựu góc dưới Loading...
local Notify = Instance.new("TextLabel", ScreenGui)
Notify.Text = "Loading..."
Notify.Size = UDim2.new(0, 150, 0, 30)
Notify.Position = UDim2.new(1, -160, 1, -40)
Notify.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Notify.TextColor3 = Color3.fromRGB(255, 255, 255)
Notify.Font = Enum.Font.Gotham
Notify.TextSize = 14
Notify.TextXAlignment = Enum.TextXAlignment.Center
Notify.TextYAlignment = Enum.TextYAlignment.Center
local NotifyCorner = Instance.new("UICorner", Notify)
NotifyCorner.CornerRadius = UDim.new(0, 8)

-- Fly bằng phím F
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            rs:BindToRenderStep("MadiFlying", Enum.RenderPriority.Character.Value, function()
                local dir = Vector3.zero
                local cam = workspace.CurrentCamera
                if uis:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                hrp.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
            end)
        else
            rs:UnbindFromRenderStep("MadiFlying")
            hrp.Velocity = Vector3.zero
        end
    end
end)