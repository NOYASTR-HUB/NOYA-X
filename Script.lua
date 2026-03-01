-- [[ NOYA X - REPAIRED & STABLE 2026 ]]
-- Menggunakan Library Orion yang aktif (Fix HTTP 404)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "NOYA X | KEYLESS", HidePremium = false, SaveConfig = true, ConfigFolder = "NoyaX_Final"})

-- [[ 1. ANTI-AFK ]]
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [[ 2. VARIABLES ]]
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- Clicker Visual (Titik Merah)
local ClickGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Cursor = Instance.new("Frame", ClickGui)
Cursor.Size = UDim2.new(0, 15, 0, 15)
Cursor.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Cursor.Visible = false
Instance.new("UICorner", Cursor).CornerRadius = UDim.new(1, 0)

_G.WalkSpeed = 16
_G.JumpPower = 50
_G.GodMode = false
_G.Aimbot = false
_G.AimbotTarget = "Head"
_G.Tracers = false
_G.HitboxSize = 2
_G.Noclip = false
_G.Fly = false
_G.FlySpeed = 50
_G.AutoClicker = false
_G.ClickPosition = Vector2.new(0,0)

-- [[ 3. TABS ]]
local HomeTab = Window:MakeTab({Name = "Home", Icon = "rbxassetid://4483362458"})
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483362458"})
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458"})
local ClickTab = Window:MakeTab({Name = "Clicker", Icon = "rbxassetid://4483362458"})

-- Fitur Buttons & Toggles
HomeTab:AddButton({Name = "📋 SALIN DISCORD", Callback = function() setclipboard("https://discord.gg/XFr5bc2eH") end})
CombatTab:AddToggle({Name = "God Mode (Kebal)", Default = false, Callback = function(v) _G.GodMode = v end})
CombatTab:AddToggle({Name = "Enable Aimbot", Default = false, Callback = function(v) _G.Aimbot = v end})
CombatTab:AddToggle({Name = "Enable ESP Tracers", Default = false, Callback = function(v) _G.Tracers = v end})
MoveTab:AddTextbox({Name = "Speed", Default = "16", Callback = function(v) _G.WalkSpeed = tonumber(v) or 16 end})
MoveTab:AddToggle({Name = "Fly (V2 Smooth)", Default = false, Callback = function(v) _G.Fly = v end})

ClickTab:AddToggle({Name = "Auto Clicker", Default = false, Callback = function(v) _G.AutoClicker = v end})
ClickTab:AddButton({Name = "SET POSISI", Callback = function()
    local conn; conn = UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            _G.ClickPosition = Vector2.new(i.Position.X, i.Position.Y)
            Cursor.Position = UDim2.new(0, i.Position.X - 7, 0, i.Position.Y - 7); Cursor.Visible = true
            conn:Disconnect()
        end
    end)
end})

-- [[ 4. ENGINES ]]
task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = _G.WalkSpeed
                    hum.JumpPower = _G.JumpPower
                    hum.UseJumpPower = true
                    if _G.GodMode and hum.Health > 0 and hum.Health < 100 then hum.Health = 100 end
                end
            end
        end)
    end
end)

-- Fly & Clicker Engine
task.spawn(function()
    while task.wait() do
        if _G.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1.5, 0)
        end
        if _G.AutoClicker then
            VIM:SendMouseButtonEvent(_G.ClickPosition.X, _G.ClickPosition.Y, 0, true, game, 0)
            VIM:SendMouseButtonEvent(_G.ClickPosition.X, _G.ClickPosition.Y, 0, false, game, 0)
        end
    end
end)

OrionLib:Init()
