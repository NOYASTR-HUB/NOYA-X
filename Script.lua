-- [[ NOYA X - ULTRA LIGHT VERSION ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "NOYA X | STABLE", HidePremium = false, SaveConfig = true, ConfigFolder = "NoyaX"})

-- Variables
local player = game.Players.LocalPlayer
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.Aimbot = false
_G.HitboxSize = 2

-- Tabs
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483362458"})

MainTab:AddTextbox({Name = "Speed", Default = "16", Callback = function(v) _G.WalkSpeed = tonumber(v) end})
MainTab:AddTextbox({Name = "Jump", Default = "50", Callback = function(v) _G.JumpPower = tonumber(v) end})
MainTab:AddToggle({Name = "Aimbot", Default = false, Callback = function(v) _G.Aimbot = v end})
MainTab:AddTextbox({Name = "Hitbox Size", Default = "2", Callback = function(v) _G.HitboxSize = tonumber(v) end})

-- Engine
task.spawn(function()
    while task.wait() do
        pcall(function()
            local hum = player.Character.Humanoid
            hum.WalkSpeed = _G.WalkSpeed
            hum.JumpPower = _G.JumpPower
            hum.UseJumpPower = true
            
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                end
            end
        end)
    end
end)

OrionLib:Init()
