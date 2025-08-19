local PremiumKeys = {  
    "JRTtibghwXeykmqzh4r3oCvzf35xtb",  
    "pFdYNaK2Phe9RHnNetFx9SqENSRogD6c",
    "GcrDNfuxZP7hxwxk6QSXex1tPVNbN4T8",
    "tD0BspG5TJoxgNCDbNc6SomEYf80LzV4",
    "ZFRKbdQfdYBi2uOKJMXtTdxeUjer8kxl",
    "d8B9McZRre3f9bYwyzMaP25SPrze7BUu",
}  
  
local BlacklistKeys = {  
    ["abc123"] = "Hành vi gian lận bị phát hiện",  
    ["badkey456"] = "Vi phạm điều khoản sử dụng",  
    ["xyz789"] = "Key đã bị thu hồi do lạm dụng"  
}  
  
local function isPremiumKey(key)  
    for _, v in ipairs(PremiumKeys) do  
        if v == key then  
            return true  
        end  
    end  
    return false  
end  
  
local function getBlacklistReason(key)  
    return BlacklistKeys[key]  
end  
  
if not script_key or getBlacklistReason(script_key) then  
    local reason = getBlacklistReason(script_key) or "Key bị chặn"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  
  
if isPremiumKey(script_key) then  
local SkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Tool-Hub-Ui"))()

local UI = SkUI:CreateWindow("SkUI V1.73 - By Ziugpro")

local Tab = UI:Create(105, "Tổng Quan")
local Fire = UI:Create(145, "Lửa Trại + Tạo")
local Web = UI:Create(110, "Webhook")
Tab:AddTextLabel("Left", "Chest")
Tab:AddToggle("Left", "Tự Động Mở Rương (Auto)", false, function(v)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    _G.AutoChestData = _G.AutoChestData or {running = false, originalCFrame = nil}

    local function getChests()
        return table.create(#workspace:GetDescendants(), function(_, obj)
            return obj:IsA("Model") and obj.Name:find("Item Chest") and obj or nil
        end)
    end

    local function getPrompts(model)
        local prompts = {}
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                table.insert(prompts, obj)
            end
        end
        return prompts
    end

    if v and not _G.AutoChestData.running then
        _G.AutoChestData.running = true
        _G.AutoChestData.originalCFrame = humanoidRootPart.CFrame

        task.spawn(function()
            while _G.AutoChestData.running do
                for _, chest in ipairs(getChests()) do
                    if not _G.AutoChestData.running then break end

                    local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                    if part then
                        humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)

                        for _, prompt in ipairs(getPrompts(chest)) do
                            pcall(fireproximityprompt, prompt, math.huge)
                        end

                        local t = tick()
                        repeat task.wait() until not _G.AutoChestData.running or tick() - t >= 4
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        _G.AutoChestData.running = false
        if _G.AutoChestData.originalCFrame then
            humanoidRootPart.CFrame = _G.AutoChestData.originalCFrame
        end
    end
end)
local chestRange = 50

Tab:AddSlider("Left", "Rương Mở Tầm Xa", 1, 100, 50, function(val)
    chestRange = val
end)

Tab:AddToggle("Left", "Rương Tự Động Mở (Gần)", false, function(v)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    _G.AutoChestNearby = _G.AutoChestNearby or {running = false}

    local function getPromptsInRange(range)
        local prompts = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:find("Item Chest") then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part and (humanoidRootPart.Position - part.Position).Magnitude <= range then
                    for _, p in ipairs(obj:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then
                            table.insert(prompts, p)
                        end
                    end
                end
            end
        end
        return prompts
    end

    if v and not _G.AutoChestNearby.running then
        _G.AutoChestNearby.running = true
        task.spawn(function()
            while _G.AutoChestNearby.running do
                for _, prompt in ipairs(getPromptsInRange(chestRange)) do
                    pcall(fireproximityprompt, prompt, math.huge)
                end
                task.wait(0.3)
            end
        end)
    else
        _G.AutoChestNearby.running = false
    end
end)
Tab:AddButton("Left", "Dịch Chuyển Đến Rương", function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local nearestChest, nearestDist, targetPart
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (humanoidRootPart.Position - part.Position).Magnitude
                if not nearestDist or dist < nearestDist then
                    nearestDist = dist
                    nearestChest = obj
                    targetPart = part
                end
            end
        end
    end

    if targetPart then
        humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, targetPart.Size.Y/2 + 6, 0)
    end
end)
Tab:AddTextLabel("Left", "Giết")
_G.killRange = _G.killRange or 10
_G.killAuraConn = _G.killAuraConn or nil

Tab:AddSlider("Left", "Tầm Giết", 1, 50, _G.killRange, function(val)
    _G.killRange = val
end)

Tab:AddToggle("Left", "Giết Aura", false, function(enabled)
    if _G.killAuraConn then
        _G.killAuraConn:Disconnect()
        _G.killAuraConn = nil
    end

    if enabled then
        local player = game.Players.LocalPlayer
        if not player then return end
        local runService = game:GetService("RunService")

        _G.killAuraConn = runService.Heartbeat:Connect(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local range = _G.killRange or 10
            for _, model in ipairs(workspace:GetDescendants()) do
                if model:IsA("Model") and model ~= char then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local targetHrp = model:FindFirstChild("HumanoidRootPart")
                    if hum and targetHrp and hum.Health > 0 then
                        if (hrp.Position - targetHrp.Position).Magnitude <= range then
                            pcall(function()
                                hum.Health = 0
                            end)
                        end
                    end
                end
            end
        end)
    end
end)
Tab:AddToggle("Left", "Giết Aura (Đã Sửa)", false, function(v)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    if not _G.KillAuraa then
        _G.KillAuraa = {running = false}
    end

    if v then
        if _G.KillAuraa.running then return end
        _G.KillAuraa.running = true
        task.spawn(function()
            while _G.KillAuraa.running do
                local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and not tool.Parent:IsA("Model") then
                    humanoid:EquipTool(tool)
                end
                tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, mob in ipairs(workspace.Character:GetChildren()) do
                        local target = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("HitRegisters")
                        if target then
                            tool:Activate()
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        _G.KillAuraa.running = false
    end
end)
Tab:AddToggle("Left", "Giết Aura (Thử Nghiệm)", false, function(v)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    if not _G.KillAura then
        _G.KillAura = {running = false}
    end

    if v then
        if _G.KillAura.running then return end
        _G.KillAura.running = true
        task.spawn(function()
            while _G.KillAura.running do
                local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and not tool.Parent:IsA("Model") then
                    humanoid:EquipTool(tool)
                end
                tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, mob in ipairs(workspace.Character:GetChildren()) do
                        local target = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("HitRegisters")
                        if target then
                            tool:Activate()
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        _G.KillAura.running = false
    end
end)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local selectedTool = nil

Tab:AddMultiDropdown("Left", "Chọn Vũ Khí", {}, {}, function(choices)
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and table.find(choices, tool.Name) then
            selectedTool = tool.Name
        end
    end
end)

Tab:AddToggle("Left", "Tự Động Cày", false, function(v)
    if not _G.AutoFarm then
        _G.AutoFarm = {running = false}
    end
    if v then
        if _G.AutoFarm.running then return end
        _G.AutoFarm.running = true
        task.spawn(function()
            while _G.AutoFarm.running do
                local tool = player.Backpack:FindFirstChild(selectedTool) or char:FindFirstChild(selectedTool)
                if tool and humanoid then
                    humanoid:EquipTool(tool)
                end
                for _, mob in ipairs(workspace:GetDescendants()) do
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        char:MoveTo(hrp.Position + Vector3.new(0, 3, 0))
                        if char:FindFirstChild(selectedTool) then
                            char[selectedTool]:Activate()
                        end
                        while hum.Health > 0 and _G.AutoFarm.running do
                            if char:FindFirstChild(selectedTool) then
                                char[selectedTool]:Activate()
                            end
                            task.wait(1)
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        _G.AutoFarm.running = false
    end
end)
Tab:AddTextLabel("Left", "Bay")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local flyUpLoop, flyUpNightLoop = false, false
local connAllTime, connNightOnly

local function getTargetY(hrp)
    local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
    local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
    return (part and pos.Y or hrp.Position.Y) + 150
end

Tab:AddToggle("Left", "Bay Lên (Mọi Thời Gian)", false, function(v)
    local char = player.Character
    if not char then return end
    local hrp, hum = char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    flyUpLoop = v
    hum.PlatformStand = v

    if v then
        local targetY = getTargetY(hrp)
        connAllTime = RunService.Heartbeat:Connect(function()
            if not flyUpLoop or not hrp.Parent then return end
            hrp.Velocity = Vector3.zero
            hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
        end)
    elseif connAllTime then
        connAllTime:Disconnect()
        connAllTime = nil
    end
end)

Tab:AddToggle("Left", "Bay Lên (Chỉ Buổi Tối)", false, function(v)
    local char = player.Character
    if not char then return end
    local hrp, hum = char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    flyUpNightLoop = v
    if v then
        local t = Lighting.ClockTime
        if t >= 18 or t < 6 then
            hum.PlatformStand = true
            local targetY = getTargetY(hrp)
            connNightOnly = RunService.Heartbeat:Connect(function()
                if not flyUpNightLoop or not hrp.Parent then return end
                local currentT = Lighting.ClockTime
                if currentT >= 18 or currentT < 6 then
                    hrp.Velocity = Vector3.zero
                    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                end
            end)
        else
            Tab:SetValue("Bay Lên (Chỉ Buổi Tối)", false)
        end
    elseif connNightOnly then
        connNightOnly:Disconnect()
        connNightOnly = nil
        hum.PlatformStand = false
    end
end)
Tab:AddTextLabel("Left", "Khác")
local noclipEnabled = false

Tab:AddToggle("Left", "Xuyên Tường", false, function(v)
    noclipEnabled = v
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local character = player.Character

    if noclipEnabled then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)
Tab:AddButton("Left", "Dịch Chuyển Xuyên Tường", function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return
    end

    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end

    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then
        return
    end

    local CurrentPosition = RootPart.Position
    local CurrentCFrame = RootPart.CFrame
    local FacingDirection = CurrentCFrame.LookVector

    local DashMagnitude = 30
    local DashOffset = Vector3.new(0, 1.25, 0)

    local DashVector = FacingDirection * DashMagnitude
    local Destination = CurrentPosition + DashVector + DashOffset

    local BodyPosition = Instance.new("BodyPosition")
    BodyPosition.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    BodyPosition.P = 1e5
    BodyPosition.D = 2000
    BodyPosition.Position = Destination
    BodyPosition.Parent = RootPart

    local DashDuration = 0.2
    local Connection = nil
    local StartTime = tick()

    Connection = RunService.RenderStepped:Connect(function()
        if tick() - StartTime >= DashDuration then
            BodyPosition:Destroy()
            if Connection then
                Connection:Disconnect()
            end
        end
    end)
end)
Tab:AddToggle("Left", "Nhảy Vô Hạng", false, function(v)
    if _G.infinityJumpConn then
        _G.infinityJumpConn:Disconnect()
        _G.infinityJumpConn = nil
    end

    if v then
        _G.infinityJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)
Tab:AddToggle("Left", "Không Bóng Tối", false, function(v)
    _G.NoShadows = v
    if v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("SpotLight") or obj:IsA("PointLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
            end
        end
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.CastShadow = false
        end
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.ShadowSoftness = 0
    else
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = true
        lighting.ShadowSoftness = 0.5
    end
end)
local player = game.Players.LocalPlayer

Tab:AddToggle("Left", "Bất Tử", false, function(v)
    _G.GodMode = v
    if v then
        while _G.GodMode do
            task.wait(0.1)
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                end
            end
        end
    else
        _G.GodMode = false
    end
end)
Tab:RealLine("Left")
Tab:AddTextLabel("Right", "Vật Phẩm")
local selectedModel = "Carrot"

Tab:AddMultiDropdown("Right", "Chọn Vật Phẩm", {"Carrot", "Morsel", "Tree", "Bunny", "Log", "Rife"}, "Carrot", function(choice)
    selectedModel = choice
end)

Tab:AddButton("Right", "Mang Vật Phẩm", function()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local model = workspace:FindFirstChild(selectedModel)
    if model and model:IsA("Model") then
        if not model.PrimaryPart then
            local found = false
            for _, part in pairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    model.PrimaryPart = part
                    found = true
                    break
                end
            end
            if not found then return end
        end
        model:SetPrimaryPartCFrame(rootPart.CFrame * CFrame.new(0, 0, -5))
    end
end)
Tab:AddTextLabel("Right", "Cây")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

Tab:AddToggle("Right", "Tự Động Chặt Cây", false, function(v)
    _G.AutoChop = v
    if v then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoChop do
            task.wait()
            local trees = {}
            for _, m in pairs(workspace:GetDescendants()) do
                if m:IsA("Model") and m.Name == "Small Tree" and m.PrimaryPart then
                    table.insert(trees, m)
                end
            end
            if #trees == 0 then break end
            for _, tree in ipairs(trees) do
                if not _G.AutoChop then break end
                if hrp and tree.PrimaryPart then
                    hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0, 0, -3)
                    UIS.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1}, false)
                    task.wait(1)
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoChop = false
    end
end)
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

Tab:AddToggle("Right", "Tự Động Chặt Cây (v2)", false, function(v)
    _G.AutoChopTP = v
    if v then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoChopTP do
            task.wait(0.3)
            local trees = {}
            for _, tree in pairs(workspace:GetDescendants()) do
                if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                    table.insert(trees, tree)
                end
            end
            for _, tree in ipairs(trees) do
                if not _G.AutoChopTP then break end
                if hrp and tree.PrimaryPart then
                    hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0,0,-3)
                    UIS.InputBegan:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                    task.wait(0.1)
                    UIS.InputEnded:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                    task.wait(0.5)
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoChopTP = false
    end
end)
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

Tab:AddToggle("Right", "Tự Động Chặt Cây (Thử Nghiệm)", false, function(v)
    _G.AutoChopFake = v
    if v then
        while _G.AutoChopFake do
            task.wait(0.3)
            for _, tree in pairs(workspace:GetDescendants()) do
                if not _G.AutoChopFake then break end
                if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                    local fakeCFrame = tree.PrimaryPart.CFrame * CFrame.new(0,0,-3)
                    UIS.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1, Position = fakeCFrame.Position}, false)
                    task.wait(0.1)
                    UIS.InputEnded:Fire({UserInputType = Enum.UserInputType.MouseButton1, Position = fakeCFrame.Position}, false)
                end
            end
        end
    else
        _G.AutoChopFake = false
    end
end)
Tab:AddTextLabel("Right", "Tốc Độ")
local speed = 50

Tab:AddSlider("Right", "Tốc Độ", 1, 300, 50, function(val)
    speed = val
end)

Tab:AddButton("Right", "Đặt Tốc Độ", function()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end)
Tab:AddToggle("Right", "Tốc Độ Tối Đa", false, function(Value)
    _G.Speed100 = Value

    local player = game:GetService("Players").LocalPlayer
    if not player then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if _G.Speed100 == true then
        humanoid.WalkSpeed = 100
    elseif _G.Speed100 == false then
        humanoid.WalkSpeed = 16
    end
end)
Tab:RealLine("Right")
Tab:AddTextLabel("Right", "Định Vị")
Tab:AddToggle("Right", "Định Vị Người Chơi", false, function(v)
    _G.ToggleESPPlayers = v

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local existingESP = char:FindFirstChild("SUPER_ESP_GUI")

                if v and not existingESP then
                    local ESPGui = Instance.new("BillboardGui")
                    ESPGui.Name = "SUPER_ESP_GUI"
                    ESPGui.Adornee = char:FindFirstChild("HumanoidRootPart")
                    ESPGui.Size = UDim2.new(0, 200, 0, 50)
                    ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                    ESPGui.AlwaysOnTop = true
                    ESPGui.ResetOnSpawn = false
                    ESPGui.Parent = char

                    local BackgroundFrame = Instance.new("Frame")
                    BackgroundFrame.Name = "BackgroundFrame"
                    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    BackgroundFrame.BackgroundTransparency = 0.5
                    BackgroundFrame.BorderSizePixel = 0
                    BackgroundFrame.Parent = ESPGui

                    local StrokeFrame = Instance.new("UIStroke")
                    StrokeFrame.Color = Color3.fromRGB(255, 85, 85)
                    StrokeFrame.Thickness = 2
                    StrokeFrame.Transparency = 0.1
                    StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    StrokeFrame.Parent = BackgroundFrame

                    local Label = Instance.new("TextLabel")
                    Label.Name = "PlayerName"
                    Label.Size = UDim2.new(1, 0, 1, 0)
                    Label.Position = UDim2.new(0, 0, 0, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = "🧍 " .. player.DisplayName
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextStrokeTransparency = 0
                    Label.TextScaled = true
                    Label.Font = Enum.Font.GothamBold
                    Label.Parent = BackgroundFrame
                elseif not v and existingESP then
                    existingESP:Destroy()
                end
            end
        end
    end
end)
Tab:AddToggle("Right", "Định Vị NPC", false, function(v)
    _G.ToggleESPNPCs = v

    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local isPlayerChar = false
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character == model then
                    isPlayerChar = true
                    break
                end
            end

            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")

            if v and not isPlayerChar and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model:FindFirstChild("HumanoidRootPart")
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model

                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui

                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(255, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "🤖 " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame

            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:AddToggle("Right", "Định Vị Quái Vật/Động Vật", false, function(v)
    _G.ToggleESPMobs = v
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            local isPlayerChar = false
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character == model then
                    isPlayerChar = true
                    break
                end
            end
            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")
            if v and not isPlayerChar and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model:FindFirstChild("HumanoidRootPart")
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model
                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui
                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(255, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "🐾 " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame
            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:AddToggle("Right", "Định Vị Đinh Tán", false, function(v)
    _G.ESPBolt = v
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model.Name == "Bolt" then
            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")
            if v and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model.HumanoidRootPart
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model

                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui

                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(255, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "⚡ " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame

            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:AddToggle("Right", "Định Vị Gỗ", false, function(v)
    _G.ESPLog = v
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model.Name == "Log" then
            local existingESP = model:FindFirstChild("SUPER_ESP_GUI")
            if v and not existingESP then
                local ESPGui = Instance.new("BillboardGui")
                ESPGui.Name = "SUPER_ESP_GUI"
                ESPGui.Adornee = model.HumanoidRootPart
                ESPGui.Size = UDim2.new(0, 200, 0, 50)
                ESPGui.StudsOffset = Vector3.new(0, 5, 0)
                ESPGui.AlwaysOnTop = true
                ESPGui.ResetOnSpawn = false
                ESPGui.Parent = model

                local BackgroundFrame = Instance.new("Frame")
                BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
                BackgroundFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BackgroundFrame.BackgroundTransparency = 0.5
                BackgroundFrame.BorderSizePixel = 0
                BackgroundFrame.Parent = ESPGui

                local StrokeFrame = Instance.new("UIStroke")
                StrokeFrame.Color = Color3.fromRGB(0, 255, 0)
                StrokeFrame.Thickness = 2
                StrokeFrame.Transparency = 0.1
                StrokeFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                StrokeFrame.Parent = BackgroundFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = "🌲 " .. model.Name
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextStrokeTransparency = 0
                Label.TextScaled = true
                Label.Font = Enum.Font.GothamBold
                Label.Parent = BackgroundFrame

            elseif not v and existingESP then
                existingESP:Destroy()
            end
        end
    end
end)
Tab:RealLine("Right")

--{ Tab Khác }--
Fire:AddTextLabel("Left", "Lửa Trại")
Fire:AddToggle("Left", "Tự Động Lửa (Dịch Chuyển)", false, function(v)
    if v then
        _G.AutoLog = true
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoLog do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoLog then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoLog = false
    end
end)
Fire:AddToggle("Left", "Tự Động Lửa (Than)", false, function(v)
    if v then
        _G.AutoCoal = true
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoCoal do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoCoal then break end
                if m:IsA("Model") and m.Name == "Coal" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoCoal = false
    end
end)
Fire:AddToggle("Left", "Tự Động Nấu Ăn (Dịch Chuyển)", false, function(v)
    if v then
        _G.AutoMorsel = true
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoMorsel do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoMorsel then break end
                if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoMorsel = false
    end
end)
Fire:AddToggle("Left", "Tự Động Lửa (Mang)", false, function(v)
    if v then
        _G.BringLogs = true
        while _G.BringLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.BringLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.BringLogs = false
    end
end)

Fire:AddToggle("Left", "Auto Cooked (Bring)", false, function(v)
    if v then
        _G.BringMorsels = true
        while _G.BringMorsels do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.BringMorsels then break end
                if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.BringMorsels = false
    end
 end)
Fire:AddButton("Left", "Dịch Chuyển Đến Trại", function()
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207)
    end
end)
Fire:AddText("Left", "Sử dụng Auto Fire và Auto Cooked Teleport sẽ hiệu quả hơn Bring và Bring có thể bị lỗi")
Fire:RealLine("Left")
Fire:AddTextLabel("Right", "Chế Tạo")
Fire:AddToggle("Right", "Tự Động Gỗ (Mang Đến)", false, function(v)
    if v then
        _G.CollectLogs = true
        while _G.CollectLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.CollectLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.CollectLogs = false
    end
end)

Fire:AddToggle("Right", "Tự Động Đinh Tán (Mang Đến)", false, function(v)
    if v then
        _G.CollectBolt = true
        while _G.CollectBolt do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.CollectBolt then break end
                if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then
                    m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                    task.wait(0.2)
                end
            end
        end
    else
        _G.CollectMorsels = false
    end
end)
Fire:AddToggle("Right", "Tự Động Gỗ (Dịch Chuyển)", false, function(v)
    if v then
        _G.AutoLogs = true
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoLogs do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoLogs then break end
                if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoLogs = false
    end
end)

Fire:AddToggle("Right", "Tự Động Đinh Tán (Dịch Chuyển)", false, function(v)
    if v then
        _G.AutoBolts = true
        local player = game.Players.LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local originalPos = hrp and hrp.CFrame
        while _G.AutoBolts do
            task.wait()
            for _, m in pairs(workspace:GetDescendants()) do
                if not _G.AutoBolts then break end
                if m:IsA("Model") and m.Name == "Bolt" and m.PrimaryPart then
                    if hrp then
                        hrp.CFrame = m.PrimaryPart.CFrame
                        m:SetPrimaryPartCFrame(CFrame.new(20.82342529296875, 7.753311634063721, -5.534992694854736))
                        task.wait(0.2)
                    end
                end
            end
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    else
        _G.AutoBolts = false
    end
end)
Fire:RealLine("Right")
    else  
    game:GetService("Players").LocalPlayer:Kick("Sai Key")  
end
