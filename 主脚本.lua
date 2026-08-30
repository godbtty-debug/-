local RanTimes = 0

local Connection = game:GetService("RunService").Heartbeat:Connect(function()
    RanTimes += 1
end)

repeat
    task.wait()
until RanTimes >= 2

Connection:Disconnect()

local lp = game:GetService("Players").LocalPlayer
if lp.Kick then
    hookfunction(lp.Kick, function() return end)
end


for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
        
        if typeof(a) == "function" then
            hookfunction(a, function(c, f, n) return true end)
        end
        
        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" then
            hookfunction(b, function(f) end)
        end
    end
end

getgenv().Options = {}
getgenv().Toggles = {}

if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not syn or not protectgui then
    getgenv().protectgui = function() end
end

local SilentAimSettings = {
    Enabled = false,
    TeamCheck = false,
    TargetPart = "Head",
    SilentAimMethod = "Raycast",
    FOVRadius = 280,
    ShowSilentAimTarget = false,
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
    HitChance = 100,
    BulletTP = false,
    FOVColor = Color3.new(1, 1, 1),
    LineColor = Color3.new(1, 0, 0),
    FOVTransparency = 0.5,
    FOVCover = false,
    FOVCentered = false,
}

local RageConfig = {
    Enabled = false,
    FireRate = 0.02,
    TargetPart = "Head",
    IgnoreTeam = true,
    MaxDistance = 2000,
    WallBang = false,
    AimMode = "Center",
    ShowTrajectory = true,
    FadeTime = 1500,
    HitSound = true,
    HitSoundVolume = 0.5,
    HitSoundPitch = 1,
    HitSoundId = "rbxassetid://4764109000",
    HitMarkerEnabled = false,
    HitMarkerLifetime = 1.5,
    InfiniteJump = {
        Enabled = false,
        Key = Enum.KeyCode.Space,
    },
    HitboxEnabled = false,
    HitboxNPC = false,
    HitboxSize = 5,
    HitboxShow = false,
    HitboxTransparency = 0.5,
    HitboxColor = Color3.new(1, 0, 0),
    TrajectoryWidth = 0.4,
    TrajectoryTextureLength = 4,
    TrajectoryType = "Beam",
    TrajectoryColor = Color3.fromRGB(0, 150, 255),
    TrajectorySpread = false,
    HitNotify = false,
}

local MovementConfig = {
    SpeedEnabled = false,
    SpeedMultiplier = 0.1,
    FlyEnabled = false,
    FlySpeed = 0.1,
    NoClipEnabled = false,
    FunctionalityEnabled = true,
}

local SelfSpinConfig = {
    Enabled = false,
    Mode = "背后打人",
}

local PhaseConfig = {
    Enabled = false,
    Mode = "NoClip",
    StudLimit = 30,
}

local DefenseConfig = {
    Disabler = false,
    StateSpoofer = false,
    AntiInvisible = false,
}

local AntiHeadEnabled = false
local AntiHandsEnabled = false

local AC = {
    NeckC0 = CFrame.new(0, 0.4, 0.3),
    NeckC1 = CFrame.new(0, -0.1, 0.4) * CFrame.Angles(math.rad(90), math.rad(-180), 0),
    LShoulder = CFrame.new(-1, 0.5, 0, 0.020794034, -7.74860382e-07, -0.999783635, -0.98459357, 0.173654854, -0.0204781592, 0.173617214, 0.984806538, 0.00361025333),
    RShoulder = CFrame.new(1, 0.5, 0, 0.020793736, 1.07288361e-06, 0.999783933, 0.984594166, 0.173652649, -0.0204781592, -0.173615277, 0.984807134, 0.00360971689),
}

local OriginalNeckC0, OriginalNeckC1 = nil, nil
local OriginalLShoulderC0, OriginalRShoulderC0 = nil, nil

local function SaveOriginalJoints(char)
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local head = char:FindFirstChild("Head")
    if head and torso then
        local neck = head:FindFirstChild("Neck") or torso:FindFirstChild("Neck")
        if neck and not OriginalNeckC0 then
            OriginalNeckC0 = neck.C0
            OriginalNeckC1 = neck.C1
        end
    end
    if torso then
        local lS = torso:FindFirstChild("Left Shoulder")
        local rS = torso:FindFirstChild("Right Shoulder")
        if lS and not OriginalLShoulderC0 then
            OriginalLShoulderC0 = lS.C0
        end
        if rS and not OriginalRShoulderC0 then
            OriginalRShoulderC0 = rS.C0
        end
    end
end

local function ApplyAntis()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local char = LocalPlayer.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local head = char:FindFirstChild("Head")
    if not torso or not head then return end
    if not OriginalNeckC0 or not OriginalLShoulderC0 then
        SaveOriginalJoints(char)
    end
    local neck = head:FindFirstChild("Neck") or torso:FindFirstChild("Neck")
    if neck then
        if AntiHeadEnabled then
            neck.C0 = AC.NeckC0
            neck.C1 = AC.NeckC1
        else
            if OriginalNeckC0 then
                neck.C0 = OriginalNeckC0
                neck.C1 = OriginalNeckC1
            end
        end
    end
    local lS = torso:FindFirstChild("Left Shoulder")
    local rS = torso:FindFirstChild("Right Shoulder")
    if lS then
        if AntiHandsEnabled then
            lS.C0 = AC.LShoulder
        else
            if OriginalLShoulderC0 then
                lS.C0 = OriginalLShoulderC0
            end
        end
    end
    if rS then
        if AntiHandsEnabled then
            rS.C0 = AC.RShoulder
        else
            if OriginalRShoulderC0 then
                rS.C0 = OriginalRShoulderC0
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(ApplyAntis)

local LocalPlayer = game:GetService("Players").LocalPlayer

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    OriginalNeckC0 = nil
    OriginalNeckC1 = nil
    OriginalLShoulderC0 = nil
    OriginalRShoulderC0 = nil
    SaveOriginalJoints(char)
    ApplyAntis()
end)

task.spawn(function()
    repeat task.wait(0.5) until game:GetService("Players").LocalPlayer.Character
    SaveOriginalJoints(game:GetService("Players").LocalPlayer.Character)
    ApplyAntis()
end)

local RageState = {
    running = false,
    last_shot_time = 0,
    totalKills = 0,
    fireCount = 0,
    killCount = 0,
    orbitAngle = 0,
}

getgenv().SilentAimSettings = SilentAimSettings

local Camera = workspace.CurrentCamera
local GameDefaultFOV = Camera.FieldOfView

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local GetPlayers = Players.GetPlayers
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GetMouseLocation = UserInputService.GetMouseLocation

local hitboxData = {}
local npcHitboxData = {}
local EntityCache = {}
local GameMode = "监狱人生"
local ShootEvent = nil
local ReloadFunction = nil
local IsPrisonLife = true
local ValidTargetParts = {"Head", "HumanoidRootPart"}

local PhaseModified = {}
local PhaseFFlag = false
local PhaseTeleported = false
local PhaseRayCheck = RaycastParams.new()
PhaseRayCheck.RespectCanCollide = true
local PhaseOverlapCheck = OverlapParams.new()
PhaseOverlapCheck.MaxParts = 9e9
local PhaseConnection = nil

local entitylib = {
    isAlive = false,
    character = nil,
    Humanoid = nil,
    RootPart = nil,
}

local function updateChar()
    local char = LocalPlayer.Character
    if char then
        entitylib.isAlive = true
        entitylib.character = char
        entitylib.Humanoid = char:FindFirstChildOfClass("Humanoid")
        entitylib.RootPart = char:FindFirstChild("HumanoidRootPart")
    else
        entitylib.isAlive = false
    end
end

local InvisibleData = {
    oldcf = nil,
    animtrack = nil,
    bindKey = nil,
    proper = true,
}

local Invisible = {Enabled = false}
local heartbeatConn = nil
local renderConn = nil

local function Invisible_animationTrickery()
    if entitylib.isAlive then
        local isR15 = entitylib.Humanoid.RigType == Enum.HumanoidRigType.R15
        local anim = Instance.new('Animation')
        anim.AnimationId = 'rbxassetid://'..(isR15 and '18537363391' or '215384594')
        InvisibleData.animtrack = entitylib.Humanoid.Animator:LoadAnimation(anim)
        if InvisibleData.animtrack then
            InvisibleData.animtrack.Priority = Enum.AnimationPriority.Action4
            InvisibleData.animtrack:Play(0, 0.001, 0)
            anim:Destroy()
            task.delay(0, function()
                if InvisibleData.animtrack then
                    InvisibleData.animtrack.TimePosition = isR15 and 0.77 or 0.38
                end
            end)
        end
    end
end

function Invisible_Enable()
    if Invisible.Enabled then return end
    Invisible.Enabled = true
    Invisible_animationTrickery()
    InvisibleData.oldcf = nil
    local bindKey = HttpService:GenerateGUID(true)
    InvisibleData.bindKey = bindKey
    renderConn = RunService:BindToRenderStep(bindKey, 0, function()
        if not Invisible.Enabled then return end
        if entitylib.isAlive and InvisibleData.oldcf then
            entitylib.RootPart.CFrame = InvisibleData.oldcf
            if InvisibleData.animtrack then
                InvisibleData.animtrack:AdjustWeight(0.001)
            end
        end
    end)
    heartbeatConn = RunService.Heartbeat:Connect(function(dt)
        if not Invisible.Enabled then return end
        if entitylib.isAlive then
            local isR15 = entitylib.Humanoid.RigType == Enum.HumanoidRigType.R15
            local root = entitylib.RootPart
            local cf = root.CFrame - Vector3.new(0, entitylib.Humanoid.HipHeight + (root.Size.Y / 2) - 1, 0)
            InvisibleData.oldcf = root.CFrame
            root.CFrame = cf * CFrame.Angles(math.rad(isR15 and 180 or 90), 0, 0)
            if InvisibleData.animtrack then
                InvisibleData.animtrack:AdjustWeight(100)
            end
        end
    end)
end

function Invisible_Disable()
    if not Invisible.Enabled then return end
    Invisible.Enabled = false
    if renderConn then
        renderConn:Disconnect()
        renderConn = nil
    end
    if heartbeatConn then
        heartbeatConn:Disconnect()
        heartbeatConn = nil
    end
    if InvisibleData.animtrack then
        pcall(function()
            InvisibleData.animtrack:Stop()
            InvisibleData.animtrack:Destroy()
        end)
        InvisibleData.animtrack = nil
    end
    if entitylib.isAlive and InvisibleData.oldcf then
        entitylib.RootPart.CFrame = InvisibleData.oldcf
        InvisibleData.oldcf = nil
    end
    if InvisibleData.bindKey then
        RunService:UnbindFromRenderStep(InvisibleData.bindKey)
        InvisibleData.bindKey = nil
    end
    InvisibleData.proper = true
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateChar()
    if Invisible.Enabled then
        task.wait(0.2)
        Invisible_Disable()
        task.wait(0.1)
        Invisible_Enable()
    end
end)

task.spawn(function()
    repeat task.wait(0.5) until LocalPlayer and LocalPlayer.Character
    updateChar()
end)

function getMousePosition()
    return GetMouseLocation(UserInputService)
end

function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then return false end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end

function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
    return chance <= Percentage / 100
end

function IsPlayerVisible(Player)
    return true
end

local function getFOVCenter()
    local viewportSize = Camera.ViewportSize
    return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end

local function getAimPoint()
    if SilentAimSettings.FOVCentered then
        return getFOVCenter()
    else
        return getMousePosition()
    end
end

local function getValidTargets(aimPoint, fovRadius, teamCheck)
    local candidates = {}
    
    for _, Player in next, GetPlayers(Players) do
        if Player == LocalPlayer then continue end
        if teamCheck and Player.Team == LocalPlayer.Team then continue end
        
        local Character = Player.Character
        if not Character then continue end
        
        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then continue end
        
        local targetPart
        if SilentAimSettings.TargetPart == "随机" then
            local validParts = {"Head", "HumanoidRootPart"}
            targetPart = Character[validParts[math.random(1, #validParts)]]
        else
            targetPart = Character[SilentAimSettings.TargetPart]
        end
        if not targetPart then continue end
        
        local ScreenPosition, OnScreen = getPositionOnScreen(targetPart.Position)
        if not OnScreen then continue end
        
        local Distance = (aimPoint - ScreenPosition).Magnitude
        if Distance > fovRadius then continue end
        
        table.insert(candidates, {
            player = Player,
            part = targetPart,
            distance = Distance
        })
    end
    
    table.sort(candidates, function(a, b) return a.distance < b.distance end)
    return candidates
end

local function getClosestPlayer()
    if not SilentAimSettings.TargetPart then return nil end
    
    local fovRadius = SilentAimSettings.FOVRadius or 130
    local teamCheck = SilentAimSettings.TeamCheck or false
    local aimPoint = getAimPoint()
    
    local candidates = getValidTargets(aimPoint, fovRadius, teamCheck)
    
    if #candidates > 0 then
        return candidates[1].part
    end
    
    return nil
end

function getClosestPlayerSimple()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local fovRadius = SilentAimSettings.FOVRadius or 130
    local teamCheck = SilentAimSettings.TeamCheck or false
    local aimPoint = getAimPoint()
    
    local bestTarget = nil
    local bestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if teamCheck and player.Team == LocalPlayer.Team then continue end
        
        local pc = player.Character
        if not pc then continue end
        
        local hum = pc:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        local targetPart = pc:FindFirstChild(SilentAimSettings.TargetPart) or pc:FindFirstChild("Head") or pc:FindFirstChild("HumanoidRootPart")
        if not targetPart or not targetPart.Parent then continue end
        
        local dist = (targetPart.Position - root.Position).Magnitude
        if dist > 2000 then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then continue end
        
        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - aimPoint).Magnitude
        if screenDist > fovRadius then continue end
        
        if screenDist < bestDist then
            bestDist = screenDist
            bestTarget = targetPart
        end
    end
    
    return bestTarget
end

function triggerEffect(targetPart)
    if not targetPart then return end
    if not SilentAimSettings._lastHoldEffect then
        SilentAimSettings._lastHoldEffect = 0
    end
    local now = tick()
    if now - SilentAimSettings._lastHoldEffect < 0.12 then return end
    SilentAimSettings._lastHoldEffect = now
    
    local startPos = getGunPosition() or Camera.CFrame.Position
    local endPos = targetPart.Position
    
    if SilentAimSettings.BulletTP then
        local randomOffset = Vector3.new((math.random() - 0.5) * 0.6, (math.random() - 0.5) * 0.6, (math.random() - 0.5) * 0.6)
        endPos = targetPart.Position + Vector3.new(0, 2, 0) + randomOffset
    end
    
    local blocked = false
    if not SilentAimSettings.BulletTP then
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
        local rayResult = workspace:Raycast(startPos, (endPos - startPos).Unit * (endPos - startPos).Magnitude, rayParams)
        if rayResult then
            blocked = true
        end
    end
    
    if RageConfig.ShowTrajectory then
        showRageTrajectory(startPos, endPos)
    end
    if RageConfig.HitSound and (not blocked or SilentAimSettings.BulletTP) then
        PlayHitSound()
    end
    Create3DMarker(endPos)
end

local trajectoryCache = {}
local MAX_TRAJECTORIES = 20

function create_tracer_beam(from_pos, to_pos)
    if typeof(from_pos) ~= "Vector3" or typeof(to_pos) ~= "Vector3" then
        return
    end
    
    local final_from = from_pos
    local final_to = to_pos
    
    if RageConfig.TrajectorySpread then
        local dist = (to_pos - from_pos).Magnitude
        local angle = math.random() * 2 * math.pi
        local dir = (to_pos - from_pos).Unit
        local up = Vector3.new(0, 1, 0)
        if math.abs(dir:Dot(up)) > 0.99 then
            up = Vector3.new(1, 0, 0)
        end
        local right = dir:Cross(up).Unit
        local localUp = right:Cross(dir).Unit
        local spreadAmount = math.random(1, 100)
        local offset = right * math.cos(angle) * spreadAmount + localUp * math.sin(angle) * spreadAmount
        final_from = from_pos + offset * 0.3
        final_to = to_pos + offset
    end
    
    if #trajectoryCache >= MAX_TRAJECTORIES then
        local oldest = table.remove(trajectoryCache, 1)
        pcall(function()
            if oldest and oldest.Parent then
                oldest:Destroy()
            end
        end)
    end
    local fade_time = RageConfig.FadeTime / 1000 or 1.5
    local width = RageConfig.TrajectoryWidth or 0.4
    local tex_len = RageConfig.TrajectoryTextureLength or 4
    local color = RageConfig.TrajectoryColor or Color3.fromRGB(0, 150, 255)
    pcall(function()
        local container = Instance.new("Folder")
        container.Name = "TrajectoryContainer"
        container.Parent = workspace
        local sp = Instance.new("Part")
        sp.Transparency = 1
        sp.Size = Vector3.new(0.05, 0.05, 0.05)
        sp.Anchored = true
        sp.CanCollide = false
        sp.Position = final_from
        sp.Parent = container
        local ep = Instance.new("Part")
        ep.Transparency = 1
        ep.Size = Vector3.new(0.05, 0.05, 0.05)
        ep.Anchored = true
        ep.CanCollide = false
        ep.Position = final_from
        ep.Parent = container
        local sa = Instance.new("Attachment")
        sa.Parent = sp
        local ea = Instance.new("Attachment")
        ea.Parent = ep
        local beam = Instance.new("Beam")
        beam.Color = ColorSequence.new(color, Color3.fromRGB(255, 255, 255))
        beam.FaceCamera = false
        beam.Attachment0 = sa
        beam.Attachment1 = ea
        beam.Width0 = width
        beam.Width1 = width
        beam.Brightness = 8
        beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0)
        })
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Texture = "rbxassetid://128372145766358"
        beam.TextureLength = tex_len
        beam.TextureSpeed = 1
        beam.TextureMode = Enum.TextureMode.Stretch
        beam.Parent = container
        table.insert(trajectoryCache, container)
        task.spawn(function()
            local tweens = game:GetService("TweenService")
            tweens:Create(ep, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = final_to}):Play()
        end)
        task.delay(fade_time, function()
            pcall(function()
                local tween = game:GetService("TweenService"):Create(beam, TweenInfo.new(0.5), {
                    Width0 = 0,
                    Width1 = 0,
                    TextureSpeed = 0
                })
                tween:Play()
                tween.Completed:Wait()
                container:Destroy()
                for i, v in ipairs(trajectoryCache) do
                    if v == container then
                        table.remove(trajectoryCache, i)
                        break
                    end
                end
            end)
        end)
    end)
end

function showRageTrajectory(startPos, endPos)
    if not RageConfig.ShowTrajectory then return end
    if not startPos or not endPos then return end
    create_tracer_beam(startPos, endPos)
end

local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = 180
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.ZIndex = 999
fov_circle.Transparency = 1
fov_circle.Color = Color3.new(1,1,1)

local lock_line = Drawing.new("Line")
lock_line.Visible = false
lock_line.ZIndex = 999
lock_line.Color = Color3.new(1, 0, 0)
lock_line.Thickness = 1.5

local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = {ArgCountRequired = 3, Args = {"Instance", "Ray", "table", "boolean", "boolean"}},
    FindPartOnRayWithWhitelist = {ArgCountRequired = 3, Args = {"Instance", "Ray", "table", "boolean"}},
    FindPartOnRay = {ArgCountRequired = 2, Args = {"Instance", "Ray", "Instance", "boolean", "boolean"}},
    Raycast = {ArgCountRequired = 3, Args = {"Instance", "Vector3", "Vector3", "RaycastParams"}},
}

local HitSoundList = {
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bubble"] = "rbxassetid://9102092728",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Cod"] = "rbxassetid://160432334",
    ["Bameware"] = "rbxassetid://6565367558",
    ["Neverlose"] = "rbxassetid://6565370984",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"] = "rbxassetid://6565371338",
}
local SelectedHitSound = "Neverlose"
local HitSounds = {}
local soundIndex = 0
local lastHitSoundTime = 0
local HIT_SOUND_COOLDOWN = 0.15

local function CreateHitSounds()
    for _, s in ipairs(HitSounds) do
        pcall(function() s:Destroy() end)
    end
    HitSounds = {}
    local id = HitSoundList[SelectedHitSound] or "rbxassetid://4764109000"
    for i = 1, 6 do
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = RageConfig.HitSoundVolume
        s.Pitch = RageConfig.HitSoundPitch
        s.Parent = SoundService
        table.insert(HitSounds, s)
    end
end

local function PlayHitSound()
    if not RageConfig.HitSound then return end
    local now = tick()
    if now - lastHitSoundTime < HIT_SOUND_COOLDOWN then return end
    lastHitSoundTime = now
    soundIndex = soundIndex % #HitSounds + 1
    local sound = HitSounds[soundIndex]
    if not sound or not sound.Parent then
        CreateHitSounds()
        sound = HitSounds[soundIndex]
    end
    if not sound then return end
    pcall(function()
        sound.Pitch = RageConfig.HitSoundPitch + math.random(-5, 5) / 100
        sound.Volume = RageConfig.HitSoundVolume * (0.9 + math.random(0, 10) / 100)
        sound.TimePosition = 0
        sound:Play()
    end)
end

CreateHitSounds()

function Create3DMarker(position)
end

local function IsDefusalGame()
    return ReplicatedStorage:FindFirstChild("Weapons") ~= nil
        and ReplicatedStorage:FindFirstChild("Gloves") ~= nil
        and ReplicatedStorage:FindFirstChild("Skins") ~= nil
end

local function IsPrisonLifeGame()
    return ReplicatedStorage:FindFirstChild("GunRemotes") ~= nil
end

local function IsRivalsGame()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    if replicatedStorage:FindFirstChild("Modules") then
        local modules = replicatedStorage.Modules
        if modules:FindFirstChild("EnumLibrary") and modules:FindFirstChild("Utility") then
            return true
        end
    end
    if localPlayer and localPlayer:FindFirstChild("PlayerScripts") then
        local ps = localPlayer.PlayerScripts
        if ps:FindFirstChild("Controllers") then
            local controllers = ps.Controllers
            if controllers:FindFirstChild("FighterController") and controllers:FindFirstChild("CameraController") then
                return true
            end
        end
    end
    return false
end

local GameType = "Unknown"
local IsDefusal = false
local IsRivals = false

local function DetectGameType()
    if IsDefusalGame() then
        GameType = "Defusal"
        IsDefusal = true
        return
    end
    if IsPrisonLifeGame() then
        local gr = ReplicatedStorage:FindFirstChild("GunRemotes")
        if gr then
            local se = gr:FindFirstChild("ShootEvent")
            if se then
                ShootEvent = se
                ReloadFunction = gr:FindFirstChild("FuncReload")
                GameType = "PrisonLife"
                IsPrisonLife = true
                return
            end
        end
    end
    if IsRivalsGame() then
        GameType = "Rivals"
        IsRivals = true
        return
    end
    GameType = "Unknown"
end

DetectGameType()

local ESP = {
    Enabled = false,
    TeamCheck = false,
    NPCEnabled = false,
    MaxDistance = 10000,
    Drawing = {
        Names = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
            Font = 0,
            Size = 16,
        },
        Distances = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
            Position = "Text",
        },
        Healthbar = {
            Enabled = true,
            Color = Color3.fromRGB(0, 255, 0),
            LowColor = Color3.fromRGB(255, 0, 0),
            LowThreshold = 30,
        },
        Weapons = {
            Enabled = false,
            Color = Color3.fromRGB(255, 255, 255),
        },
        Boxes = {
            Full = {
                Enabled = true,
                RGB = Color3.fromRGB(0, 100, 255),
            },
            Corner = {
                Enabled = false,
                RGB = Color3.fromRGB(0, 100, 255),
            },
        },
    };
}

local ESPObjects = {}
local NPCObjects = {}

local function CreateDrawingObjects(plr)
    if ESPObjects[plr] then return end
    
    local objs = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line"),
        Weapon = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
    }
    
    objs.Box.Thickness = 1.5
    objs.Box.Filled = false
    objs.Box.Color = ESP.Drawing.Boxes.Full.RGB
    objs.Box.Visible = false
    objs.Box.ZIndex = 5
    
    objs.BoxOutline.Thickness = 3.5
    objs.BoxOutline.Filled = false
    objs.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    objs.BoxOutline.Visible = false
    objs.BoxOutline.ZIndex = 4
    
    objs.Name.Size = ESP.Drawing.Names.Size
    objs.Name.Center = true
    objs.Name.Outline = true
    objs.Name.Font = ESP.Drawing.Names.Font
    objs.Name.Color = ESP.Drawing.Names.Color
    objs.Name.Visible = false
    objs.Name.ZIndex = 6
    
    objs.Health.Thickness = 2
    objs.Health.Color = ESP.Drawing.Healthbar.Color
    objs.Health.Visible = false
    objs.Health.ZIndex = 5
    
    objs.HealthOutline.Thickness = 4
    objs.HealthOutline.Color = Color3.fromRGB(0, 0, 0)
    objs.HealthOutline.Visible = false
    objs.HealthOutline.ZIndex = 4
    
    objs.Weapon.Size = 12
    objs.Weapon.Center = true
    objs.Weapon.Outline = true
    objs.Weapon.Font = 3
    objs.Weapon.Color = ESP.Drawing.Weapons.Color
    objs.Weapon.Visible = false
    objs.Weapon.ZIndex = 6
    
    objs.Distance.Size = 11
    objs.Distance.Center = true
    objs.Distance.Outline = true
    objs.Distance.Font = 3
    objs.Distance.Color = ESP.Drawing.Distances.Color
    objs.Distance.Visible = false
    objs.Distance.ZIndex = 6
    
    ESPObjects[plr] = objs
end

local function CreateNPCDrawingObjects(npc)
    if NPCObjects[npc] then return end
    
    local objs = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line"),
        Distance = Drawing.new("Text"),
    }
    
    objs.Box.Thickness = 1.5
    objs.Box.Filled = false
    objs.Box.Color = Color3.fromRGB(255, 200, 100)
    objs.Box.Visible = false
    objs.Box.ZIndex = 5
    
    objs.BoxOutline.Thickness = 3.5
    objs.BoxOutline.Filled = false
    objs.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    objs.BoxOutline.Visible = false
    objs.BoxOutline.ZIndex = 4
    
    objs.Name.Size = 13
    objs.Name.Center = true
    objs.Name.Outline = true
    objs.Name.Font = 3
    objs.Name.Color = Color3.fromRGB(255, 200, 100)
    objs.Name.Visible = false
    objs.Name.ZIndex = 6
    
    objs.Health.Thickness = 2
    objs.Health.Color = ESP.Drawing.Healthbar.Color
    objs.Health.Visible = false
    objs.Health.ZIndex = 5
    
    objs.HealthOutline.Thickness = 4
    objs.HealthOutline.Color = Color3.fromRGB(0, 0, 0)
    objs.HealthOutline.Visible = false
    objs.HealthOutline.ZIndex = 4
    
    objs.Distance.Size = 11
    objs.Distance.Center = true
    objs.Distance.Outline = true
    objs.Distance.Font = 3
    objs.Distance.Color = ESP.Drawing.Distances.Color
    objs.Distance.Visible = false
    objs.Distance.ZIndex = 6
    
    NPCObjects[npc] = objs
end

local function GetPlayerTeam(player)
    if GameType == "Defusal" then
        return player:GetAttribute("Team")
    elseif GameType == "PrisonLife" then
        return player.Team
    elseif GameType == "Rivals" then
        return player:GetAttribute("TeamID")
    end
    return nil
end

local function GetPlayerWeapon(plr)
    if GameType == "Defusal" then
        local char = plr.Character
        if char then
            local weapon = char:GetAttribute("WhatGun")
            if weapon then return weapon end
        end
        return "None"
    elseif GameType == "PrisonLife" then
        local char = plr.Character
        if not char then return "None" end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool.Name end
        return "None"
    elseif GameType == "Rivals" then
        local char = plr.Character
        if not char then return "None" end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool.Name end
        return "None"
    end
    return "None"
end

local function UpdateESPForPlayer(plr)
    if not ESPObjects[plr] then return end
    local objs = ESPObjects[plr]
    
    if not ESP.Enabled or not plr.Character then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local char = plr.Character
    local HRP = char:FindFirstChild("HumanoidRootPart")
    local Humanoid = char:FindFirstChild("Humanoid")
    
    if not HRP or not Humanoid or Humanoid.Health <= 0 then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
    local Dist = (Camera.CFrame.Position - HRP.Position).Magnitude
    
    if not OnScreen or Dist > ESP.MaxDistance then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local showESP = true
    if ESP.TeamCheck then
        local plrTeam = GetPlayerTeam(plr)
        local localTeam = GetPlayerTeam(LocalPlayer)
        if plr == LocalPlayer then
            showESP = false
        elseif plrTeam and localTeam and plrTeam == localTeam then
            showESP = false
        end
    end
    
    if not showESP then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local Size = HRP.Size.Y
    local scaleFactor = (Size * Camera.ViewportSize.Y) / (Pos.Z * 2)
    local w = math.max(30, 3 * scaleFactor)
    local h = math.max(40, 4.5 * scaleFactor)
    local health = Humanoid.Health / Humanoid.MaxHealth
    local healthPercent = math.max(0, math.min(1, health))
    
    local boxX = Pos.X - w / 2
    local boxY = Pos.Y - h / 2
    
    local boxEnabled = ESP.Drawing.Boxes.Full.Enabled
    if boxEnabled then
        objs.Box.Color = ESP.Drawing.Boxes.Full.RGB
        objs.Box.Size = Vector2.new(w, h)
        objs.Box.Position = Vector2.new(boxX, boxY)
        objs.Box.Visible = true
        
        objs.BoxOutline.Size = Vector2.new(w, h)
        objs.BoxOutline.Position = Vector2.new(boxX, boxY)
        objs.BoxOutline.Visible = true
    else
        objs.Box.Visible = false
        objs.BoxOutline.Visible = false
    end
    
    if ESP.Drawing.Healthbar.Enabled then
        local healthHeight = h * healthPercent
        local healthX = boxX - 6
        
        local healthColor = ESP.Drawing.Healthbar.Color
        if healthPercent * 100 < ESP.Drawing.Healthbar.LowThreshold then
            healthColor = ESP.Drawing.Healthbar.LowColor
        end
        
        objs.Health.Color = healthColor
        objs.Health.From = Vector2.new(healthX, boxY + h)
        objs.Health.To = Vector2.new(healthX, boxY + h - healthHeight)
        objs.Health.Visible = true
        
        objs.HealthOutline.From = Vector2.new(healthX, boxY + h + 1)
        objs.HealthOutline.To = Vector2.new(healthX, boxY - 1)
        objs.HealthOutline.Visible = true
    else
        objs.Health.Visible = false
        objs.HealthOutline.Visible = false
    end
    
    if ESP.Drawing.Names.Enabled then
        local nameText = plr.DisplayName
        if LocalPlayer:IsFriendsWith(plr.UserId) then
            nameText = "★ " .. nameText
            objs.Name.Color = Color3.fromRGB(0, 255, 0)
        else
            objs.Name.Color = ESP.Drawing.Names.Color
        end
        objs.Name.Text = nameText
        objs.Name.Position = Vector2.new(Pos.X, boxY - 18)
        objs.Name.Visible = true
    else
        objs.Name.Visible = false
    end
    
    if ESP.Drawing.Weapons.Enabled then
        local weaponName = GetPlayerWeapon(plr)
        if #weaponName > 18 then
            weaponName = string.sub(weaponName, 1, 15) .. "..."
        end
        objs.Weapon.Text = weaponName
        objs.Weapon.Position = Vector2.new(Pos.X, boxY + h + 6)
        objs.Weapon.Visible = true
    else
        objs.Weapon.Visible = false
    end
    
    if ESP.Drawing.Distances.Enabled then
        local distText = string.format("[%dm]", math.floor(Dist))
        if ESP.Drawing.Weapons.Enabled then
            objs.Distance.Position = Vector2.new(Pos.X, boxY + h + 20)
        else
            objs.Distance.Position = Vector2.new(Pos.X, boxY + h + 6)
        end
        objs.Distance.Text = distText
        objs.Distance.Visible = true
    else
        objs.Distance.Visible = false
    end
end

local function UpdateNPCESP(npc)
    if not NPCObjects[npc] then return end
    local objs = NPCObjects[npc]
    
    if not ESP.Enabled or not ESP.NPCEnabled or not npc or not npc.Parent then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local HRP = npc:FindFirstChild("HumanoidRootPart")
    local Humanoid = npc:FindFirstChildOfClass("Humanoid")
    
    if not HRP or not Humanoid or Humanoid.Health <= 0 then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
    local Dist = (Camera.CFrame.Position - HRP.Position).Magnitude
    
    if not OnScreen or Dist > ESP.MaxDistance then
        for _, obj in pairs(objs) do
            if type(obj) == "userdata" and obj.Visible ~= nil then
                obj.Visible = false
            end
        end
        return
    end
    
    local Size = HRP.Size.Y
    local scaleFactor = (Size * Camera.ViewportSize.Y) / (Pos.Z * 2)
    local w = math.max(30, 3 * scaleFactor)
    local h = math.max(40, 4.5 * scaleFactor)
    local health = Humanoid.Health / Humanoid.MaxHealth
    local healthPercent = math.max(0, math.min(1, health))
    
    local boxX = Pos.X - w / 2
    local boxY = Pos.Y - h / 2
    
    local boxEnabled = ESP.Drawing.Boxes.Full.Enabled
    if boxEnabled then
        objs.Box.Color = ESP.Drawing.Boxes.Full.RGB
        objs.Box.Size = Vector2.new(w, h)
        objs.Box.Position = Vector2.new(boxX, boxY)
        objs.Box.Visible = true
        
        objs.BoxOutline.Size = Vector2.new(w, h)
        objs.BoxOutline.Position = Vector2.new(boxX, boxY)
        objs.BoxOutline.Visible = true
    else
        objs.Box.Visible = false
        objs.BoxOutline.Visible = false
    end
    
    if ESP.Drawing.Healthbar.Enabled then
        local healthHeight = h * healthPercent
        local healthX = boxX - 6
        
        local healthColor = ESP.Drawing.Healthbar.Color
        if healthPercent * 100 < ESP.Drawing.Healthbar.LowThreshold then
            healthColor = ESP.Drawing.Healthbar.LowColor
        end
        
        objs.Health.Color = healthColor
        objs.Health.From = Vector2.new(healthX, boxY + h)
        objs.Health.To = Vector2.new(healthX, boxY + h - healthHeight)
        objs.Health.Visible = true
        
        objs.HealthOutline.From = Vector2.new(healthX, boxY + h + 1)
        objs.HealthOutline.To = Vector2.new(healthX, boxY - 1)
        objs.HealthOutline.Visible = true
    else
        objs.Health.Visible = false
        objs.HealthOutline.Visible = false
    end
    
    if ESP.Drawing.Names.Enabled then
        local nameText = npc.Name
        if ESP.Drawing.Distances.Enabled then
            nameText = nameText .. " [" .. math.floor(Dist) .. "m]"
        end
        objs.Name.Text = nameText
        objs.Name.Position = Vector2.new(Pos.X, boxY - 16)
        objs.Name.Visible = true
    else
        objs.Name.Visible = false
    end
    
    if ESP.Drawing.Distances.Enabled and not ESP.Drawing.Names.Enabled then
        local distText = string.format("[%dm]", math.floor(Dist))
        objs.Distance.Text = distText
        objs.Distance.Position = Vector2.new(Pos.X, boxY + h + 2)
        objs.Distance.Visible = true
    else
        objs.Distance.Visible = false
    end
end

local function InitESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            CreateDrawingObjects(v)
        end
    end
    
    Players.PlayerAdded:Connect(function(v)
        if v ~= LocalPlayer then
            task.wait(0.5)
            CreateDrawingObjects(v)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(v)
        if ESPObjects[v] then
            for _, obj in pairs(ESPObjects[v]) do
                if type(obj) == "userdata" then
                    pcall(function() obj:Remove() end)
                end
            end
            ESPObjects[v] = nil
        end
    end)
    
    local function CheckNPC(instance)
        if instance:IsA("Model") and instance ~= LocalPlayer.Character then
            local hum = instance:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not Players:FindFirstChild(instance.Name) then
                if not NPCObjects[instance] then
                    CreateNPCDrawingObjects(instance)
                end
                EntityCache[instance] = true
            end
        end
    end
    
    workspace.DescendantAdded:Connect(CheckNPC)
    for _, obj in pairs(workspace:GetDescendants()) do
        CheckNPC(obj)
    end
    
    workspace.DescendantRemoving:Connect(function(desc)
        if desc:IsA("Model") then
            EntityCache[desc] = nil
            if NPCObjects[desc] then
                for _, obj in pairs(NPCObjects[desc]) do
                    if type(obj) == "userdata" then
                        pcall(function() obj:Remove() end)
                    end
                end
                NPCObjects[desc] = nil
            end
        elseif desc:IsA("Humanoid") then
            local parent = desc.Parent
            if parent and NPCObjects[parent] then
                for _, obj in pairs(NPCObjects[parent]) do
                    if type(obj) == "userdata" then
                        pcall(function() obj:Remove() end)
                    end
                end
                NPCObjects[parent] = nil
            end
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        for plr, _ in pairs(ESPObjects) do
            if plr and plr ~= LocalPlayer then
                UpdateESPForPlayer(plr)
            end
        end
        for npc, _ in pairs(NPCObjects) do
            if npc and npc.Parent then
                UpdateNPCESP(npc)
            end
        end
    end)
end

InitESP()

local SelfChamsEnabled = false
local SelfChamsRainbow = false
local SelfChamsColor = Color3.new(1, 1, 1)
local SelfChamsOriginal = {}

local function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0
    if h < 60 then
        r, g, b = c, x, 0
    elseif h < 120 then
        r, g, b = x, c, 0
    elseif h < 180 then
        r, g, b = 0, c, x
    elseif h < 240 then
        r, g, b = x, 0, c
    elseif h < 300 then
        r, g, b = c, 0, x
    else
        r, g, b = c, 0, x
    end
    return Color3.new(r + m, g + m, b + m)
end

local function ApplySelfChams(char)
    if not char then return end
    SelfChamsOriginal = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            SelfChamsOriginal[part] = {Color = part.Color, Material = part.Material}
            part.Material = Enum.Material.ForceField
            part.Color = SelfChamsColor
        end
    end
end

local function RestoreSelfChams()
    for part, props in pairs(SelfChamsOriginal) do
        if part and part.Parent then
            pcall(function()
                part.Color = props.Color
                part.Material = props.Material
            end)
        end
    end
    SelfChamsOriginal = {}
end

local function UpdateSelfChams()
    if not SelfChamsEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    for part, _ in pairs(SelfChamsOriginal) do
        if part and part.Parent then
            if SelfChamsRainbow then
                local hue = (tick() * 120) % 360
                part.Color = HSVToRGB(hue, 1, 1)
            else
                part.Color = SelfChamsColor
            end
        end
    end
end
RunService.RenderStepped:Connect(UpdateSelfChams)

local WorldTimeEnabled = false
local WorldTime = 12
local WorldFOVEnabled = false
local WorldFOV = 70
local SkyboxName = "Game's Default Sky"
local DefaultClockTime = Lighting.ClockTime
local DefaultFOV = 70

local FullSkyboxes = {
    ["Game's Default Sky"] = {SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex", SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex", SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex", SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex", SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex", SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"},
    ["Sunset"] = {SkyboxBk = "rbxassetid://600830446", SkyboxDn = "rbxassetid://600831635", SkyboxFt = "rbxassetid://600832720", SkyboxLf = "rbxassetid://600886090", SkyboxRt = "rbxassetid://600833862", SkyboxUp = "rbxassetid://600835177"},
    ["Space"] = {SkyboxBk = "rbxassetid://166509999", SkyboxDn = "rbxassetid://166510057", SkyboxFt = "rbxassetid://166510116", SkyboxLf = "rbxassetid://166510092", SkyboxRt = "rbxassetid://166510131", SkyboxUp = "rbxassetid://166510114"},
    ["Red Night"] = {SkyboxBk = "rbxassetid://401664839", SkyboxDn = "rbxassetid://401664862", SkyboxFt = "rbxassetid://401664960", SkyboxLf = "rbxassetid://401664881", SkyboxRt = "rbxassetid://401664901", SkyboxUp = "rbxassetid://401664936"},
    ["Pink Skies"] = {SkyboxBk = "rbxassetid://151165214", SkyboxDn = "rbxassetid://151165197", SkyboxFt = "rbxassetid://151165224", SkyboxLf = "rbxassetid://151165191", SkyboxRt = "rbxassetid://151165206", SkyboxUp = "rbxassetid://151165227"},
    ["Purple Sunset"] = {SkyboxBk = "rbxassetid://264908339", SkyboxDn = "rbxassetid://264907909", SkyboxFt = "rbxassetid://264909420", SkyboxLf = "rbxassetid://264909758", SkyboxRt = "rbxassetid://264908886", SkyboxUp = "rbxassetid://264907379"},
    ["Blue Night"] = {SkyboxBk = "rbxassetid://12064107", SkyboxDn = "rbxassetid://12064152", SkyboxFt = "rbxassetid://12064121", SkyboxLf = "rbxassetid://12063984", SkyboxRt = "rbxassetid://12064115", SkyboxUp = "rbxassetid://12064131"},
    ["Blue Nebula"] = {SkyboxBk = "rbxassetid://135207744", SkyboxDn = "rbxassetid://135207662", SkyboxFt = "rbxassetid://135207770", SkyboxLf = "rbxassetid://135207615", SkyboxRt = "rbxassetid://135207695", SkyboxUp = "rbxassetid://135207794"},
    ["Galaxy"] = {SkyboxBk = "rbxassetid://15125283003", SkyboxDn = "rbxassetid://15125281008", SkyboxFt = "rbxassetid://15125277539", SkyboxLf = "rbxassetid://15125279325", SkyboxRt = "rbxassetid://15125274388", SkyboxUp = "rbxassetid://15125275800"},
    ["Vaporwave"] = {SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146", SkyboxFt = "rbxassetid://1417494253", SkyboxLf = "rbxassetid://1417494402", SkyboxRt = "rbxassetid://1417494499", SkyboxUp = "rbxassetid://1417494643"},
    ["Desert"] = {SkyboxBk = "rbxassetid://1013852", SkyboxDn = "rbxassetid://1013853", SkyboxFt = "rbxassetid://1013850", SkyboxLf = "rbxassetid://1013851", SkyboxRt = "rbxassetid://1013849", SkyboxUp = "rbxassetid://1013854"},
    ["Blaze"] = {SkyboxBk = "rbxassetid://150939022", SkyboxDn = "rbxassetid://150939038", SkyboxFt = "rbxassetid://150939047", SkyboxLf = "rbxassetid://150939056", SkyboxRt = "rbxassetid://150939063", SkyboxUp = "rbxassetid://150939082"},
    ["Among Us"] = {SkyboxBk = "rbxassetid://5752463190", SkyboxDn = "rbxassetid://5752463190", SkyboxFt = "rbxassetid://5752463190", SkyboxLf = "rbxassetid://5752463190", SkyboxRt = "rbxassetid://5752463190", SkyboxUp = "rbxassetid://5752463190"},
    ["Space Wave2"] = {SkyboxBk = "rbxassetid://1233158420", SkyboxDn = "rbxassetid://1233158838", SkyboxFt = "rbxassetid://1233157105", SkyboxLf = "rbxassetid://1233157640", SkyboxRt = "rbxassetid://1233157995", SkyboxUp = "rbxassetid://1233159158"},
    ["Turquoise Wave"] = {SkyboxBk = "rbxassetid://47974894", SkyboxDn = "rbxassetid://47974690", SkyboxFt = "rbxassetid://47974821", SkyboxLf = "rbxassetid://47974776", SkyboxRt = "rbxassetid://47974859", SkyboxUp = "rbxassetid://47974909"},
    ["Dark Night"] = {SkyboxBk = "rbxassetid://6285719338", SkyboxDn = "rbxassetid://6285721078", SkyboxFt = "rbxassetid://6285722964", SkyboxLf = "rbxassetid://6285724682", SkyboxRt = "rbxassetid://6285726335", SkyboxUp = "rbxassetid://6285730635"},
    ["Bright Pink"] = {SkyboxBk = "rbxassetid://271042516", SkyboxDn = "rbxassetid://271077243", SkyboxFt = "rbxassetid://271042556", SkyboxLf = "rbxassetid://271042310", SkyboxRt = "rbxassetid://271042467", SkyboxUp = "rbxassetid://271077958"},
    ["Setting Sun"] = {SkyboxBk = "rbxassetid://626460377", SkyboxDn = "rbxassetid://626460216", SkyboxFt = "rbxassetid://626460513", SkyboxLf = "rbxassetid://626473032", SkyboxRt = "rbxassetid://626458639", SkyboxUp = "rbxassetid://626460625"},
}

local function GetRandomSkyboxes(count)
    local names = {}
    for name in pairs(FullSkyboxes) do
        table.insert(names, name)
    end
    while #names > count do
        local idx = math.random(1, #names)
        table.remove(names, idx)
    end
    local result = {}
    for _, name in ipairs(names) do
        result[name] = FullSkyboxes[name]
    end
    return result
end

local Skyboxes = GetRandomSkyboxes(15)
local SkyboxNames = {}
for k, _ in pairs(Skyboxes) do
    table.insert(SkyboxNames, k)
end
table.sort(SkyboxNames)

local function ApplySkybox(name)
    local data = Skyboxes[name]
    if not data then return end
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky", Lighting)
    end
    for k, v in pairs(data) do
        sky[k] = v
    end
end

local function UpdateWorld()
    if WorldTimeEnabled then
        Lighting.ClockTime = WorldTime
    else
        Lighting.ClockTime = DefaultClockTime
    end
    if WorldFOVEnabled then
        Camera.FieldOfView = WorldFOV
    end
    ApplySkybox(SkyboxName)
end
RunService.Heartbeat:Connect(UpdateWorld)

local function Phase_GetClosestNormal(ray)
    local partCF, mag, closest = ray.Instance.CFrame, 0, Enum.NormalId.Top
    for _, normal in Enum.NormalId:GetEnumItems() do
        local dot = partCF:VectorToWorldSpace(Vector3.fromNormalId(normal)):Dot(ray.Normal)
        if dot > mag then
            mag, closest = dot, normal
        end
    end
    return Vector3.fromNormalId(closest).X ~= 0 and 'X' or 'Z'
end

local PhaseFunctions = {
    NoClip = function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in char:GetDescendants() do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end,
    Part = function()
        local chars = {Camera, LocalPlayer.Character}
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                table.insert(chars, v.Character)
            end
        end
        PhaseOverlapCheck.FilterDescendantsInstances = chars
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local parts = workspace:GetPartBoundsInBox(root.CFrame + Vector3.new(0, 1, 0), root.Size + Vector3.new(1, hum.HipHeight or 2, 1), PhaseOverlapCheck)
        for _, part in parts do
            if part.CanCollide then
                PhaseModified[part] = true
                part.CanCollide = false
            end
        end
        for part in pairs(PhaseModified) do
            if not table.find(parts, part) then
                PhaseModified[part] = nil
                part.CanCollide = true
            end
        end
    end,
    CFrame = function()
        local chars = {Camera, LocalPlayer.Character}
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                table.insert(chars, v.Character)
            end
        end
        PhaseRayCheck.FilterDescendantsInstances = chars
        PhaseOverlapCheck.FilterDescendantsInstances = chars
        local char = LocalPlayer.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not head or not root or not hum then return end
        local ray = workspace:Raycast(head.CFrame.Position, hum.MoveDirection * 1.1, PhaseRayCheck)
        if ray then
            local phaseDirection = Phase_GetClosestNormal(ray)
            if ray.Instance.Size[phaseDirection] <= PhaseConfig.StudLimit then
                local dest = root.CFrame + (ray.Normal * (-(ray.Instance.Size[phaseDirection]) - (root.Size.X / 1.5)))
                if #workspace:GetPartBoundsInBox(dest, Vector3.one, PhaseOverlapCheck) <= 0 then
                    root.CFrame = dest
                end
            end
        end
    end,
}

local function Phase_Start()
    if PhaseConnection then PhaseConnection:Disconnect() end
    PhaseConnection = RunService.Stepped:Connect(function()
        if not PhaseConfig.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        if PhaseFunctions[PhaseConfig.Mode] then
            PhaseFunctions[PhaseConfig.Mode]()
        end
    end)
end

local function Phase_Stop()
    if PhaseConnection then
        PhaseConnection:Disconnect()
        PhaseConnection = nil
    end
    if PhaseFFlag then
        setfflag('AssemblyExtentsExpansionStudHundredth', '30')
        PhaseFFlag = false
    end
    for part in pairs(PhaseModified) do
        part.CanCollide = true
    end
    table.clear(PhaseModified)
    PhaseTeleported = false
    if PhaseConfig.Mode == "NoClip" then
        local char = LocalPlayer.Character
        if char then
            for _, part in char:GetDescendants() do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local AntiInvisibleConfig = {
    Enabled = false,
    ShowNotifications = true,
}

local AntiInvisibleThreads = {}
local AntiInvisibleNotified = {}

local ANIMATION_WHITELIST = {
    ['http://www.roblox.com/asset/?id=125750702'] = true,
    ['http://www.roblox.com/asset/?id=128777973'] = true,
    ['http://www.roblox.com/asset/?id=128853357'] = true,
    ['http://www.roblox.com/asset/?id=129423030'] = true,
    ['http://www.roblox.com/asset/?id=129423131'] = true,
    ['http://www.roblox.com/asset/?id=129967390'] = true,
    ['http://www.roblox.com/asset/?id=129967478'] = true,
    ['http://www.roblox.com/asset/?id=178130996'] = true,
    ['http://www.roblox.com/asset/?id=180426354'] = true,
    ['http://www.roblox.com/asset/?id=180435571'] = true,
    ['http://www.roblox.com/asset/?id=180435792'] = true,
    ['http://www.roblox.com/asset/?id=180436148'] = true,
    ['http://www.roblox.com/asset/?id=180436334'] = true,
    ['http://www.roblox.com/asset/?id=182393478'] = true,
    ['http://www.roblox.com/asset/?id=182435998'] = true,
    ['http://www.roblox.com/asset/?id=182436842'] = true,
    ['http://www.roblox.com/asset/?id=182436935'] = true,
    ['http://www.roblox.com/asset/?id=182491037'] = true,
    ['http://www.roblox.com/asset/?id=182491065'] = true,
    ['http://www.roblox.com/asset/?id=182491248'] = true,
    ['http://www.roblox.com/asset/?id=182491277'] = true,
    ['http://www.roblox.com/asset/?id=182491368'] = true,
    ['http://www.roblox.com/asset/?id=182491423'] = true,
    ['rbxassetid://279227693'] = true,
    ['rbxassetid://279229192'] = true,
    ['rbxassetid://287112271'] = true,
    ['rbxassetid://388723916'] = true,
    ['rbxassetid://388726667'] = true,
    ['rbxassetid://389472570'] = true,
    ['rbxassetid://405194080'] = true,
    ['rbxassetid://405212265'] = true,
    ['rbxassetid://481088553'] = true,
    ['rbxassetid://481089053'] = true,
    ['rbxassetid://484200742'] = true,
    ['rbxassetid://484926359'] = true,
    ['rbxassetid://83690472549256'] = true,
    ['rbxassetid://107176344504758'] = true,
    ['rbxassetid://111090572475133'] = true,
    ['rbxassetid://113267949064300'] = true,
    ['rbxassetid://131326339350805'] = true,
}

local function AntiInvisible_CheckAnimation(animTrack, player)
    if not animTrack or not animTrack.Animation then return end
    if not player or player == LocalPlayer then return end
    local animId = animTrack.Animation.AnimationId
    if not animId then return end
    local isVapeInvisible = animId:find("18537363391") or animId:find("215384594")
    if (not ANIMATION_WHITELIST[animId] or isVapeInvisible) then
        if AntiInvisibleThreads[animTrack] then
            task.cancel(AntiInvisibleThreads[animTrack])
        end
        if AntiInvisibleConfig.ShowNotifications and not AntiInvisibleNotified[player] then
            AntiInvisibleNotified[player] = true
            pcall(function()
                if Library and Library.Notify then
                    Library:Notify({
                        Description = '反隐身: 已禁用 ' .. player.Name .. ' 的隐身',
                        Time = 3,
                        Title = "反隐身",
                        IconColor = Color3.new(1, 0, 0),
                    })
                end
            end)
            task.delay(5, function()
                AntiInvisibleNotified[player] = nil
            end)
        end
        AntiInvisibleThreads[animTrack] = task.spawn(function()
            local attempts = 0
            while AntiInvisibleConfig.Enabled and animTrack and animTrack.IsPlaying do
                pcall(function()
                    animTrack:AdjustWeight(0, 0)
                end)
                attempts = attempts + 1
                if attempts > 100 then break end
                task.wait(0.03)
            end
            AntiInvisibleThreads[animTrack] = nil
        end)
    end
end

local function AntiInvisible_ScanAllPlayers()
    if not AntiInvisibleConfig.Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local animator = hum:FindFirstChild('Animator')
        if not animator then continue end
        local success, tracks = pcall(function()
            return animator:GetPlayingAnimationTracks()
        end)
        if success and tracks and type(tracks) == "table" then
            for _, animTrack in ipairs(tracks) do
                AntiInvisible_CheckAnimation(animTrack, player)
            end
        end
    end
end

local function AntiInvisible_OnPlayerAdded(player)
    if not AntiInvisibleConfig.Enabled then return end
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        if not AntiInvisibleConfig.Enabled then return end
        task.wait(0.5)
        AntiInvisible_ScanAllPlayers()
    end)
    task.wait(0.5)
    AntiInvisible_ScanAllPlayers()
end

local function AntiInvisible_Enable()
    if AntiInvisibleConfig.Enabled then return end
    AntiInvisibleConfig.Enabled = true
    table.clear(AntiInvisibleNotified)
    Players.PlayerAdded:Connect(AntiInvisible_OnPlayerAdded)
    task.spawn(function()
        while AntiInvisibleConfig.Enabled do
            AntiInvisible_ScanAllPlayers()
            task.wait(2)
        end
    end)
    task.wait(0.5)
    AntiInvisible_ScanAllPlayers()
end

local function AntiInvisible_Disable()
    AntiInvisibleConfig.Enabled = false
    for _, thread in pairs(AntiInvisibleThreads) do
        pcall(task.cancel, thread)
    end
    table.clear(AntiInvisibleThreads)
    table.clear(AntiInvisibleNotified)
end

local BlinkData = {
    running = false,
}

local function Blink_Enable()
    if BlinkData.running then return end
    BlinkData.running = true
    pcall(function()
        setfflag('PhysicsSenderMaxBandwidthBps', '0')
        setfflag('DataSenderRate', '-1')
    end)
    task.spawn(function()
        while BlinkData.running do
            pcall(function()
                setfflag('PhysicsSenderMaxBandwidthBps', '0')
                setfflag('DataSenderRate', '-1')
            end)
            task.wait(0.05)
        end
    end)
end

local function Blink_Disable()
    if not BlinkData.running then return end
    BlinkData.running = false
    pcall(function()
        setfflag('PhysicsSenderMaxBandwidthBps', '38760')
        setfflag('DataSenderRate', '60')
    end)
end

local function UpdateMovement()
    if not MovementConfig.FunctionalityEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if MovementConfig.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
        local dir = hum.MoveDirection.Unit
        root.CFrame = root.CFrame + dir * MovementConfig.SpeedMultiplier
    end
    if MovementConfig.FlyEnabled then
        local flyDir = Vector3.zero
        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyDir = flyDir + look end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyDir = flyDir - look end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyDir = flyDir - right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyDir = flyDir + right end
        if flyDir.Magnitude > 0 then flyDir = flyDir.Unit end
        root.CFrame = root.CFrame + flyDir * MovementConfig.FlySpeed
        root.Velocity = Vector3.zero
    end
end

local function UpdateSelfSpin()
    if not SelfSpinConfig.Enabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.AutoRotate = true
            end
        end
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    hum.AutoRotate = false
    local look = cam.CFrame.LookVector
    local horizontalLook = Vector3.new(look.X, 0, look.Z).Unit
    if horizontalLook.Magnitude < 0.01 then return end
    local pos = root.Position
    if SelfSpinConfig.Mode == "背后打人" then
        hum.PlatformStand = false
        root.CFrame = CFrame.new(pos, pos - horizontalLook)
    elseif SelfSpinConfig.Mode == "倒立" then
        hum.PlatformStand = true
        local up = Vector3.new(0, -1, 0)
        root.CFrame = CFrame.lookAt(pos, pos + horizontalLook, up)
        local moveVec = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
        if moveVec.Magnitude > 0 then
            moveVec = Vector3.new(moveVec.X, 0, moveVec.Z).Unit
            root.CFrame = root.CFrame + moveVec * 0.2
        end
    end
end

RunService.Heartbeat:Connect(function()
    UpdateMovement()
    UpdateSelfSpin()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if SelfChamsEnabled then
        ApplySelfChams(char)
    else
        RestoreSelfChams()
    end
    if PhaseConfig.Enabled then
        Phase_Stop()
        task.wait(0.1)
        Phase_Start()
    end
    if DefenseConfig.AntiInvisible then
        AntiInvisible_Disable()
        task.wait(0.1)
        AntiInvisible_Enable()
    end
    if Invisible.Enabled then
        task.wait(0.2)
        Invisible_Disable()
        task.wait(0.1)
        Invisible_Enable()
    end
end)

local function getGunPosition()
    local char = LocalPlayer.Character
    if not char then return nil end
    local rightHand = char:FindFirstChild("RightHand")
    if rightHand and rightHand:IsA("BasePart") then
        return rightHand.Position
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then
            return handle.Position
        end
        for _, part in ipairs(tool:GetChildren()) do
            if part:IsA("BasePart") then
                return part.Position
            end
        end
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        return root.CFrame:PointToWorldSpace(Vector3.new(0.5, -0.2, 1.5))
    end
    return nil
end

local function checkPrisonTeam(player)
    local pt = player.Team
    if not pt then return false end
    local lt = LocalPlayer.Team
    if not lt then return false end
    local Inmates = Teams:FindFirstChild("Inmates")
    local Guards = Teams:FindFirstChild("Guards")
    local Criminals = Teams:FindFirstChild("Criminals")
    local Neutral = Teams:FindFirstChild("Neutral")
    if lt == Neutral then return false end
    if lt == Guards then
        if pt == Guards then return false end
        if pt == Inmates then
            local pc = player.Character
            if pc then
                if pc:GetAttribute("Hostile") then return true end
                if pc:GetAttribute("EnteredArmory") then return true end
                if pc:GetAttribute("EquippedHostileTool") then return true end
            end
            return false
        end
        if pt == Criminals then return true end
        return false
    end
    if pt == Guards then return true end
    return false
end

local function getRageTargetPart(player)
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild(RageConfig.TargetPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function isRageTargetVisible(player)
    local pc = player.Character
    local lc = LocalPlayer.Character
    if not (pc and lc) then return false end
    
    local root = pc:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local checkPoints = {
        root.Position,
        root.Position + Vector3.new(0, 1, 0),
        root.Position + Vector3.new(0, 2, 0),
    }
    
    local head = pc:FindFirstChild("Head")
    if head then
        table.insert(checkPoints, head.Position)
    end
    
    for _, point in ipairs(checkPoints) do
        local startPos = Camera.CFrame.Position
        local direction = (point - startPos).Unit
        local distance = (point - startPos).Magnitude
        
        if distance > 5000 then continue end
        
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {lc, pc}
        params.IgnoreWater = true
        
        local result = workspace:Raycast(startPos, direction * distance, params)
        
        if not result then
            return true
        end
        
        local hit = result.Instance
        if hit and hit:IsDescendantOf(pc) then
            return true
        end
        
        if hit and hit.Transparency and hit.Transparency > 0.5 then
            return true
        end
    end
    
    return false
end

local RageTargetCache = {}
local RageTargetCacheTime = 0
local RAGE_TARGET_CACHE_DURATION = 0.1

local function getClosestRageTarget()
    if not RageState.running then return nil end
    
    local now = tick()
    if now - RageTargetCacheTime < RAGE_TARGET_CACHE_DURATION then
        return RageTargetCache.target
    end
    
    local char = LocalPlayer.Character
    if not char then
        RageTargetCache.target = nil
        RageTargetCacheTime = now
        return nil
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        RageTargetCache.target = nil
        RageTargetCacheTime = now
        return nil
    end
    local myPos = root.Position
    local viewportSize = Camera.ViewportSize
    
    local aimPoint
    if RageConfig.AimMode == "Mouse" then
        local mousePos = getMousePosition()
        if mousePos then
            aimPoint = Vector2.new(mousePos.X, mousePos.Y)
        else
            aimPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        end
    else
        aimPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    end
    
    local bestTarget = nil
    local bestScore = math.huge
    
    local players = Players:GetPlayers()
    
    for i = 1, #players do
        local player = players[i]
        if player == LocalPlayer then continue end
        if IsPrisonLife and not checkPrisonTeam(player) then continue end
        if RageConfig.IgnoreTeam and player.Team == LocalPlayer.Team then continue end
        
        local pc = player.Character
        if not pc then continue end
        
        local humanoid = pc:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local targetPart = getRageTargetPart(player)
        if not targetPart then continue end
        
        if not RageConfig.WallBang then
            if not isRageTargetVisible(player) then continue end
        end
        
        local dist = (targetPart.Position - myPos).Magnitude
        if dist > RageConfig.MaxDistance then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then continue end
        
        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - aimPoint).Magnitude
        
        if screenDist < bestScore then
            bestScore = screenDist
            bestTarget = player
        end
    end
    
    RageTargetCache.target = bestTarget
    RageTargetCacheTime = now
    return bestTarget
end

local HitNotifyData = {}

local HIT_WINDOW = 1.0

local function ShowHitNotify(player, distance, health)
    if not RageConfig.HitNotify then return end
    if not player then return end
    
    local now = tick()
    local playerKey = player
    
    if not HitNotifyData[playerKey] then
        HitNotifyData[playerKey] = {
            lastHealth = health or 100,
            hitCount = 0,
            lastHitTime = 0
        }
    end
    
    local data = HitNotifyData[playerKey]
    
    local healthChanged = health ~= data.lastHealth
    
    if healthChanged then
        if now - data.lastHitTime > HIT_WINDOW then
            data.hitCount = 1
        else
            data.hitCount = data.hitCount + 1
        end
        
        data.lastHealth = health
        data.lastHitTime = now
        
        local displayName = player.DisplayName or player.Name or "Unknown"
        local playerName = displayName
        if #playerName > 15 then
            playerName = string.sub(playerName, 1, 12) .. "..."
        end
        
        local healthDisplay = health or 0
        local distDisplay = math.floor(distance or 0)
        
        local msg = string.format(
            "%s | %d%% | %dm",
            playerName,
            healthDisplay,
            distDisplay
        )
        
        if Library and Library.Notify then
            Library:Notify({
                Description = msg,
                Time = 2.5,
                Title = "Hit",
            })
        else
            print(msg)
        end
    else
        data.hitCount = data.hitCount + 1
        data.lastHitTime = now
    end
end

Players.PlayerRemoving:Connect(function(player)
    HitNotifyData[player] = nil
end)

local function ResetHitNotifyData(player)
    if player and HitNotifyData[player] then
        HitNotifyData[player] = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        ResetHitNotifyData(player)
    end)
end)

local function shootAt(player)
    if not player then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local pc = player.Character
    if not pc then return false end
    local humanoid = pc:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    local targetPart = pc:FindFirstChild("Head") or pc:FindFirstChild("HumanoidRootPart")
    if not targetPart then return false end
    local current_time = tick()
    if current_time - RageState.last_shot_time < RageConfig.FireRate then return false end
    if IsPrisonLife then
        local current_ammo = tool:GetAttribute("CurrentAmmo")
        local max_ammo = tool:GetAttribute("MaxAmmo")
        if current_ammo and current_ammo == 0 and max_ammo then
            local attempts = 0
            repeat
                task.wait(0.1)
                if ReloadFunction then pcall(function() ReloadFunction:InvokeServer() end) end
                current_ammo = tool:GetAttribute("CurrentAmmo")
                attempts = attempts + 1
            until current_ammo == max_ammo or attempts >= 30
            if attempts >= 30 then return false end
        end
    end
    local startPos = getGunPosition()
    if not startPos then
        startPos = Camera.CFrame.Position
        if not startPos then return false end
    end
    local endPos = targetPart.Position
    local dist = (endPos - startPos).Magnitude
    if dist > RageConfig.MaxDistance then return false end
    local direction = (endPos - startPos).Unit
    if not RageConfig.WallBang then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char, pc}
        local rayResult = workspace:Raycast(startPos, direction * dist, params)
        if rayResult and rayResult.Instance.CanCollide then
            return false
        end
    end
    local finalStart = startPos
    local finalEnd = endPos
    if RageConfig.ShowTrajectory then
        showRageTrajectory(finalStart, finalEnd)
    end
    local success = false
    if IsPrisonLife then
        local gunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
        if gunRemotes then
            local shootEvent = gunRemotes:FindFirstChild("ShootEvent")
            if shootEvent then
                local toolName = tool.Name
                if toolName == "Remington 870" then
                    local args = {
                        {
                            {finalStart, finalEnd, targetPart},
                            {finalStart, finalEnd, targetPart},
                            {finalStart, finalEnd, targetPart},
                            {finalStart, finalEnd, targetPart},
                            {finalStart, finalEnd, targetPart}
                        }
                    }
                    success = pcall(function() shootEvent:FireServer(unpack(args)) end)
                else
                    local args = {{ {finalStart, finalEnd, targetPart} }}
                    success = pcall(function() shootEvent:FireServer(unpack(args)) end)
                end
            end
        end
    end
    if success then
        RageState.last_shot_time = current_time
        PlayHitSound()
        local targetHealth = humanoid and humanoid.Health or 0
        local maxHealth = humanoid and humanoid.MaxHealth or 100
        local healthPercent = maxHealth > 0 and math.floor((targetHealth / maxHealth) * 100) or 0
        ShowHitNotify(player, dist, healthPercent)
        return true
    end
    return false
end

local RageUpdateCooldown = 0
local RAGE_UPDATE_INTERVAL = 0.05

local function updateRagebot()
    if not RageState.running then return end
    
    local now = tick()
    if now - RageUpdateCooldown < RAGE_UPDATE_INTERVAL then return end
    RageUpdateCooldown = now
    
    local target = getClosestRageTarget()
    if target then
        if shootAt(target) then
            RageState.totalKills = RageState.totalKills + 1
        end
    end
end

RunService.Heartbeat:Connect(updateRagebot)

local DefusalRage = {
    Enabled = false,
    LastShotTick = 0,
    FireEvent = nil,
}

local function GetDefusalFireEvent()
    local b = ReplicatedStorage
    if not b then return nil end
    local function weaponFireRemoteNameFromSeed(seed)
        local t, u = math.max(1, math.floor(seed) % 2147483647), {}
        for v = 1, 24 do
            t = t * 48271 % 2147483647
            local w = t % 62 + 1
            u[v] = string.sub('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', w, w)
        end
        return 'sus_' .. table.concat(u)
    end
    local function getWeaponFireRemote()
        local s = b:GetAttribute('AmongUsSauce')
        while typeof(s) ~= 'number' do
            b:GetAttributeChangedSignal('AmongUsSauce'):Wait()
            s = b:GetAttribute('AmongUsSauce')
        end
        return b:WaitForChild('Events'):WaitForChild(weaponFireRemoteNameFromSeed(s))
    end
    return getWeaponFireRemote()
end

if IsDefusal then
    DefusalRage.FireEvent = GetDefusalFireEvent()
    ReplicatedStorage:GetAttributeChangedSignal('AmongUsSauce'):Connect(function()
        DefusalRage.FireEvent = GetDefusalFireEvent()
    end)

    local DefusalRageUpdateCooldown = 0
    local DEFUSAL_RAGE_INTERVAL = 0.05

    local function DefusalRageUpdate()
        if not DefusalRage.Enabled then return end
        if not RageConfig.Enabled then return end
        
        local now = tick()
        if now - DefusalRageUpdateCooldown < DEFUSAL_RAGE_INTERVAL then return end
        DefusalRageUpdateCooldown = now
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local equippedWeapon = char:GetAttribute('WhatGun')
        if not equippedWeapon or equippedWeapon == 'C4' then return end
        
        local weaponFolder = ReplicatedStorage.Weapons:FindFirstChild(equippedWeapon)
        if not weaponFolder then return end
        if weaponFolder:GetAttribute('WeaponType') == 'Throwable' then return end
        
        local fireRate = weaponFolder:GetAttribute('FireRate') or 0.1
        local scopedFireRate = weaponFolder:GetAttribute('ScopedFireRate') or fireRate
        local currentFireRate = char:GetAttribute('Aiming') and scopedFireRate or fireRate
        if RageConfig.FireRate then currentFireRate = RageConfig.FireRate end
        
        if now - DefusalRage.LastShotTick < currentFireRate then return end
        
        local myTeam = LocalPlayer:GetAttribute('Team')
        local startPos = Camera.CFrame.Position
        local viewportSize = Camera.ViewportSize
        
        local aimPoint
        if RageConfig.AimMode == "Mouse" then
            local mousePos = getMousePosition()
            if mousePos then
                aimPoint = Vector2.new(mousePos.X, mousePos.Y)
            else
                aimPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            end
        else
            aimPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        end
        
        local targets = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player:GetAttribute('Alive') or player:GetAttribute('Health') <= 0 then continue end
            if RageConfig.IgnoreTeam and player:GetAttribute('Team') == myTeam then continue end
            if player.Character:FindFirstChildWhichIsA('ForceField') then continue end
            
            local targetPart = player.Character:FindFirstChild(RageConfig.TargetPart) or player.Character:FindFirstChild('Head')
            if not targetPart then continue end
            
            local dist = (targetPart.Position - startPos).Magnitude
            if dist > RageConfig.MaxDistance then continue end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if not onScreen then continue end
            
            local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - aimPoint).Magnitude
            
            local visible = false
            if RageConfig.WallBang then
                visible = true
            else
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Blacklist
                params.FilterDescendantsInstances = {LocalPlayer.Character}
                params.IgnoreWater = true
                local ray = workspace:Raycast(startPos, (targetPart.Position - startPos).Unit * dist, params)
                if not ray then
                    visible = true
                elseif ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
                    visible = true
                end
            end
            
            if visible then
                table.insert(targets, {
                    player = player,
                    part = targetPart,
                    dist = dist,
                    screenDist = screenDist,
                    visible = visible
                })
            end
        end
        
        table.sort(targets, function(a, b) return a.screenDist < b.screenDist end)
        
        for _, target in ipairs(targets) do
            if DefusalRage.FireEvent then
                local finalStart = startPos
                local finalEnd = target.part.Position
                
                if RageConfig.ShowTrajectory then
                    showRageTrajectory(finalStart, finalEnd)
                end
                
                local shootData = {
                    Normal = Vector3.zero,
                    Position = target.part.Position + Vector3.one,
                    Hit = target.part.Parent,
                    cCF = Camera.CFrame,
                    hS = target.part.Size and target.part.Size.Magnitude,
                    hP = target.part.Position,
                    PartName = target.part.Name,
                    Wallbang = not target.visible,
                    Noscope = false,
                    Backstab = false,
                    Ratio = 1
                }
                
                local success = pcall(function()
                    DefusalRage.FireEvent:FireServer(
                        shootData,
                        weaponFolder,
                        nil,
                        true,
                        Camera.CFrame,
                        target.part.Position,
                        nil,
                        nil
                    )
                end)
                
                if success then
                    DefusalRage.LastShotTick = now
                    RageState.totalKills = RageState.totalKills + 1
                    PlayHitSound()
                    local targetHealth = target.player:GetAttribute('Health') or 0
                    local maxHealth = target.player:GetAttribute('MaxHealth') or 100
                    local healthPercent = maxHealth > 0 and math.floor((targetHealth / maxHealth) * 100) or 0
                    ShowHitNotify(target.player, target.dist, healthPercent)
                    break
                end
            end
        end
    end
    
    RunService.Heartbeat:Connect(DefusalRageUpdate)
end

local RivalsRage = {
    Enabled = false,
    LastShotTick = 0,
    FireRate = 0.08,
    TargetPart = "Head",
    MaxDistance = 2000,
    WallBang = false,
    IgnoreTeam = true,
    AimMode = "Center",
}

local function getRivalsWeapon()
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return nil end
    local firstPerson = viewModels:FindFirstChild("FirstPerson")
    if not firstPerson then return nil end
    for _, child in ipairs(firstPerson:GetChildren()) do
        local parts = {}
        for part in child.Name:gmatch("[^-]+") do
            table.insert(parts, part:match("^%s*(.-)%s*$"))
        end
        if #parts >= 2 then
            return parts[2]
        end
    end
    return nil
end

local function getRivalsTargetPart(player)
    local char = player.Character
    if not char then return nil end
    local targetMap = {
        Head = "Head",
        ["HumanoidRootPart"] = "HumanoidRootPart",
        Torso = "UpperTorso",
        ["LowerTorso"] = "LowerTorso",
    }
    local partName = targetMap[RivalsRage.TargetPart] or "Head"
    return char:FindFirstChild(partName) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function getRivalsTeam(player)
    if not player then return nil end
    return player:GetAttribute("TeamID")
end

local function isRivalsPlayerAlive(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return true
end

local function isRivalsTargetVisible(player)
    local pc = player.Character
    local lc = LocalPlayer.Character
    if not (pc and lc) then return false end
    
    local targetPart = getRivalsTargetPart(player)
    if not targetPart then return false end
    
    local checkPoints = {
        targetPart.Position,
        targetPart.Position + Vector3.new(0, 0.5, 0),
    }
    
    for _, point in ipairs(checkPoints) do
        local startPos = Camera.CFrame.Position
        local direction = (point - startPos).Unit
        local distance = (point - startPos).Magnitude
        
        if distance > 5000 then continue end
        
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {lc, pc}
        params.IgnoreWater = true
        
        local result = workspace:Raycast(startPos, direction * distance, params)
        
        if not result then
            return true
        end
        
        local hit = result.Instance
        if hit and hit:IsDescendantOf(pc) then
            return true
        end
        
        if hit and hit.Transparency and hit.Transparency > 0.5 then
            return true
        end
    end
    
    return false
end

local function getClosestRivalsTarget()
    if not RivalsRage.Enabled then return nil end
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position
    local viewportSize = Camera.ViewportSize
    
    local aimPoint
    if RivalsRage.AimMode == "Mouse" then
        local mousePos = getMousePosition()
        aimPoint = mousePos or Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    else
        aimPoint = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    end
    
    local bestTarget = nil
    local bestScore = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not isRivalsPlayerAlive(player) then continue end
        if RivalsRage.IgnoreTeam then
            local myTeam = getRivalsTeam(LocalPlayer)
            local theirTeam = getRivalsTeam(player)
            if myTeam and theirTeam and myTeam == theirTeam then continue end
        end
        local targetPart = getRivalsTargetPart(player)
        if not targetPart then continue end
        if not RivalsRage.WallBang then
            if not isRivalsTargetVisible(player) then continue end
        end
        local dist = (targetPart.Position - myPos).Magnitude
        if dist > RivalsRage.MaxDistance then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then continue end
        
        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - aimPoint).Magnitude
        
        if screenDist < bestScore then
            bestScore = screenDist
            bestTarget = {player = player, part = targetPart, dist = dist}
        end
    end
    return bestTarget
end

local function shootRivals(targetData)
    if not targetData then return false end
    if not targetData.player or not targetData.part then return false end
    local now = tick()
    if now - RivalsRage.LastShotTick < RivalsRage.FireRate then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local weapon = getRivalsWeapon()
    if not weapon or weapon == "Fists" then return false end
    local function getMuzzlePos()
        local vm = workspace:FindFirstChild("ViewModels")
        if not vm then return nil end
        local fp = vm:FindFirstChild("FirstPerson")
        if not fp then return nil end
        local playerName = LocalPlayer.Name
        for _, model in pairs(fp:GetChildren()) do
            if model:IsA("Model") and model.Name:find("^" .. playerName) then
                local iv = model:FindFirstChild("ItemVisual")
                if iv then
                    local body = iv:FindFirstChild("Body")
                    if body then
                        local bp = body:FindFirstChild("BodyPrimary")
                        if bp then
                            local muzzle = bp:FindFirstChild("_muzzle")
                            if muzzle and muzzle:IsA("Attachment") then
                                return muzzle.WorldPosition
                            end
                        end
                    end
                end
            end
        end
        return nil
    end
    local startPos = getMuzzlePos() or Camera.CFrame.Position
    local endPos = targetData.part.Position
    if not RivalsRage.WallBang then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char, targetData.player.Character}
        local result = workspace:Raycast(startPos, (endPos - startPos).Unit * (endPos - startPos).Magnitude, params)
        if result and result.Instance.CanCollide then
            return false
        end
    end
    local function getRivalsFireRemote()
        local rs = game:GetService("ReplicatedStorage")
        local remotes = rs:FindFirstChild("Remotes")
        if not remotes then return nil end
        local replication = remotes:FindFirstChild("Replication")
        if not replication then return nil end
        local fighter = replication:FindFirstChild("Fighter")
        if not fighter then return nil end
        return fighter:FindFirstChild("UseItem")
    end
    local fireRemote = getRivalsFireRemote()
    if not fireRemote then return false end
    local function getObjectID()
        local lf = LocalPlayer:FindFirstChild("PlayerScripts")
        if not lf then return nil end
        local controllers = lf:FindFirstChild("Controllers")
        if not controllers then return nil end
        local fc = controllers:FindFirstChild("FighterController")
        if not fc then return nil end
        local ok, controller = pcall(require, fc)
        if not ok or not controller then return nil end
        if controller.LocalFighter and controller.LocalFighter.EquippedItem then
            return controller.LocalFighter.EquippedItem:Get("ObjectID")
        end
        return nil
    end
    local objectId = getObjectID()
    if not objectId then return false end
    local function getEnumLibrary()
        local rs = game:GetService("ReplicatedStorage")
        local modules = rs:FindFirstChild("Modules")
        if not modules then return nil end
        local enumLib = modules:FindFirstChild("EnumLibrary")
        if not enumLib then return nil end
        local ok, lib = pcall(require, enumLib)
        if ok then return lib end
        return nil
    end
    local enumLib = getEnumLibrary()
    if not enumLib then return false end
    local function getUtility()
        local rs = game:GetService("ReplicatedStorage")
        local modules = rs:FindFirstChild("Modules")
        if not modules then return nil end
        local util = modules:FindFirstChild("Utility")
        if not util then return nil end
        local ok, lib = pcall(require, util)
        if ok then return lib end
        return nil
    end
    local util = getUtility()
    if not util then return false end
    local data = {
        [utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(CFrame.new(startPos, endPos)),
            [utf8.char(1)] = util:EncodeCFrame(CFrame.new(startPos, endPos)),
            [utf8.char(2)] = targetData.part,
            [utf8.char(3)] = util:EncodeCFrame(CFrame.new(0.43, 0.25, 0.42)),
        },
    }
    local startShooting = enumLib:ToEnum("StartShooting")
    if RageConfig.ShowTrajectory then
        showRageTrajectory(startPos, endPos)
    end
    local success = pcall(function()
        fireRemote:FireServer(objectId, startShooting, data, nil)
    end)
    if success then
        RivalsRage.LastShotTick = now
        PlayHitSound()
        local char = targetData.player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local targetHealth = hum and hum.Health or 0
        local maxHealth = hum and hum.MaxHealth or 100
        local healthPercent = maxHealth > 0 and math.floor((targetHealth / maxHealth) * 100) or 0
        ShowHitNotify(targetData.player, targetData.dist, healthPercent)
        return true
    end
    return false
end

local function updateRivalsRage()
    if not RivalsRage.Enabled then return end
    if not RageConfig.Enabled then return end
    local target = getClosestRivalsTarget()
    if target then
        shootRivals(target)
    end
end

local function updateAllRage()
    if not RageConfig.Enabled then return end
    if GameType == "Rivals" then
        updateRivalsRage()
    elseif GameType == "PrisonLife" then
        updateRagebot()
    elseif GameType == "Defusal" then
    end
end

RunService.Heartbeat:Connect(updateAllRage)

local function ApplyHitboxToModel(model)
    if not model or model == LocalPlayer.Character then return end
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local key = model
    local dataTable = hitboxData
    if not Players:FindFirstChild(model.Name) then
        dataTable = npcHitboxData
    end
    if not dataTable[key] then
        dataTable[key] = {
            size = root.Size,
            transparency = root.Transparency,
            color = root.Color,
            canCollide = root.CanCollide
        }
    end
    root.Size = Vector3.new(RageConfig.HitboxSize, RageConfig.HitboxSize, RageConfig.HitboxSize)
    root.Transparency = RageConfig.HitboxShow and RageConfig.HitboxTransparency or 1
    root.Color = RageConfig.HitboxColor
end

local function ResetHitboxForModel(model)
    local key = model
    local dataTable = hitboxData
    if not Players:FindFirstChild(model.Name) then
        dataTable = npcHitboxData
    end
    local data = dataTable[key]
    if data then
        local root = model:FindFirstChild("HumanoidRootPart")
        if root then
            root.Size = data.size
            root.Transparency = data.transparency
            root.Color = data.color
            root.CanCollide = data.canCollide
        end
        dataTable[key] = nil
    end
end

local function UpdateHitboxProperties()
    for model, data in pairs(hitboxData) do
        local root = model:FindFirstChild("HumanoidRootPart")
        if root then
            root.Size = Vector3.new(RageConfig.HitboxSize, RageConfig.HitboxSize, RageConfig.HitboxSize)
            root.Transparency = RageConfig.HitboxShow and RageConfig.HitboxTransparency or 1
            root.Color = RageConfig.HitboxColor
        else
            hitboxData[model] = nil
        end
    end
    if RageConfig.HitboxNPC then
        for model, data in pairs(npcHitboxData) do
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(RageConfig.HitboxSize, RageConfig.HitboxSize, RageConfig.HitboxSize)
                root.Transparency = RageConfig.HitboxShow and RageConfig.HitboxTransparency or 1
                root.Color = RageConfig.HitboxColor
            else
                npcHitboxData[model] = nil
            end
        end
    end
end

local function ApplyHitboxToAll()
    if not RageConfig.HitboxEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            ApplyHitboxToModel(p.Character)
        end
    end
    if RageConfig.HitboxNPC then
        for npc in pairs(EntityCache) do
            if npc and npc.Parent then
                ApplyHitboxToModel(npc)
            end
        end
    end
end

local function ResetHitboxForAll()
    for p, _ in pairs(hitboxData) do
        ResetHitboxForModel(p)
    end
    for npc, _ in pairs(npcHitboxData) do
        ResetHitboxForModel(npc)
    end
    hitboxData = {}
    npcHitboxData = {}
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if RageConfig.HitboxEnabled and p ~= LocalPlayer then
            ApplyHitboxToModel(p.Character)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(p)
    ResetHitboxForModel(p)
end)
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            if RageConfig.HitboxEnabled then
                ApplyHitboxToModel(p.Character)
            end
        end)
    end
end

workspace.DescendantAdded:Connect(function(inst)
    if inst:IsA("Model") and inst ~= LocalPlayer.Character then
        local hum = inst:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and not Players:FindFirstChild(inst.Name) then
            EntityCache[inst] = true
            if RageConfig.HitboxEnabled and RageConfig.HitboxNPC then
                task.wait(0.1)
                ApplyHitboxToModel(inst)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not RageConfig.InfiniteJump.Enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local key = RageConfig.InfiniteJump.Key or Enum.KeyCode.Space
    if not UserInputService:IsKeyDown(key) then return end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
        root.Velocity = Vector3.new(root.Velocity.X, 10, root.Velocity.Z)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        RageConfig.Enabled = not RageConfig.Enabled
        RageState.running = RageConfig.Enabled
        if IsDefusal then
            DefusalRage.Enabled = RageConfig.Enabled
        end
        if GameType == "Rivals" then
            RivalsRage.Enabled = RageConfig.Enabled
        end
    end
end)

local Mouse = LocalPlayer:GetMouse()
local oldNamecall
local oldIndex

local function getSilentAimTarget()
    if not SilentAimSettings.Enabled then return nil end
    if not SilentAimSettings.TargetPart then return nil end
    
    local fovRadius = SilentAimSettings.FOVRadius or 130
    local teamCheck = SilentAimSettings.TeamCheck or false
    local aimPoint = getAimPoint()
    
    local candidates = getValidTargets(aimPoint, fovRadius, teamCheck)
    
    if #candidates > 0 then
        return candidates[1].part
    end
    
    return nil
end

oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]
    local chance = CalculateChance(SilentAimSettings.HitChance)
    if SilentAimSettings.Enabled and self == workspace and not checkcaller() and chance == true then
        local HitPart = getClosestPlayer()
        if HitPart then
            local Origin = nil
            local Ray = Arguments[2]
            
            if Method == "Raycast" then
                Origin = Arguments[2]
            elseif Method == "FindPartOnRay" or Method == "findPartOnRay" or 
                   Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRayWithWhitelist" then
                if Ray and typeof(Ray) == "Ray" then
                    Origin = Ray.Origin
                end
            end
            
            if Origin then
                local newOrigin = Origin
                if SilentAimSettings.BulletTP then
                    newOrigin = (HitPart.CFrame * CFrame.new(0, 0, 1)).p
                end
                
                local Direction = (HitPart.Position - newOrigin).Unit * 1000
                
                if Method == "Raycast" and SilentAimSettings.SilentAimMethod == Method then
                    Arguments[2] = newOrigin
                    Arguments[3] = Direction
                    return oldNamecall(unpack(Arguments))
                elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and SilentAimSettings.SilentAimMethod:lower() == Method:lower() then
                    Arguments[2] = Ray.new(newOrigin, Direction)
                    return oldNamecall(unpack(Arguments))
                elseif Method == "FindPartOnRayWithIgnoreList" and SilentAimSettings.SilentAimMethod == Method then
                    Arguments[2] = Ray.new(newOrigin, Direction)
                    return oldNamecall(unpack(Arguments))
                elseif Method == "FindPartOnRayWithWhitelist" and SilentAimSettings.SilentAimMethod == Method then
                    Arguments[2] = Ray.new(newOrigin, Direction)
                    return oldNamecall(unpack(Arguments))
                end
            end
        end
    end
    return oldNamecall(...)
end))

oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if self == Mouse and not checkcaller() and SilentAimSettings.Enabled and SilentAimSettings.SilentAimMethod == "Mouse.Hit/Target" then
        local targetPart = getSilentAimTarget()
        if targetPart then
            if Index == "Target" or Index == "target" then 
                return targetPart
            elseif Index == "Hit" or Index == "hit" then
                local prediction = SilentAimSettings.MouseHitPrediction or false
                local predAmount = SilentAimSettings.MouseHitPredictionAmount or 0.165
                if prediction and targetPart.Parent and targetPart.Parent:FindFirstChild("HumanoidRootPart") then
                    local root = targetPart.Parent.HumanoidRootPart
                    if root and root.Velocity then
                        return targetPart.CFrame + (root.Velocity * predAmount)
                    end
                end
                return targetPart.CFrame
            elseif Index == "X" or Index == "x" then 
                return self.X 
            elseif Index == "Y" or Index == "y" then 
                return self.Y 
            elseif Index == "UnitRay" then 
                return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
            end
        end
    end
    return oldIndex(self, Index)
end))

_G.frameCounter = 0
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        _G.frameCounter = _G.frameCounter + 1
        if _G.frameCounter % 2 ~= 0 then return end
        
        local fovPos
        if SilentAimSettings.FOVCentered then
            fovPos = getFOVCenter()
        else
            fovPos = getMousePosition()
        end
        
        if SilentAimSettings.FOVVisible and SilentAimSettings.Enabled then
            fov_circle.Visible = true
            fov_circle.Position = fovPos
            fov_circle.Radius = SilentAimSettings.FOVRadius or 130
            fov_circle.Color = SilentAimSettings.FOVColor or Color3.new(1, 1, 1)
            fov_circle.Transparency = SilentAimSettings.FOVTransparency or 0.5
        else
            fov_circle.Visible = false
        end
        
        if SilentAimSettings.ShowSilentAimTarget and SilentAimSettings.Enabled then
            local target = getSilentAimTarget()
            if target then
                local screenPos, onScreen = WorldToViewportPoint(Camera, target.Position)
                if onScreen then
                    local fromPos = fovPos
                    lock_line.From = fromPos
                    lock_line.To = Vector2.new(screenPos.X, screenPos.Y)
                    lock_line.Visible = true
                    lock_line.Color = SilentAimSettings.LineColor or Color3.new(1, 0, 0)
                    lock_line.Thickness = 1.5
                else
                    lock_line.Visible = false
                end
            else
                lock_line.Visible = false
            end
        else
            lock_line.Visible = false
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    for animTrack, thread in pairs(AntiInvisibleThreads) do
        if animTrack and animTrack.Animation then
            local owner = animTrack.Animation.Owner
            if owner and owner.Parent == player.Character then
                pcall(task.cancel, thread)
                AntiInvisibleThreads[animTrack] = nil
            end
        end
    end
end)

local DigConfig = {
    Enabled = false,
    Depth = 1.5,
    _phaseEnabled = false,
    _lastValidY = nil,
}

local DigConnection = nil
local DigPhaseOriginalEnabled = false

local function Dig_EnablePhase()
    if DigConfig._phaseEnabled then return end
    DigPhaseOriginalEnabled = PhaseConfig.Enabled
    PhaseConfig.Enabled = true
    PhaseConfig.Mode = "Part"
    if not PhaseConnection then
        Phase_Start()
    end
    DigConfig._phaseEnabled = true
end

local function Dig_DisablePhase()
    if not DigConfig._phaseEnabled then return end
    if not DigPhaseOriginalEnabled then
        PhaseConfig.Enabled = false
        Phase_Stop()
    end
    DigConfig._phaseEnabled = false
end

local function DigUpdate()
    if not DigConfig.Enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local pos = root.Position
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {char}
    rayParams.IgnoreWater = true
    
    local rayOrigin = Vector3.new(pos.X, pos.Y + 10, pos.Z)
    local rayResult = workspace:Raycast(rayOrigin, Vector3.new(0, -1, 0) * 200, rayParams)
    
    local groundY
    if rayResult then
        groundY = rayResult.Position.Y
        DigConfig._lastValidY = groundY
    else
        if DigConfig._lastValidY then
            groundY = DigConfig._lastValidY
        else
            return
        end
    end
    
    local targetY = groundY - DigConfig.Depth
    
    local moveSpeed = 10 / 60
    
    local moveDir = Vector3.zero
    local look = Camera.CFrame.LookVector
    local right = Camera.CFrame.RightVector
    look = Vector3.new(look.X, 0, look.Z).Unit
    right = Vector3.new(right.X, 0, right.Z).Unit
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + look end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - look end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + right end
    
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
    end
    
    local newX = pos.X + moveDir.X * moveSpeed
    local newZ = pos.Z + moveDir.Z * moveSpeed
    local newPos = Vector3.new(newX, targetY, newZ)
    
    root.Velocity = Vector3.zero
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(newPos)
    hum.PlatformStand = true
end

local function Dig_Toggle(Value)
    DigConfig.Enabled = Value
    if Value then
        DigConfig._lastValidY = nil
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos = root.Position
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {char}
                rayParams.IgnoreWater = true
                local result = workspace:Raycast(Vector3.new(pos.X, pos.Y + 10, pos.Z), Vector3.new(0, -1, 0) * 200, rayParams)
                if result then
                    DigConfig._lastValidY = result.Position.Y
                end
            end
        end
        
        Dig_EnablePhase()
        if DigConnection then DigConnection:Disconnect() end
        DigConnection = RunService.Heartbeat:Connect(DigUpdate)
        if Library and Library.Notify then
            Library:Notify({Description = "遁地已开启", Time = 2, Title = "遁地"})
        end
    else
        Dig_DisablePhase()
        if DigConnection then
            DigConnection:Disconnect()
            DigConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        DigConfig._lastValidY = nil
        if Library and Library.Notify then
            Library:Notify({Description = "遁地已关闭", Time = 2, Title = "遁地"})
        end
    end
end

local origPhaseStop = Phase_Stop
Phase_Stop = function()
    if DigConfig._phaseEnabled then
        return
    end
    origPhaseStop()
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if DigConfig.Enabled then
        Dig_EnablePhase()
        if DigConnection then
            DigConnection:Disconnect()
            DigConnection = nil
        end
        DigConnection = RunService.Heartbeat:Connect(DigUpdate)
    end
end)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

if not Library then
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wsbstudio/Obsidian/main/Library.lua"))()
end

if not Library then
    return
end

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true

local Window = Library:CreateWindow({
    Title = " LeMoN.Xyz",
    Footer = "版本1.2 ",
    Center = true,
    AutoShow = true,
    Resizable = true,
    GlobalSearch = true,
    NotifySide = "Right",
    ToggleKeybind = Enum.KeyCode.RightControl,
    CornerRadius = 20,
    Animations = {
        ToggleWindow = true,
        TabSwitch = true,
        Groupbox = true,
        Dropdown = true,
        KeyPicker = true
    }
})

local AimTab = Window:AddTab("瞄准", "crosshair")
local RageTab = Window:AddTab("杀戮", "sword")
local VisualTab = Window:AddTab("视觉", "eye")
local MiscTab = Window:AddTab("杂项", "settings")
local ToolsTab = Window:AddTab("工具", "tools")
local SettingsTab = Window:AddTab("设置", "gear")

do
    local AntiInvisibleBox = ToolsTab:AddLeftGroupbox("反隐身")
    AntiInvisibleBox:AddToggle("AntiInvisible", {
        Text = "启用反隐身",
        Default = false,
        Tooltip = "检测并禁用其他玩家的隐身",
        Callback = function(Value)
            if Value then AntiInvisible_Enable() else AntiInvisible_Disable() end
        end
    })
    AntiInvisibleBox:AddToggle("AntiInvisibleNotifications", {
        Text = "弹窗通知",
        Default = true,
        Callback = function(Value) AntiInvisibleConfig.ShowNotifications = Value end
    })

    local SpectateBox = ToolsTab:AddRightGroupbox("观战玩家")
    local plrMap = {}
    local specSubject = nil
    local currentSelection = nil
    local isSpectating = false

    local function buildPlrList()
        plrMap = {}
        local items = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                plrMap[p.Name] = p
                table.insert(items, p.Name)
            end
        end
        if #items == 0 then
            plrMap["(无玩家)"] = nil
            items = {"(无玩家)"}
        end
        return items
    end

    local function resolveTarget()
        local sel = currentSelection or "(无玩家)"
        return plrMap[sel]
    end

    local function stopSpectate(silent)
        Camera.CameraType = Enum.CameraType.Custom
        local c = LocalPlayer.Character
        Camera.CameraSubject = c and c:FindFirstChild("Humanoid") or nil
        specSubject = nil
        isSpectating = false
        if not silent and Library and Library.Notify then
            Library:Notify({Description = "已停止观战", Time = 2, Title = "观战"})
        end
    end

    local initItems = buildPlrList()
    local plrDropObj = SpectateBox:AddDropdown("SpectatePlayer", {
        Text = "选择玩家",
        Values = initItems,
        Default = initItems[1] or "(无玩家)",
        Callback = function(Value) currentSelection = Value end
    })

    task.spawn(function()
        while true do
            task.wait(1)
            local newItems = buildPlrList()
            if plrDropObj and typeof(plrDropObj.SetValues) == "function" then
                plrDropObj:SetValues(newItems)
                if #newItems > 0 and currentSelection then
                    local found = false
                    for _, name in ipairs(newItems) do
                        if name == currentSelection then found = true; break end
                    end
                    if not found then
                        plrDropObj:SetValue(newItems[1])
                        currentSelection = newItems[1]
                    else
                        plrDropObj:SetValue(currentSelection)
                    end
                elseif #newItems > 0 then
                    plrDropObj:SetValue(newItems[1])
                    currentSelection = newItems[1]
                end
            end
        end
    end)

    SpectateBox:AddButton("观战", function()
        if isSpectating then
            stopSpectate(true)
        end
        
        local tgt = resolveTarget()
        if not tgt or not tgt.Character then
            if Library and Library.Notify then
                Library:Notify({Description = "玩家不存在或已离线", Time = 3, Title = "错误", IconColor = Color3.new(1, 0, 0)})
            end
            return
        end
        
        local hum = tgt.Character:FindFirstChild("Humanoid")
        if hum then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = hum
            specSubject = hum
            isSpectating = true
            if Library and Library.Notify then
                Library:Notify({Description = "正在观战 " .. tgt.DisplayName, Time = 3, Title = "观战", IconColor = Color3.new(0, 1, 0)})
            end
        else
            if Library and Library.Notify then
                Library:Notify({Description = "目标没有 Humanoid", Time = 2, Title = "错误", IconColor = Color3.new(1, 0, 0)})
            end
        end
    end)

    SpectateBox:AddButton("停止观战", function()
        stopSpectate(false)
    end)

    Players.PlayerRemoving:Connect(function(pl)
        if specSubject and pl.Character and specSubject:IsDescendantOf(pl.Character) then
            stopSpectate(true)
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        if isSpectating then
            stopSpectate(true)
        end
    end)
end

do
    local SilentAimBox = AimTab:AddLeftGroupbox("子弹追踪")
    SilentAimBox:AddToggle("SilentAimEnable", {
        Text = "开启子弹追踪",
        Default = false,
        Callback = function(Value) SilentAimSettings.Enabled = Value end
    })
    SilentAimBox:AddToggle("SilentAimTeamCheck", {
        Text = "队伍检测",
        Default = false,
        Callback = function(Value) SilentAimSettings.TeamCheck = Value end
    })
    SilentAimBox:AddToggle("SilentAimBulletTP", {
        Text = "子弹穿墙",
        Default = false,
        Callback = function(Value) SilentAimSettings.BulletTP = Value end
    })
    SilentAimBox:AddDropdown("SilentAimTargetPart", {
        Text = "部位",
        Values = {"头部", "身体", "随机"},
        Default = 1,
        Callback = function(Value) SilentAimSettings.TargetPart = Value end
    })
    SilentAimBox:AddDropdown("SilentAimMethod", {
        Text = "子追方法",
        Values = {"Raycast", "FindPartOnRay", "FindPartOnRayWithWhitelist", "FindPartOnRayWithIgnoreList", "Mouse.Hit/Target"},
        Default = 1,
        Callback = function(Value) SilentAimSettings.SilentAimMethod = Value end
    })
    SilentAimBox:AddSlider('HitChance', {
        Text = "命中率",
        Default = 100,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Callback = function(Value) SilentAimSettings.HitChance = Value end
    })

    local FOVBox = AimTab:AddLeftGroupbox("FOV")
    FOVBox:AddToggle("SilentAimFOVVisible", {
        Text = "显示 FOV",
        Default = false,
        Callback = function(Value) SilentAimSettings.FOVVisible = Value end
    }):AddColorPicker("FOVColor", {
        Default = Color3.new(1, 1, 1),
        Title = "FOV 颜色",
        Callback = function(Value) SilentAimSettings.FOVColor = Value; fov_circle.Color = Value end
    })
    FOVBox:AddToggle("SilentAimShowTarget", {
        Text = "显示追踪线",
        Default = false,
        Callback = function(Value) SilentAimSettings.ShowSilentAimTarget = Value end
    }):AddColorPicker("LineColor", {
        Default = Color3.new(1, 0, 0),
        Title = "追踪线颜色",
        Callback = function(Value) SilentAimSettings.LineColor = Value; lock_line.Color = Value end
    })
    FOVBox:AddToggle("SilentAimFOVCover", {
        Text = "填充fov",
        Default = false,
        Callback = function(Value) SilentAimSettings.FOVCover = Value; fov_circle.Filled = Value end
    })
    FOVBox:AddToggle("FOVCentered", {
        Text = "FOV居中",
        Default = false,
        Tooltip = "开启后FOV固定在屏幕中心，关闭后跟随鼠标",
        Callback = function(Value) SilentAimSettings.FOVCentered = Value end
    })
    FOVBox:AddSlider("SilentAimFOV", {
        Text = "FOV 大小",
        Default = 280,
        Min = 30,
        Max = 1000,
        Rounding = 0,
        Suffix = "px",
        Callback = function(Value) SilentAimSettings.FOVRadius = Value end
    })
    FOVBox:AddSlider("SilentAimFOVTransparency", {
        Text = "FOV 透明度",
        Default = 0.5,
        Min = 0,
        Max = 1,
        Rounding = 1,
        Callback = function(Value) SilentAimSettings.FOVTransparency = Value; fov_circle.Transparency = Value end
    })
end

do
    local RageLeft = RageTab:AddLeftGroupbox("Ragebot 设置")
    RageLeft:AddToggle("RageEnable", {
        Text = "启用 Ragebot",
        Default = false,
        Callback = function(Value)
            RageConfig.Enabled = Value
            RageState.running = Value
            if IsDefusal then DefusalRage.Enabled = Value end
            if GameType == "Rivals" then RivalsRage.Enabled = Value end
        end
    })
    RageLeft:AddLabel("当前游戏模式: " .. GameType)
    RageLeft:AddSlider("FireRateSlider", {
        Text = "射速",
        Default = 0.02,
        Min = 0.01,
        Max = 0.5,
        Rounding = 2,
        Suffix = "s",
        Callback = function(Value)
            RageConfig.FireRate = Value
            if GameType == "Rivals" then RivalsRage.FireRate = Value end
        end
    })
    RageLeft:AddSlider("MaxDistanceSlider", {
        Text = "最大距离",
        Default = 500,
        Min = 50,
        Max = 2000,
        Rounding = 0,
        Suffix = "m",
        Callback = function(Value)
            RageConfig.MaxDistance = Value
            if GameType == "Rivals" then RivalsRage.MaxDistance = Value end
        end
    })
    RageLeft:AddDropdown("RageTargetPartDrop", {
        Text = "瞄准部位",
        Values = {"头部", "身体", "腿部"},
        Default = 1,
        Callback = function(Value)
            RageConfig.TargetPart = Value
            if GameType == "Rivals" then RivalsRage.TargetPart = Value end
        end
    })
    RageLeft:AddToggle("RageIgnoreTeam", {
        Text = "忽略队友",
        Default = true,
        Callback = function(Value)
            RageConfig.IgnoreTeam = Value
            if GameType == "Rivals" then RivalsRage.IgnoreTeam = Value end
        end
    })
    RageLeft:AddToggle("RageWallBang", {
        Text = "穿墙模式",
        Default = false,
        Callback = function(Value)
            RageConfig.WallBang = Value
            if GameType == "Rivals" then RivalsRage.WallBang = Value end
        end
    })
    RageLeft:AddDropdown("RageAimMode", {
        Text = "优先级",
        Values = {"屏幕中心", "鼠标位置"},
        Default = 1,
        Callback = function(Value)
            RageConfig.AimMode = Value == "屏幕中心" and "Center" or "Mouse"
            if GameType == "Rivals" then RivalsRage.AimMode = RageConfig.AimMode end
        end
    })
    RageLeft:AddToggle("HitNotify", {
        Text = "命中提示",
        Default = false,
        Tooltip = "命中时显示玩家名、血量、距离、击中次数 (血量变化时显示)",
        Callback = function(Value)
            RageConfig.HitNotify = Value
            if not Value then
                table.clear(HitNotifyData)
            end
        end
    })

    local TrajectoryBox = RageTab:AddRightGroupbox("子弹轨迹")
    TrajectoryBox:AddToggle("ShowTrajectory", {
        Text = "显示子弹轨迹",
        Default = true,
        Callback = function(Value) 
            RageConfig.ShowTrajectory = Value 
        end
    }):AddColorPicker("TrajectoryColor", {
        Default = Color3.fromRGB(0, 150, 255),
        Title = "轨迹颜色",
        Callback = function(Value)
            RageConfig.TrajectoryColor = Value
        end
    })
    TrajectoryBox:AddSlider("TrajectoryWidth", {
        Text = "轨迹宽度",
        Default = 0.4,
        Min = 0.05,
        Max = 2,
        Rounding = 2,
        Suffix = "x",
        Callback = function(Value) RageConfig.TrajectoryWidth = Value end
    })
    TrajectoryBox:AddSlider("TrajectoryTextureLength", {
        Text = "纹理长度",
        Default = 4,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Suffix = "x",
        Callback = function(Value) RageConfig.TrajectoryTextureLength = Value end
    })
    TrajectoryBox:AddSlider("FadeTime", {
        Text = "保留时间",
        Default = 1500,
        Min = 500,
        Max = 3000,
        Rounding = 0,
        Suffix = "毫秒",
        Callback = function(Value) RageConfig.FadeTime = Value end
    })
    
    TrajectoryBox:AddToggle("TrajectorySpread", {
        Text = "轨迹分散",
        Default = false,
        Callback = function(Value)
            RageConfig.TrajectorySpread = Value
        end
    })

    local SoundBox = RageTab:AddRightGroupbox("命中音效")
    SoundBox:AddToggle("HitSound", {
        Text = "启用命中音效",
        Default = true,
        Callback = function(Value) RageConfig.HitSound = Value end
    })
    SoundBox:AddDropdown("HitSoundSelect", {
        Text = "音效选择",
        Values = {"RIFK7", "Bubble", "Minecraft", "Cod", "Bameware", "Neverlose", "Gamesense", "Rust"},
        Default = 6,
        Callback = function(Value)
            SelectedHitSound = Value
            CreateHitSounds()
        end
    })
    SoundBox:AddSlider("HitSoundVolume", {
        Text = "音量",
        Default = 0.5,
        Min = 0.1,
        Max = 1,
        Rounding = 1,
        Callback = function(Value)
            RageConfig.HitSoundVolume = Value
            CreateHitSounds()
        end
    })
end

do
    local ESPBox = VisualTab:AddLeftGroupbox("ESP 设置")
    
    ESPBox:AddToggle("esp_enabled", {
        Text = "开启ESP",
        Default = false,
        Callback = function(Value) ESP.Enabled = Value end
    })
    
    ESPBox:AddToggle("esp_teamcheck", {
        Text = "队伍检测",
        Default = false,
        Callback = function(Value) ESP.TeamCheck = Value end
    })
    
    ESPBox:AddToggle("esp_npc", {
        Text = "NPC检测",
        Default = false,
        Callback = function(Value) ESP.NPCEnabled = Value end
    })
    
    ESPBox:AddToggle("esp_boxes", {
        Text = "边框透视",
        Default = true,
        Callback = function(Value) 
            ESP.Drawing.Boxes.Full.Enabled = Value 
        end
    }):AddColorPicker("esp_box_color", {
        Default = Color3.fromRGB(0, 100, 255),
        Title = "边框颜色",
        Callback = function(Value) 
            ESP.Drawing.Boxes.Full.RGB = Value
            for plr, objs in pairs(ESPObjects) do
                if objs and objs.Box then
                    objs.Box.Color = Value
                end
            end
        end
    })
    
    ESPBox:AddToggle("esp_names", {
        Text = "名字透视",
        Default = true,
        Callback = function(Value) ESP.Drawing.Names.Enabled = Value end
    }):AddColorPicker("esp_name_color", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "名字颜色",
        Callback = function(Value)
            ESP.Drawing.Names.Color = Value
            for plr, objs in pairs(ESPObjects) do
                if objs and objs.Name then
                    objs.Name.Color = Value
                end
            end
        end
    })
    ESP.Drawing.Names.Font = 0
    ESP.Drawing.Names.Size = 16
    
    ESPBox:AddToggle("esp_health", {
        Text = "显示血量",
        Default = true,
        Callback = function(Value) ESP.Drawing.Healthbar.Enabled = Value end
    })
    
    ESPBox:AddToggle("esp_distances", {
        Text = "显示距离",
        Default = true,
        Callback = function(Value) ESP.Drawing.Distances.Enabled = Value end
    }):AddColorPicker("esp_dist_color", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "距离颜色",
        Callback = function(Value)
            ESP.Drawing.Distances.Color = Value
            for plr, objs in pairs(ESPObjects) do
                if objs and objs.Distance then
                    objs.Distance.Color = Value
                end
            end
        end
    })
    
    ESPBox:AddToggle("esp_weapons", {
        Text = "显示武器",
        Default = false,
        Callback = function(Value) ESP.Drawing.Weapons.Enabled = Value end
    })
 
    local ESPBox = VisualTab:AddLeftGroupbox("透明化")
    ESPBox:AddToggle("SelfChamsEnable", {
        Text = "自身透明化",
        Default = false,
        Callback = function(Value)
            SelfChamsEnabled = Value
            if Value and LocalPlayer.Character then
                ApplySelfChams(LocalPlayer.Character)
            else
                RestoreSelfChams()
            end
        end
    })
    ESPBox:AddToggle("SelfChamsRainbow", {
        Text = "彩虹模式",
        Default = false,
        Callback = function(Value) 
            SelfChamsRainbow = Value 
        end
    })

    local ESPBox = VisualTab:AddLeftGroupbox("反部位")
    ESPBox:AddToggle("anti_head", {
        Text = "藏头",
        Default = false,
        Callback = function(Value) AntiHeadEnabled = Value; ApplyAntis() end
    })
    ESPBox:AddToggle("anti_hands", {
        Text = "举手",
        Default = false,
        Callback = function(Value) AntiHandsEnabled = Value; ApplyAntis() end
    })

    local WorldBox = VisualTab:AddRightGroupbox("世界修改器")
    WorldBox:AddToggle("WorldTimeEnable", {
        Text = "时间修改",
        Default = false,
        Callback = function(Value) WorldTimeEnabled = Value end
    })
    WorldBox:AddSlider("WorldTime", {
        Text = "时间",
        Default = 12,
        Min = 0,
        Max = 24,
        Rounding = 1,
        Callback = function(Value) WorldTime = Value end
    })
    WorldBox:AddToggle("WorldFOVEnable", {
        Text = "视场修改",
        Default = false,
        Callback = function(Value)
            WorldFOVEnabled = Value
            if Value then Camera.FieldOfView = WorldFOV else Camera.FieldOfView = GameDefaultFOV end
        end
    })
    WorldBox:AddSlider("WorldFOV", {
        Text = "视场",
        Default = 70,
        Min = 30,
        Max = 120,
        Rounding = 1,
        Callback = function(Value)
            WorldFOV = Value
            if WorldFOVEnabled then Camera.FieldOfView = Value end
        end
    })

    local fullBrightEnabled = false
    local brightLoop = nil
    WorldBox:AddToggle("FullBrightEnable", {
        Text = "夜视",
        Default = false,
        Callback = function(Value)
            fullBrightEnabled = Value
            if brightLoop then brightLoop:Disconnect(); brightLoop = nil end
            if Value then
                brightLoop = RunService.RenderStepped:Connect(function()
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 14
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                end)
            else
                Lighting.Brightness = 1
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            end
        end
    })

    WorldBox:AddDropdown("SkyboxSelect", {
        Text = "天空盒 (共" .. #SkyboxNames .. "个)",
        Values = SkyboxNames,
        Default = 7,
        Callback = function(Value) SkyboxName = Value; ApplySkybox(Value) end
    })
end

do
    local MoveBox = MiscTab:AddLeftGroupbox("移动 & 杂项")
    
    local speedToggle = MoveBox:AddToggle("SpeedEnable", {
        Text = "启用加速",
        Default = false,
        Callback = function(Value)
            MovementConfig.SpeedEnabled = Value
            if Library and Library.Notify then
                if Value then
                    Library:Notify({Description = "加速已开启", Time = 2, Title = "移动"})
                else
                    Library:Notify({Description = "加速已关闭", Time = 2, Title = "移动"})
                end
            end
        end
    })
    speedToggle:AddKeyPicker("SpeedKey", {
        Default = "None",
        Mode = "Toggle",
        Text = "加速",
        SyncToggleState = true
    })

    MoveBox:AddSlider("SpeedMultiplier", {
        Text = "速度",
        Default = 0.1,
        Min = 0.1,
        Max = 5,
        Rounding = 1,
        Callback = function(Value) MovementConfig.SpeedMultiplier = Value end
    })

    local flyToggle = MoveBox:AddToggle("FlyEnable", {
        Text = "启用飞行",
        Default = false,
        Callback = function(Value)
            MovementConfig.FlyEnabled = Value
            if Library and Library.Notify then
                if Value then
                    Library:Notify({Description = "飞行已开启", Time = 2, Title = "移动"})
                else
                    Library:Notify({Description = "飞行已关闭", Time = 2, Title = "移动"})
                end
            end
        end
    })
    flyToggle:AddKeyPicker("FlyKey", {
        Default = "None",
        Mode = "Toggle",
        Text = "飞行",
        SyncToggleState = true
    })

    MoveBox:AddSlider("FlySpeed", {
        Text = "飞行速度",
        Default = 0.1,
        Min = 0.1,
        Max = 5,
        Rounding = 1,
        Callback = function(Value) MovementConfig.FlySpeed = Value end
    })

    MoveBox:AddToggle("InfiniteJump", {
        Text = "无限跳",
        Default = false,
        Callback = function(Value)
            RageConfig.InfiniteJump.Enabled = Value
            if Library and Library.Notify then
                if Value then
                    Library:Notify({Description = "无限跳已开启", Time = 2, Title = "移动"})
                else
                    Library:Notify({Description = "无限跳已关闭", Time = 2, Title = "移动"})
                end
            end
        end
    })

    local SpinBox = MiscTab:AddLeftGroupbox("自身旋转")
    SpinBox:AddToggle("SpinEnable", {
        Text = "启用自身旋转",
        Default = false,
        Callback = function(Value)
            SelfSpinConfig.Enabled = Value
        end
    })
    SpinBox:AddDropdown("SpinMode", {
        Text = "旋转模式",
        Values = {"背后打人", "倒立"},
        Default = 1,
        Callback = function(Value) SelfSpinConfig.Mode = Value end
    })

    local HitboxBox = MiscTab:AddRightGroupbox("Hitbox 扩大")
    HitboxBox:AddToggle("Hitbox", {
        Text = "启用 Hitbox 扩大",
        Default = false,
        Callback = function(Value)
            RageConfig.HitboxEnabled = Value
            if Value then ApplyHitboxToAll() else ResetHitboxForAll() end
        end
    })
    HitboxBox:AddToggle("HitboxNPC", {
        Text = "对NPC生效",
        Default = false,
        Callback = function(Value)
            RageConfig.HitboxNPC = Value
            if RageConfig.HitboxEnabled then
                ResetHitboxForAll()
                task.wait(0.1)
                ApplyHitboxToAll()
            end
        end
    })
    HitboxBox:AddSlider("HitboxSize", {
        Text = "Hitbox 大小",
        Default = 5,
        Min = 1,
        Max = 250,
        Rounding = 0,
        Suffix = "studs",
        Callback = function(Value)
            RageConfig.HitboxSize = Value
            if RageConfig.HitboxEnabled then UpdateHitboxProperties() end
        end
    })
    HitboxBox:AddToggle("HitboxShow", {
        Text = "显示 Hitbox",
        Default = false,
        Callback = function(Value)
            RageConfig.HitboxShow = Value
            if RageConfig.HitboxEnabled then UpdateHitboxProperties() end
        end
    })

    local InvisibleBox = MiscTab:AddRightGroupbox("隐身")
    InvisibleBox:AddToggle("InvisibleEnable", {
        Text = "启用隐身",
        Default = false,
        Callback = function(Value)
            if Value then 
                Invisible_Enable()
                if Library and Library.Notify then
                    Library:Notify({Description = "隐身已开启", Time = 2, Title = "隐身"})
                end
            else 
                Invisible_Disable()
                if Library and Library.Notify then
                    Library:Notify({Description = "隐身已关闭", Time = 2, Title = "隐身"})
                end
            end
        end
    })

    local BlinkBox = MiscTab:AddRightGroupbox("Desync")
    local blinkToggle = BlinkBox:AddToggle("BlinkEnable", {
        Text = "启用Desync",
        Default = false,
        Callback = function(Value)
            if Value then 
                Blink_Enable()
                if Library and Library.Notify then
                    Library:Notify({Description = "Desync已开启", Time = 2, Title = "Desync"})
                end
            else 
                Blink_Disable()
                if Library and Library.Notify then
                    Library:Notify({Description = "Desync已关闭", Time = 2, Title = "Desync"})
                end
            end
        end
    })
    blinkToggle:AddKeyPicker("BlinkKey", {
        Default = "None",
        Mode = "Toggle",
        Text = "Desync",
        SyncToggleState = true
    })

    local PhaseBox = MiscTab:AddRightGroupbox("穿墙")
    PhaseBox:AddToggle("PhaseEnable", {
        Text = "启用穿墙",
        Default = false,
        Callback = function(Value)
            PhaseConfig.Enabled = Value
            if Value then 
                Phase_Start()
                if Library and Library.Notify then
                    Library:Notify({Description = "穿墙已开启", Time = 2, Title = "穿墙"})
                end
            else 
                Phase_Stop()
                if Library and Library.Notify then
                    Library:Notify({Description = "穿墙已关闭", Time = 2, Title = "穿墙"})
                end
            end
        end
    })
    PhaseBox:AddDropdown("PhaseMode", {
        Text = "穿墙方式",
        Values = {"NoClip", "Part", "CFrame"},
        Default = 1,
        Callback = function(Value)
            PhaseConfig.Mode = Value
            if PhaseConfig.Enabled then
                Phase_Stop()
                task.wait(0.1)
                Phase_Start()
            end
        end
    })

    local DigBox = MiscTab:AddRightGroupbox("遁地")
    local digToggle = DigBox:AddToggle("DigEnable", {
        Text = "启用遁地",
        Default = false,
        Tooltip = "开启后自动穿墙并置于地面下方，走到高处自动调整",
        Callback = function(Value)
            Dig_Toggle(Value)
        end
    })
    digToggle:AddKeyPicker("DigKey", {
        Default = "None",
        Mode = "Toggle",
        Text = "遁地快捷键",
        SyncToggleState = true
    })
    DigBox:AddSlider("DigDepth", {
        Text = "遁地深度",
        Default = 1.5,
        Min = 0.5,
        Max = 10,
        Rounding = 1,
        Suffix = "studs",
        Callback = function(Value)
            DigConfig.Depth = Value
        end
    })
end

do
    local SettingsGroup = SettingsTab:AddLeftGroupbox("菜单设置")
    SettingsGroup:AddLabel("菜单快捷键")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightControl",
        NoUI = false,
        Text = "菜单",
        Callback = function() Library:Toggle() end
    })

    SettingsGroup:AddToggle("ShowKeybinds", {
        Text = "显示快捷键绑定",
        Default = false,
        Callback = function(Value)
            if Library and Library.KeybindFrame then Library.KeybindFrame.Visible = Value end
        end
    })

    SettingsGroup:AddToggle("ShowCustomCursor", {
        Text = "显示自定义鼠标",
        Default = true,
        Callback = function(Value) Library.ShowCustomCursor = Value end
    })

    SettingsGroup:AddDropdown("NotificationSide", {
        Text = "通知位置",
        Values = {"左", "右"},
        Default = "Right",
        Callback = function(Value) Library:SetNotifySide(Value) end
    })

    SettingsGroup:AddDropdown("DPIScale", {
        Text = "DPI 缩放",
        Values = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"},
        Default = "100%",
        Callback = function(Value)
            local dpi = tonumber(Value:gsub("%%", ""))
            Library:SetDPIScale(dpi)
        end
    })

    SettingsGroup:AddDivider()
    SettingsGroup:AddButton("卸载脚本", function() Library:Unload() end)
end

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("LeMoNThemes")
ThemeManager:ApplyToTab(SettingsTab)

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("LeMoNConfigs")
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:BuildConfigSection(SettingsTab)
SaveManager:LoadAutoloadConfig()