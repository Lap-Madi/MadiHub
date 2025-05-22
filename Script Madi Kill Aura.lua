--// Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Madi BF V1 BETA",
    SubTitle = "by Madi",
    TabWidth = 120,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = true, -- blur nền
    Theme = "Darker", -- Light / Darker / Aqua / etc
    MinimizeKey = Enum.KeyCode.LeftControl
})

--// Tab + Section
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "🧠" }),
}
local Section = Tabs.Main:AddSection("⚔️ Kill Aura")

--// Kill Aura Toggle State
local KillAuraEnabled = false

--// Function để xử lý Kill Aura
local function StartKillAura()
    task.spawn(function()
        while KillAuraEnabled do
            task.wait(0.1)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                if not (char:FindFirstChild("EquippedWeapon") and char:FindFirstChild("HumanoidRootPart")) then return end

                local targets = {}
                for _, container in ipairs({workspace.Enemies, workspace.Characters}) do
                    for _, v in ipairs(container:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") and 
                            (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude < 50 then
                            table.insert(targets, v)
                        end
                    end
                end

                local Net = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net")
                Net:WaitForChild("RE"):WaitForChild("RegisterAttack"):FireServer(-math.huge)

                local args = {targets[1].Head, {}}
                for i, v in ipairs(targets) do
                    args[2][i] = {v, v.HumanoidRootPart}
                end
                Net:WaitForChild("RE"):WaitForChild("RegisterHit"):FireServer(unpack(args))
            end)
        end
    end)
end

--// Toggle trong UI
Section:AddToggle("KillAuraToggle", {
    Title = "Bật Kill Aura",
    Default = false,
    Callback = function(value)
        KillAuraEnabled = value
        if KillAuraEnabled then
            StartKillAura()
        end
    end
})

--// Phím F để bật/tắt Kill Aura
game:GetService("UserInputService").InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.F then
        KillAuraEnabled = not KillAuraEnabled
        Fluent:Notify({
            Title = "Kill Aura",
            Content = KillAuraEnabled and "Đã bật!" or "Đã tắt!",
            Duration = 2
        })
        if KillAuraEnabled then
            StartKillAura()
        end
    end
end)