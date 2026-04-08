local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local Cam = workspace.CurrentCamera

local Parent = (gethui and gethui()) or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
if Parent:FindFirstChild("NOYA_X_AIMBOT") then Parent.NOYA_X_AIMBOT:Destroy() end

local SG = Instance.new("ScreenGui", Parent)
SG.Name = "NOYA_X_AIMBOT"; SG.ResetOnSpawn = false

local Config = { Aim = "OFF", Hb = false }

-- GUI UTAMA
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 200, 0, 300); Main.Position = UDim2.new(0.02, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true

-- FLOATING BUTTON
local Float = Instance.new("TextButton", SG)
Float.Size = UDim2.new(0, 130, 0, 35); Float.Position = Main.Position
Float.Text = "NOYA-X AIMBOT"; Float.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Float.TextColor3 = Color3.new(1, 1, 1); Float.Font = Enum.Font.GothamBold; Float.Visible = false; Float.Draggable = true

-- HEADER
local HeadH = Instance.new("Frame", Main)
HeadH.Size = UDim2.new(1, 0, 0, 35); HeadH.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Title = Instance.new("TextLabel", HeadH)
Title.Size = UDim2.new(1, -65, 1, 0); Title.Text = " NOYA-X V23"; Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold; Title.BackgroundTransparency = 1; Title.TextXAlignment = "Left"

local X = Instance.new("TextButton", HeadH); X.Size = UDim2.new(0, 30, 0, 30); X.Position = UDim2.new(1, -35, 0.5, -15); X.Text = "X"; X.BackgroundColor3 = Color3.fromRGB(200, 0, 0); X.TextColor3 = Color3.new(1,1,1)
local Min = Instance.new("TextButton", HeadH); Min.Size = UDim2.new(0, 30, 0, 30); Min.Position = UDim2.new(1, -65, 0.5, -15); Min.Text = "-"; Min.BackgroundColor3 = Color3.fromRGB(60, 60, 60); Min.TextColor3 = Color3.new(1,1,1)

X.MouseButton1Click:Connect(function() SG:Destroy() end)
Min.MouseButton1Click:Connect(function() Main.Visible = false; Float.Position = Main.Position; Float.Visible = true end)
Float.MouseButton1Click:Connect(function() Main.Visible = true; Main.Position = Float.Position; Float.Visible = false end)

local Content = Instance.new("ScrollingFrame", Main)
Content.Position = UDim2.new(0,0,0,40); Content.Size = UDim2.new(1,0,1,-40); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 2
local List = Instance.new("UIListLayout", Content); List.Padding = UDim.new(0, 5); List.HorizontalAlignment = "Center"

local function AddBtn(txt, color, callback)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

local bAim = AddBtn("Aimbot: OFF", Color3.fromRGB(45, 45, 45), function(b)
    if Config.Aim == "OFF" then Config.Aim = "Head" elseif Config.Aim == "Head" then Config.Aim = "HumanoidRootPart" else Config.Aim = "OFF" end
    b.Text = "Aimbot: " .. Config.Aim
end)

local bHb = AddBtn("Hitbox: OFF", Color3.fromRGB(45, 45, 45), function(b)
    Config.Hb = not Config.Hb; b.Text = "Hitbox: " .. (Config.Hb and "ON" or "OFF")
end)

AddBtn("Grafik Potato", Color3.fromRGB(45, 45, 45), function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
    end
end)

AddBtn("RESET ALL", Color3.fromRGB(150, 0, 0), function()
    Config = { Aim = "OFF", Hb = false }
    bAim.Text = "Aimbot: OFF"; bHb.Text = "Hitbox + Name: OFF"
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1); v.Character.HumanoidRootPart.Transparency = 1
        end
    end
end)

AddBtn("UNLOAD", Color3.fromRGB(35, 35, 35), function() SG:Destroy() end)

-- LOOP UTAMA
RS.RenderStepped:Connect(function()
    local rb = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character then
            local head = v.Character:FindFirstChild("Head")
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            local hum = v.Character:FindFirstChild("Humanoid")
            
            if head and hrp and hum and hum.Health > 0 then
                -- Hitbox & Tag (Name + HP)
                if Config.Hb then
                    hrp.Size = Vector3.new(15,15,15); hrp.Transparency = 0.8; hrp.Color = rb
                    local tag = head:FindFirstChild("TAG") or Instance.new("BillboardGui", head)
                    tag.Name = "TAG"; tag.AlwaysOnTop = true; tag.Size = UDim2.new(0,100,0,40); tag.StudsOffset = Vector3.new(0,4,0)
                    local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag)
                    l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,1); l.TextStrokeTransparency = 0
                    l.Text = v.Name.."\nHP: "..math.floor(hum.Health); l.Font = "GothamBold"; l.TextSize = 12
                elseif head:FindFirstChild("TAG") then 
                    head.TAG:Destroy(); hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1 
                end
            end
        end
    end
    -- Aimbot Exec
    if Config.Aim ~= "OFF" then
        local target = nil; local dist = 1000
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild(Config.Aim) and v.Character.Humanoid.Health > 0 then
                local p = v.Character[Config.Aim]
                local sPos, vis = Cam:WorldToViewportPoint(p.Position)
                if vis then
                    local mag = (Vector2.new(sPos.X, sPos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                    if mag < dist then dist = mag; target = p end
                end
            end
        end
        if target then Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, target.Position) end
    end
end)
