-- ============================================================
-- 龙卷脚本 · 绿色主题整合版（含强制第三人称）
-- ============================================================

-- [1] 加载 WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [2] 绿色主题
WindUI:AddTheme({
    Name = "GreenHairTheme", Accent = "2E4A3D", Outline = "3A6B4D",
    Text = "FFFFFF", Placeholder = "A3D9B6",
})

-- [3] 复制函数
local function CopyToClipboard(text)
    text = tostring(text)
    if setclipboard then setclipboard(text) return true
    elseif toclipboard then toclipboard(text) return true
    elseif setrbxclipboard then setrbxclipboard(text) return true
    end
    return false
end

local CopyItems = {
    { Title = "复制 QQ 群",   Icon = "users", Text = "1107181697" },
    { Title = "复制作者名",   Icon = "user",  Text = "CypTec" },
    { Title = "复制脚本链接", Icon = "link",  Text = "https://example.com" },
}

-- [4] 基础服务
local Players  = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera   = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

-- [5] 通知
local function Notify(title, content, duration, icon)
    pcall(function()
        WindUI:Notify({
            Title = tostring(title or "提示"),
            Content = tostring(content or ""),
            Duration = duration or 3,
            Icon = icon or "info",
        })
    end)
end

-- [6] 功能列表显示
local FeatureDisplayEnabled = true
local EnabledFeatures = {}
local FeatureItems = {}
local FeatureGui = Instance.new("ScreenGui")
FeatureGui.Name = "FeatureDisplay"
FeatureGui.Parent = game:GetService("CoreGui")
FeatureGui.ResetOnSpawn = false

local Container = Instance.new("Frame")
Container.AnchorPoint = Vector2.new(1, 0)
Container.Position = UDim2.new(1, -10, 0, 10)
Container.Size = UDim2.new(0, 200, 0, 300)
Container.BackgroundTransparency = 1
Container.Parent = FeatureGui

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 4)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIList.Parent = Container

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local function Rainbow() return Color3.fromHSV((tick()*0.25)%1,1,1) end

local function RefreshFeatureUI()
    Container.Visible = FeatureDisplayEnabled
    if not FeatureDisplayEnabled then return end
    for name, item in pairs(FeatureItems) do
        if not table.find(EnabledFeatures, name) and item then
            TweenService:Create(item, TweenInfo.new(0.25), {
                Size = UDim2.new(0, item.Size.X.Offset, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            for _, v in pairs(item:GetChildren()) do
                if v:IsA("TextLabel") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        TextTransparency = 1, TextStrokeTransparency = 1
                    }):Play()
                end
            end
            task.delay(0.25, function() if item then item:Destroy() end end)
            FeatureItems[name] = nil
        end
    end
    for _, name in ipairs(EnabledFeatures) do
        if not FeatureItems[name] then
            local textSize = TextService:GetTextSize(name, 14, Enum.Font.SourceSansBold, Vector2.new(1000,20))
            local width = textSize.X + 10
            local item = Instance.new("Frame")
            item.Size = UDim2.new(0, 0, 0, 16)
            item.BackgroundTransparency = 1
            item.BackgroundColor3 = Color3.new(0,0,0)
            item.BorderSizePixel = 0
            item.Parent = Container
            Instance.new("UICorner", item).CornerRadius = UDim.new(0,10)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,-6,1,0)
            label.Position = UDim2.new(0,3,0,0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextTransparency = 1
            label.TextStrokeTransparency = 1
            label.TextStrokeColor3 = Color3.new(0,0,0)
            label.Parent = item
            task.spawn(function()
                while label.Parent do
                    label.TextColor3 = Rainbow()
                    task.wait(0.05)
                end
            end)
            task.spawn(function()
                task.wait()
                TweenService:Create(item, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, width, 0, 20), BackgroundTransparency = 0.5
                }):Play()
                task.wait(0.1)
                TweenService:Create(label, TweenInfo.new(0.3), {
                    TextTransparency = 0, TextStrokeTransparency = 0.3
                }):Play()
            end)
            FeatureItems[name] = item
        end
    end
end

local function AddFeature(name)
    if name == "龙卷" then
        for i, v in ipairs(EnabledFeatures) do
            if v == "龙卷" then table.remove(EnabledFeatures, i) break end
        end
        table.insert(EnabledFeatures, 1, name)
    else
        if not table.find(EnabledFeatures, name) then
            table.insert(EnabledFeatures, name)
        end
    end
    RefreshFeatureUI()
end

local function RemoveFeature(name)
    for i, v in ipairs(EnabledFeatures) do
        if v == name then table.remove(EnabledFeatures, i) break end
    end
    RefreshFeatureUI()
end

-- [7] 自身血量显示
local HealthDisplay = { Enabled = true, Position = "LeftTop", Label = nil }
local HealthGui = Instance.new("ScreenGui")
HealthGui.Name = "SelfHealthDisplay"
HealthGui.ResetOnSpawn = false
HealthGui.Parent = game:GetService("CoreGui")

local function CreateHealthUI()
    if HealthDisplay.Label then HealthDisplay.Label:Destroy() end
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 0, 20)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.Text = "HP: -- / --"
    label.Parent = HealthGui
    HealthDisplay.Label = label
end

local function UpdatePosition()
    local label = HealthDisplay.Label
    if not label then return end
    if HealthDisplay.Position == "LeftTop" then
        label.Position = UDim2.new(0, 10, 0, 10)
        label.TextXAlignment = Enum.TextXAlignment.Left
    elseif HealthDisplay.Position == "RightTop" then
        label.Position = UDim2.new(1, -150, 0, 10)
        label.TextXAlignment = Enum.TextXAlignment.Right
    elseif HealthDisplay.Position == "LeftBottom" then
        label.Position = UDim2.new(0, 10, 1, -30)
        label.TextXAlignment = Enum.TextXAlignment.Left
    elseif HealthDisplay.Position == "RightBottom" then
        label.Position = UDim2.new(1, -150, 1, -30)
        label.TextXAlignment = Enum.TextXAlignment.Right
    end
end

CreateHealthUI()
UpdatePosition()

task.spawn(function()
    while true do
        if HealthDisplay.Enabled and HealthDisplay.Label then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                local cur = math.floor(hum.Health)
                local max = math.max(1, math.floor(hum.MaxHealth))
                local pct = cur / max
                local color = pct > 0.6 and Color3.fromRGB(0,255,0) or (pct > 0.3 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0))
                HealthDisplay.Label.TextColor3 = color
                HealthDisplay.Label.Text = "HP: " .. cur .. " / " .. max
                HealthDisplay.Label.Visible = true
            end
        elseif HealthDisplay.Label then
            HealthDisplay.Label.Visible = false
        end
        task.wait(0)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    CreateHealthUI()
    UpdatePosition()
end)

-- [8] 强制第三人称
local ThirdPersonUnlock = {
    Enabled = false,
    Connection = nil
}

local function ApplyUnlock()
    pcall(function()
        if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
        end
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 50
    end)
end

local function EnableUnlock()
    if ThirdPersonUnlock.Connection then return end
    ThirdPersonUnlock.Enabled = true
    ApplyUnlock()
    ThirdPersonUnlock.Connection = RunService.RenderStepped:Connect(function()
        if not ThirdPersonUnlock.Enabled then return end
        ApplyUnlock()
    end)
end

local function DisableUnlock()
    ThirdPersonUnlock.Enabled = false
    if ThirdPersonUnlock.Connection then
        ThirdPersonUnlock.Connection:Disconnect()
        ThirdPersonUnlock.Connection = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if ThirdPersonUnlock.Enabled then
        ApplyUnlock()
    end
end)

-- [9] 管理员检测
local AdminDetectEnabled = true
local flaggedAdmins = {}

local function CheckAdmin(player)
    if not AdminDetectEnabled then return end
    if flaggedAdmins[player] then return end
    if not player or not player.Parent then return end
    local suspicious = false
    pcall(function()
        for _, g in ipairs(player:GetGroups()) do
            if g.Rank >= 200 then suspicious = true end
        end
    end)
    if suspicious then
        flaggedAdmins[player] = true
        Notify("⚠️ 管理员警告", player.Name .. " - 高Rank玩家", 5)
    end
end

Players.PlayerAdded:Connect(function(p) task.wait(1) CheckAdmin(p) end)
for _, p in ipairs(Players:GetPlayers()) do task.spawn(function() CheckAdmin(p) end) end
task.spawn(function()
    while true do
        if AdminDetectEnabled then
            for _, p in ipairs(Players:GetPlayers()) do CheckAdmin(p) end
        end
        task.wait(2)
    end
end)
Players.PlayerRemoving:Connect(function(p) flaggedAdmins[p] = nil end)

-- [10] 玩家ESP设置
local PLAYER_ESP = {
    Enabled = false, HighlightEnabled = false, BoxEnabled = false,
    TeamCheck = false, ShowName = false, ShowHealth = false, ShowDist = false
}

local function ClearPlayerESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "PlayerESP_Highlight" or obj.Name == "PlayerESP_Info" or obj.Name == "PlayerESP_Box" then
            obj:Destroy()
        end
    end
end

local function UpdatePlayerESP()
    if not PLAYER_ESP.Enabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and head and root and hum.Health > 0 then
                local isTeam = (p.Team == LocalPlayer.Team)
                local filtered = PLAYER_ESP.TeamCheck and isTeam
                local color = p.TeamColor.Color

                local high = char:FindFirstChild("PlayerESP_Highlight")
                if PLAYER_ESP.HighlightEnabled and not filtered then
                    if not high then
                        high = Instance.new("Highlight", char)
                        high.Name = "PlayerESP_Highlight"
                    end
                    high.FillColor = color
                    high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif high then high:Destroy() end

                local box = char:FindFirstChild("PlayerESP_Box")
                if PLAYER_ESP.BoxEnabled and not filtered then
                    if not box then
                        box = Instance.new("BillboardGui", char)
                        box.Name = "PlayerESP_Box"
                        box.Size = UDim2.new(4.5,0,6,0)
                        box.AlwaysOnTop = true
                        box.Adornee = root
                        local f = Instance.new("Frame", box)
                        f.Size = UDim2.new(1,0,1,0)
                        f.BackgroundTransparency = 1
                        local s = Instance.new("UIStroke", f)
                        s.Thickness = 1.5
                    end
                    box.Frame.UIStroke.Color = color
                elseif box then box:Destroy() end

                local info = char:FindFirstChild("PlayerESP_Info")
                if not filtered then
                    if not info then
                        info = Instance.new("BillboardGui", char)
                        info.Name = "PlayerESP_Info"
                        info.Size = UDim2.new(0,200,0,50)
                        info.AlwaysOnTop = true
                        info.Adornee = head
                        info.ExtentsOffset = Vector3.new(0,3.5,0)
                        local txt = Instance.new("TextLabel", info)
                        txt.Name = "Label"
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.RichText = true
                        txt.TextStrokeTransparency = 0.5
                        txt.Font = Enum.Font.GothamMedium
                    end
                    local text = ""
                    if PLAYER_ESP.ShowName then
                        text = "<font color='#ffffff'><b>"..p.DisplayName.."</b></font>\n"
                    end
                    if PLAYER_ESP.ShowHealth then
                        local hp = math.floor(hum.Health)
                        local hpColor = (hp > 50 and "#55ff55" or "#ff5555")
                        text = text .. "<font color='"..hpColor.."'>HP: "..hp.."</font> "
                    end
                    if PLAYER_ESP.ShowDist then
                        local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                        text = text .. "<font color='#ffffff'>| "..dist.."m</font>"
                    end
                    info.Label.Text = text
                elseif info then info:Destroy() end
            end
        end
    end
end

-- [11] NPC透视
local NPCESP = { Enabled = false, Color = Color3.fromRGB(0,162,255), Highlights = {} }

local function GetNPCPart(model)
    if not model then return nil end
    if model:FindFirstChild("HumanoidRootPart") then return model.HumanoidRootPart end
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

local function AddNPCESP(model)
    if not model or NPCESP.Highlights[model] then return end
    if not model:FindFirstChildWhichIsA("Humanoid") then return end
    if Players:GetPlayerFromCharacter(model) then return end
    if not GetNPCPart(model) then return end
    local ok, hl = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "NPCESP"
        h.Adornee = model
        h.FillColor = NPCESP.Color
        h.OutlineColor = Color3.fromRGB(255,255,255)
        h.FillTransparency = 0.4
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = game:GetService("CoreGui")
        return h
    end)
    if ok and hl then
        NPCESP.Highlights[model] = hl
        hl.AncestryChanged:Connect(function(_, parent)
            if not parent then
                pcall(function() hl:Destroy() end)
                NPCESP.Highlights[model] = nil
            end
        end)
    end
end

local function RemoveNPCESP(model)
    if not model then return end
    if NPCESP.Highlights[model] then
        pcall(function() NPCESP.Highlights[model]:Destroy() end)
        NPCESP.Highlights[model] = nil
    end
end

local function ToggleNPCESP(state)
    NPCESP.Enabled = state
    if state then
        task.spawn(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") then task.spawn(AddNPCESP, obj) end
            end
        end)
        task.spawn(function()
            while NPCESP.Enabled do
                for model, hl in pairs(NPCESP.Highlights) do
                    if not model or not model.Parent or not hl or not hl.Parent then
                        NPCESP.Highlights[model] = nil
                    end
                end
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") then AddNPCESP(obj) end
                end
                task.wait(2)
            end
        end)
    else
        for model, _ in pairs(NPCESP.Highlights) do
            RemoveNPCESP(model)
        end
    end
end

-- [12] 互动透视
local InteractESP = { Enabled = false, Color = Color3.fromRGB(0,255,0), Highlights = {} }

local function IsInteractive(obj)
    return obj and (obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector"))
end

local function AddInteractESP(target)
    if not target or InteractESP.Highlights[target] then return end
    if not (target:IsA("BasePart") or target:IsA("Model")) then return end
    local ok, hl = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "InteractESP"
        h.Adornee = target
        h.FillColor = InteractESP.Color
        h.OutlineColor = Color3.fromRGB(255,255,255)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = target
        return h
    end)
    if ok and hl then InteractESP.Highlights[target] = hl end
end

local function RemoveInteractESP(target)
    if not target then return end
    if InteractESP.Highlights[target] then
        pcall(function() InteractESP.Highlights[target]:Destroy() end)
        InteractESP.Highlights[target] = nil
    end
end

local function ToggleInteractESP(state)
    InteractESP.Enabled = state
    if state then
        task.spawn(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if IsInteractive(obj) and obj.Parent then
                    pcall(function() AddInteractESP(obj.Parent) end)
                end
            end
        end)
    else
        for target, _ in pairs(InteractESP.Highlights) do RemoveInteractESP(target) end
    end
end

-- [13] 夜视/去雾
local OriginalLighting = {
    Brightness = Lighting.Brightness, Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient, FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd, FogColor = Lighting.FogColor,
    ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
    ColorShift_Top = Lighting.ColorShift_Top, ColorShift_Bottom = Lighting.ColorShift_Bottom,
}
local OriginalAtmosphere = {}
local VisualModule = { NormalNightVision = false, SuperNightVision = false, NoFog = false }

local function ApplyNormalNightVision(enable)
    VisualModule.NormalNightVision = enable
    if enable then
        Lighting.Brightness = 10
        Lighting.Ambient = Color3.fromRGB(220,220,220)
        Lighting.OutdoorAmbient = Color3.fromRGB(220,220,220)
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 8
        Lighting.ColorShift_Top = Color3.new(0,0,0)
        Lighting.ColorShift_Bottom = Color3.new(0,0,0)
        Notify("普通夜视", "已开启", 2)
    else
        for k, v in pairs(OriginalLighting) do pcall(function() Lighting[k] = v end) end
        Notify("普通夜视", "已关闭", 2)
    end
end

local function ApplySuperNightVision(enable)
    VisualModule.SuperNightVision = enable
    if enable then
        Lighting.Brightness = 70
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.EnvironmentDiffuseScale = 1
        Notify("超级夜视", "已开启", 2)
    else
        for k, v in pairs(OriginalLighting) do pcall(function() Lighting[k] = v end) end
        Notify("超级夜视", "已关闭", 2)
    end
end

local function ApplyNoFog(enable)
    VisualModule.NoFog = enable
    if enable then
        Lighting.FogStart = 0
        Lighting.FogEnd = math.huge
        Lighting.FogColor = Color3.fromRGB(200,200,220)
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then
                if not OriginalAtmosphere[obj] then
                    OriginalAtmosphere[obj] = {
                        Density = obj.Density, Offset = obj.Offset,
                        Glare = obj.Glare, Haze = obj.Haze
                    }
                end
                pcall(function() obj.Density=0 obj.Offset=0 obj.Glare=0 obj.Haze=0 end)
            end
        end
        Notify("去雾", "已开启", 2)
    else
        Lighting.FogStart = OriginalLighting.FogStart
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogColor = OriginalLighting.FogColor
        for obj, props in pairs(OriginalAtmosphere) do
            if obj and obj.Parent then
                pcall(function()
                    obj.Density = props.Density
                    obj.Offset = props.Offset
                    obj.Glare = props.Glare
                    obj.Haze = props.Haze
                end)
            end
        end
        OriginalAtmosphere = {}
        Notify("去雾", "已关闭", 2)
    end
end

-- [14] 防摔
local AntiFallEnabled = false
local AntiFallConnection = nil

local function StartAntiFall(character)
    local root = character:WaitForChild("HumanoidRootPart", 10)
    if not root then return end
    if AntiFallConnection then AntiFallConnection:Disconnect() end
    AntiFallConnection = RunService.Heartbeat:Connect(function()
        if not AntiFallEnabled or not character.Parent or not root or not root.Parent then return end
        local v = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.zero
        RunService.RenderStepped:Wait()
        root.AssemblyLinearVelocity = v
    end)
end

local function ToggleAntiFall(state)
    AntiFallEnabled = state
    if state then
        local char = LocalPlayer.Character
        if char then char:WaitForChild("HumanoidRootPart") StartAntiFall(char) end
        Notify("防摔落伤害", "已开启", 1)
    else
        if AntiFallConnection then AntiFallConnection:Disconnect() AntiFallConnection = nil end
        Notify("防摔落伤害", "已关闭", 1)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if not AntiFallEnabled then return end
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(0.2)
    if AntiFallEnabled then StartAntiFall(char) end
end)

local AntiFall2Enabled = false
local AntiFall2Connection = nil

local function StartAntiFall2(character)
    if AntiFall2Connection then AntiFall2Connection:Disconnect() end
    local root = character:WaitForChild("HumanoidRootPart")
    local lastY = root.Position.Y
    AntiFall2Connection = RunService.Heartbeat:Connect(function()
        if not AntiFall2Enabled or not character.Parent then return end
        local cur = root.Position
        local fall = lastY - cur.Y
        if fall >= 14 then
            local vel = root.AssemblyLinearVelocity
            root.CFrame = root.CFrame * CFrame.new(0, -0.5, 0)
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -10, vel.Z)
            lastY = root.Position.Y
        end
        if cur.Y > lastY then lastY = cur.Y end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5) StartAntiFall2(char) end)
if LocalPlayer.Character then StartAntiFall2(LocalPlayer.Character) end

-- [15] 速度/跳跃/无限跳
local SpeedEnabled = false
local TargetWalkSpeed = 16
local OriginalWalkSpeed = 16
local CustomJumpEnabled = false
local CustomJumpValue = 50
local OriginalJump = 50
local InfiniteJumpEnabled = false

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    OriginalWalkSpeed = hum.WalkSpeed
    OriginalJump = (hum.JumpPower > 0) and hum.JumpPower or hum.JumpHeight
end)

RunService.RenderStepped:Connect(function()
    if CustomJumpEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = CustomJumpValue
            hum.JumpHeight = CustomJumpValue * (7.2/50)
        end
    end
    if SpeedEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= TargetWalkSpeed then
            hum.WalkSpeed = TargetWalkSpeed
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if SpeedEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = TargetWalkSpeed end
    end
end)

UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end
end)

-- [16] 自由视角
local Freecam = {
    Speed = 2, Sensitivity = 0.01, Enabled = false, Rig = nil, Loop = nil,
    Yaw = 0, Pitch = 0, MoveInput = Vector2.zero, Connections = {},
    Touch = { Move = nil, Look = nil, MoveStart = nil }
}

local function InitFreecamInput()
    if Freecam._InputInited then return end
    Freecam._InputInited = true
    table.insert(Freecam.Connections, UIS.TouchStarted:Connect(function(t)
        if not Freecam.Enabled then return end
        local half = Camera.ViewportSize.X / 2
        if t.Position.X < half then
            if not Freecam.Touch.Move then
                Freecam.Touch.Move = t
                Freecam.Touch.MoveStart = t.Position
                Freecam.MoveInput = Vector2.zero
            end
        else
            if not Freecam.Touch.Look then Freecam.Touch.Look = t end
        end
    end))
    table.insert(Freecam.Connections, UIS.TouchMoved:Connect(function(t)
        if not Freecam.Enabled then return end
        if t == Freecam.Touch.Move and Freecam.Touch.MoveStart then
            local delta = t.Position - Freecam.Touch.MoveStart
            Freecam.MoveInput = Vector2.new(
                math.clamp(delta.X/80, -1, 1),
                math.clamp(-delta.Y/80, -1, 1)
            )
        elseif t == Freecam.Touch.Look then
            local d = t.Delta
            Freecam.Yaw -= d.X * Freecam.Sensitivity
            Freecam.Pitch = math.clamp(Freecam.Pitch - d.Y * Freecam.Sensitivity, math.rad(-85), math.rad(85))
        end
    end))
    table.insert(Freecam.Connections, UIS.TouchEnded:Connect(function(t)
        if t == Freecam.Touch.Move then
            Freecam.Touch.Move = nil
            Freecam.Touch.MoveStart = nil
            Freecam.MoveInput = Vector2.zero
        end
        if t == Freecam.Touch.Look then Freecam.Touch.Look = nil end
    end))
end

local function StartFreecam()
    if Freecam.Enabled then return end
    Freecam.Enabled = true
    InitFreecamInput()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if not Freecam.Rig then
        Freecam.Rig = Instance.new("Part")
        Freecam.Rig.Anchored = true
        Freecam.Rig.CanCollide = false
        Freecam.Rig.Transparency = 1
        Freecam.Rig.Size = Vector3.new(1,1,1)
        Freecam.Rig.Parent = Workspace
    end
    Freecam.Rig.CFrame = Camera.CFrame
    root.Anchored = true
    hum.AutoRotate = false
    hum.PlatformStand = true
    Camera.CameraType = Enum.CameraType.Scriptable
    local x, y = Camera.CFrame:ToEulerAnglesYXZ()
    Freecam.Yaw = y
    Freecam.Pitch = x
    Freecam.Loop = RunService.RenderStepped:Connect(function()
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if r then
            r.AssemblyLinearVelocity = Vector3.zero
            r.AssemblyAngularVelocity = Vector3.zero
        end
        local rotCF = CFrame.Angles(0, Freecam.Yaw, 0) * CFrame.Angles(Freecam.Pitch, 0, 0)
        local cf = CFrame.new(Freecam.Rig.Position) * rotCF
        local move = (cf.RightVector * Freecam.MoveInput.X) + (cf.LookVector * Freecam.MoveInput.Y)
        Freecam.Rig.CFrame = CFrame.new(Freecam.Rig.Position + move * Freecam.Speed) * rotCF
        Camera.CFrame = Freecam.Rig.CFrame
    end)
end

local function StopFreecam()
    if not Freecam.Enabled then return end
    Freecam.Enabled = false
    if Freecam.Loop then Freecam.Loop:Disconnect() Freecam.Loop = nil end
    for _, conn in pairs(Freecam.Connections) do pcall(function() conn:Disconnect() end) end
    Freecam.Connections = {}
    Freecam._InputInited = false
    Freecam.MoveInput = Vector2.zero
    Freecam.Touch.Move = nil
    Freecam.Touch.Look = nil
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if root then root.Anchored = false end
        if hum then hum.AutoRotate = true hum.PlatformStand = false end
    end
    Camera.CameraType = Enum.CameraType.Custom
end

-- [17] 自瞄系统
local ESP_SETTINGS = {
    HighlightEnabled = false, TeamCheck = false,
    SmoothAim = false, WallCheck = false
}
local AimbotTeamWhitelist = {}
local AimbotTeamWhitelistEnabled = false
local FOV = 120
local Smoothness = 0.18
local AimPart = "Head"
local ShowFOVCircle = true
local MaxDistance = 1000
local AimPartsList = {"Head", "HumanoidRootPart", "UpperTorso", "Torso"}
local LockTargetEnabled = false
local SelectedTarget = nil
local CurrentTarget = nil
local LastSwitchTime = 0
local SWITCH_DELAY = 0.25
local SWITCH_THRESHOLD = 0.7

local function GetAimPart(char)
    if not char then return nil end
    local p = char:FindFirstChild(AimPart)
    if not p then
        p = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end
    return p
end

local VisibilityCache = {}

local function isVisible(p, part)
    if not Camera then return false end
    if not ESP_SETTINGS.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true
    local ignore = {LocalPlayer.Character, Camera}
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then table.insert(ignore, tool) end
    params.FilterDescendantsInstances = ignore
    local offsets = {
        Vector3.new(0,0,0), Vector3.new(0.25,0,0), Vector3.new(-0.25,0,0),
        Vector3.new(0,0.25,0), Vector3.new(0,-0.25,0),
    }
    local count = 0
    for _, offset in ipairs(offsets) do
        local targetPos = part.Position + offset
        local remaining = targetPos - origin
        local curOrigin = origin
        local hitChar = false
        for _ = 1, 3 do
            local r = Workspace:Raycast(curOrigin, remaining, params)
            if not r then hitChar = true break end
            local h = r.Instance
            if h and p.Character and h:IsDescendantOf(p.Character) then
                hitChar = true break
            end
            if h and (h.Transparency > 0.4 or h.CanCollide == false or h.Material == Enum.Material.Glass) then
                curOrigin = r.Position + (remaining.Unit * 0.1)
                remaining = part.Position - curOrigin
            else
                break
            end
        end
        if hitChar then count += 1 end
    end
    local now = count >= 2
    local last = VisibilityCache[p]
    if last == nil then VisibilityCache[p] = now return now end
    if now ~= last then
        VisibilityCache[p] = last
        task.delay(0.03, function() VisibilityCache[p] = now end)
        return last
    end
    VisibilityCache[p] = now
    return now
end

local function isAlive(p)
    local c = p.Character
    local h = c and c:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

local function shouldForceSwitch(target)
    if not target then return true end
    if not isAlive(target) then return true end
    local char = target.Character
    local part = char and GetAimPart(char)
    if not part then return true end
    if not isVisible(target, part) then return true end
    local pos, visible = Camera:WorldToViewportPoint(part.Position)
    if not visible then return true end
    local center = Camera.ViewportSize / 2
    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    return dist > FOV
end

local function getTarget()
    local now = tick()
    local center = Camera.ViewportSize / 2
    local bestTarget = nil
    local bestDist = math.huge
    local candidates = {}
    if LockTargetEnabled and SelectedTarget then
        table.insert(candidates, SelectedTarget)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(candidates, p) end
        end
    end
    for _, p in ipairs(candidates) do
        if p and isAlive(p) then
            local skip = false
            if not LockTargetEnabled then
                if AimbotTeamWhitelistEnabled and next(AimbotTeamWhitelist) ~= nil then
                    if not p.Team or not AimbotTeamWhitelist[p.Team.Name] then skip = true end
                elseif ESP_SETTINGS.TeamCheck then
                    if p.Team == LocalPlayer.Team then skip = true end
                end
            end
            if not skip then
                local char = p.Character
                local part = char and GetAimPart(char)
                if part then
                    local dist3D = (part.Position - Camera.CFrame.Position).Magnitude
                    if dist3D <= MaxDistance and isVisible(p, part) then
                        local pos, visible = Camera:WorldToViewportPoint(part.Position)
                        if visible then
                            local dist2D = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if dist2D <= FOV and dist2D < bestDist then
                                bestDist = dist2D
                                bestTarget = p
                            end
                        end
                    end
                end
            end
        end
    end
    if shouldForceSwitch(CurrentTarget) then
        CurrentTarget = bestTarget
        LastSwitchTime = now
        return bestTarget
    end
    if bestTarget then
        if now - LastSwitchTime < SWITCH_DELAY then return CurrentTarget end
        if CurrentTarget and CurrentTarget ~= bestTarget then
            local char = CurrentTarget.Character
            local part = char and GetAimPart(char)
            if part then
                local pos, visible = Camera:WorldToViewportPoint(part.Position)
                if visible then
                    local curDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if bestDist > curDist * SWITCH_THRESHOLD then return CurrentTarget end
                end
            end
        end
        CurrentTarget = bestTarget
        LastSwitchTime = now
        return bestTarget
    end
    return nil
end

-- FOV 圈 UI
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "FOVCircle_UI"
fovGui.IgnoreGuiInset = true
fovGui.ResetOnSpawn = false
fovGui.Parent = game:GetService("CoreGui")

local circle = Instance.new("Frame")
circle.Name = "FOVCircle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.new(0.5, 0, 0.5, 0)
circle.Size = UDim2.new(0, 240, 0, 240)
circle.BackgroundTransparency = 1
circle.Parent = fovGui
circle.Visible = false

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(128, 0, 128)
stroke.Parent = circle

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle

RunService.RenderStepped:Connect(function()
    if circle then
        local size = FOV * 2
        circle.Size = UDim2.new(0, size, 0, size)
        local shouldShow = ESP_SETTINGS.HighlightEnabled and ShowFOVCircle
        if circle.Visible ~= shouldShow then circle.Visible = shouldShow end
    end
    if not Camera then return end
    if not ESP_SETTINGS.HighlightEnabled then return end
    local target = getTarget()
    if target and target.Character then
        local part = GetAimPart(target.Character)
        if part then
            local camPos = Camera.CFrame.Position
            local dir = (part.Position - camPos).Unit
            local newCF = CFrame.new(camPos, camPos + dir)
            if ESP_SETTINGS.SmoothAim then
                Camera.CFrame = Camera.CFrame:Lerp(newCF, Smoothness)
            else
                Camera.CFrame = newCF
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if PLAYER_ESP.Enabled then UpdatePlayerESP() end
end)

-- [18] 传送/甩飞/观战
local Flinging = false
local AlreadyNotified = {}
local TP_SelectedPlayer = nil
local TP_Loop = false
local FlingLoop = false
local Spectating = false

local function TeleportToPlayer(target)
    if not target then return end
    local char = LocalPlayer.Character
    local tChar = target.Character
    if not char or not tChar then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if root and tRoot then
        root.CFrame = tRoot.CFrame * CFrame.new(0, 4, 0)
    end
end

local function SpectatePlayer(target)
    if not target then return end
    local char = target.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    Camera.CameraSubject = hum
    Camera.CameraType = Enum.CameraType.Custom
    Spectating = true
end

local function StopSpectate()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then Camera.CameraSubject = hum end
    Spectating = false
end

local function SkidFling(TargetPlayer)
    if not TargetPlayer or TargetPlayer == LocalPlayer then return end
    if Flinging then return end
    Flinging = true
    local Player = LocalPlayer
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not (Character and Humanoid and RootPart and TCharacter) then
        Flinging = false
        return
    end
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Dead = false
    local DeadConn
    DeadConn = Player.CharacterAdded:Connect(function()
        Dead = true
        if DeadConn then DeadConn:Disconnect() DeadConn = nil end
    end)
    if RootPart and RootPart.Parent and RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    if THead then Camera.CameraSubject = THead
    elseif THumanoid then Camera.CameraSubject = THumanoid end
    local function FPos(BasePart, Pos, Ang)
        if Dead then return end
        local curChar = Player.Character
        local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
        local curRoot = curHum and curHum.RootPart
        if not curChar or not curHum or not curRoot or not curRoot.Parent then return end
        if not BasePart or not BasePart.Parent then return end
        local tCF = CFrame.new(BasePart.Position) * Pos * Ang
        pcall(function()
            curRoot.CFrame = tCF
            curChar:SetPrimaryPartCFrame(tCF)
            curRoot.Velocity = Vector3.new(9e7, 9e7*10, 9e7)
            curRoot.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end)
    end
    local function SFBasePart(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0
        repeat
            if Dead then break end
            if not BasePart or not BasePart.Parent then break end
            local curChar = Player.Character
            local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
            local curRoot = curHum and curHum.RootPart
            if not curChar or not curHum or not curRoot then break end
            if not TRootPart or not TRootPart.Parent then break end
            if not THumanoid or THumanoid.Health <= 0 then break end
            if BasePart.Velocity.Magnitude > 1 then
                Angle = Angle + 100
                FPos(BasePart, CFrame.new(0,1.5,0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude/1.25, CFrame.Angles(math.rad(Angle),0,0)) task.wait()
                FPos(BasePart, CFrame.new(0,-1.5,0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude/1.25, CFrame.Angles(math.rad(Angle),0,0)) task.wait()
                FPos(BasePart, CFrame.new(2.25,1.5,-2.25) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)) task.wait()
                FPos(BasePart, CFrame.new(-2.25,-1.5,2.25) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)) task.wait()
            else
                FPos(BasePart, CFrame.new(0,1.5,THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)) task.wait()
                FPos(BasePart, CFrame.new(0,-1.5,-THumanoid.WalkSpeed), CFrame.Angles(0,0,0)) task.wait()
                FPos(BasePart, CFrame.new(0,1.5,TRootPart.Velocity.Magnitude/1.25), CFrame.Angles(math.rad(90),0,0)) task.wait()
                FPos(BasePart, CFrame.new(0,-1.5,-TRootPart.Velocity.Magnitude/1.25), CFrame.Angles(0,0,0)) task.wait()
            end
        until BasePart.Velocity.Magnitude > 500 or not BasePart.Parent or Dead or tick() > Time + TimeToWait
    end
    local BV
    if not Dead and RootPart and RootPart.Parent then
        pcall(function()
            BV = Instance.new("BodyVelocity")
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        end)
    end
    pcall(function() Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)
    if not Dead then
        if TRootPart and TRootPart.Parent then SFBasePart(TRootPart)
        elseif THead and THead.Parent then SFBasePart(THead) end
    end
    if BV then pcall(function() BV:Destroy() end) BV = nil end
    if DeadConn then DeadConn:Disconnect() DeadConn = nil end
    Flinging = false
end

local function MonitorTarget(target)
    if not target then return end
    if not (TP_Loop or FlingLoop or Flinging) then return end
    if not AlreadyNotified[target] then
        AlreadyNotified[target] = { dead = false, left = false }
    end
end

local function StartFlingLoop()
    if FlingLoop then return end
    FlingLoop = true
    AlreadyNotified = {}
    task.spawn(function()
        while FlingLoop do
            local selfChar = LocalPlayer.Character
            local selfHum = selfChar and selfChar:FindFirstChildOfClass("Humanoid")
            if not selfChar or not selfHum or selfHum.Health <= 0 then task.wait(0.5) continue end
            if TP_SelectedPlayer == "ALL" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if not FlingLoop then break end
                    local c = LocalPlayer.Character
                    local h = c and c:FindFirstChildOfClass("Humanoid")
                    if not c or not h or h.Health <= 0 then break end
                    if p ~= LocalPlayer then
                        local pHum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                        if pHum and pHum.Health > 0 then
                            MonitorTarget(p)
                            SkidFling(p)
                            local t = tick()
                            repeat task.wait() until not Flinging or tick()-t > 3
                        end
                    end
                end
            else
                local target = (TP_SelectedPlayer ~= "ALL") and (TP_SelectedPlayer or SelectedTarget) or nil
                if target then
                    MonitorTarget(target)
                    SkidFling(target)
                    local t = tick()
                    repeat task.wait() until not Flinging or tick()-t > 3
                end
            end
            task.wait(0.2)
        end
    end)
end

local function StopFlingLoop() FlingLoop = false end

-- [19] 旋转
local SpinEnabled = false
local SpinSpeed = 5
local SpinConnection = nil
local AnimationLockThread = nil

local function ApplyAnimationLock(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = false end
    if AnimationLockThread then task.cancel(AnimationLockThread) AnimationLockThread = nil end
    AnimationLockThread = task.spawn(function()
        local animate = char:WaitForChild("Animate", 3)
        while SpinEnabled and animate and animate.Parent do
            animate.Disabled = true
            task.wait(0.2)
        end
    end)
end

local function RemoveAnimationLock(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
    if AnimationLockThread then task.cancel(AnimationLockThread) AnimationLockThread = nil end
    local animate = char:FindFirstChild("Animate")
    if animate then animate.Disabled = false end
end

local function StartSpin()
    if SpinConnection then return end
    SpinConnection = RunService.RenderStepped:Connect(function(dt)
        if not SpinEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(SpinSpeed) * dt * 60, 0)
        end
    end)
    ApplyAnimationLock(LocalPlayer.Character)
end

local function StopSpin()
    SpinEnabled = false
    if SpinConnection then SpinConnection:Disconnect() SpinConnection = nil end
    RemoveAnimationLock(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if SpinEnabled then
        task.wait(0.5)
        ApplyAnimationLock(char)
        if not SpinConnection then StartSpin() end
    end
end)

-- ============================================================
-- [20] 主窗口
-- ============================================================
local Window = WindUI:CreateWindow({
    Title = "龙卷",
    Icon = "door-open",
    Author = "CypTec",
    Folder = "LongJuan",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "GreenHairTheme",
    SideBarWidth = 200,
    HasOutline = true,
    KeySystem = {
        Key = { "1234", "5678" },
        Note = "请输入密钥。\n\n密钥为 '1234' 或 '5678'",
        URL = "https://github.com/Footagesus/WindUI",
        SaveKey = true,
    },
})

WindUI:SetTheme("GreenHairTheme")

-- [21] 悬浮球
Window:EditOpenButton({
    Title = "",
    Icon = "menu",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("3A6B4D"),
        Color3.fromHex("A3D9B6")
    ),
    Draggable = true,
})

-- [22] 最小化/关闭染色
task.spawn(function()
    task.wait(1.5)
    local GREEN_MAIN  = Color3.fromHex("3A6B4D")
    local GREEN_LIGHT = Color3.fromHex("A3D9B6")
    local ICON_COLOR  = Color3.fromHex("FFFFFF")
    local function colorButton(btn, color)
        if not btn then return end
        if btn:IsA("TextButton") or btn:IsA("ImageButton") or btn:IsA("Frame") then
            btn.BackgroundColor3 = color
            if btn.BackgroundTransparency > 0.5 then btn.BackgroundTransparency = 0 end
        end
        for _, d in ipairs(btn:GetDescendants()) do
            if d:IsA("Frame") then
                d.BackgroundColor3 = color
                if d.BackgroundTransparency > 0.5 then d.BackgroundTransparency = 0 end
            elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
                d.ImageColor3 = ICON_COLOR
            end
        end
    end
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("TextButton") then
                    local name = (obj.Name or ""):lower()
                    local parent = obj.Parent
                    if name:find("minim") or name == "minus" then
                        colorButton(parent, GREEN_MAIN)
                    elseif name:find("close") or name:find("exit") or name == "x" then
                        colorButton(parent, GREEN_LIGHT)
                    end
                end
            end
        end
    end
end)

-- [23] Tabs
local Tabs = {
    Main     = Window:Tab({ Title = "主页",       Icon = "house" }),
    Player   = Window:Tab({ Title = "玩家功能",   Icon = "zap" }),
    Common   = Window:Tab({ Title = "通用",       Icon = "info" }),
    Visual   = Window:Tab({ Title = "透视功能",   Icon = "eye" }),
    Night    = Window:Tab({ Title = "视觉功能",   Icon = "moon" }),
    Aimbot   = Window:Tab({ Title = "自瞄",       Icon = "target" }),
    Teleport = Window:Tab({ Title = "传送与甩飞", Icon = "send" }),
    Config   = Window:Tab({ Title = "配置",       Icon = "settings" }),
}

Window:SelectTab(1)

-- [24] 主页
Tabs.Main:Paragraph({
    Title = "欢迎使用龙卷脚本",
    Desc = "新手制作",
    Image = "rbxassetid://81780048927282",
    ImageSize = 34,
    Thumbnail = "rbxassetid://83309978374356",
    ThumbnailSize = 120,
})

local copyButtons = {}
for _, item in ipairs(CopyItems) do
    table.insert(copyButtons, {
        Title = item.Title,
        Variant = "Primary",
        Icon = item.Icon,
        Callback = function()
            if CopyToClipboard(item.Text) then
                WindUI:Notify({ Title = "复制成功", Content = item.Text, Icon = "check", Duration = 3 })
            else
                WindUI:Notify({ Title = "复制失败", Content = "请手动复制：" .. item.Text, Icon = "triangle-alert", Duration = 5 })
            end
        end,
    })
end

Tabs.Main:Paragraph({
    Title = "此脚本免费禁止倒卖",
    Desc = "作者：CypTec",
    Image = "rbxassetid://114856747961077",
    ImageSize = 34,
    Thumbnail = "rbxassetid://112493898480660",
    ThumbnailSize = 120,
    Buttons = copyButtons,
})

-- [25] 玩家功能
Tabs.Player:Toggle({
    Title = "开启速度修改", Default = false,
    Callback = function(v)
        SpeedEnabled = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then hum.WalkSpeed = TargetWalkSpeed AddFeature("速度修改")
            else hum.WalkSpeed = OriginalWalkSpeed RemoveFeature("速度修改") end
        end
    end
})

Tabs.Player:Input({
    Title = "速度数值", Desc = "0 - 400", Placeholder = "默认 16",
    Callback = function(text)
        local n = tonumber(text)
        if n then
            TargetWalkSpeed = math.clamp(n, 0, 400)
            if SpeedEnabled then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = TargetWalkSpeed end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "开启跳跃修改", Default = false,
    Callback = function(v)
        CustomJumpEnabled = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then
                hum.UseJumpPower = true
                hum.JumpPower = CustomJumpValue
                AddFeature("跳跃修改")
            else
                hum.JumpPower = OriginalJump
                RemoveFeature("跳跃修改")
            end
        end
    end
})

Tabs.Player:Slider({
    Title = "跳跃高度",
    Value = { Min = 50, Max = 600, Default = 50 }, Increment = 1,
    Callback = function(v)
        CustomJumpValue = v
        if CustomJumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.UseJumpPower = true hum.JumpPower = v end
        end
    end
})

Tabs.Player:Toggle({
    Title = "无限跳跃", Default = false,
    Callback = function(v)
        InfiniteJumpEnabled = v
        if v then AddFeature("无限跳") else RemoveFeature("无限跳") end
    end
})

local NoclipConn = nil
local NoclipCharConn = nil
local OriginalCollision = {}

Tabs.Player:Toggle({
    Title = "穿墙", Default = false,
    Callback = function(enabled)
        if enabled then
            OriginalCollision = {}
            if NoclipCharConn then NoclipCharConn:Disconnect() end
            NoclipCharConn = LocalPlayer.CharacterAdded:Connect(function() OriginalCollision = {} end)
            if NoclipConn then NoclipConn:Disconnect() end
            NoclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if OriginalCollision[part] == nil then OriginalCollision[part] = part.CanCollide end
                        part.CanCollide = false
                    end
                end
            end)
            AddFeature("穿墙")
        else
            if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
            if NoclipCharConn then NoclipCharConn:Disconnect() NoclipCharConn = nil end
            for part, state in pairs(OriginalCollision) do
                if typeof(part) == "Instance" and part.Parent then part.CanCollide = state end
            end
            OriginalCollision = {}
            RemoveFeature("穿墙")
        end
    end
})

-- [26] 通用
Tabs.Common:Toggle({
    Title = "强制第三人称",
    Desc = "解除游戏锁定，自由缩放视角",
    Default = false,
    Callback = function(v)
        if v then
            EnableUnlock()
            AddFeature("第三人称")
            WindUI:Notify({ Title = "第三人称", Content = "已开启", Icon = "check", Duration = 2 })
        else
            DisableUnlock()
            RemoveFeature("第三人称")
            WindUI:Notify({ Title = "第三人称", Content = "已关闭", Icon = "info", Duration = 2 })
        end
    end
})

Tabs.Common:Toggle({
    Title = "自由视角", Default = false,
    Callback = function(v)
        if v then StartFreecam() AddFeature("自由视角")
        else StopFreecam() RemoveFeature("自由视角") end
    end
})

Tabs.Common:Slider({
    Title = "自由视角速度",
    Value = { Min = 1, Max = 20, Default = 2 }, Increment = 0.5,
    Callback = function(v) Freecam.Speed = v end
})

Tabs.Common:Toggle({
    Title = "防摔落伤害", Default = false,
    Callback = function(v)
        ToggleAntiFall(v)
        if v then AddFeature("防摔") else RemoveFeature("防摔") end
    end
})

Tabs.Common:Toggle({
    Title = "防摔落伤害2", Default = false,
    Callback = function(v)
        AntiFall2Enabled = v
        if v then AddFeature("防摔2") else RemoveFeature("防摔2") end
    end
})

-- [27] 透视功能
Tabs.Visual:Toggle({
    Title = "NPC透视", Default = false,
    Callback = function(v)
        ToggleNPCESP(v)
        if v then AddFeature("NPC透视") else RemoveFeature("NPC透视") end
    end
})

Tabs.Visual:Toggle({
    Title = "互动透视", Default = false,
    Callback = function(v)
        ToggleInteractESP(v)
        if v then AddFeature("互动透视") else RemoveFeature("互动透视") end
    end
})

Tabs.Visual:Toggle({
    Title = "玩家透视", Default = false,
    Callback = function(v)
        PLAYER_ESP.Enabled = v
        if not v then ClearPlayerESP() end
        if v then AddFeature("玩家透视") else RemoveFeature("玩家透视") end
    end
})

Tabs.Visual:Toggle({ Title = "高亮", Default = false, Callback = function(v) PLAYER_ESP.HighlightEnabled = v end })
Tabs.Visual:Toggle({ Title = "方框", Default = false, Callback = function(v) PLAYER_ESP.BoxEnabled = v end })
Tabs.Visual:Toggle({ Title = "名字", Default = false, Callback = function(v) PLAYER_ESP.ShowName = v end })
Tabs.Visual:Toggle({ Title = "血量", Default = false, Callback = function(v) PLAYER_ESP.ShowHealth = v end })
Tabs.Visual:Toggle({ Title = "距离", Default = false, Callback = function(v) PLAYER_ESP.ShowDist = v end })
Tabs.Visual:Toggle({ Title = "队伍检测", Default = false, Callback = function(v) PLAYER_ESP.TeamCheck = v end })

-- [28] 视觉功能
Tabs.Night:Toggle({
    Title = "普通夜视", Default = false,
    Callback = function(v)
        ApplyNormalNightVision(v)
        if v then AddFeature("夜视") else RemoveFeature("夜视") end
    end
})

Tabs.Night:Toggle({
    Title = "超级夜视", Default = false,
    Callback = function(v)
        ApplySuperNightVision(v)
        if v then AddFeature("超级夜视") else RemoveFeature("超级夜视") end
    end
})

Tabs.Night:Toggle({
    Title = "彻底去雾", Default = false,
    Callback = function(v)
        ApplyNoFog(v)
        if v then AddFeature("去雾") else RemoveFeature("去雾") end
    end
})

Tabs.Night:Button({
    Title = "关闭所有夜视/去雾",
    Callback = function()
        ApplyNormalNightVision(false)
        ApplySuperNightVision(false)
        ApplyNoFog(false)
    end
})

Tabs.Night:Toggle({
    Title = "功能列表显示", Value = true,
    Callback = function(v)
        FeatureDisplayEnabled = v
        if v then
            for _, item in pairs(FeatureItems) do if item then item:Destroy() end end
            FeatureItems = {}
            task.wait(0.05)
            AddFeature("龙卷")
            RefreshFeatureUI()
        else
            RemoveFeature("龙卷")
            RefreshFeatureUI()
        end
    end
})

task.spawn(function()
    task.wait(0.5)
    AddFeature("龙卷")
    RefreshFeatureUI()
end)

Tabs.Night:Toggle({
    Title = "自身血量显示", Value = true,
    Callback = function(v)
        HealthDisplay.Enabled = v
        if HealthDisplay.Label then HealthDisplay.Label.Visible = v end
    end
})

Tabs.Night:Dropdown({
    Title = "显示位置",
    Values = {"LeftTop","RightTop","LeftBottom","RightBottom"},
    Default = HealthDisplay.Position,
    Callback = function(v)
        HealthDisplay.Position = v
        UpdatePosition()
    end
})

-- [29] 自瞄
Tabs.Aimbot:Toggle({
    Title = "自瞄开关", Default = false,
    Callback = function(v)
        ESP_SETTINGS.HighlightEnabled = v
        if circle then circle.Visible = v end
        if v then AddFeature("自瞄") else RemoveFeature("自瞄") end
    end
})

Tabs.Aimbot:Toggle({
    Title = "显示FOV圈", Default = true,
    Callback = function(v) ShowFOVCircle = v end
})

Tabs.Aimbot:Toggle({
    Title = "队伍检测", Default = false,
    Callback = function(v) ESP_SETTINGS.TeamCheck = v end
})

Tabs.Aimbot:Toggle({
    Title = "墙体检测", Default = false,
    Callback = function(v) ESP_SETTINGS.WallCheck = v end
})

Tabs.Aimbot:Slider({
    Title = "自瞄范围(FOV)",
    Value = { Min = 10, Max = 700, Default = FOV }, Increment = 10,
    Callback = function(v) FOV = v end
})

Tabs.Aimbot:Slider({
    Title = "最大距离",
    Value = { Min = 50, Max = 6000, Default = MaxDistance }, Increment = 50,
    Callback = function(v) MaxDistance = v end
})

Tabs.Aimbot:Toggle({
    Title = "平滑自瞄", Default = false,
    Callback = function(v) ESP_SETTINGS.SmoothAim = v end
})

Tabs.Aimbot:Dropdown({
    Title = "瞄准部位", Values = AimPartsList, Default = nil,
    Callback = function(v)
        if typeof(v) == "table" then v = v.Value or v[1] end
        if v then AimPart = v end
    end
})

Tabs.Aimbot:Toggle({
    Title = "指定自瞄目标", Default = false,
    Callback = function(v) LockTargetEnabled = v end
})

local PlayerDropdown = nil
local AimbotPlayerList = {}

local function RefreshAimbotPlayerList()
    AimbotPlayerList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(AimbotPlayerList, p.Name) end
    end
    local last = SelectedTarget and SelectedTarget.Name or nil
    if PlayerDropdown then
        PlayerDropdown:Refresh(AimbotPlayerList, last)
    else
        PlayerDropdown = Tabs.Aimbot:Dropdown({
            Title = "选择玩家", Values = AimbotPlayerList, Default = last,
            Callback = function(v)
                if typeof(v) == "table" then v = v.Value or v[1] end
                if not v then return end
                local t = Players:FindFirstChild(v)
                if t then SelectedTarget = t end
            end
        })
    end
end

Tabs.Aimbot:Button({
    Title = "刷新玩家列表",
    Callback = function() RefreshAimbotPlayerList() end
})

Tabs.Aimbot:Toggle({
    Title = "启用团队白名单", Default = false,
    Callback = function(v) AimbotTeamWhitelistEnabled = v end
})

local TeamDropdown = nil
local function RefreshTeamList()
    local teams = {}
    for _, t in ipairs(game:GetService("Teams"):GetTeams()) do table.insert(teams, t.Name) end
    if TeamDropdown then
        TeamDropdown:Refresh(teams, {})
    else
        TeamDropdown = Tabs.Aimbot:Dropdown({
            Title = "自瞄团队白名单", Values = teams, Value = {}, Multi = true, AllowNone = true,
            Callback = function(selected)
                AimbotTeamWhitelist = {}
                for _, name in ipairs(selected) do AimbotTeamWhitelist[name] = true end
            end
        })
    end
end

Tabs.Aimbot:Button({
    Title = "刷新团队列表",
    Callback = function() RefreshTeamList() end
})

task.delay(1, function() RefreshTeamList() end)
task.delay(1, function() RefreshAimbotPlayerList() end)

-- [30] 传送与甩飞
Tabs.Teleport:Paragraph({ Title = "警告", Desc = "不要在循环甩飞时手动重生，否则可能报错" })

local TP_PlayerList = {}
local TP_Dropdown = nil

local function CreateTPDropdown(lastSel)
    TP_PlayerList = {"所有人"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(TP_PlayerList, p.Name) end
    end
    if TP_Dropdown then
        TP_Dropdown:Refresh(TP_PlayerList, lastSel)
    else
        TP_Dropdown = Tabs.Teleport:Dropdown({
            Title = "选择玩家", Values = TP_PlayerList, Default = lastSel,
            Callback = function(v)
                if typeof(v) == "table" then v = v.Value or v[1] end
                if not v then return end
                if v == "所有人" then
                    TP_SelectedPlayer = "ALL"
                    SelectedTarget = nil
                    return
                end
                local plr = Players:FindFirstChild(v)
                if plr then
                    TP_SelectedPlayer = plr
                    SelectedTarget = plr
                end
            end
        })
    end
end

local function TP_RefreshPlayerList()
    local last = nil
    if typeof(TP_SelectedPlayer) == "Instance" then last = TP_SelectedPlayer.Name
    elseif TP_SelectedPlayer == "ALL" then last = "所有人" end
    CreateTPDropdown(last)
    if last and last ~= "所有人" then
        local still = Players:FindFirstChild(last)
        if still then
            TP_SelectedPlayer = still
            SelectedTarget = still
        else
            TP_SelectedPlayer = nil
            SelectedTarget = nil
        end
    end
end

Tabs.Teleport:Button({ Title = "刷新玩家列表", Callback = function() TP_RefreshPlayerList() end })
task.delay(1, function() TP_RefreshPlayerList() end)

Tabs.Teleport:Button({
    Title = "传送到玩家",
    Callback = function()
        local t = TP_SelectedPlayer
        if t then TeleportToPlayer(t) end
    end
})

local TP_LoopConn = nil
Tabs.Teleport:Toggle({
    Title = "循环传送", Default = false,
    Callback = function(v)
        TP_Loop = v
        if v then
            AlreadyNotified = {}
            TP_LoopConn = RunService.Heartbeat:Connect(function()
                local t = TP_SelectedPlayer or SelectedTarget
                if t then
                    if not AlreadyNotified[t] then MonitorTarget(t) end
                    TeleportToPlayer(t)
                end
            end)
            AddFeature("循环传送")
        else
            if TP_LoopConn then TP_LoopConn:Disconnect() TP_LoopConn = nil end
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
            RemoveFeature("循环传送")
        end
    end
})

Tabs.Teleport:Toggle({
    Title = "观战玩家", Default = false,
    Callback = function(v)
        if v then
            local t = TP_SelectedPlayer or SelectedTarget
            if t then SpectatePlayer(t) AddFeature("观战") end
        else
            StopSpectate()
            RemoveFeature("观战")
        end
    end
})

Tabs.Teleport:Button({
    Title = "甩飞一次",
    Callback = function()
        if TP_SelectedPlayer == "ALL" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    SkidFling(p)
                    repeat task.wait() until not Flinging
                    task.wait(0.1)
                end
            end
        else
            local t = TP_SelectedPlayer or SelectedTarget
            if t then SkidFling(t) end
        end
    end
})

Tabs.Teleport:Toggle({
    Title = "循环甩飞", Default = false,
    Callback = function(v)
        if v then StartFlingLoop() AddFeature("循环甩飞")
        else StopFlingLoop() RemoveFeature("循环甩飞") end
    end
})

Tabs.Teleport:Toggle({
    Title = "人物自转", Default = false,
    Callback = function(v)
        SpinEnabled = v
        if v then StartSpin() AddFeature("自转")
        else StopSpin() RemoveFeature("自转") end
    end
})

Tabs.Teleport:Slider({
    Title = "旋转速度",
    Value = { Min = 1, Max = 200, Default = SpinSpeed }, Increment = 5,
    Callback = function(v) SpinSpeed = v end
})

-- [31] 配置
Tabs.Config:Toggle({
    Title = "管理员检测", Default = true,
    Callback = function(v) AdminDetectEnabled = v end
})

Tabs.Config:Button({
    Title = "重新进入服务器",
    Callback = function()
        Notify("正在重进", "请稍候...", 3)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Config:Button({
    Title = "强制退出",
    Callback = function()
        pcall(function() game:Shutdown() end)
    end
})

Tabs.Config:Button({
    Title = "自杀（重生）",
    Callback = function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 Notify("已自杀", "角色已重生", 2) end
    end
})

-- [32] 加载完成通知
WindUI:Notify({
    Title = "脚本加载成功",
    Content = "感谢使用龙卷脚本",
    Icon = "bird",
    Duration = 3,
})