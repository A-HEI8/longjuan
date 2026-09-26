-- ============================================================
-- 加载动画
-- ============================================================
local TweenService = game:GetService("TweenService")

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingScreen"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 999999
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.Parent = game:GetService("CoreGui")

local Dim = Instance.new("Frame")
Dim.Size = UDim2.new(1, 0, 1, 0)
Dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Dim.BackgroundTransparency = 0.6
Dim.BorderSizePixel = 0
Dim.ZIndex = 1
Dim.Parent = LoadingGui

local Splash = Instance.new("ImageLabel")
Splash.Size = UDim2.new(0, 300, 0, 300)
Splash.Position = UDim2.new(0.5, 0, 0.5, -60)
Splash.AnchorPoint = Vector2.new(0.5, 0.5)
Splash.BackgroundTransparency = 1
Splash.Image = "rbxassetid://81780048927282"
Splash.ScaleType = Enum.ScaleType.Fit
Splash.ZIndex = 2
Splash.Parent = LoadingGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0.5, 0, 0.5, 110)
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.BackgroundTransparency = 1
Title.Text = "龙卷脚本"
Title.TextColor3 = Color3.fromHex("A3D9B6")
Title.TextStrokeTransparency = 0.3
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 42
Title.ZIndex = 6
Title.Parent = LoadingGui

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 260, 0, 6)
BarBg.Position = UDim2.new(0.5, 0, 0.5, 155)
BarBg.AnchorPoint = Vector2.new(0.5, 0.5)
BarBg.BackgroundColor3 = Color3.fromHex("1E2E23")
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 6
BarBg.Parent = LoadingGui
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromHex("A3D9B6")
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 7
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

local Percent = Instance.new("TextLabel")
Percent.Size = UDim2.new(0, 60, 0, 18)
Percent.Position = UDim2.new(0.5, 145, 0.5, 155)
Percent.AnchorPoint = Vector2.new(0, 0.5)
Percent.BackgroundTransparency = 1
Percent.Text = "0%"
Percent.TextColor3 = Color3.fromHex("A3D9B6")
Percent.Font = Enum.Font.GothamBold
Percent.TextSize = 14
Percent.TextXAlignment = Enum.TextXAlignment.Left
Percent.ZIndex = 6
Percent.Parent = LoadingGui

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0.5, 0, 0.5, 190)
Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "正在加载..."
Subtitle.TextColor3 = Color3.fromHex("FFFFFF")
Subtitle.TextStrokeTransparency = 0.5
Subtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.ZIndex = 6
Subtitle.Parent = LoadingGui

TweenService:Create(Title, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { TextTransparency = 0.2 }):Play()

local barTween = TweenService:Create(BarFill, TweenInfo.new(15, Enum.EasingStyle.Linear), { Size = UDim2.new(0.85, 0, 1, 0) })
barTween:Play()

task.spawn(function()
    while LoadingGui and LoadingGui.Parent do
        if BarFill and BarFill.Parent then
            Percent.Text = math.floor(BarFill.Size.X.Scale * 100) .. "%"
        end
        task.wait(0.05)
    end
end)


-- ============================================================
-- 加载 WindUI
-- ============================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name        = "GreenHairTheme",
    Accent      = "2E4A3D",
    Outline     = "3A6B4D",
    Text        = "FFFFFF",
    Placeholder = "A3D9B6",
})

if barTween then barTween:Cancel() end
local currentScale = BarFill.Size.X.Scale
local remaining = 1 - currentScale
local fillTime = math.clamp(remaining * 1.2, 0.3, 0.8)
TweenService:Create(BarFill, TweenInfo.new(fillTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) }):Play()
Subtitle.Text = "加载完成！"
task.wait(fillTime + 0.3)

TweenService:Create(Dim,    TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
TweenService:Create(Splash, TweenInfo.new(0.6), { ImageTransparency = 1 }):Play()
TweenService:Create(Title,  TweenInfo.new(0.6), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
TweenService:Create(Subtitle, TweenInfo.new(0.6), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
TweenService:Create(BarBg,   TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
TweenService:Create(BarFill, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
TweenService:Create(Percent, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
task.wait(0.6)
LoadingGui:Destroy()


-- ============================================================
-- 基础服务
-- ============================================================
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Workspace   = game:GetService("Workspace")
local Lighting    = game:GetService("Lighting")
local CoreGui     = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() Camera = Workspace.CurrentCamera end)

-- 功能显示空函数（兔小黑功能兼容）
local function AddFeature(name) end
local function RemoveFeature(name) end

-- 变量
local SpeedEnabled        = false
local TargetWalkSpeed     = 16
local OriginalWalkSpeed   = 16
local CustomJumpEnabled   = false
local CustomJumpValue     = 50
local OriginalJump        = 50
local InfiniteJumpEnabled = false
local sudu                = nil
local Speed               = 50

-- 通知
local function Notify(title, content, duration)
    pcall(function()
        WindUI:Notify({ Title = tostring(title or "提示"), Content = tostring(content or ""), Duration = duration or 3, Icon = "info" })
    end)
end

-- 复制
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


-- ============================================================
-- 自由视角
-- ============================================================
local Freecam = {
    Speed = 2, Sensitivity = 0.01, Enabled = false,
    Rig = nil, Loop = nil, Yaw = 0, Pitch = 0,
    MoveInput = Vector2.zero, Connections = {},
    Touch = { Move = nil, Look = nil, MoveStart = nil }
}

local function InitFreecamInput()
    if Freecam._InputInited then return end
    Freecam._InputInited = true
    table.insert(Freecam.Connections, UIS.TouchStarted:Connect(function(t)
        if not Freecam.Enabled then return end
        if t.Position.X < Camera.ViewportSize.X / 2 then
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
            local d = t.Position - Freecam.Touch.MoveStart
            Freecam.MoveInput = Vector2.new(math.clamp(d.X/80,-1,1), math.clamp(-d.Y/80,-1,1))
        elseif t == Freecam.Touch.Look then
            local dd = t.Delta
            Freecam.Yaw -= dd.X * Freecam.Sensitivity
            Freecam.Pitch = math.clamp(Freecam.Pitch - dd.Y * Freecam.Sensitivity, math.rad(-85), math.rad(85))
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
        Freecam.Rig.Parent = workspace
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
    for _, c in pairs(Freecam.Connections) do pcall(function() c:Disconnect() end) end
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


-- ============================================================
-- 闪电尖兵
-- ============================================================
local TP_Module = {}
local TP_Loaded = false

function EnableTPUI()
    if TP_Loaded then
        if TP_Module.Gui then TP_Module.Gui.Enabled = true end
        return
    end
    TP_Loaded = true
    local LP = LocalPlayer
    local Mode = false
    local Root, Hum
    local OldCF, OldType, FixedY = nil, nil, 0
    local MoveInput = Vector2.zero
    local TouchMove, TouchStart
    local SpeedTP = 3
    local HeightSpeed = 4

    local Gui = Instance.new("ScreenGui")
    Gui.Parent = game:GetService("CoreGui")
    Gui.IgnoreGuiInset = true
    Gui.Enabled = true
    TP_Module.Gui = Gui

    local Btn = Instance.new("TextButton", Gui)
    Btn.Size = UDim2.new(0,80,0,40)
    Btn.Position = UDim2.new(1,-90,0.35,0)
    Btn.Text = "瞬移"
    Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Btn.TextColor3 = Color3.new(1,1,1)

    local Cross = Instance.new("Frame", Gui)
    Cross.Size = UDim2.new(0,8,0,8)
    Cross.AnchorPoint = Vector2.new(0.5,0.5)
    Cross.Position = UDim2.new(0.5,0,0.5,0)
    Cross.BackgroundColor3 = Color3.fromRGB(255,0,0)
    Cross.Visible = false
    Instance.new("UICorner", Cross).CornerRadius = UDim.new(1,0)

    local UpBtn = Instance.new("TextButton", Gui)
    UpBtn.Size = UDim2.new(0,60,0,60)
    UpBtn.Position = UDim2.new(1,-80,0.7,-70)
    UpBtn.Text = "↑"
    UpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    UpBtn.Visible = false

    local DownBtn = Instance.new("TextButton", Gui)
    DownBtn.Size = UDim2.new(0,60,0,60)
    DownBtn.Position = UDim2.new(1,-80,0.7,10)
    DownBtn.Text = "↓"
    DownBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    DownBtn.Visible = false

    local function LockChar()
        local char = LP.Character
        if not char then return end
        Root = char:FindFirstChild("HumanoidRootPart")
        Hum = char:FindFirstChildOfClass("Humanoid")
        if Root then Root.Anchored = true end
        if Hum then Hum.AutoRotate = false Hum.PlatformStand = true end
    end
    local function UnlockChar()
        if Root then Root.Anchored = false end
        if Hum then Hum.AutoRotate = true Hum.PlatformStand = false end
    end
    local function Enter()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        OldCF = Camera.CFrame
        OldType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Scriptable
        FixedY = root.Position.Y + 150
        Camera.CFrame = CFrame.new(root.Position + Vector3.new(0,150,0)) * CFrame.Angles(math.rad(-90), 0, 0)
        LockChar()
        Cross.Visible = true
        UpBtn.Visible = true
        DownBtn.Visible = true
    end
    local function Exit()
        local char = LP.Character
        if char then
            Root = char:FindFirstChild("HumanoidRootPart")
            Hum = char:FindFirstChildOfClass("Humanoid")
        end
        UnlockChar()
        if Hum then
            pcall(function()
                Hum.PlatformStand = false
                Hum.AutoRotate = true
                Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                Hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        if Root and Root.Parent then Root.Anchored = false end
        Camera.CameraType = OldType or Enum.CameraType.Custom
        if OldCF then Camera.CFrame = OldCF end
        Cross.Visible = false
        UpBtn.Visible = false
        DownBtn.Visible = false
    end

    RunService.RenderStepped:Connect(function()
        if not Mode then return end
        local move = Vector3.new(MoveInput.X, 0, MoveInput.Y) * SpeedTP
        local pos = Camera.CFrame.Position + move
        Camera.CFrame = CFrame.new(Vector3.new(pos.X, FixedY, pos.Z)) * CFrame.Angles(math.rad(-90), 0, 0)
    end)

    local UpHolding, DownHolding = false, false
    UpBtn.MouseButton1Down:Connect(function() UpHolding = true end)
    UpBtn.MouseButton1Up:Connect(function() UpHolding = false end)
    DownBtn.MouseButton1Down:Connect(function() DownHolding = true end)
    DownBtn.MouseButton1Up:Connect(function() DownHolding = false end)

    RunService.RenderStepped:Connect(function()
        if not Mode then return end
        if UpHolding then FixedY += HeightSpeed end
        if DownHolding then FixedY -= HeightSpeed end
    end)

    UIS.TouchStarted:Connect(function(t)
        if not Mode then return end
        if t.Position.X < Camera.ViewportSize.X/2 then
            TouchMove = t
            TouchStart = t.Position
        end
    end)
    UIS.TouchMoved:Connect(function(t)
        if t ~= TouchMove then return end
        local d = t.Position - TouchStart
        MoveInput = Vector2.new(math.clamp(d.X/50, -1, 1), math.clamp(d.Y/50, -1, 1))
    end)
    UIS.TouchEnded:Connect(function(t)
        if t == TouchMove then
            TouchMove = nil
            MoveInput = Vector2.zero
        end
    end)

    local function GetCenterRay()
        local ap = Cross.AbsolutePosition
        local as_ = Cross.AbsoluteSize
        local ray = Camera:ViewportPointToRay(ap.X + as_.X/2, ap.Y + as_.Y/2)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {LP.Character}
        local result = Workspace:Raycast(ray.Origin, Vector3.new(0,-5000,0), params)
        return result and result.Position or ray.Origin
    end

    local function TP()
        if not Root then return end
        local pos = GetCenterRay()
        Root.Anchored = false
        Root.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
    end

    Btn.MouseButton1Click:Connect(function()
        if not Mode then
            Mode = true
            Btn.Text = "确认地点"
            Btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
            Enter()
        else
            Mode = false
            Btn.Text = "瞬移"
            Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            TP()
            Exit()
        end
    end)
end

function DisableTPUI()
    if TP_Module.Gui then TP_Module.Gui.Enabled = false end
end


-- ============================================================
-- 防摔 1
-- ============================================================
local AntiFallEnabled   = false
local AntiFallConnection = nil

local function StartAntiFall(character)
    local root = character:WaitForChild("HumanoidRootPart", 10)
    if not root then return end
    if AntiFallConnection then AntiFallConnection:Disconnect() end
    AntiFallConnection = RunService.Heartbeat:Connect(function()
        if not AntiFallEnabled then return end
        if not character.Parent or not root or not root.Parent then return end
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
        if char then
            char:WaitForChild("HumanoidRootPart")
            StartAntiFall(char)
        end
        Notify("防摔落伤害", "已开启", 1)
    else
        if AntiFallConnection then AntiFallConnection:Disconnect() AntiFallConnection = nil end
        Notify("防摔落伤害", "已关闭", 1)
    end
end


-- ============================================================
-- 防摔 2
-- ============================================================
local AntiFall2Enabled    = false
local AntiFall2Connection = nil

local function StartAntiFall2(character)
    if AntiFall2Connection then AntiFall2Connection:Disconnect() end
    local root = character:WaitForChild("HumanoidRootPart")
    local lastY = root.Position.Y
    AntiFall2Connection = RunService.Heartbeat:Connect(function()
        if not AntiFall2Enabled then return end
        if not character.Parent then return end
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


-- ============================================================
-- 甩飞系统
-- ============================================================
local Flinging = false
local FlingLoop = false
local AlreadyNotified = {}
local TP_SelectedPlayer = nil
local SelectedTarget = nil
local TP_Loop = false

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
end

local function StopSpectate()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then Camera.CameraSubject = hum end
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
    if not (Character and Humanoid and RootPart and TCharacter) then Flinging = false return end

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
                            SkidFling(p)
                            local t = tick()
                            repeat task.wait() until not Flinging or tick()-t > 3
                            task.wait(0.1)
                        end
                    end
                end
            else
                local target = TP_SelectedPlayer or SelectedTarget
                if target then
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


-- ============================================================
-- 强制第三人称（替换版）
-- ============================================================
local ThirdPersonUnlock = {
    Enabled = false,
    Connection = nil
}

local function ApplyUnlock()
    pcall(function()
        -- ⭐核心：解除锁定
        if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
        end
        -- ⭐允许缩放
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 50
    end)
end

local function EnableUnlock()
    if ThirdPersonUnlock.Connection then return end
    ThirdPersonUnlock.Enabled = true
    ApplyUnlock()
    -- ⭐持续对抗游戏锁定（关键）
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
    -- ⚠️ 不强制改回（避免干扰游戏）
end

-- ⭐重生修复
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if ThirdPersonUnlock.Enabled then
        ApplyUnlock()
    end
end)


-- ============================================================
-- 普京比例（兔小黑）
-- ============================================================
local PutinActive = false
local PutinConn = nil

local function ApplyPutinRatio(ratio)
    if PutinConn then PutinConn:Disconnect() PutinConn = nil end
    getgenv().TXH_Resolution = ratio
    PutinConn = RunService.RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().TXH_Resolution, 0, 0, 0, 1)
    end)
    PutinActive = true
end

local function RestoreRatio()
    if PutinConn then PutinConn:Disconnect() PutinConn = nil end
    getgenv().TXH_Resolution = 1
    PutinConn = RunService.RenderStepped:Connect(function()
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    end)
    PutinActive = true
end


-- ============================================================
-- 旋转恶搞（兔小黑）
-- ============================================================
local function TXH_Spin(spinSpeed)
    local c = LocalPlayer.Character
    if not c then Notify("错误", "无角色", 2) return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hum then Notify("错误", "无Humanoid", 2) return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then Notify("错误", "无HRP", 2) return end
    task.spawn(function()
        local animId = hum.RigType == Enum.HumanoidRigType.R6 and "rbxassetid://27432686" or "rbxassetid://507776043"
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        local track = hum:LoadAnimation(anim)
        track:Play()
        track:AdjustSpeed(0)
        local animate = c:FindFirstChild("Animate")
        if animate then animate.Disabled = true end
        local oldSpin = hrp:FindFirstChild("TXH_Spin")
        if oldSpin then oldSpin:Destroy() end
        local spin = Instance.new("BodyAngularVelocity")
        spin.Name = "TXH_Spin"
        spin.Parent = hrp
        spin.MaxTorque = Vector3.new(0, math.huge, 0)
        spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
        Notify("旋转", "速度 " .. spinSpeed .. " 已开启", 2)
    end)
end

local function StopSpin()
    local c = LocalPlayer.Character
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            local sp = hrp:FindFirstChild("TXH_Spin")
            if sp then sp:Destroy() end
        end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            local animate = c:FindFirstChild("Animate")
            if animate then animate.Disabled = false end
            for _, t in pairs(hum:GetPlayingAnimationTracks()) do
                if t.Animation and (t.Animation.AnimationId:find("27432686") or t.Animation.AnimationId:find("507776043")) then
                    t:Stop()
                end
            end
        end
    end
    Notify("旋转", "已停止", 2)
end


-- ============================================================
-- 防甩飞（兔小黑）
-- ============================================================
local antiFlingConn = nil
local antiFlingCharConn = nil
local antiFlingVelConn = nil
local origFallenHeight = workspace.FallenPartsDestroyHeight

local function EnableAntiFling()
    origFallenHeight = workspace.FallenPartsDestroyHeight
    if antiFlingConn then antiFlingConn:Disconnect() end
    if antiFlingCharConn then antiFlingCharConn:Disconnect() end
    if antiFlingVelConn then antiFlingVelConn:Disconnect() end

    local function protectChar(char)
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if antiFlingVelConn then antiFlingVelConn:Disconnect() end
        antiFlingVelConn = hrp:GetPropertyChangedSignal("Velocity"):Connect(function()
            pcall(function()
                if hrp.Velocity.Magnitude > 300 then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end)
    end

    protectChar(LocalPlayer.Character)
    antiFlingCharConn = LocalPlayer.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        protectChar(c)
    end)
    antiFlingConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local c = LocalPlayer.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
            if hrp.Velocity.Magnitude > 500 then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
            for _, child in ipairs(hrp:GetChildren()) do
                if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") or child:IsA("BodyThrust") then
                    if child.Name ~= "TXHVel" then child:Destroy() end
                end
            end
        end)
    end)
end

local function DisableAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
    if antiFlingCharConn then antiFlingCharConn:Disconnect() antiFlingCharConn = nil end
    if antiFlingVelConn then antiFlingVelConn:Disconnect() antiFlingVelConn = nil end
    workspace.FallenPartsDestroyHeight = origFallenHeight
    local c = LocalPlayer.Character
    if c then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end


-- ============================================================
-- 拉到身边（兔小黑）
-- ============================================================
local function PullPlayerToSelf(target)
    if not target then return end
    local tChar = target.Character
    local c = LocalPlayer.Character
    if tChar and c then
        tChar:PivotTo(c:GetPivot())
        Notify("拉取", "已拉到身边", 2)
    end
end


-- ============================================================
-- 自动发言（兔小黑）
-- ============================================================
local sayMessage = ""
local sayCount = 1
local isSpeaking = false
local speakThread = nil

local function SendChatMessage(msg)
    local TCS = game:GetService("TextChatService")
    local RS2 = game:GetService("ReplicatedStorage")
    if TCS.ChatVersion == Enum.ChatVersion.TextChatService then
        TCS.TextChannels.RBXGeneral:SendAsync(msg)
    else
        RS2.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end


-- ============================================================
-- 快速互动 / 自动互动 / 互动距离（兔小黑）
-- ============================================================
local function FirePrompt(prompt)
    if not prompt or not prompt.Parent then return end
    if type(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
    else
        pcall(function() prompt:InputHoldBegin() end)
        task.wait(prompt.HoldDuration or 0)
        pcall(function() prompt:InputHoldEnd() end)
    end
end

local quickInteractConn = nil
local quickInteractOrigin = {}

local function EnableQuickInteract()
    if quickInteractConn then return end
    quickInteractConn = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
        if not prompt then return end
        if quickInteractOrigin[prompt] == nil then
            quickInteractOrigin[prompt] = prompt.HoldDuration
        end
        pcall(function() prompt.HoldDuration = 0 end)
    end)
end

local function DisableQuickInteract()
    if quickInteractConn then
        quickInteractConn:Disconnect()
        quickInteractConn = nil
    end
    for prompt, orig in pairs(quickInteractOrigin) do
        if prompt and prompt.Parent then
            pcall(function() prompt.HoldDuration = orig end)
        end
    end
    quickInteractOrigin = {}
end

local autoInteract = false

local function EnableAutoInteract()
    if autoInteract then return end
    autoInteract = true
    task.spawn(function()
        while autoInteract do
            for _, descendant in ipairs(workspace:GetDescendants()) do
                if not autoInteract then break end
                if descendant:IsA("ProximityPrompt") then
                    FirePrompt(descendant)
                end
            end
            task.wait(0.25)
        end
    end)
end

local function DisableAutoInteract()
    autoInteract = false
end

local interactRangeEnabled = false
local interactRangeValue = 20
local interactRangeConn = nil
local interactRangeOrigin = {}

local function ApplyInteractRange(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    if interactRangeOrigin[prompt] == nil then
        interactRangeOrigin[prompt] = prompt.MaxActivationDistance
    end
    pcall(function() prompt.MaxActivationDistance = interactRangeValue end)
end

local function EnableInteractRange()
    if interactRangeConn then return end
    interactRangeEnabled = true
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("ProximityPrompt") then ApplyInteractRange(d) end
    end
    interactRangeConn = workspace.DescendantAdded:Connect(function(d)
        if not interactRangeEnabled then return end
        if d:IsA("ProximityPrompt") then
            task.defer(function() ApplyInteractRange(d) end)
        end
    end)
end

local function DisableInteractRange()
    interactRangeEnabled = false
    if interactRangeConn then
        interactRangeConn:Disconnect()
        interactRangeConn = nil
    end
    for prompt, orig in pairs(interactRangeOrigin) do
        if prompt and prompt.Parent then
            pcall(function() prompt.MaxActivationDistance = orig end)
        end
    end
    interactRangeOrigin = {}
end


-- ============================================================
-- 滤镜与光影（兔小黑）
-- ============================================================
local function clearPost()
    for _, v in ipairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") and v.Name:sub(1, 4) == "TXH_" then v:Destroy() end
    end
end

local function ApplyFilterMovie()
    clearPost()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "TXH_CC"
    cc.Saturation = 0.1 cc.Contrast = 0.2 cc.Brightness = -0.05
    cc.Parent = Lighting
    Lighting.FogColor = Color3.fromRGB(80, 80, 90)
    Lighting.FogEnd = 600
    Notify("滤镜", "电影感", 2)
end

local function ApplyFilterVivid()
    clearPost()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "TXH_CC"
    cc.Saturation = 0.5 cc.Contrast = 0.15 cc.Brightness = 0.05
    cc.Parent = Lighting
    Notify("滤镜", "鲜艳", 2)
end

local function ApplyFilterDark()
    clearPost()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "TXH_CC"
    cc.Saturation = -0.3 cc.Contrast = 0.4 cc.Brightness = -0.2
    cc.Parent = Lighting
    Lighting.Ambient = Color3.new(0.1, 0.1, 0.1)
    Notify("滤镜", "暗黑", 2)
end

local function ApplyFilterRetro()
    clearPost()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "TXH_CC"
    cc.Saturation = -0.2 cc.TintColor = Color3.fromRGB(255, 220, 180) cc.Contrast = 0.1
    cc.Parent = Lighting
    Notify("滤镜", "复古", 2)
end

local function ApplyFilterNeon()
    clearPost()
    local b = Instance.new("BloomEffect")
    b.Name = "TXH_Bloom"
    b.Intensity = 2 b.Size = 30 b.Threshold = 0.6
    b.Parent = Lighting
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "TXH_CC"
    cc.Saturation = 0.4
    cc.Parent = Lighting
    Notify("滤镜", "霓虹", 2)
end

local function RestoreFilter()
    clearPost()
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Brightness = 1
    Lighting.ExposureCompensation = 0
    Lighting.FogStart = 0
    Lighting.FogEnd = 1000
    Lighting.FogColor = Color3.fromRGB(192, 192, 192)
    Notify("滤镜", "已恢复原状", 2)
end


-- ============================================================
-- 夜视 / 去雾 / 去阴影（兔小黑）
-- ============================================================
local NightVisionEnabled = false

local function ToggleNightVision(state)
    NightVisionEnabled = state
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
    end
end

local fogOrigStart = Lighting.FogStart
local fogOrigEnd = Lighting.FogEnd
local FogEnabled = false

local function ToggleFog(state)
    FogEnabled = state
    if state then
        fogOrigStart = Lighting.FogStart
        fogOrigEnd = Lighting.FogEnd
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e20
        Notify("去雾", "已开启", 2)
    else
        Lighting.FogStart = fogOrigStart
        Lighting.FogEnd = fogOrigEnd
        Notify("去雾", "已关闭", 2)
    end
end

local shadowOriginals = {}
local noShadowConn = nil
local origGlobalShadows = Lighting.GlobalShadows

local function noShadowApply(part)
    if part:IsA("BasePart") and part.CastShadow then
        if shadowOriginals[part] == nil then shadowOriginals[part] = true end
        pcall(function() part.CastShadow = false end)
    end
end

local function EnableNoShadow()
    origGlobalShadows = Lighting.GlobalShadows
    pcall(function() Lighting.GlobalShadows = false end)
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") then noShadowApply(d) end
    end
    noShadowConn = workspace.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then noShadowApply(d) end
    end)
    Notify("去阴影", "已开启", 2)
end

local function DisableNoShadow()
    pcall(function() Lighting.GlobalShadows = origGlobalShadows end)
    if noShadowConn then noShadowConn:Disconnect() noShadowConn = nil end
    for part, _ in pairs(shadowOriginals) do
        pcall(function()
            if part and part.Parent then part.CastShadow = true end
        end)
    end
    shadowOriginals = {}
    Notify("去阴影", "已关闭", 2)
end


-- ============================================================
-- 动画包（兔小黑）
-- ============================================================
local function LoadTrack(hum, anim)
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then return animator:LoadAnimation(anim) end
    return hum:LoadAnimation(anim)
end

local function SetAnimations(animData, packName)
    local c = LocalPlayer.Character
    if not c then Notify("错误", "角色未加载", 3) return end
    local Animate = c:FindFirstChild("Animate")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not (Animate and hum) then Notify("错误", "缺少 Animate/Humanoid", 3) return end
    Animate.Disabled = true
    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop() end)
    end
    pcall(function() Animate.idle.Animation1.AnimationId = animData.idle1 end)
    pcall(function() Animate.idle.Animation2.AnimationId = animData.idle2 end)
    pcall(function() Animate.walk.WalkAnim.AnimationId = animData.walk end)
    pcall(function() Animate.run.RunAnim.AnimationId = animData.run end)
    pcall(function() Animate.jump.JumpAnim.AnimationId = animData.jump end)
    pcall(function() Animate.climb.ClimbAnim.AnimationId = animData.climb end)
    pcall(function() Animate.fall.FallAnim.AnimationId = animData.fall end)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    Animate.Disabled = false
    Notify("动画", (packName or "动画") .. " 已应用", 3)
end

local AnimationPacks = {
    {name="吸血鬼", data={idle1="http://www.roblox.com/asset/?id=1083445855",idle2="http://www.roblox.com/asset/?id=1083450166",walk="http://www.roblox.com/asset/?id=1083473930",run="http://www.roblox.com/asset/?id=1083462077",jump="http://www.roblox.com/asset/?id=1083455352",climb="http://www.roblox.com/asset/?id=1083439238",fall="http://www.roblox.com/asset/?id=1083443587"}},
    {name="英雄", data={idle1="http://www.roblox.com/asset/?id=616111295",idle2="http://www.roblox.com/asset/?id=616113536",walk="http://www.roblox.com/asset/?id=616122287",run="http://www.roblox.com/asset/?id=616117076",jump="http://www.roblox.com/asset/?id=616115533",climb="http://www.roblox.com/asset/?id=616104706",fall="http://www.roblox.com/asset/?id=616108001"}},
    {name="经典僵尸", data={idle1="http://www.roblox.com/asset/?id=616158929",idle2="http://www.roblox.com/asset/?id=616160636",walk="http://www.roblox.com/asset/?id=616168032",run="http://www.roblox.com/asset/?id=616163682",jump="http://www.roblox.com/asset/?id=616161997",climb="http://www.roblox.com/asset/?id=616156119",fall="http://www.roblox.com/asset/?id=616157476"}},
    {name="法师", data={idle1="http://www.roblox.com/asset/?id=707742142",idle2="http://www.roblox.com/asset/?id=707855907",walk="http://www.roblox.com/asset/?id=707897309",run="http://www.roblox.com/asset/?id=707861613",jump="http://www.roblox.com/asset/?id=707853694",climb="http://www.roblox.com/asset/?id=707826056",fall="http://www.roblox.com/asset/?id=707829716"}},
    {name="幽灵", data={idle1="http://www.roblox.com/asset/?id=616006778",idle2="http://www.roblox.com/asset/?id=616008087",walk="http://www.roblox.com/asset/?id=616010382",run="http://www.roblox.com/asset/?id=616013216",jump="http://www.roblox.com/asset/?id=616008936",climb="http://www.roblox.com/asset/?id=616003713",fall="http://www.roblox.com/asset/?id=616005863"}},
    {name="长者", data={idle1="http://www.roblox.com/asset/?id=845397899",idle2="http://www.roblox.com/asset/?id=845400520",walk="http://www.roblox.com/asset/?id=845403856",run="http://www.roblox.com/asset/?id=845386501",jump="http://www.roblox.com/asset/?id=845398858",climb="http://www.roblox.com/asset/?id=845392038",fall="http://www.roblox.com/asset/?id=845396048"}},
    {name="悬浮", data={idle1="http://www.roblox.com/asset/?id=616006778",idle2="http://www.roblox.com/asset/?id=616008087",walk="http://www.roblox.com/asset/?id=616013216",run="http://www.roblox.com/asset/?id=616010382",jump="http://www.roblox.com/asset/?id=616008936",climb="http://www.roblox.com/asset/?id=616003713",fall="http://www.roblox.com/asset/?id=616005863"}},
    {name="宇航员", data={idle1="http://www.roblox.com/asset/?id=891621366",idle2="http://www.roblox.com/asset/?id=891633237",walk="http://www.roblox.com/asset/?id=891667138",run="http://www.roblox.com/asset/?id=891636393",jump="http://www.roblox.com/asset/?id=891627522",climb="http://www.roblox.com/asset/?id=891609353",fall="http://www.roblox.com/asset/?id=891617961"}},
    {name="忍者", data={idle1="http://www.roblox.com/asset/?id=656117400",idle2="http://www.roblox.com/asset/?id=656118341",walk="http://www.roblox.com/asset/?id=656121766",run="http://www.roblox.com/asset/?id=656118852",jump="http://www.roblox.com/asset/?id=656117878",climb="http://www.roblox.com/asset/?id=656114359",fall="http://www.roblox.com/asset/?id=656115606"}},
    {name="狼人", data={idle1="http://www.roblox.com/asset/?id=1083195517",idle2="http://www.roblox.com/asset/?id=1083214717",walk="http://www.roblox.com/asset/?id=1083178339",run="http://www.roblox.com/asset/?id=1083216690",jump="http://www.roblox.com/asset/?id=1083218792",climb="http://www.roblox.com/asset/?id=1083182000",fall="http://www.roblox.com/asset/?id=1083189019"}},
    {name="卡通", data={idle1="http://www.roblox.com/asset/?id=742637544",idle2="http://www.roblox.com/asset/?id=742638445",walk="http://www.roblox.com/asset/?id=742640026",run="http://www.roblox.com/asset/?id=742638842",jump="http://www.roblox.com/asset/?id=742637942",climb="http://www.roblox.com/asset/?id=742636889",fall="http://www.roblox.com/asset/?id=742637151"}},
    {name="海盗", data={idle1="http://www.roblox.com/asset/?id=750781874",idle2="http://www.roblox.com/asset/?id=750782770",walk="http://www.roblox.com/asset/?id=750785693",run="http://www.roblox.com/asset/?id=750783738",jump="http://www.roblox.com/asset/?id=750782230",climb="http://www.roblox.com/asset/?id=750779899",fall="http://www.roblox.com/asset/?id=750780242"}},
    {name="潜行", data={idle1="http://www.roblox.com/asset/?id=1132473842",idle2="http://www.roblox.com/asset/?id=1132477671",walk="http://www.roblox.com/asset/?id=1132510133",run="http://www.roblox.com/asset/?id=1132494274",jump="http://www.roblox.com/asset/?id=1132489853",climb="http://www.roblox.com/asset/?id=1132461372",fall="http://www.roblox.com/asset/?id=1132469004"}},
    {name="玩具", data={idle1="http://www.roblox.com/asset/?id=782841498",idle2="http://www.roblox.com/asset/?id=782845736",walk="http://www.roblox.com/asset/?id=782843345",run="http://www.roblox.com/asset/?id=782842708",jump="http://www.roblox.com/asset/?id=782847020",climb="http://www.roblox.com/asset/?id=782843869",fall="http://www.roblox.com/asset/?id=782846423"}},
    {name="骑士", data={idle1="http://www.roblox.com/asset/?id=657595757",idle2="http://www.roblox.com/asset/?id=657568135",walk="http://www.roblox.com/asset/?id=657552124",run="http://www.roblox.com/asset/?id=657564596",jump="http://www.roblox.com/asset/?id=658409194",climb="http://www.roblox.com/asset/?id=658360781",fall="http://www.roblox.com/asset/?id=657600338"}},
    {name="自信", data={idle1="http://www.roblox.com/asset/?id=1069977950",idle2="http://www.roblox.com/asset/?id=1069987858",walk="http://www.roblox.com/asset/?id=1070017263",run="http://www.roblox.com/asset/?id=1070001516",jump="http://www.roblox.com/asset/?id=1069984524",climb="http://www.roblox.com/asset/?id=1069946257",fall="http://www.roblox.com/asset/?id=1069973677"}},
    {name="流行明星", data={idle1="http://www.roblox.com/asset/?id=1212900985",idle2="http://www.roblox.com/asset/?id=1212900985",walk="http://www.roblox.com/asset/?id=1212980338",run="http://www.roblox.com/asset/?id=1212980348",jump="http://www.roblox.com/asset/?id=1212954642",climb="http://www.roblox.com/asset/?id=1213044953",fall="http://www.roblox.com/asset/?id=1212900995"}},
    {name="公主", data={idle1="http://www.roblox.com/asset/?id=941003647",idle2="http://www.roblox.com/asset/?id=941013098",walk="http://www.roblox.com/asset/?id=941028902",run="http://www.roblox.com/asset/?id=941015281",jump="http://www.roblox.com/asset/?id=941008832",climb="http://www.roblox.com/asset/?id=940996062",fall="http://www.roblox.com/asset/?id=941000007"}},
    {name="牛仔", data={idle1="http://www.roblox.com/asset/?id=1014390418",idle2="http://www.roblox.com/asset/?id=1014398616",walk="http://www.roblox.com/asset/?id=1014421541",run="http://www.roblox.com/asset/?id=1014401683",jump="http://www.roblox.com/asset/?id=1014394726",climb="http://www.roblox.com/asset/?id=1014380606",fall="http://www.roblox.com/asset/?id=1014384571"}},
    {name="巡逻", data={idle1="http://www.roblox.com/asset/?id=1149612882",idle2="http://www.roblox.com/asset/?id=1150842221",walk="http://www.roblox.com/asset/?id=1151231493",run="http://www.roblox.com/asset/?id=1150967949",jump="http://www.roblox.com/asset/?id=1150944216",climb="http://www.roblox.com/asset/?id=1148811837",fall="http://www.roblox.com/asset/?id=1148863382"}},
}

local activeAnims = {}
local curAnimTrack = nil
local animLooped = true
local animSpeed = 1

local function playAnimation(id, speed, timepos)
    local c = LocalPlayer.Character
    if not c then Notify("错误", "角色未加载", 3) return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hum then Notify("错误", "缺少 Humanoid", 3) return end
    for _, track in pairs(activeAnims) do
        if track then pcall(function() track:Stop() end) end
    end
    activeAnims = {}
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. id
    local track = LoadTrack(hum, anim)
    if track then
        track.Looped = animLooped
        track:Play()
        track:AdjustSpeed(speed or animSpeed)
        track.TimePosition = timepos or 0
        activeAnims[id] = track
        curAnimTrack = track
        Notify("动画", "播放 " .. id, 2)
    end
end


-- ============================================================
-- 杂项（兔小黑）
-- ============================================================
local timeGui = nil
local timeConn = nil

local function updateTime()
    local t = os.date("*t")
    local s = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
    if timeGui then
        local lbl = timeGui:FindFirstChild("TimeLabel")
        if lbl then lbl.Text = "🕐 " .. s end
    end
end

local function EnableTimeDisplay()
    timeGui = Instance.new("ScreenGui")
    timeGui.Name = "TXH_Time"
    timeGui.ResetOnSpawn = false
    pcall(function() timeGui.Parent = CoreGui end)
    if not timeGui.Parent then timeGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local lbl = Instance.new("TextLabel")
    lbl.Name = "TimeLabel"
    lbl.Parent = timeGui
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 10)
    lbl.Size = UDim2.new(0, 150, 0, 30)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextStrokeTransparency = 0
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "🕐 --:--:--"
    updateTime()
    timeConn = RunService.Heartbeat:Connect(updateTime)
    Notify("显示时间", "已开启", 2)
end

local function DisableTimeDisplay()
    if timeConn then timeConn:Disconnect() timeConn = nil end
    if timeGui then timeGui:Destroy() timeGui = nil end
    Notify("显示时间", "已关闭", 2)
end

local fpsConn = nil
local function EnableFPS()
    local g = Instance.new("ScreenGui")
    g.Name = "TXH_FPS"
    g.ResetOnSpawn = false
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local l = Instance.new("TextLabel")
    l.Parent = g
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(.78, 0, 0, 0)
    l.Size = UDim2.new(0, 130, 0, 30)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextStrokeTransparency = 0
    l.Text = "FPS: 0"
    local n = 0
    fpsConn = RunService.RenderStepped:Connect(function(dt)
        n = n + 1
        if n >= 10 then l.Text = "FPS: " .. math.floor(1 / dt) n = 0 end
    end)
end

local function DisableFPS()
    if fpsConn then fpsConn:Disconnect() fpsConn = nil end
    local g = CoreGui:FindFirstChild("TXH_FPS")
    if g then g:Destroy() end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then local g3 = pg:FindFirstChild("TXH_FPS") if g3 then g3:Destroy() end end
end


-- ============================================================
-- 主窗口
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
    User = { Enabled = true, Anonymous = false, Callback = function() print("点击了用户头像") end },
})

WindUI:SetTheme("GreenHairTheme")

Window:EditOpenButton({
    Title = "",
    Icon = "menu",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("3A6B4D"), Color3.fromHex("A3D9B6")),
    Draggable = true,
})

Window:SetToggleKey(Enum.KeyCode.K)

task.spawn(function()
    task.wait(2)
    local CoreGui = game:GetService("CoreGui")
    local GREEN_LIGHT = Color3.fromHex("A3D9B6")
    local ICON_COLOR  = Color3.fromHex("FFFFFF")
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    local name = (obj.Name or ""):lower()
                    if name:find("minim") or name:find("minus") then
                        obj:Destroy()
                    elseif name:find("close") or name:find("exit") or name == "x" then
                        obj.BackgroundColor3 = GREEN_LIGHT
                        if obj.Parent and obj.Parent:IsA("Frame") then obj.Parent.BackgroundColor3 = GREEN_LIGHT end
                        for _, d in ipairs(obj:GetDescendants()) do
                            if d:IsA("ImageLabel") or d:IsA("ImageButton") then d.ImageColor3 = ICON_COLOR end
                        end
                    end
                end
            end
        end
    end
end)


-- ============================================================
-- 标签页
-- ============================================================
local Tabs = {
    Main       = Window:Tab({ Title = "主页",       Icon = "house" }),
    Player     = Window:Tab({ Title = "玩家功能",   Icon = "zap" }),
    Common     = Window:Tab({ Title = "通用",       Icon = "toolbox" }),
    Visual     = Window:Tab({ Title = "透视",       Icon = "eye" }),
    Fling      = Window:Tab({ Title = "甩飞",       Icon = "send" }),
    Chat       = Window:Tab({ Title = "消息",       Icon = "message-circle" }),
    Interact   = Window:Tab({ Title = "互动",       Icon = "zap" }),
    Light      = Window:Tab({ Title = "滤镜与光影", Icon = "sun" }),
    Night      = Window:Tab({ Title = "夜视",       Icon = "moon" }),
    FE         = Window:Tab({ Title = "FE",         Icon = "code" }),
    Fun        = Window:Tab({ Title = "娱乐",       Icon = "gamepad-2" }),
    Music      = Window:Tab({ Title = "音乐",       Icon = "music" }),
    Animation  = Window:Tab({ Title = "动画",       Icon = "star" }),
    Misc       = Window:Tab({ Title = "杂项",       Icon = "toolbox" }),
    Scripts    = Window:Tab({ Title = "脚本大全",   Icon = "download" }),
    Server     = Window:Tab({ Title = "服务器脚本", Icon = "server" }),
}
Window:SelectTab(1)


-- ============================================================
-- 主页
-- ============================================================
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


-- ============================================================
-- 玩家功能 - 本地玩家
-- ============================================================
local LPS = Tabs.Player:Section({ Title = "本地玩家" })

LPS:Toggle({
    Title = "开启速度修改", Default = false,
    Callback = function(v)
        SpeedEnabled = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then hum.WalkSpeed = TargetWalkSpeed else hum.WalkSpeed = OriginalWalkSpeed end
        end
    end
})

LPS:Input({
    Title = "速度数值", Desc = "0 - 400", Placeholder = "默认 16",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            TargetWalkSpeed = math.clamp(n, 0, 400)
            if SpeedEnabled then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = TargetWalkSpeed end
            end
        end
    end
})

LPS:Toggle({
    Title = "开启快速跑步", Default = false,
    Callback = function(enabled)
        if enabled then
            if sudu then sudu:Disconnect() end
            sudu = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * Speed / 0.5)
                end
            end)
        else
            if sudu then sudu:Disconnect() sudu = nil end
        end
    end
})

LPS:Input({
    Title = "快速跑步强度", Placeholder = "0-200", Default = tostring(Speed or 0),
    Callback = function(text)
        local n = tonumber(text)
        if n then Speed = math.clamp(n, 0, 200) end
    end
})

LPS:Toggle({
    Title = "开启跳跃修改", Default = false,
    Callback = function(v)
        CustomJumpEnabled = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then
                hum.UseJumpPower = true
                hum.JumpPower = CustomJumpValue
            else
                hum.JumpPower = OriginalJump
            end
        end
    end
})

LPS:Slider({
    Title = "跳跃高度",
    Value = { Min = 50, Max = 600, Default = 50 },
    Increment = 1,
    Callback = function(value)
        CustomJumpValue = value
        if CustomJumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = value
            end
        end
    end
})

local GravityEnabled  = false
local CustomGravity   = 196.2
local OriginalGravity = workspace.Gravity

RunService.RenderStepped:Connect(function()
    if not GravityEnabled then return end
    if workspace.Gravity ~= CustomGravity then workspace.Gravity = CustomGravity end
end)

LPS:Toggle({
    Title = "重力控制", Desc = "开启后可自定义重力", Default = false,
    Callback = function(state)
        if state then
            OriginalGravity = workspace.Gravity
            workspace.Gravity = CustomGravity
            GravityEnabled = true
        else
            GravityEnabled = false
            workspace.Gravity = OriginalGravity or 196.2
        end
    end
})

LPS:Input({
    Title = "重力数值", Desc = "默认196.2", Placeholder = "196.2",
    Callback = function(val)
        local n = tonumber(val)
        if not n then return end
        CustomGravity = math.clamp(n, 0, 500)
        if GravityEnabled then workspace.Gravity = CustomGravity end
    end
})

LPS:Toggle({
    Title = "无限跳跃", Default = false,
    Callback = function(v) InfiniteJumpEnabled = v end
})

UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end
end)

local NoclipConnection    = nil
local CharacterConnection = nil
local OriginalCollision   = {}

LPS:Toggle({
    Title = "穿墙", Default = false,
    Callback = function(enabled)
        if enabled then
            OriginalCollision = {}
            if CharacterConnection then CharacterConnection:Disconnect() end
            CharacterConnection = LocalPlayer.CharacterAdded:Connect(function() OriginalCollision = {} end)
            if NoclipConnection then NoclipConnection:Disconnect() end
            NoclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if not character then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if OriginalCollision[part] == nil then OriginalCollision[part] = part.CanCollide end
                        part.CanCollide = false
                    end
                end
            end)
        else
            if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
            if CharacterConnection then CharacterConnection:Disconnect() CharacterConnection = nil end
            for part, state in pairs(OriginalCollision) do
                if typeof(part) == "Instance" and part.Parent then part.CanCollide = state end
            end
            OriginalCollision = {}
        end
    end
})

LPS:Toggle({
    Title = "防摔落伤害", Default = false,
    Callback = function(v) ToggleAntiFall(v) end
})

LPS:Toggle({
    Title = "防摔落伤害2（1没用再开）", Default = false,
    Callback = function(state)
        AntiFall2Enabled = state
        if state then
            Notify("防摔落伤害2", "已开启", 3)
            local char = LocalPlayer.Character
            if char then StartAntiFall2(char) end
        else
            Notify("防摔落伤害2", "已关闭", 3)
        end
    end
})


-- ============================================================
-- 通用标签页
-- ============================================================
Tabs.Common:Button({
    Title = "飞行",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/z1mFBr9I/raw"))()
    end,
})

Tabs.Common:Button({
    Title = "飞车",
    Icon = "car",
    Callback = function()
        Notify("通用", "正在加载飞车...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-SILLY-CAR-V1-48227"))()
        end)
        if ok then
            Notify("通用", "飞车加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

Tabs.Common:Toggle({
    Title = "自由视角", Default = false,
    Callback = function(v)
        if v then
            StartFreecam()
            Notify("自由视角", "已开启", 2)
        else
            StopFreecam()
            Notify("自由视角", "已关闭", 2)
        end
    end
})

Tabs.Common:Slider({
    Title = "自由视角速度",
    Value = { Min = 1, Max = 20, Default = 2 },
    Increment = 0.5,
    Callback = function(value) Freecam.Speed = value end
})

Tabs.Common:Toggle({
    Title = "定点传送", Default = false,
    Callback = function(v)
        if v then
            EnableTPUI()
            Notify("定点传送", "已开启", 2)
        else
            DisableTPUI()
            Notify("定点传送", "已关闭", 2)
        end
    end
})

-- ===== 强制第三人称 =====
Tabs.Common:Toggle({
    Title = "强制第三人称", Default = false,
    Callback = function(v)
        if v then EnableUnlock() Notify("相机", "已强制第三人称", 2)
        else DisableUnlock() Notify("相机", "已关闭强制", 2) end
    end
})

Tabs.Common:Input({
    Title = "最大视距", Placeholder = "默认 128，如 500",
    Callback = function(t)
        local n = tonumber(t)
        if n then LocalPlayer.CameraMaxZoomDistance = n Notify("相机", "最大视距 " .. n, 2) end
    end
})

Tabs.Common:Button({
    Title = "普京比例",
    Callback = function() ApplyPutinRatio(0.65) end
})

Tabs.Common:Button({
    Title = "恢复比例",
    Callback = function() RestoreRatio() end
})

-- ===== 踏空行走 =====
Tabs.Common:Button({
    Title = "踏空行走",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))() end)
        if ok then Notify("踏空", "启动成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

-- ===== 点击传送工具 =====
Tabs.Common:Button({
    Title = "获取点击传送工具",
    Callback = function()
        local ok, err = pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local tool = Instance.new("Tool")
            tool.RequiresHandle = false
            tool.Name = "[FE] 点击传送"
            tool.Activated:Connect(function()
                local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
                pos = CFrame.new(pos.X, pos.Y, pos.Z)
                local c = LocalPlayer.Character
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = pos end
                end
            end)
            tool.Parent = LocalPlayer:WaitForChild("Backpack")
        end)
        if ok then Notify("传送工具", "已放入背包", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

-- ===== 旋转恶搞 =====
Tabs.Common:Button({
    Title = "快速旋转",
    Callback = function() TXH_Spin(30) end
})

Tabs.Common:Button({
    Title = "极速旋转",
    Callback = function() TXH_Spin(500) end
})

Tabs.Common:Button({
    Title = "停止旋转",
    Callback = function() StopSpin() end
})

-- ===== 防甩飞 =====
Tabs.Common:Toggle({
    Title = "防甩飞", Default = false,
    Callback = function(s)
        if s then EnableAntiFling() Notify("防甩飞", "已开启", 2)
        else DisableAntiFling() Notify("防甩飞", "已关闭", 2) end
    end
})


-- ============================================================
-- ⭐ 透视标签页（11 个控件必须显示）
-- ============================================================
-- 空表兜底：即使 ESP 加载失败，控件也全部创建
local playerESP = {}

-- 静默加载：成功就把函数合并进 playerESP，失败也不报错
pcall(function()
    local espFuncs = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/main/ESP.lua"))()
    if type(espFuncs) == "table" then
        for k, v in pairs(espFuncs) do
            playerESP[k] = v
        end
    end
end)

Tabs.Visual:Section({ Title = "玩家ESP设置" })

Tabs.Visual:Toggle({
    Title = "ESP开关", Default = false,
    Callback = function(value) playerESP.Enabled = value end
})

Tabs.Visual:Toggle({
    Title = "显示名称", Default = true,
    Callback = function(value) playerESP.ShowName = value end
})

Tabs.Visual:Toggle({
    Title = "显示方框", Default = false,
    Callback = function(value) playerESP.ShowBox = value end
})

Tabs.Visual:Toggle({
    Title = "显示血量", Default = false,
    Callback = function(value) playerESP.ShowHealth = value end
})

Tabs.Visual:Toggle({
    Title = "显示距离", Default = false,
    Callback = function(value) playerESP.ShowDistance = value end
})

Tabs.Visual:Toggle({
    Title = "显示射线", Default = false,
    Callback = function(value) playerESP.ShowTracer = value end
})

Tabs.Visual:Toggle({
    Title = "队伍颜色", Default = false,
    Callback = function(value) playerESP.TeamCheck = value end
})

Tabs.Visual:Toggle({
    Title = "穿墙显示", Default = false,
    Callback = function(value) playerESP.WallCheck = value end
})

Tabs.Visual:Toggle({
    Title = "队伍ESP", Default = false,
    Callback = function(value) playerESP.TeamColor = value end
})

Tabs.Visual:Dropdown({
    Title = "射线位置",
    Values = {"上", "中", "下"},
    Default = "上",
    Callback = function(value)
        if typeof(value) == "table" then value = value.Value or value[1] end
        if value == "上" then playerESP.TracerPosition = "Top"
        elseif value == "中" then playerESP.TracerPosition = "Middle"
        elseif value == "下" then playerESP.TracerPosition = "Bottom"
        end
    end
})

Tabs.Visual:Slider({
    Title = "射线粗细",
    Value = { Min = 0, Max = 10, Default = 1 },
    Increment = 1,
    Callback = function(value) playerESP.TracerThickness = value end
})

Tabs.Visual:Button({
    Title = "加载通用ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/main/Content/ESP-Universal"))()
    end
})

Tabs.Visual:Button({
    Title = "加载血量ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Content/NameHealthESP.lua"))()
    end
})


-- ============================================================
-- ⭐ 甩飞标签页
-- ============================================================
Tabs.Fling:Paragraph({
    Title = "警告",
    Desc = "不要在循环甩飞时手动重生，否则可能报错"
})

local Fling_Dropdown = nil

local function CreateFlingDropdown(lastSel)
    local list = {"所有人"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    if Fling_Dropdown then
        Fling_Dropdown:Refresh(list, lastSel)
    else
        Fling_Dropdown = Tabs.Fling:Dropdown({
            Title = "选择玩家",
            Values = list,
            Default = lastSel,
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

Tabs.Fling:Button({
    Title = "刷新玩家列表",
    Callback = function()
        local last = nil
        if typeof(TP_SelectedPlayer) == "Instance" then last = TP_SelectedPlayer.Name
        elseif TP_SelectedPlayer == "ALL" then last = "所有人" end
        CreateFlingDropdown(last)
    end
})

Tabs.Fling:Button({
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

Tabs.Fling:Toggle({
    Title = "循环甩飞", Default = false,
    Callback = function(v)
        if v then StartFlingLoop() else StopFlingLoop() end
    end
})

Tabs.Fling:Toggle({
    Title = "观战玩家", Default = false,
    Callback = function(v)
        if v then
            local t = TP_SelectedPlayer or SelectedTarget
            if t then SpectatePlayer(t) end
        else
            StopSpectate()
        end
    end
})

Tabs.Fling:Button({
    Title = "传送到玩家",
    Callback = function()
        local t = TP_SelectedPlayer
        if t then TeleportToPlayer(t) end
    end
})

Tabs.Fling:Button({
    Title = "拉到身边",
    Callback = function()
        local t = TP_SelectedPlayer
        if t then PullPlayerToSelf(t) end
    end
})

local Fling_LoopConn = nil
Tabs.Fling:Toggle({
    Title = "循环传送", Default = false,
    Callback = function(v)
        TP_Loop = v
        if v then
            AlreadyNotified = {}
            Fling_LoopConn = RunService.Heartbeat:Connect(function()
                local target = TP_SelectedPlayer or SelectedTarget
                if target then TeleportToPlayer(target) end
            end)
        else
            if Fling_LoopConn then
                Fling_LoopConn:Disconnect()
                Fling_LoopConn = nil
            end
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
})

task.delay(1, function()
    CreateFlingDropdown(nil)
end)


-- ============================================================
-- ⭐ 消息标签页
-- ============================================================
Tabs.Chat:Section({ Title = "自动发言设置" })

Tabs.Chat:Input({
    Title = "消息内容", Placeholder = "输入你要说的话",
    Callback = function(txt) sayMessage = txt end
})

Tabs.Chat:Input({
    Title = "发言次数", Placeholder = "默认 1",
    Callback = function(txt) sayCount = tonumber(txt) or 1 end
})

Tabs.Chat:Toggle({
    Title = "发言开关", Default = false,
    Callback = function(s)
        isSpeaking = s
        if s then
            if sayMessage == "" then Notify("错误", "请先输入要说的内容", 3) isSpeaking = false return end
            speakThread = task.spawn(function()
                for i = 1, sayCount do
                    if not isSpeaking then break end
                    SendChatMessage(sayMessage)
                    task.wait(0.5)
                end
                isSpeaking = false
            end)
            Notify("消息", "开始发送", 2)
        else
            if speakThread then task.cancel(speakThread) speakThread = nil end
            Notify("消息", "已停止", 2)
        end
    end
})


-- ============================================================
-- ⭐ 互动标签页
-- ============================================================
Tabs.Interact:Section({ Title = "快捷互动" })

Tabs.Interact:Toggle({
    Title = "快速互动", Default = false,
    Callback = function(s)
        if s then EnableQuickInteract() Notify("互动", "快速互动已开启", 2)
        else DisableQuickInteract() Notify("互动", "快速互动已关闭", 2) end
    end
})

Tabs.Interact:Toggle({
    Title = "自动互动", Default = false,
    Callback = function(state)
        if state then EnableAutoInteract() Notify("互动", "自动互动已开启", 2)
        else DisableAutoInteract() Notify("互动", "自动互动已关闭", 2) end
    end
})

Tabs.Interact:Input({
    Title = "互动距离", Placeholder = "默认 10，如 20",
    Callback = function(t)
        local n = tonumber(t)
        if not n or n <= 0 then return end
        interactRangeValue = n
        if interactRangeEnabled then
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("ProximityPrompt") then ApplyInteractRange(d) end
            end
        end
        Notify("互动", "互动距离 = " .. n, 1)
    end
})

Tabs.Interact:Toggle({
    Title = "启用互动距离", Default = false,
    Callback = function(s)
        if s then EnableInteractRange() Notify("互动", "互动距离 " .. interactRangeValue .. " 已开启", 2)
        else DisableInteractRange() Notify("互动", "互动距离已关闭", 2) end
    end
})


-- ============================================================
-- ⭐ 滤镜与光影标签页
-- ============================================================
Tabs.Light:Section({ Title = "画质设置" })

Tabs.Light:Button({
    Title = "自定义画质包",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet('https://pastefy.app/xXkUxA0P/raw', true))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "巨好看光影",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "高亮全图",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/4LDKiJ5a"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "着色器",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/JeckAsChristopher/h/refs/heads/main/loader.lua"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "自定义光影",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/gvb/refs/heads/main/DeepGraphicsHub.lua'))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "白光影",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%99%BD%E5%85%89%E5%BD%B1.txt"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "夜晚",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%A4%9C%E6%99%9A.txt"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "RTX光影V1",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/RTXv1.txt"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Section({ Title = "环境光颜色" })

Tabs.Light:Button({ Title = "恢复默认", Callback = function() Lighting.Ambient = Color3.new(0, 0, 0) Notify("滤镜", "已恢复默认", 2) end })
Tabs.Light:Button({ Title = "全亮", Callback = function() Lighting.Ambient = Color3.new(1, 1, 1) Notify("滤镜", "全亮", 2) end })
Tabs.Light:Button({ Title = "超亮", Callback = function() Lighting.Ambient = Color3.new(2, 2, 2) Notify("滤镜", "超亮", 2) end })
Tabs.Light:Button({ Title = "红色", Callback = function() Lighting.Ambient = Color3.new(1, 0, 0) end })
Tabs.Light:Button({ Title = "绿色", Callback = function() Lighting.Ambient = Color3.new(0, 1, 0) end })
Tabs.Light:Button({ Title = "蓝色", Callback = function() Lighting.Ambient = Color3.new(0, 0, 1) end })

Tabs.Light:Section({ Title = "一键滤镜" })

Tabs.Light:Button({ Title = "电影感", Callback = function() ApplyFilterMovie() end })
Tabs.Light:Button({ Title = "鲜艳", Callback = function() ApplyFilterVivid() end })
Tabs.Light:Button({ Title = "暗黑", Callback = function() ApplyFilterDark() end })
Tabs.Light:Button({ Title = "复古", Callback = function() ApplyFilterRetro() end })
Tabs.Light:Button({ Title = "霓虹", Callback = function() ApplyFilterNeon() end })
Tabs.Light:Button({ Title = "恢复原状", Callback = function() RestoreFilter() end })


-- ============================================================
-- ⭐ 夜视标签页
-- ============================================================
Tabs.Night:Section({ Title = "夜视" })

Tabs.Night:Toggle({
    Title = "夜视", Default = false,
    Callback = function(s) ToggleNightVision(s) end
})

Tabs.Night:Toggle({
    Title = "去雾", Default = false,
    Callback = function(s) ToggleFog(s) end
})

Tabs.Night:Toggle({
    Title = "去阴影", Default = false,
    Callback = function(s)
        if s then EnableNoShadow() else DisableNoShadow() end
    end
})


-- ============================================================
-- ⭐ 动作功能标签页 (独立 Tab)
-- ============================================================
local TabFE = Window:Tab({
    Title = "动作功能",
    Icon = "eye",
    Locked = false,
})

TabFE:Paragraph({
    Title = "提示",
    Desc = "实测下面动作全部是别人可见，如果那个人是新进来的，需要重新开动作他才会可见。\n所有动作来自bs源码，感谢bs脚本！\n部分不可用是正常的，可能是动作代码被原作者删了。"
})

local player = Players.LocalPlayer
local currentTrack = nil

player.CharacterAdded:Connect(function()
    currentTrack = nil
end)

local function GetAnimator()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    return animator
end

local function PlayAnim(animId)
    local animator = GetAnimator()
    if currentTrack then
        currentTrack:Stop()
        currentTrack:Destroy()
        currentTrack = nil
    end
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = animator:LoadAnimation(anim)
    anim:Destroy()
    track.Priority = Enum.AnimationPriority.Action
    track.Looped = true
    track:Play()
    currentTrack = track
end

local function StopAllAnim()
    if currentTrack then
        currentTrack:Stop()
        currentTrack:Destroy()
        currentTrack = nil
    end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end
    end
end

TabFE:Button({
    Title = "关闭所有动作",
    Callback = function()
        StopAllAnim()
    end
})

TabFE:Button({ Title = "环绕身体动作", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
TabFE:Button({ Title = "无头", Callback = function() PlayAnim("rbxassetid://78837807518622") end })
TabFE:Button({ Title = "直升机", Callback = function() PlayAnim("rbxassetid://95301257497525") end })
TabFE:Button({ Title = "飞机", Callback = function() PlayAnim("rbxassetid://82135680487389") end })
TabFE:Button({ Title = "坦克", Callback = function() PlayAnim("rbxassetid://94915612757079") end })
TabFE:Button({ Title = "假死", Callback = function() PlayAnim("rbxassetid://88130117312312") end })
TabFE:Button({ Title = "投降", Callback = function() PlayAnim("rbxassetid://100537772865440") end })
TabFE:Button({ Title = "加州女孩", Callback = function() PlayAnim("rbxassetid://124982597491660") end })
TabFE:Button({ Title = "直升机2", Callback = function() PlayAnim("rbxassetid://122951149300674") end })
TabFE:Button({ Title = "直升机3", Callback = function() PlayAnim("rbxassetid://91257498644328") end })
TabFE:Button({ Title = "街头舞蹈", Callback = function() PlayAnim("rbxassetid://108171959207138") end })
TabFE:Button({ Title = "街头跺脚", Callback = function() PlayAnim("rbxassetid://115048845533448") end })
TabFE:Button({ Title = "扑腾的鱼", Callback = function() PlayAnim("rbxassetid://79075971527754") end })
TabFE:Button({ Title = "江南Style", Callback = function() PlayAnim("rbxassetid://100531289776679") end })
TabFE:Button({ Title = "苹果糖舞", Callback = function() PlayAnim("rbxassetid://88315693621494") end })
TabFE:Button({ Title = "空中转圈", Callback = function() PlayAnim("rbxassetid://94324173536622") end })
TabFE:Button({ Title = "比心(左)", Callback = function() PlayAnim("rbxassetid://110936682778213") end })
TabFE:Button({ Title = "比心(右)", Callback = function() PlayAnim("rbxassetid://84671941093489") end })
TabFE:Button({ Title = "67", Callback = function() PlayAnim("rbxassetid://115439144505157") end })
TabFE:Button({ Title = "6", Callback = function() PlayAnim("rbxassetid://115439144505157") end })
TabFE:Button({ Title = "7", Callback = function() PlayAnim("rbxassetid://115439144505157") end })
TabFE:Button({ Title = "狗狗", Callback = function() PlayAnim("rbxassetid://78195344190486") end })
TabFE:Button({ Title = "MM2禅", Callback = function() PlayAnim("rbxassetid://86872878957632") end })
TabFE:Button({ Title = "默认舞蹈", Callback = function() PlayAnim("rbxassetid://88455578674030") end })
TabFE:Button({ Title = "坐下", Callback = function() PlayAnim("rbxassetid://97185364700038") end })
TabFE:Button({ Title = "哥萨克踢", Callback = function() PlayAnim("rbxassetid://119264600441310") end })
TabFE:Button({ Title = "战斗姿态", Callback = function() PlayAnim("rbxassetid://116763940575803") end })
TabFE:Button({ Title = "你是谁", Callback = function() PlayAnim("rbxassetid://81389876138766") end })
TabFE:Button({ Title = "摇摆坐", Callback = function() PlayAnim("rbxassetid://130995344283026") end })
TabFE:Button({ Title = "摇摆坐2", Callback = function() PlayAnim("rbxassetid://131836270858895") end })
TabFE:Button({ Title = "蠕虫舞", Callback = function() PlayAnim("rbxassetid://90333292347820") end })
TabFE:Button({ Title = "蛇", Callback = function() PlayAnim("rbxassetid://98476854035224") end })
TabFE:Button({ Title = "彼得死亡", Callback = function() PlayAnim("rbxassetid://129787664584610") end })
TabFE:Button({ Title = "沃尔特场景", Callback = function() PlayAnim("rbxassetid://113475147402830") end })
TabFE:Button({ Title = "可爱躺姿", Callback = function() PlayAnim("rbxassetid://80754582835479") end })
TabFE:Button({ Title = "暗影迪奥", Callback = function() PlayAnim("rbxassetid://92266904563270") end })
TabFE:Button({ Title = "承太郎姿势", Callback = function() PlayAnim("rbxassetid://122120443600865") end })
TabFE:Button({ Title = "JOJO姿势", Callback = function() PlayAnim("rbxassetid://120629563851640") end })
TabFE:Button({ Title = "漂浮躺", Callback = function() PlayAnim("rbxassetid://77840765435893") end })
TabFE:Button({ Title = "圣经天使", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
TabFE:Button({ Title = "ME!ME!ME!", Callback = function() PlayAnim("rbxassetid://103235915424832") end })
TabFE:Button({ Title = "Xavier舞", Callback = function() PlayAnim("rbxassetid://90802740360125") end })
TabFE:Button({ Title = "中国舞", Callback = function() PlayAnim("rbxassetid://131758838511368") end })
TabFE:Button({ Title = "背头", Callback = function() PlayAnim("rbxassetid://74288964113793") end })
TabFE:Button({ Title = "车辆1", Callback = function() PlayAnim("rbxassetid://108747312576405") end })
TabFE:Button({ Title = "车辆2", Callback = function() PlayAnim("rbxassetid://76503595759461") end })
TabFE:Button({ Title = "车辆3", Callback = function() PlayAnim("rbxassetid://115245341767944") end })
TabFE:Button({ Title = "车辆4", Callback = function() PlayAnim("rbxassetid://127805235430271") end })
TabFE:Button({ Title = "车辆5", Callback = function() PlayAnim("rbxassetid://138003068153218") end })
TabFE:Button({ Title = "车辆6", Callback = function() PlayAnim("rbxassetid://116772752010894") end })
TabFE:Button({ Title = "车辆7", Callback = function() PlayAnim("rbxassetid://116625361313832") end })
TabFE:Button({ Title = "车辆8", Callback = function() PlayAnim("rbxassetid://81388785824317") end })
TabFE:Button({ Title = "车辆9", Callback = function() PlayAnim("rbxassetid://113181071290859") end })
TabFE:Button({ Title = "车辆10", Callback = function() PlayAnim("rbxassetid://134681712937413") end })
TabFE:Button({ Title = "车辆11", Callback = function() PlayAnim("rbxassetid://115260380433565") end })
TabFE:Button({ Title = "车辆12", Callback = function() PlayAnim("rbxassetid://72382226286301") end })
TabFE:Button({ Title = "击败Koto", Callback = function() PlayAnim("rbxassetid://93497729736287") end })
TabFE:Button({ Title = "经典行走", Callback = function() PlayAnim("rbxassetid://107806791584829") end })
TabFE:Button({ Title = "奇怪生物", Callback = function() PlayAnim("rbxassetid://87025086742503") end })
TabFE:Button({ Title = "马桶人", Callback = function() PlayAnim("rbxassetid://127154705636043") end })
TabFE:Button({ Title = "滚动哭宝", Callback = function() PlayAnim("rbxassetid://129699431093711") end })
TabFE:Button({ Title = "思考", Callback = function() PlayAnim("rbxassetid://127088545449493") end })
TabFE:Button({ Title = "迷幻", Callback = function() PlayAnim("rbxassetid://135611169366768") end })
TabFE:Button({ Title = "穿搭检查", Callback = function() PlayAnim("rbxassetid://81176957565811") end })
TabFE:Button({ Title = "假设", Callback = function() PlayAnim("rbxassetid://91294374426630") end })
TabFE:Button({ Title = "Griddy舞", Callback = function() PlayAnim("rbxassetid://121966805049108") end })
TabFE:Button({ Title = "认输", Callback = function() PlayAnim("rbxassetid://78653596566468") end })
TabFE:Button({ Title = "篮球头转", Callback = function() PlayAnim("rbxassetid://92854797386719") end })
TabFE:Button({ Title = "鹦鹉舞", Callback = function() PlayAnim("rbxassetid://101810746304426") end })
TabFE:Button({ Title = "射击", Callback = function() PlayAnim("rbxassetid://102691551292124") end })
TabFE:Button({ Title = "布娃娃", Callback = function() PlayAnim("rbxassetid://136224735234038") end })
TabFE:Button({ Title = "悲伤坐", Callback = function() PlayAnim("rbxassetid://100798804992348") end })
TabFE:Button({ Title = "汽水", Callback = function() PlayAnim("rbxassetid://105459130960429") end })
TabFE:Button({ Title = "比利弹跳", Callback = function() PlayAnim("rbxassetid://137501135905857") end })
TabFE:Button({ Title = "篮球", Callback = function() PlayAnim("rbxassetid://119242308765484") end })
TabFE:Button({ Title = "打桩机", Callback = function() PlayAnim("rbxassetid://91423662648449") end })
TabFE:Button({ Title = "怪物捣碎", Callback = function() PlayAnim("rbxassetid://137883764619555") end })
TabFE:Button({ Title = "芙兰玩偶", Callback = function() PlayAnim("rbxassetid://107217181254431") end })
TabFE:Button({ Title = "后空翻", Callback = function() PlayAnim("rbxassetid://131205329995035") end })
TabFE:Button({ Title = "漂浮", Callback = function() PlayAnim("rbxassetid://89523370947906") end })
TabFE:Button({ Title = "你好", Callback = function() PlayAnim("rbxassetid://103041144411206") end })
TabFE:Button({ Title = "附身", Callback = function() PlayAnim("rbxassetid://90708290447388") end })
TabFE:Button({ Title = "去你的!", Callback = function() PlayAnim("rbxassetid://98289978017308") end })
TabFE:Button({ Title = "摸头", Callback = function() PlayAnim("rbxassetid://85422671683973") end })
TabFE:Button({ Title = "上帝山羊漂浮", Callback = function() PlayAnim("rbxassetid://100405715895755") end })
TabFE:Button({ Title = "直升机4", Callback = function() PlayAnim("rbxassetid://115417853064013") end })
TabFE:Button({ Title = "网格舞", Callback = function() PlayAnim("rbxassetid://85588129788692") end })
TabFE:Button({ Title = "破碎", Callback = function() PlayAnim("rbxassetid://79757971761739") end })
TabFE:Button({ Title = "认输2", Callback = function() PlayAnim("rbxassetid://83265734904502") end })
TabFE:Button({ Title = "江南StyleV2", Callback = function() PlayAnim("rbxassetid://129764254213842") end })
TabFE:Button({ Title = "180°翻转", Callback = function() PlayAnim("rbxassetid://114400428765989") end })
TabFE:Button({ Title = "马桶舞", Callback = function() PlayAnim("rbxassetid://128334204821841") end })
TabFE:Button({ Title = "吾乃天命唯一", Callback = function() PlayAnim("rbxassetid://138433137191760") end })
TabFE:Button({ Title = "橙色正义", Callback = function() PlayAnim("rbxassetid://110146282544198") end })
TabFE:Button({ Title = "牙线舞", Callback = function() PlayAnim("rbxassetid://10714340543") end })
TabFE:Button({ Title = "三角符文舞蹈", Callback = function() PlayAnim("rbxassetid://77984841414450") end })
TabFE:Button({ Title = "圣经级准确表情", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
TabFE:Button({ Title = "呃呃呃", Callback = function() PlayAnim("rbxassetid://111251252458517") end })
TabFE:Button({ Title = "彼得不要啊", Callback = function() PlayAnim("rbxassetid://84623954062978") end })
TabFE:Button({ Title = "我变成敞篷车了", Callback = function() PlayAnim("rbxassetid://124756446017361") end })
TabFE:Button({ Title = "加里舞蹈", Callback = function() PlayAnim("rbxassetid://93014787120483") end })
TabFE:Button({ Title = "IShowSpeed舞蹈", Callback = function() PlayAnim("rbxassetid://92618727772186") end })
TabFE:Button({ Title = "光环农场", Callback = function() PlayAnim("rbxassetid://99499783161907") end })
TabFE:Button({ Title = "雪天使", Callback = function() PlayAnim("rbxassetid://80177289449617") end })
TabFE:Button({ Title = "被皮行者附身", Callback = function() PlayAnim("rbxassetid://70432904702322") end })
TabFE:Button({ Title = "老鼠舞", Callback = function() PlayAnim("rbxassetid://123916423751437") end })
TabFE:Button({ Title = "花生酱果冻时间", Callback = function() PlayAnim("rbxassetid://129537633250603") end })
TabFE:Button({ Title = "撒尿狗", Callback = function() PlayAnim("rbxassetid://130059214239749") end })
TabFE:Button({ Title = "玛卡雷娜", Callback = function() PlayAnim("rbxassetid://91047682123297") end })
TabFE:Button({ Title = "严肃全能侠", Callback = function() PlayAnim("rbxassetid://130019914905925") end })
TabFE:Button({ Title = "翻滚", Callback = function() PlayAnim("rbxassetid://133612047483255") end })
TabFE:Button({ Title = "恐怖月份到啦", Callback = function() PlayAnim("rbxassetid://99637983789946") end })
TabFE:Button({ Title = "怪物混搭", Callback = function() PlayAnim("rbxassetid://88971195093161") end })
TabFE:Button({ Title = "无人机模式", Callback = function() PlayAnim("rbxassetid://118592095684994") end })
TabFE:Button({ Title = "植物大战僵尸向日葵", Callback = function() PlayAnim("rbxassetid://95894948496521") end })
TabFE:Button({ Title = "鱼类模式", Callback = function() PlayAnim("rbxassetid://137969542385356") end })
TabFE:Button({ Title = "拉屎", Callback = function() PlayAnim("rbxassetid://132399051509976") end })
TabFE:Button({ Title = "足球杂耍", Callback = function() PlayAnim("rbxassetid://122583653807009") end })
TabFE:Button({ Title = "工程师舞蹈", Callback = function() PlayAnim("rbxassetid://107355541549056") end })
TabFE:Button({ Title = "小鸡舞", Callback = function() PlayAnim("rbxassetid://126960077574956") end })
TabFE:Button({ Title = "他掏出了鸡儿", Callback = function() PlayAnim("rbxassetid://78347793265211") end })
TabFE:Button({ Title = "俄罗斯舞蹈", Callback = function() PlayAnim("rbxassetid://97148848007002") end })
TabFE:Button({ Title = "爬行者模式", Callback = function() PlayAnim("rbxassetid://114687548971893") end })
TabFE:Button({ Title = "灭霸舞蹈", Callback = function() PlayAnim("rbxassetid://106389948045296") end })
TabFE:Button({ Title = "俯卧撑", Callback = function() PlayAnim("rbxassetid://108313130500811") end })
TabFE:Button({ Title = "云端漂浮", Callback = function() PlayAnim("rbxassetid://106022089542174") end })
TabFE:Button({ Title = "椅子模式2", Callback = function() PlayAnim("rbxassetid://114140630538674") end })
TabFE:Button({ Title = "AI猫舞", Callback = function() PlayAnim("rbxassetid://108865839239307") end })
TabFE:Button({ Title = "蔬菜舞蹈", Callback = function() PlayAnim("rbxassetid://84352128203419") end })
TabFE:Button({ Title = "DJ哈立德", Callback = function() PlayAnim("rbxassetid://82293338535013") end })


-- ============================================================
-- ⭐ 动画标签页
-- ============================================================
Tabs.Animation:Section({ Title = "动画包" })

for _, pack in ipairs(AnimationPacks) do
    Tabs.Animation:Button({
        Title = pack.name,
        Callback = function()
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("Animate") then
                local ok, err = pcall(SetAnimations, pack.data, pack.name)
                if not ok then Notify("错误", tostring(err):sub(1, 80), 4) end
            else
                Notify("错误", "角色未加载完成，请稍后再试", 3)
            end
        end
    })
end

Tabs.Animation:Section({ Title = "自定义动画" })

local animIdInput = ""
Tabs.Animation:Input({
    Title = "输入动画ID", Placeholder = "如 507776043",
    Callback = function(v) animIdInput = v end
})

Tabs.Animation:Button({
    Title = "播放动画",
    Callback = function()
        if animIdInput == "" then Notify("错误", "请输入动画ID", 2) return end
        local id = string.match(animIdInput, "id=(%d+)") or string.match(animIdInput, "rbxassetid://(%d+)") or animIdInput
        if not tonumber(id) then Notify("错误", "ID无效", 2) return end
        pcall(playAnimation, tostring(id), animSpeed, 0)
    end
})

Tabs.Animation:Button({
    Title = "停止所有动画",
    Callback = function()
        pcall(function()
            local c = LocalPlayer.Character
            if c then
                local hum = c:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
                end
            end
        end)
        activeAnims = {} curAnimTrack = nil
        Notify("动画", "已停止", 2)
    end
})

Tabs.Animation:Toggle({
    Title = "循环播放", Default = true,
    Callback = function(s)
        animLooped = s
        if curAnimTrack then curAnimTrack.Looped = s end
    end
})

Tabs.Animation:Slider({
    Title = "动画速度",
    Value = { Min = 0, Max = 10, Default = 1 },
    Increment = 0.5,
    Callback = function(v)
        animSpeed = v
        if curAnimTrack then pcall(function() curAnimTrack:AdjustSpeed(v) end) end
    end
})

-- ============================================================
-- ⭐ 娱乐标签页
-- ============================================================
Tabs.Fun:Section({ Title = "跳跃特效" })
local JumpEffectEnabled = false
local jumpEffectConnections = {}
local jumpEffectHalos = {}
Tabs.Fun:Toggle({
    Title = "跳跃光环特效", Default = false,
    Callback = function(state)
        JumpEffectEnabled = state
        if state then
            Notify("娱乐", "跳跃特效已开启", 2)
            local CONFIG = { Segments = 120, MaxRadius = 6, TubeRadius = 0.6, Overlap = 1.2, GrowTime = 0.5, HoldTime = 0.2, FadeTime = 0.3, Cooldown = 0.3, Color = Color3.fromRGB(0, 180, 255), LightBrightness = 2.5, LightRange = 15 }
            local TUBE_HEIGHT = CONFIG.TubeRadius * 2 * CONFIG.Overlap
            local GROUND_OFFSET = CONFIG.TubeRadius / 2
            local lastSpawn = 0
            local function getGroundY(hrp, char)
                local origin = hrp.Position + Vector3.new(0, 2, 0)
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local filter = {char}
                for _, m in ipairs(jumpEffectHalos) do if m and m.Parent then table.insert(filter, m) end end
                params.FilterDescendantsInstances = filter
                local hit = workspace:Raycast(origin, Vector3.new(0, -200, 0), params)
                if hit then return hit.Position.Y end
                local hum = char:FindFirstChild("Humanoid")
                local hip = 2
                if hum and hum.HipHeight and hum.HipHeight > 0 then hip = hum.HipHeight end
                return hrp.Position.Y - hip - (hrp.Size.Y / 2)
            end
            local function spawnHalo(centerPos)
                local model = Instance.new("Model")
                model.Name = "JumpHalo"
                model.Parent = workspace
                table.insert(jumpEffectHalos, model)
                local parts = {}
                local up = Vector3.new(0, 1, 0)
                for i = 1, CONFIG.Segments do
                    local angle = (i / CONFIG.Segments) * 2 * math.pi
                    local pos = centerPos + Vector3.new(CONFIG.MaxRadius * math.cos(angle), 0, CONFIG.MaxRadius * math.sin(angle))
                    local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
                    local vZ = up:Cross(tangent)
                    local finalCF = CFrame.fromMatrix(pos, up, tangent, vZ)
                    local part = Instance.new("Part")
                    part.Shape = Enum.PartType.Cylinder
                    part.Size = Vector3.new(0.1, 0.1, 0.1)
                    part.CFrame = CFrame.new(centerPos)
                    part.Anchored = true
                    part.CanCollide = false
                    part.CastShadow = false
                    part.Material = Enum.Material.Neon
                    part.Color = CONFIG.Color
                    part.Parent = model
                    table.insert(parts, { part = part, finalCF = finalCF, finalSize = Vector3.new(CONFIG.TubeRadius, TUBE_HEIGHT, CONFIG.TubeRadius) })
                end
                local lightPart = Instance.new("Part")
                lightPart.Size = Vector3.new(0.2, 0.2, 0.2)
                lightPart.CFrame = CFrame.new(centerPos)
                lightPart.Anchored = true
                lightPart.CanCollide = false
                lightPart.CastShadow = false
                lightPart.Transparency = 1
                lightPart.Parent = model
                local light = Instance.new("PointLight")
                light.Parent = lightPart
                light.Brightness = 0
                light.Range = CONFIG.LightRange
                light.Color = CONFIG.Color
                local growInfo = TweenInfo.new(CONFIG.GrowTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                for _, data in ipairs(parts) do
                    TweenService:Create(data.part, growInfo, { CFrame = data.finalCF, Size = data.finalSize }):Play()
                end
                TweenService:Create(light, growInfo, { Brightness = CONFIG.LightBrightness }):Play()
                task.wait(CONFIG.GrowTime + CONFIG.HoldTime)
                local fadeInfo = TweenInfo.new(CONFIG.FadeTime, Enum.EasingStyle.Linear)
                for _, data in ipairs(parts) do TweenService:Create(data.part, fadeInfo, { Transparency = 1 }):Play() end
                TweenService:Create(light, fadeInfo, { Brightness = 0 }):Play()
                task.wait(CONFIG.FadeTime + 0.1)
                for i, m in ipairs(jumpEffectHalos) do if m == model then table.remove(jumpEffectHalos, i) break end end
                model:Destroy()
            end
            local function setupCharacter(char)
                local humanoid = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not humanoid or not hrp then return end
                if jumpEffectConnections[char] then jumpEffectConnections[char]:Disconnect() end
                jumpEffectConnections[char] = humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Jumping or newState == Enum.HumanoidStateType.Freefall then
                        local now = tick()
                        if now - lastSpawn >= CONFIG.Cooldown then
                            lastSpawn = now
                            local groundY = getGroundY(hrp, char)
                            local pos = Vector3.new(hrp.Position.X, groundY + GROUND_OFFSET, hrp.Position.Z)
                            task.spawn(function() spawnHalo(pos) end)
                        end
                    end
                end)
            end
            local function onCharacterAdded(char)
                char:WaitForChild("Humanoid") char:WaitForChild("HumanoidRootPart")
                setupCharacter(char)
                char.AncestryChanged:Connect(function()
                    if not char.Parent then
                        if jumpEffectConnections[char] then jumpEffectConnections[char]:Disconnect() jumpEffectConnections[char] = nil end
                    end
                end)
            end
            if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
            LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        else
            Notify("娱乐", "跳跃特效已关闭", 2)
            for char, conn in pairs(jumpEffectConnections) do if conn then conn:Disconnect() end end
            jumpEffectConnections = {}
            for _, m in ipairs(jumpEffectHalos) do if m and m.Parent then m:Destroy() end end
            jumpEffectHalos = {}
        end
    end
})
Tabs.Fun:Section({ Title = "角色外观" })

Tabs.Fun:Button({
    Title = "无头 & 断腿",
    Icon = "user",
    Callback = function()
        Notify("娱乐", "正在加载无头 & 断腿...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/cwmen755-ai/abc/refs/heads/main/Korblox%20And%20Headless"))()
        end)
        if ok then
            Notify("娱乐", "无头 & 断腿已加载", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})
Tabs.Fun:Section({ Title = "恶搞功能" })
Tabs.Fun:Button({
    Title = "⚠️ 移动就踢 (仅对自己生效)", Variant = "Destructive", Icon = "triangle-alert",
    Callback = function()
        local confirm = WindUI:Dialog({
            Title = "警告",
            Content = "这个功能开启后，你只要在游戏里移动，就会被立刻踢出游戏！确定要开启吗？",
            Buttons = {
                { Title = "取消", Variant = "Secondary" },
                { Title = "确定开启", Variant = "Primary", Callback = function()
                    Notify("娱乐", "已开启移动检测，千万别动！", 5)
                    local alreadyKicked = false
                    local moveKickConn = RunService.RenderStepped:Connect(function()
                        if alreadyKicked then return end
                        local char = LocalPlayer.Character
                        if char then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum and hum.MoveDirection.Magnitude > 0 then
                                alreadyKicked = true
                                pcall(function() LocalPlayer:Kick("\n不要移动") end)
                                if moveKickConn then moveKickConn:Disconnect() end
                            end
                        end
                    end)
                end}
            }
        })
    end
})
-- ============================================================
-- ⭐ 音乐标签页
-- ============================================================
Tabs.Music:Section({ Title = "网易云音乐" })
Tabs.Music:Paragraph({ Title = "网易云音乐 Roblox 内置版", Desc = "点击下方按钮启动，稍等片刻会出现独立悬浮窗" })
Tabs.Music:Button({
    Title = "启动网易云音乐", Variant = "Primary", Icon = "music",
    Callback = function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/meisdad321-cloud/dda158cf8ec9d771c7764bd08e8d19cb/raw/NeteaseCloudMusicForRoblox.lua"))()
        end)
        if ok then Notify("音乐", "网易云音乐加载成功！", 3)
        else Notify("加载失败", tostring(err):sub(1, 80), 5) end
    end,
})
-- ============================================================
-- ⭐ 杂项标签页
-- ============================================================
Tabs.Misc:Section({ Title = "快捷操作" })

Tabs.Misc:Button({
    Title = "刷新角色",
    Callback = function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end
})

Tabs.Misc:Button({
    Title = "重新加入",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Misc:Toggle({
    Title = "显示时间", Default = false,
    Callback = function(s)
        if s then EnableTimeDisplay() else DisableTimeDisplay() end
    end
})

Tabs.Misc:Toggle({
    Title = "显示FPS", Default = false,
    Callback = function(s)
        if s then EnableFPS() else DisableFPS() end
    end
})


-- ============================================================
-- ⭐ 脚本大全标签页
-- ============================================================
Tabs.Scripts:Section({ Title = "外部脚本加载器" })

local function LoadExternalScript(name, url)
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if ok then Notify("脚本大全", name .. "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
end

Tabs.Scripts:Button({ Title = "XA脚本", Callback = function() LoadExternalScript("XA脚本", "https://raw.gitcode.com/Xingtaiduan/Scripts/raw/main/Loader.lua") end })
Tabs.Scripts:Button({ Title = "夜脚本", Callback = function() LoadExternalScript("夜脚本", "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben") end })
Tabs.Scripts:Button({ Title = "R6🦌管", Callback = function() LoadExternalScript("R6", "https://pastefy.app/wa3v2Vgm/raw") end })
Tabs.Scripts:Button({ Title = "R15🦌管", Callback = function() LoadExternalScript("R15", "https://pastefy.app/YZoglOyJ/raw") end })
Tabs.Scripts:Button({ Title = "皮脚本", Callback = function() LoadExternalScript("皮脚本", "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua") end })
Tabs.Scripts:Button({ Title = "BS黑洞脚本", Callback = function() LoadExternalScript("BS黑洞", "https://gitee.com/BS_script/script/raw/master/BS_Script.Lua") end })
Tabs.Scripts:Button({ Title = "恐脚本😱", Callback = function() LoadExternalScript("恐脚本😱", "https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/恐脚本.NB") end })
Tabs.Scripts:Button({ Title = "黑白脚本", Callback = function() LoadExternalScript("黑白脚本", "https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器") end })

Tabs.Scripts:Paragraph({
    Title = "说明",
    Desc = "所有脚本均来自网络，用之前请用小号测试"
})

-- ============================================================
-- ⭐ 服务器脚本标签页
-- ============================================================
Tabs.Server:Section({ Title = "服务器脚本" })

Tabs.Server:Button({
    Title = "二狗子森林 99 夜",
    Icon = "moon",
    Callback = function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/99day.lua"))()
        end)
        if ok then Notify("服务器脚本", "二狗子森林 99 夜加载成功！", 3)
        else Notify("加载失败", tostring(err):sub(1, 80), 5) end
    end
})

Tabs.Server:Button({
    Title = "破坏者谜团 2",
    Icon = "sword",
    Callback = function()
        Notify("服务器脚本", "正在加载破坏者谜团 2...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xv3gasx/Murder-Mystery-2/refs/heads/main/Release.lua"))()
        end)
        if ok then
            Notify("服务器脚本", "破坏者谜团 2 加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

Tabs.Server:Button({
    Title = "皮脚本-圣奥里",
    Icon = "star",
    Callback = function()
        Notify("服务器脚本", "正在加载皮脚本-圣奥里...", 3)
        local ok, err = pcall(function()
            getgenv().XiaoPi = "皮脚本-圣奥里"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Roblox-Pi-Script-SaintOrie.lua"))()
        end)
        if ok then
            Notify("服务器脚本", "皮脚本-圣奥里加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

Tabs.Server:Button({
    Title = "逃跑者",
    Icon = "play",
    Callback = function()
        Notify("服务器脚本", "正在加载逃跑者...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://scriptkeysystem.com/loader/c15e031fb1fccfdb9928.lua"))()
        end)
        if ok then
            Notify("服务器脚本", "逃跑者加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

-- ============================================================
-- 完成通知
-- ============================================================
task.wait(0.3)
WindUI:Notify({
    Title = "脚本加载成功",
    Content = "感谢使用龙卷脚本",
    Icon = "bird",
    Duration = 3,
})