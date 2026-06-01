--[[
    DrifterZ Hub V24 - Cleaned Version
    Features:
    - Gravity presets (Long/Short/Street/Reset)
    - Drift Camera (FOV changes)
    - Photo Mode (freecam)
    - Speedometer
    - NoSit (disable sitting)
    - On-screen touch controls (mobile layout)
    - Music player with volume slider
--]]

local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables
local gravityPresetSelected = false
local photoMode = false
local driftCam = false
local showLayout = false
local noSit = false
local showSpeedo = false
local cooldownActive = true
local savedCameraCFrame = nil
local musicPanelOpen = false

-- Keycodes for mobile layout
local keyMap = {
    forward = Enum.KeyCode.W,
    backward = Enum.KeyCode.S,
    left = Enum.KeyCode.A,
    right = Enum.KeyCode.D
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DrifterZ_V24_Full"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer.PlayerGui

-- Intro animation
local introLabel = Instance.new("TextLabel", screenGui)
introLabel.Size = UDim2.new(0, 400, 0, 100)
introLabel.Position = UDim2.new(0.5, -200, 0.45, 0)
introLabel.BackgroundTransparency = 1
introLabel.Text = "DrifterZ BY Nitro"
introLabel.Font = Enum.Font.GothamBold
introLabel.TextSize = 45
introLabel.TextColor3 = Color3.new(1, 1, 1)
introLabel.TextTransparency = 1
introLabel.ZIndex = 50

local introStroke = Instance.new("UIStroke", introLabel)
introStroke.Thickness = 2
introStroke.Color = Color3.new(1, 0, 0)
introStroke.Transparency = 1

-- Animate intro
task.spawn(function()
    local tween = TweenService:Create(introLabel, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
    tween:Play()
    local strokeTween = TweenService:Create(introStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0})
    strokeTween:Play()
    task.wait(2)
    local exitTween = TweenService:Create(introLabel, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1, Position = UDim2.new(0.5, -200, 0.4, 0)})
    exitTween:Play()
    local exitStroke = TweenService:Create(introStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
    exitStroke:Play()
    task.wait(1)
    introLabel:Destroy()
end)

-- Main panel
local mainPanel = Instance.new("Frame", screenGui)
mainPanel.Name = "MainPanel"
mainPanel.AnchorPoint = Vector2.new(0.5, 0)
mainPanel.Position = UDim2.new(0.5, 0, 0.3, 0)
mainPanel.Size = UDim2.new(0, 0, 0, 0)
mainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainPanel.BorderSizePixel = 0
mainPanel.ClipsDescendants = true
mainPanel.Active = true
mainPanel.Draggable = true
mainPanel.Visible = false
mainPanel.ZIndex = 10
Instance.new("UICorner", mainPanel)

local panelStroke = Instance.new("UIStroke", mainPanel)
panelStroke.Color = Color3.new(1, 0, 0)
panelStroke.Thickness = 2

-- Animate panel appearance
task.delay(4, function()
    mainPanel.Visible = true
    local openTween = TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 2)})
    openTween:Play()
    task.wait(0.5)
    local expandTween = TweenService:Create(mainPanel, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 35)})
    expandTween:Play()
end)

-- Header
local header = Instance.new("Frame", mainPanel)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.ZIndex = 11
Instance.new("UICorner", header)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.Text = "DRIFTERZ HUB V24"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

-- Animated rainbow text
task.spawn(function()
    local hue = 0
    while title and title.Parent do
        hue = (hue + 0.002) % 1
        title.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
        task.wait()
    end
end)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.ZIndex = 15
Instance.new("UICorner", closeBtn)

local expandBtn = Instance.new("TextButton", header)
expandBtn.Size = UDim2.new(0, 25, 0, 25)
expandBtn.Position = UDim2.new(1, -60, 0, 5)
expandBtn.Text = "+"
expandBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
expandBtn.TextColor3 = Color3.new(1, 1, 1)
expandBtn.ZIndex = 15
Instance.new("UICorner", expandBtn)

local footer = Instance.new("TextLabel", mainPanel)
footer.Size = UDim2.new(1, 0, 0, 25)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.BackgroundTransparency = 1
footer.Text = "TikTok: kkyoraaku"
footer.Font = Enum.Font.GothamBold
footer.TextSize = 13
footer.ZIndex = 11
footer.Visible = false

local panelExpanded = true
expandBtn.MouseButton1Click:Connect(function()
    panelExpanded = not panelExpanded
    local targetHeight = panelExpanded and 35 or 385
    local tween = TweenService:Create(mainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, targetHeight)})
    tween:Play()
    expandBtn.Text = panelExpanded and "+" or "-"
    footer.Visible = not panelExpanded
end)

-- Close animation
closeBtn.MouseButton1Click:Connect(function()
    local shrinkTween = TweenService:Create(mainPanel, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 280, 0, 2)})
    shrinkTween:Play()
    shrinkTween.Completed:Connect(function()
        local collapseTween = TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 2)})
        collapseTween:Play()
        collapseTween.Completed:Connect(function()
            mainPanel.Visible = false
            local thanks = Instance.new("TextLabel", screenGui)
            thanks.Size = UDim2.new(0, 500, 0, 50)
            thanks.Position = UDim2.new(0.5, -250, 0.45, 0)
            thanks.BackgroundTransparency = 1
            thanks.Font = Enum.Font.GothamBold
            thanks.TextColor3 = Color3.new(1, 1, 1)
            thanks.TextTransparency = 1
            thanks.ZIndex = 100
            local thanksStroke = Instance.new("UIStroke", thanks)
            thanksStroke.Thickness = 2
            thanksStroke.Color = Color3.new(1, 0, 0)
            thanksStroke.Transparency = 1
            thanks.Text = "Thanks for using DrifterZ!"
            thanks.TextSize = 30
            
            TweenService:Create(thanks, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            TweenService:Create(thanksStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
            task.wait(2.5)
            thanks.Text = "Support me on TikTok: kkyoraaku"
            thanks.TextSize = 22
            task.wait(3)
            screenGui:Destroy()
        end)
    end)
end)

-- Button helper
local function addButton(text, position, callback, isToggleGroup)
    local btn = Instance.new("TextButton", mainPanel)
    btn.Size = UDim2.new(0, 125, 0, 35)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.ZIndex = 11
    Instance.new("UICorner", btn)
    Instance.new("UIStroke", btn).Color = Color3.new(1, 0, 0)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Gravity presets
local gravityButtons = {}
addButton("Long Distance", UDim2.new(0, 10, 0, 50), function()
    Workspace.Gravity = 40
    for _, btn in ipairs(gravityButtons) do btn.TextColor3 = Color3.new(1, 1, 1) end
    gravityButtons[1].TextColor3 = Color3.new(0, 1, 0)
end, true)

addButton("Short Distance", UDim2.new(0, 145, 0, 50), function()
    Workspace.Gravity = 60
    for _, btn in ipairs(gravityButtons) do btn.TextColor3 = Color3.new(1, 1, 1) end
    gravityButtons[2].TextColor3 = Color3.new(0, 1, 0)
end, true)

addButton("Street Drift", UDim2.new(0, 10, 0, 95), function()
    Workspace.Gravity = 50
    for _, btn in ipairs(gravityButtons) do btn.TextColor3 = Color3.new(1, 1, 1) end
    gravityButtons[3].TextColor3 = Color3.new(0, 1, 0)
end, true)

addButton("Reset Gravity", UDim2.new(0, 145, 0, 95), function()
    Workspace.Gravity = 196.2
    for _, btn in ipairs(gravityButtons) do btn.TextColor3 = Color3.new(1, 1, 1) end
end)

-- Drift Cam
addButton("Drift Cam: OFF", UDim2.new(0, 10, 0, 140), function(btn)
    driftCam = not driftCam
    Camera.FieldOfView = driftCam and 90 or 70
    btn.Text = driftCam and "Drift Cam: ON" or "Drift Cam: OFF"
    btn.TextColor3 = driftCam and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

-- Photo Mode
addButton("Photo Mode: OFF", UDim2.new(0, 145, 0, 140), function(btn)
    photoMode = not photoMode
    if photoMode then
        savedCameraCFrame = Camera.CFrame
        Camera.CameraType = Enum.CameraType.Scriptable
        btn.Text = "Photo Mode: ON"
        btn.TextColor3 = Color3.new(0, 1, 0)
    else
        Camera.CameraType = Enum.CameraType.Custom
        btn.Text = "Photo Mode: OFF"
        btn.TextColor3 = Color3.new(1, 1, 1)
    end
end)

-- Remove Auto Fov Follow
addButton("Remove Auto Fov Follow", UDim2.new(0, 10, 0, 185), function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        Camera.CameraType = Enum.CameraType.Fixed
        task.wait(0.05)
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = char.Humanoid
        Camera.FieldOfView = 70
    end
end)

-- Layout toggle
local cooldownFrame = Instance.new("Frame", screenGui)
cooldownFrame.Size = UDim2.new(0, 200, 0, 60)
cooldownFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
cooldownFrame.BackgroundTransparency = 1
cooldownFrame.Visible = false
cooldownFrame.ZIndex = 1

local cooldownTimer = Instance.new("TextLabel", cooldownFrame)
cooldownTimer.Size = UDim2.new(1, 0, 0, 30)
cooldownTimer.BackgroundTransparency = 1
cooldownTimer.Font = Enum.Font.GothamBold
cooldownTimer.TextSize = 25
cooldownTimer.TextColor3 = Color3.fromRGB(255, 0, 0)
cooldownTimer.ZIndex = 1

local cooldownLabel = Instance.new("TextLabel", cooldownFrame)
cooldownLabel.Size = UDim2.new(1, 0, 0, 20)
cooldownLabel.Position = UDim2.new(0, 0, 0.6, 0)
cooldownLabel.BackgroundTransparency = 1
cooldownLabel.Font = Enum.Font.GothamBold
cooldownLabel.TextSize = 14
cooldownLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
cooldownLabel.Text = "RESETTING CONTROLS"
cooldownLabel.ZIndex = 1

local function startCooldown(btn)
    cooldownActive = false
    cooldownFrame.Visible = true
    local startTime = tick()
    local duration = 10
    task.spawn(function()
        while tick() - startTime < duration do
            cooldownTimer.Text = string.format("%.3f", duration - (tick() - startTime))
            btn.Text = "COOLDOWN..."
            task.wait(0.01)
        end
        cooldownFrame.Visible = false
        cooldownActive = true
        btn.Text = "Layout: OFF"
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)
end

-- Layout button
addButton("Layout: OFF", UDim2.new(0, 10, 0, 230), function(btn)
    if not cooldownActive then return end
    showLayout = not showLayout
    if screenGui:FindFirstChild("LayoutFrame") then
        screenGui.LayoutFrame.Visible = showLayout
    end
    btn.Text = showLayout and "Layout: ON" or "Layout: OFF"
    btn.TextColor3 = showLayout and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    if not showLayout then
        startCooldown(btn)
    end
end)

-- NoSit button
addButton("NoSit: OFF", UDim2.new(0, 145, 0, 230), function(btn)
    noSit = not noSit
    btn.Text = noSit and "NoSit: ON" or "NoSit: OFF"
    btn.TextColor3 = noSit and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    if not noSit then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            end
        end
    end
end)

-- Speedometer
local speedoLabel = Instance.new("TextLabel", screenGui)
speedoLabel.Size = UDim2.new(0, 200, 0, 50)
speedoLabel.Position = UDim2.new(0.5, -100, 0.85, 0)
speedoLabel.BackgroundTransparency = 1
speedoLabel.Visible = false
speedoLabel.Font = Enum.Font.GothamBold
speedoLabel.TextSize = 35
speedoLabel.TextColor3 = Color3.new(1, 1, 1)
speedoLabel.ZIndex = 5
local speedoStroke = Instance.new("UIStroke", speedoLabel)
speedoStroke.Thickness = 3
speedoStroke.Color = Color3.new(0, 0, 0)

addButton("Speedometer: OFF", UDim2.new(0, 10, 0, 275), function(btn)
    showSpeedo = not showSpeedo
    speedoLabel.Visible = showSpeedo
    btn.Text = showSpeedo and "Speedometer: ON" or "Speedometer: OFF"
    btn.TextColor3 = showSpeedo and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

-- Music Player
local musicPanel = Instance.new("Frame", screenGui)
musicPanel.Name = "MusicPanel"
musicPanel.Size = UDim2.new(0, 0, 0, 0)
musicPanel.Position = UDim2.new(0.5, 150, 0.35, 0)
musicPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
musicPanel.Visible = false
musicPanel.ClipsDescendants = true
musicPanel.Active = true
musicPanel.Draggable = true
musicPanel.BackgroundTransparency = 1
Instance.new("UICorner", musicPanel)

local musicStroke = Instance.new("UIStroke", musicPanel)
musicStroke.Color = Color3.new(1, 0, 0)
musicStroke.Thickness = 2
musicStroke.Transparency = 1

local musicTitle = Instance.new("TextLabel", musicPanel)
musicTitle.Size = UDim2.new(1, 0, 0, 30)
musicTitle.Position = UDim2.new(0, 0, 0, 5)
musicTitle.BackgroundTransparency = 1
musicTitle.Text = "MUSIC PLAYER"
musicTitle.Font = Enum.Font.GothamBold
musicTitle.TextSize = 14

task.spawn(function()
    local hue = 0
    while musicTitle and musicTitle.Parent do
        hue = (hue + 0.002) % 1
        musicTitle.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
        task.wait()
    end
end)

local musicClose = Instance.new("TextButton", musicPanel)
musicClose.Size = UDim2.new(0, 20, 0, 20)
musicClose.Position = UDim2.new(1, -25, 0, 5)
musicClose.Text = "X"
musicClose.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
musicClose.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", musicClose)

local soundIdBox = Instance.new("TextBox", musicPanel)
soundIdBox.Size = UDim2.new(0, 180, 0, 35)
soundIdBox.Position = UDim2.new(0.5, -90, 0, 40)
soundIdBox.PlaceholderText = "Sound ID..."
soundIdBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
soundIdBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", soundIdBox)

local musicSound = Instance.new("Sound", Workspace)
musicSound.Looped = true
musicSound.Volume = 0.5

local playBtn = Instance.new("TextButton", musicPanel)
playBtn.Size = UDim2.new(0, 85, 0, 35)
playBtn.Position = UDim2.new(0, 20, 0, 85)
playBtn.Text = "PLAY"
playBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
playBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", playBtn)

local stopBtn = Instance.new("TextButton", musicPanel)
stopBtn.Size = UDim2.new(0, 85, 0, 35)
stopBtn.Position = UDim2.new(0, 115, 0, 85)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", stopBtn)

local volumeLabel = Instance.new("TextLabel", musicPanel)
volumeLabel.Size = UDim2.new(0, 100, 0, 20)
volumeLabel.Position = UDim2.new(0, 20, 0, 125)
volumeLabel.Text = "Volume: 50%"
volumeLabel.Font = Enum.Font.GothamBold
volumeLabel.TextSize = 11
volumeLabel.TextColor3 = Color3.new(1, 1, 1)
volumeLabel.BackgroundTransparency = 1
volumeLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderBar = Instance.new("Frame", musicPanel)
sliderBar.Size = UDim2.new(0, 180, 0, 4)
sliderBar.Position = UDim2.new(0.5, -90, 0, 155)
sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBar.BorderSizePixel = 0

local sliderFill = Instance.new("Frame", sliderBar)
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.new(1, 0, 0)
sliderFill.BorderSizePixel = 0

local sliderKnob = Instance.new("TextButton", sliderFill)
sliderKnob.Size = UDim2.new(0, 12, 0, 12)
sliderKnob.Position = UDim2.new(1, -6, 0.5, -6)
sliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
sliderKnob.Text = ""
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

local dragging = false
sliderKnob.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local percent = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        musicSound.Volume = percent
        volumeLabel.Text = "Volume: " .. math.floor(percent * 100) .. "%"
    end
end)

playBtn.MouseButton1Click:Connect(function()
    musicSound.SoundId = "rbxassetid://" .. soundIdBox.Text
    musicSound:Play()
end)

stopBtn.MouseButton1Click:Connect(function()
    musicSound:Stop()
end)

local function toggleMusic()
    musicPanelOpen = not musicPanelOpen
    if musicPanelOpen then
        musicPanel.Visible = true
        TweenService:Create(musicPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 220, 0, 185), BackgroundTransparency = 0}):Play()
        TweenService:Create(musicStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Transparency = 0}):Play()
    else
        TweenService:Create(musicPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(musicStroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
        task.wait(0.4)
        if not musicPanelOpen then musicPanel.Visible = false end
    end
end

musicClose.MouseButton1Click:Connect(toggleMusic)

addButton("Music Player", UDim2.new(0, 10, 0, 320), toggleMusic)

-- Mobile Layout Frame (on-screen controls)
local layoutFrame = Instance.new("Frame", screenGui)
layoutFrame.Name = "LayoutFrame"
layoutFrame.Size = UDim2.new(1, 0, 1, 0)
layoutFrame.BackgroundTransparency = 1
layoutFrame.Visible = false
layoutFrame.ZIndex = 2

local function createControlButton(text, position, size, keyCode, parent, bgColor)
    local btn = Instance.new("TextButton", parent)
    btn.Size = size
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = bgColor or Color3.new(0, 0, 0)
    btn.BackgroundTransparency = 0.4
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 25
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)
    
    local function press()
        VirtualInput:SendKeyEvent(true, keyCode, false, game)
        btn.BackgroundTransparency = 0
    end
    local function release()
        VirtualInput:SendKeyEvent(false, keyCode, false, game)
        btn.BackgroundTransparency = 0.4
    end
    
    btn.MouseButton1Down:Connect(press)
    btn.MouseButton1Up:Connect(release)
    btn.MouseLeave:Connect(release)
    return btn
end

local navFrame = Instance.new("Frame", layoutFrame)
navFrame.Position = UDim2.new(0, 40, 1, -140)
navFrame.Size = UDim2.new(0, 180, 0, 90)
navFrame.BackgroundTransparency = 1

createControlButton("←", UDim2.new(0, 0, 0, 0), UDim2.new(0, 80, 0, 80), keyMap.left, navFrame)
createControlButton("→", UDim2.new(0, 90, 0, 0), UDim2.new(0, 80, 0, 80), keyMap.right, navFrame)

local actionFrame = Instance.new("Frame", layoutFrame)
actionFrame.Position = UDim2.new(1, -250, 1, -180)
actionFrame.Size = UDim2.new(0, 220, 0, 150)
actionFrame.BackgroundTransparency = 1

createControlButton("BRAKE", UDim2.new(0, 0, 0, 50), UDim2.new(0, 100, 0, 60), keyMap.backward, actionFrame, Color3.fromRGB(150, 0, 0))
createControlButton("GAS", UDim2.new(0, 120, 0, 0), UDim2.new(0, 65, 0, 130), keyMap.forward, actionFrame, Color3.fromRGB(0, 150, 0))

-- Render loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if showSpeedo and rootPart then
            local speed = math.floor(rootPart.Velocity.Magnitude * 0.67)
            speedoLabel.Text = speed .. " KM/H"
        end
        
        if noSit then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                if humanoid.Sit then humanoid.Sit = false end
            end
        end
    end
    
    if photoMode and savedCameraCFrame then
        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = savedCameraCFrame
    end
end)