-- [[ NOYA X -  ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "NOYA X|KEYLESS", HidePremium = false, SaveConfig = true, ConfigFolder = "NoyaX_Final"})

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
local HomeTab = Window:MakeTab({Name = "discord", Icon = "rbxassetid://4483362458"})
local CombatTab = Window:MakeTab({Name = "cheat", Icon = "rbxassetid://4483362458"})
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458"})
local ClickTab = Window:MakeTab({Name = "Clicker", Icon = "rbxassetid://4483362458"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483362458"})

-- HOME
HomeTab:AddButton({Name = "📋 SALIN WA", Callback = function() setclipboard("https://whatsapp.com/channel/0029VbCJBzP3WHTbqFHqei0m") end})
HomeTab:AddButton({Name = "📋 SALIN DISCORD", Callback = function() setclipboard("https://discord.gg/XFr5bc2eH") end})

-- COMBAT
CombatTab:AddToggle({Name = "God Mode (Kebal)", Default = false, Callback = function(v) _G.GodMode = v end})
CombatTab:AddToggle({Name = "Enable Aimbot", Default = false, Callback = function(v) _G.Aimbot = v end})
CombatTab:AddDropdown({Name = "Aimbot Target", Options = {"Head", "UpperTorso", "HumanoidRootPart"}, Default = "Head", Callback = function(v) _G.AimbotTarget = v end})
CombatTab:AddToggle({Name = "Enable ESP Tracers", Default = false, Callback = function(v) _G.Tracers = v end})
CombatTab:AddTextbox({Name = "Hitbox Size", Default = "2", Callback = function(v) _G.HitboxSize = tonumber(v) or 2 end})

-- MOVEMENT
MoveTab:AddTextbox({Name = "Speed", Default = "16", Callback = function(v) _G.WalkSpeed = tonumber(v) or 16 end})
MoveTab:AddTextbox({Name = "Jump", Default = "50", Callback = function(v) _G.JumpPower = tonumber(v) or 50 end})
MoveTab:AddToggle({Name = "Fly (V2 Smooth)", Default = false, Callback = function(v) _G.Fly = v end})
MoveTab:AddToggle({Name = "Noclip", Default = false, Callback = function(v) _G.Noclip = v end})

-- CLICKER
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

-- MISC
MiscTab:AddButton({Name = "🔥 DUPE ITEMS", Callback = function() player:Kick("\nAWOKAWOKAWOK [ NOYA HUB NIH ]") end})

-- [[ 4. ENGINES ]]

-- MAIN ENGINE (SPEED, JUMP, GOD, HITBOX)
task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = player.Character
            local hum = char:WaitForChild("Humanoid")
            hum.WalkSpeed = _G.WalkSpeed
            hum.JumpPower = _G.JumpPower
            hum.UseJumpPower = true -- HARUS TRUE BIAR JUMP WORK
            
            if _G.GodMode and hum.Health > 0 and hum.Health < 100 then hum.Health = 100 end
            if _G.Noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    v.Character.HumanoidRootPart.Transparency = 0.8
                end
            end
        end)
    end
end)

-- FLY ENGINE
task.spawn(function()
    while task.wait() do
        if _G.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 1.5, 0)
            local moveDir = player.Character.Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (camera.CFrame.LookVector * (moveDir.Z * -_G.FlySpeed/12)) + (camera.CFrame.RightVector * (moveDir.X * _G.FlySpeed/12))
            end
        end
    end
end)

-- AIMBOT & ESP ENGINE
local function CreateESP(p)
    local l = Drawing.new("Line")
    l.Color = Color3.fromRGB(0, 255, 255); l.Thickness = 1
    RunService.RenderStepped:Connect(function()
        if _G.Tracers and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then l.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y); l.To = Vector2.new(pos.X, pos.Y); l.Visible = true else l.Visible = false end
        else l.Visible = false end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= player then CreateESP(v) end end

RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = nil; local dist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild(_G.AimbotTarget) then
                local p, vis = camera:WorldToViewportPoint(v.Character[_G.AimbotTarget].Position)
                if vis then
                    local m = (Vector2.new(p.X, p.Y) - UIS:GetMouseLocation()).Magnitude
                    if m < dist then target = v; dist = m end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character[_G.AimbotTarget].Position) end
    end
end)

-- CLICKER
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoClicker then
            VIM:SendMouseButtonEvent(_G.ClickPosition.X, _G.ClickPosition.Y, 0, true, game, 0)
            VIM:SendMouseButtonEvent(_G.ClickPosition.X, _G.ClickPosition.Y, 0, false, game, 0)
        end
    end
end)

OrionLib:Init()
