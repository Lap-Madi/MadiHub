local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local gui = player:WaitForChild("PlayerGui")
local flyUI = gui:WaitForChild("FlyUI")
local titleLabel = flyUI:WaitForChild("TitleLabel")
local speedLabel = flyUI:WaitForChild("SpeedLabel")
local closeButton = flyUI:WaitForChild("CloseButton")

local flying = false
local speed = 50
local maxSpeed = 999
local minSpeed = 10

local bodyGyro
local bodyVelocity
local moveX = 0
local moveZ = 0

-- Cập nhật UI
local function updateUI()
	titleLabel.Visible = true
	speedLabel.Visible = true
	closeButton.Visible = true
	speedLabel.Text = "🚀 Tốc độ: " .. tostring(speed)
end

-- Ẩn UI
local function hideUI()
	titleLabel.Visible = false
	speedLabel.Visible = false
	closeButton.Visible = false
end

-- Bắt đầu bay
local function startFlying()
	flying = true

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = humanoidRootPart.CFrame
	bodyGyro.Parent = humanoidRootPart

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = humanoidRootPart

	runService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Input.Value, function()
		if flying then
			local camCF = workspace.CurrentCamera.CFrame
			local moveDir = Vector3.new(moveX, 0, moveZ)

			if moveDir.Magnitude > 0 then
				moveDir = (camCF.RightVector * moveX + camCF.LookVector * moveZ).Unit
			else
				moveDir = Vector3.zero
			end

			bodyGyro.CFrame = camCF
			bodyVelocity.Velocity = moveDir * speed
		end
	end)

	updateUI()
end

-- Tắt bay
local function stopFlying()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
	runService:UnbindFromRenderStep("FlyMovement")
	hideUI()
end

-- Nút ❌ để ẩn UI
closeButton.MouseButton1Click:Connect(function()
	hideUI()
end)

-- Xử lý nhấn phím
uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	local key = input.KeyCode

	if key == Enum.KeyCode.F then
		if flying then
			stopFlying()
		else
			startFlying()
		end

	elseif key == Enum.KeyCode.W then
		moveZ = -1
	elseif key == Enum.KeyCode.S then
		moveZ = 1
	elseif key == Enum.KeyCode.A then
		moveX = -1
	elseif key == Enum.KeyCode.D then
		moveX = 1

	elseif key == Enum.KeyCode.Equals or key == Enum.KeyCode.Plus then
		speed = math.min(speed + 10, maxSpeed)
		updateUI()
	elseif key == Enum.KeyCode.Minus then
		speed = math.max(speed - 10, minSpeed)
		updateUI()
	end
end)

-- Xử lý thả phím
uis.InputEnded:Connect(function(input)
	local key = input.KeyCode

	if key == Enum.KeyCode.W or key == Enum.KeyCode.S then
		moveZ = 0
	elseif key == Enum.KeyCode.A or key == Enum.KeyCode.D then
		moveX = 0
	end
end)