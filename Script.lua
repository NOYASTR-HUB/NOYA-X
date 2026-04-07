local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- ========== SISTEM PENYIMPANAN DATA ==========
local fileName = "NoyaX_Data.json"
local stats = { totalExecute = 0, totalJoin = 0, savedPos = {x = 0, y = 0, z = 0} }

pcall(function()
    if isfile(fileName) then
        stats = HttpService:JSONDecode(readfile(fileName))
    end
    stats.totalExecute = (stats.totalExecute or 0) + 1
    stats.totalJoin = (stats.totalJoin or 0) + 1
    writefile(fileName, HttpService:JSONEncode(stats))
end)

-- ========== LOGGING DISCORD WEBHOOK ==========
task.spawn(function()
    local WebhookURL = "https://discord.com/api/webhooks/1462782745867714611/WbxolOiLjDkl_aVi-RYGdD68DrPN7kZlGn9JluK_P_APvNOZw2-32CfXSHImYiZiqQk8"
    local gameName = "Unknown Game"
    pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    
    local data = {
        ["embeds"] = {{
            ["title"] = "🚀 **NOYA-X EXECUTION**",
            ["description"] = "Seseorang telah menjalankan script NOYA-X!",
            ["color"] = 65280, -- Warna Hijau
            ["fields"] = {
                { ["name"] = "👤 **Player**", ["value"] = ">>> **User:** " .. player.Name .. "\n**ID:** " .. player.UserId, ["inline"] = false },
                { ["name"] = "🎮 **Game**", ["value"] = ">>> **Name:** " .. gameName .. "\n**Place ID:** " .. game.PlaceId, ["inline"] = false },
                { ["name"] = "📊 **Stats**", ["value"] = ">>> **Total Exec:** " .. stats.totalExecute .. "\n**Total Join:** " .. stats.totalJoin, ["inline"] = false }
            },
            ["footer"] = { ["text"] = "Sistem Log NOYA-X • " .. os.date("%X") },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local requestBody = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    local send = http_request or request or (syn and syn.request)
    
    if send then
        send({Url = WebhookURL, Method = "POST", Headers = headers, Body = requestBody})
    end
end)

-- ========== VARIABEL GLOBAL ==========
local startTime = tick()
local WalkSpeedVal, JumpPowerVal = 16, 50
local InfJump, Noclip, RespawnCancel = false, false, false
local EspEnabled, PlayerNotifyEnabled = false, false
local lastNotifyTime = 0
local Tracers = {}

local function getPlaytime()
    local s = math.floor(tick() - startTime)
    return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor((s/60)%60), s%60)
end

-- ========== MEMBUAT GUI WINDOW ==========
local Window = Rayfield:CreateWindow({
   Name = "NOYA X | v1.2",
   LoadingTitle = "NOYA X SCRIPT ALL GAME",
   LoadingSubtitle = "https://discord.gg/3kVrrdPnN",
   ConfigurationSaving = { Enabled = false }
})

-- ========== TAB 1: INFO ==========
local TabInfo = Window:CreateTab("Info")
TabInfo:CreateSection("STATISTIK PLAYER")
TabInfo:CreateLabel("USERNAME : " .. player.Name)
local LabelTotalExec = TabInfo:CreateLabel("TOTAL EXECUTE : " .. stats.totalExecute)
local LabelTotalJoin = TabInfo:CreateLabel("TOTAL JOIN : " .. stats.totalJoin)
local LabelTime = TabInfo:CreateLabel("PLAYTIME : 00:00:00")
local LabelCD = TabInfo:CreateLabel("COOLDOWN NOTIFY : READY")
TabInfo:CreateSection("INDIKATOR POSISI")
local LabelPos = TabInfo:CreateLabel("POSISI: 0, 0, 0")

-- ========== TAB 2: PLAYER ==========
local TabPlayer = Window:CreateTab("Player")
TabPlayer:CreateSection("Movement")
TabPlayer:CreateInput({ Name = "Walkspeed", PlaceholderText = "16", Callback = function(t) WalkSpeedVal = tonumber(t) or 16 end })
TabPlayer:CreateButton({ Name = "Terapkan Walkspeed", Callback = function() if player.Character then player.Character.Humanoid.WalkSpeed = WalkSpeedVal end end })

TabPlayer:CreateInput({ Name = "Jump Power", PlaceholderText = "50", Callback = function(t) JumpPowerVal = tonumber(t) or 50 end })
TabPlayer:CreateButton({ Name = "Terapkan Jump Power", Callback = function() if player.Character then player.Character.Humanoid.JumpPower = JumpPowerVal end end })

TabPlayer:CreateSection("Toggles")
TabPlayer:CreateToggle({ Name = "Noclip (Tembus Tembok)", CurrentValue = false, Callback = function(v) Noclip = v end })
TabPlayer:CreateToggle({ Name = "Unlimited Jump", CurrentValue = false, Callback = function(v) InfJump = v end })

TabPlayer:CreateSection("Sistem Respawn")
TabPlayer:CreateButton({ Name = "RESPAWN (5 DETIK)", Callback = function()
    RespawnCancel = false
    for i = 5, 1, -1 do
        if RespawnCancel then return end
        Rayfield:Notify({Title = "NOYA-X", Content = "Respawn dalam " .. i .. " detik", Duration = 1})
        task.wait(1)
    end
    if not RespawnCancel and player.Character then player.Character:BreakJoints() end
end })
TabPlayer:CreateButton({ Name = "BATALKAN RESPAWN", Callback = function() RespawnCancel = true end })

-- ========== TAB 3: ESP ==========
local TabEsp = Window:CreateTab("ESP")
TabEsp:CreateToggle({ Name = "Nyalakan ESP Rainbow", CurrentValue = false, Callback = function(v) 
    EspEnabled = v 
    if not v then for _,t in pairs(Tracers) do t.Visible = false end end 
end })
TabEsp:CreateToggle({ Name = "Notify Player Dekat", CurrentValue = false, Callback = function(v) PlayerNotifyEnabled = v end })

-- ========== TAB 4: TELEPORT ==========
local TabTp = Window:CreateTab("Teleport")
local TpInput = ""
TabTp:CreateSection("Manual Teleport")
TabTp:CreateInput({ Name = "Koordinat (X,Y,Z)", PlaceholderText = "Contoh: 100, 50, -200", Callback = function(t) TpInput = t end })
TabTp:CreateButton({ Name = "Teleport Sekarang", Callback = function()
    local coords = {}
    for v in string.gmatch(TpInput, "([^,]+)") do table.insert(coords, tonumber(v)) end
    if #coords >= 3 and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
    end
end })

TabTp:CreateSection("Quick Actions")
TabTp:CreateButton({ Name = "Salin Koordinat Saat Ini", Callback = function()
    local p = player.Character.HumanoidRootPart.Position
    setclipboard(string.format("%.2f, %.2f, %.2f", p.X, p.Y, p.Z))
    Rayfield:Notify({Title = "NOYA-X", Content = "Koordinat berhasil disalin!", Duration = 2})
end })
TabTp:CreateButton({ Name = "Simpan Posisi", Callback = function()
    local p = player.Character.HumanoidRootPart.Position
    stats.savedPos = {x = p.X, y = p.Y, z = p.Z}
    writefile(fileName, HttpService:JSONEncode(stats))
    Rayfield:Notify({Title = "NOYA-X", Content = "Posisi berhasil disimpan!", Duration = 2})
end })
TabTp:CreateButton({ Name = "TP Ke Posisi Tersimpan", Callback = function()
    if stats.savedPos and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(stats.savedPos.x, stats.savedPos.y, stats.savedPos.z)
    end
end })

-- ========== TAB 5: SETTINGS ==========
local TabSet = Window:CreateTab("Settings")
TabSet:CreateSection("Visual")
TabSet:CreateButton({ Name = "Full Bright (Selalu Siang)", Callback = function() 
    local L = game:GetService("Lighting")
    L.Brightness = 2
    L.ClockTime = 14
    L.GlobalShadows = false
    L.Ambient = Color3.new(1, 1, 1)
    L.OutdoorAmbient = Color3.new(1, 1, 1)
    Rayfield:Notify({Title = "NOYA-X", Content = "Full Bright Aktif!", Duration = 2})
end })

TabSet:CreateSection("Server & Script")
TabSet:CreateButton({ Name = "Aktifkan Anti-AFK", Callback = function() 
    player.Idled:Connect(function() 
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
        task.wait(1) 
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
    end)
    Rayfield:Notify({Title = "NOYA-X", Content = "Anti-AFK Berhasil Dijalankan!", Duration = 2})
end })
TabSet:CreateButton({ Name = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end })
TabSet:CreateButton({ Name = "Hapus Menu (Unload)", Callback = function() Rayfield:Destroy() end })

-- ========== LOGIKA UTAMA (BACKGROUND LOOP) ==========
RunService.Heartbeat:Connect(function()
    -- Update UI Info secara Real-time
    pcall(function()
        LabelTime:Set("PLAYTIME : " .. getPlaytime())
        local cd = math.floor(30 - (tick() - lastNotifyTime))
        LabelCD:Set("COOLDOWN NOTIFY : " .. (cd > 0 and (cd .. "s") or "READY"))
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            LabelPos:Set(string.format("POSISI: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
        end
    end)

    -- Logika Noclip
    if Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Logika ESP & Player Detector
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = otherPlayer.Character.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
            
            -- ESP Lines
            if EspEnabled and onScreen then
                if not Tracers[otherPlayer.Name] then 
                    Tracers[otherPlayer.Name] = Drawing.new("Line") 
                    Tracers[otherPlayer.Name].Thickness = 2 
                end
                local t = Tracers[otherPlayer.Name]
                t.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) -- Rainbow effect
                t.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                t.To = Vector2.new(pos.X, pos.Y)
                t.Visible = true
            elseif Tracers[otherPlayer.Name] then
                Tracers[otherPlayer.Name].Visible = false
            end

            -- Notify Player Sekitar
            if PlayerNotifyEnabled and (tick() - lastNotifyTime) > 30 then
                local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if distance < 50 then
                    lastNotifyTime = tick()
                    Rayfield:Notify({Title = "⚠️ PERINGATAN", Content = otherPlayer.Name .. " Berada didekatmu!", Duration = 5})
                end
            end
        end
    end
end)

-- Infinite Jump Request
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState("Jumping")
    end
end)
