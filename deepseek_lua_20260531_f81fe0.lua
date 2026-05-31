local Env = getfenv();
local d = {};
local v1 = {...};
local r1 = true;
local r2 = string.gmatch;
local r4 = false;
local v2 = pcall(function(...) r4 = true; return; end);
local v3 = v2;
if v2 then v3 = r4; end;
local v4 = 1;
local r5 = math.random;
local v5 = table.concat;
local r6 = table and table.unpack or unpack;
local r7 = r5(3, 65);

local v7 = { pcall(function(...) return "qv27QrQ0" / (1086277 - "PXIux" ^ 9192534); end) };
local v8 = v7[2];
local r8 = tonumber(r2(tostring(v8), ":(%d*):")());

for F = 1, r7 do
    r9 = F;
    r10 = math.random(1, 100);
    r11 = r5(0, 255);
    r12 = r5(1, r10);
    r13 = r5(1, 2) == 1;
    r14 = v8.gsub(v8, ":(%d*):", ":" .. tostring(r5(0, 10000)) .. ":");
    V = {
        pcall(function(...)
            if r5(1, 2) == 1 or r9 == r7 then
                r1 = r1 and r8 == tonumber(r2(tostring(({
                    pcall(function(...) return "2Lh67MHR6qwQ" / (3225714 - "QcOodBo" ^ 14544285); end)
                })[2]), ":(%d*):")());
            end;
            if r13 then error(r14, 0) end;
            v1 = {};
            for n = 1, r10 do v1[n] = r5(0, 255); end;
            v1[r12] = r11;
            return r6(v1);
        end)
    };
    if r13 then
        r1 = r1 and (pcall(function(...)
            if r5(1, 2) == 1 or r9 == r7 then
                r1 = r1 and r8 == tonumber(r2(tostring(({
                    pcall(function(...) return "2Lh67MHR6qwQ" / (3225714 - "QcOodBo" ^ 14544285); end)
                })[2]), ":(%d*):")());
            end;
            if r13 then error(r14, 0) end;
            v1 = {};
            for n = 1, r10 do v1[n] = r5(0, 255); end;
            v1[r12] = r11;
            return r6(v1);
        end) == false and V[2] == r14);
    end;
end;

r1 = r1 and 0 == 0;

if r1 then
    v7 = {};
    r17 = math.floor;
    r18 = 0;
    r19 = 2;
    r20 = {};
    y = 0;
    for l = 1, 256 do v7[l] = l; end;
    v8 = #v7 == 0;
    l = table.remove(v7, math.random(1, #v7));
    r20[l] = string.char(l - 1);
    if #v7 == 0 then
        r21 = {};
        r23 = {};
        r15 = setmetatable({}, {
            ["__index"] = r23,
            ["__metatable"] = nil
        });
        n = game;
        r24 = n.GetService(n, "Players");
        b = game;
        r25 = b.GetService(b, "RunService");
        v4 = game;
        v4 = game;
        r26 = v4.GetService(v4, "TweenService");
        r27 = workspace.CurrentCamera;
        r28 = r24.LocalPlayer;
        r29 = Instance.new("ScreenGui", game.CoreGui);
        r29.ResetOnSpawn = false;
        r29.Name = "AimbotGUI";
        r30 = Instance.new("ImageButton", r29);
        r30.Size = UDim2.new(0, 50, 0, 50);
        r30.Position = UDim2.new(0, 10, 0, 10);
        r30.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
        r30.Image = "rbxassetid://132533655213092";
        r30.ImageColor3 = Color3.fromRGB(255, 255, 255);
        r30.ScaleType = Enum.ScaleType.Fit;
        r30.ZIndex = 10;
        Instance.new("UICorner", r30).CornerRadius = UDim.new(1, 0);
        r31 = TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        v7 = r30.MouseEnter;
        v7.Connect(v7, function(...)
            v5 = r26;
            v3 = v5.Create(v5, r30, r31, { ["Size"] = UDim2.new(0, 55, 0, 55) });
            v3.Play(v3);
        end);
        v7 = r30.MouseLeave;
        v7.Connect(v7, function(...)
            v5 = r26;
            v3 = v5.Create(v5, r30, r31, { ["Size"] = UDim2.new(0, 50, 0, 50) });
            v3.Play(v3);
        end);
        r32 = Instance.new("Frame", r29);
        r32.Size = UDim2.new(0, 180, 0, 260);
        r32.Position = UDim2.new(0, 70, 0, 10);
        r32.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
        r32.Active = true;
        r32.Draggable = true;
        Instance.new("UICorner", r32).CornerRadius = UDim.new(0, 10);
        r33 = true;
        v8 = r30.MouseButton1Click;
        v8.Connect(v8, function(...) r33 = not r33; r32.Visible = r33; end);
        o = Instance.new("TextLabel", r32);
        o.Size = UDim2.new(1, 0, 0, 30);
        o.Text = "Aimbot Mobile";
        o.BackgroundTransparency = 1;
        o.Font = Enum.Font.GothamBold;
        o.TextColor3 = Color3.fromRGB(255, 255, 255);
        o.TextScaled = true;
        Y = Instance.new("TextButton", r32);
        Y.Size = UDim2.new(0, 30, 0, 30);
        Y.Position = UDim2.new(1, -35, 0, 223);
        Y.BackgroundColor3 = Color3.fromRGB(255, 50, 50);
        Y.Text = "X";
        Y.TextColor3 = Color3.new(1, 1, 1);
        Y.Font = Enum.Font.GothamBold;
        Y.TextScaled = true;
        Instance.new("UICorner", Y).CornerRadius = UDim.new(1, 0);
        r34 = false;
        r35 = 80;
        r36 = false;
        r37 = false;
        r38 = false;
        r39 = Drawing.new("Circle");
        r39.Thickness = 1.5;
        r39.Color = Color3.fromRGB(255, 255, 255);
        r39.Filled = false;
        r39.Visible = false;
        m = Y.MouseButton1Click;
        m.Connect(m, function(...)
            r40 = Instance.new("Frame", r29);
            r40.Size = UDim2.new(1, 0, 1, 0);
            r40.BackgroundColor3 = Color3.new(0, 0, 0);
            r40.BackgroundTransparency = 1;
            r40.ZIndex = 20;
            g = Instance.new("Frame", r40);
            g.Size = UDim2.new(0, 300, 0, 140);
            g.Position = UDim2.new(0.5, -150, 0.5, -70);
            g.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            g.ZIndex = 21;
            Instance.new("UICorner", g).CornerRadius = UDim.new(0, 10);
            n = Instance.new("TextLabel", g);
            n.Size = UDim2.new(1, 0, 0, 30);
            n.Position = UDim2.new(0, 0, 0, 10);
            n.Text = "Fechar GUI";
            n.Font = Enum.Font.GothamBold;
            n.TextColor3 = Color3.new(1, 1, 1);
            n.TextScaled = true;
            n.BackgroundTransparency = 1;
            n.ZIndex = 21;
            v = Instance.new("TextLabel", g);
            v.Size = UDim2.new(1, -20, 0, 40);
            v.Position = UDim2.new(0, 10, 0, 45);
            v.Text = "Você quer realmente fechar a interface?";
            v.TextWrapped = true;
            v.Font = Enum.Font.Gotham;
            v.TextColor3 = Color3.new(1, 1, 1);
            v.TextScaled = true;
            v.BackgroundTransparency = 1;
            v.ZIndex = 21;
            b = Instance.new("TextButton", g);
            b.Size = UDim2.new(.45, -5, 0, 30);
            b.Position = UDim2.new(.05, 0, 1, -40);
            b.BackgroundColor3 = Color3.fromRGB(255, 50, 50);
            b.Text = "SIM";
            b.Font = Enum.Font.GothamBold;
            b.TextColor3 = Color3.new(1, 1, 1);
            b.TextScaled = true;
            b.ZIndex = 21;
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6);
            v4 = Instance.new("TextButton", g);
            v4.Size = UDim2.new(.45, -5, 0, 30);
            v4.Position = UDim2.new(0.5, 5, 1, -40);
            v4.BackgroundColor3 = Color3.fromRGB(60, 150, 255);
            v4.Text = "NÃO";
            v4.Font = Enum.Font.GothamBold;
            v4.TextColor3 = Color3.new(1, 1, 1);
            v4.TextScaled = true;
            v4.ZIndex = 21;
            Instance.new("UICorner", v4).CornerRadius = UDim.new(0, 6);
            v5 = b.MouseButton1Click;
            v5.Connect(v5, function(...)
                r34 = false;
                r39.Visible = false;
                v3 = r25;
                v3.UnbindFromRenderStep(v3, "AimbotRender");
                v3 = r40;
                v3.Destroy(v3);
                r41 = Instance.new("Frame");
                r41.Size = UDim2.new(0, 310, 0, 60);
                r41.Position = UDim2.new(0.5, -155, 1, 100);
                r41.AnchorPoint = Vector2.new(0.5, 1);
                r41.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
                r41.BackgroundTransparency = .2;
                r41.BorderSizePixel = 0;
                r41.Parent = r29;
                Instance.new("UICorner", r41).CornerRadius = UDim.new(0, 10);
                v1 = Instance.new("ImageLabel");
                v1.Size = UDim2.new(0, 40, 0, 40);
                v1.Position = UDim2.new(0, 5, 0.5, -20);
                v1.BackgroundTransparency = 1;
                v1.Image = "rbxassetid://77474537431792";
                v1.ZIndex = 1;
                v1.Parent = r41;
                n = Instance.new("TextLabel");
                n.Size = UDim2.new(1, -60, 1, 0);
                n.Position = UDim2.new(0, 55, 0, 0);
                n.BackgroundTransparency = 1;
                n.Text = "Até a próxima!\nBy ZecadaDiv";
                n.TextColor3 = Color3.fromRGB(255, 255, 255);
                n.TextSize = 18;
                n.Font = Enum.Font.GothamBold;
                n.TextXAlignment = Enum.TextXAlignment.Left;
                n.TextYAlignment = Enum.TextYAlignment.Center;
                n.TextWrapped = true;
                n.Parent = r41;
                v = Instance.new("Sound", r29);
                v.SoundId = "rbxassetid://8284260932";
                v.Volume = 1;
                v.Play(v);
                v3 = r26;
                b = v3.Create(v3, r41, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ["Position"] = UDim2.new(.8, -10, 1, -99) });
                b.Play(b);
                task.delay(3, function(...)
                    v5 = r26;
                    v1 = v5.Create(v5, r41, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { ["Position"] = UDim2.new(.8, -10, 1, 100) });
                    v1.Play(v1);
                    v5 = v1.Completed;
                    v5.Connect(v5, function(...) v5 = d[p[7]]; v5.Destroy(v5); end);
                end);
            end);
            v5 = v4.MouseButton1Click;
            v5.Connect(v5, function(...) v5 = r40; v5.Destroy(v5); end);
        end);
        r42 = Instance.new("TextButton", r32);
        r42.Size = UDim2.new(1, -20, 0, 30);
        r42.Position = UDim2.new(0, 10, 0, 35);
        r42.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
        r42.TextColor3 = Color3.fromRGB(255, 255, 255);
        r42.Text = "Ativar Aimbot: OFF";
        r42.Font = Enum.Font.Gotham;
        r42.TextScaled = true;
        Instance.new("UICorner", r42).CornerRadius = UDim.new(0, 6);
        k = r42.MouseButton1Click;
        k.Connect(k, function(...) r34 = not r34; r42.Text = "Ativar Aimbot: " .. (r34 and "ON" or "OFF"); r39.Visible = r34; end);
        r43 = Instance.new("TextLabel", r32);
        r43.Size = UDim2.new(1, -20, 0, 30);
        r43.Position = UDim2.new(0, 10, 0, 70);
        r43.BackgroundTransparency = 1;
        r43.TextColor3 = Color3.fromRGB(255, 255, 255);
        r43.Text = "FOV: 80";
        r43.Font = Enum.Font.Gotham;
        r43.TextScaled = true;
        r44 = Instance.new("TextButton", r32);
        r44.Size = UDim2.new(1, -20, 0, 15);
        r44.Position = UDim2.new(0, 10, 0, 105);
        r44.BackgroundColor3 = Color3.fromRGB(70, 70, 70);
        r44.Text = "";
        r44.AutoButtonColor = false;
        r45 = Instance.new("Frame", r44);
        r45.Size = UDim2.new(0, 10, 1, 0);
        r45.Position = UDim2.new(0.5, -5, 0, 0);
        r45.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Instance.new("UICorner", r45).CornerRadius = UDim.new(1, 0);
        r46 = false;
        w = r44.InputBegan;
        w.Connect(w, function(arg1_2, ...)
            if arg1_2.UserInputType == Enum.UserInputType.Touch or arg1_2.UserInputType == Enum.UserInputType.MouseButton1 then
                r46 = true;
            end;
        end);
        w = r44.InputEnded;
        w.Connect(w, function(...) r46 = false; end);
        w = v4.GetService(v4, "UserInputService").InputChanged;
        w.Connect(w, function(arg1_3, ...)
            if r46 then
                local g = math.clamp(arg1_3.Position.X - r44.AbsolutePosition.X, 0, r44.AbsoluteSize.X);
                r45.Position = UDim2.new(0, g - 5, 0, 0);
                r35 = math.floor(g / r44.AbsoluteSize.X * 300);
                r43.Text = "FOV: " .. r35;
            end;
        end);
        local function w(arg1_4, arg2_4, arg3_4, arg4_4, ...)
            local r50 = Instance.new("TextButton", r32);
            r50.Size = UDim2.new(1, -20, 0, 25);
            r50.Position = UDim2.new(0, 10, 0, arg2_4);
            r50.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            r50.TextColor3 = Color3.fromRGB(255, 255, 255);
            r50.Font = Enum.Font.Gotham;
            r50.TextScaled = true;
            r50.Text = arg1_4 .. ": " .. (arg3_4 and "ON" or "OFF");
            Instance.new("UICorner", r50).CornerRadius = UDim.new(0, 6);
            r50.MouseButton1Click:Connect(function()
                arg3_4 = not arg3_4;
                r50.Text = arg1_4 .. ": " .. (arg3_4 and "ON" or "OFF");
                arg4_4(arg3_4);
            end);
        end;
        w("Team Check", 130, r36, function(arg) r36 = arg; end);
        w("Kill Check", 160, r37, function(arg) r37 = arg; end);
        w("Wall Check", 190, r38, function(arg) r38 = arg; end);
        r51 = "Head";
        (function(parent, title, options, current, callback)
            local frame = Instance.new("Frame");
            frame.Size = UDim2.new(0, 180, 0, 36);
            frame.BackgroundTransparency = 1;
            frame.Parent = parent;
            local label = Instance.new("TextLabel");
            label.Text = title;
            label.Size = UDim2.new(1, 0, 0, 16);
            label.TextSize = 13;
            label.TextColor3 = Color3.fromRGB(255, 255, 255);
            label.BackgroundTransparency = 1;
            label.Font = Enum.Font.Gotham;
            label.Parent = frame;
            local btn = Instance.new("TextButton");
            btn.Size = UDim2.new(1, 0, 0, 20);
            btn.Position = UDim2.new(0, 0, 0, 16);
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
            btn.BorderSizePixel = 0;
            btn.Text = current;
            btn.TextSize = 14;
            btn.TextColor3 = Color3.fromRGB(255, 255, 255);
            btn.Font = Enum.Font.GothamBold;
            btn.Parent = frame;
            local dropdown = Instance.new("Frame");
            dropdown.Visible = false;
            dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
            dropdown.BorderSizePixel = 0;
            dropdown.Position = UDim2.new(0, 0, 1, 0);
            dropdown.Size = UDim2.new(1, 0, 0, #options * 20);
            dropdown.ClipsDescendants = true;
            dropdown.Parent = btn;
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton");
                optBtn.Text = opt;
                optBtn.Size = UDim2.new(1, 0, 0, 20);
                optBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 20);
                optBtn.BackgroundTransparency = 1;
                optBtn.TextSize = 14;
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
                optBtn.Font = Enum.Font.Gotham;
                optBtn.Parent = dropdown;
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = opt;
                    dropdown.Visible = false;
                    callback(opt);
                end);
            end;
            btn.MouseButton1Click:Connect(function()
                dropdown.Visible = not dropdown.Visible;
            end);
        end)(r32, "Aimbot Target Part", { "Head", "Torso", "HumanoidRootPart", "LeftLeg", "RightLeg" }, r51, function(val) r51 = val; print("Target set to:", val); end);
        local function getClosestPlayer()
            local closest = nil
            local shortestDist = math.huge
            local center = Vector2.new(r27.ViewportSize.X / 2, r27.ViewportSize.Y / 2)
            for _, player in pairs(r24:GetPlayers()) do
                if player ~= r28 and player.Character then
                    if r36 and player.Team == r28.Team then
                        -- skip same team
                    else
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if r37 and not humanoid then
                            -- skip if no humanoid
                        else
                            if r38 then
                                local raycastParams = RaycastParams.new()
                                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                raycastParams.FilterDescendantsInstances = { r28.Character }
                                local rayResult = workspace:Raycast(r27.CFrame.Position, (player.Character.Head.Position - r27.CFrame.Position).Unit * 500, raycastParams)
                                if rayResult then
                                    if not player.Character:IsAncestorOf(rayResult.Instance) then
                                        -- wall check failed
                                    else
                                        -- valid
                                    end
                                end
                            end
                            local pos, onScreen = r27:WorldToViewportPoint(player.Character.Head.Position)
                            if onScreen then
                                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                                if dist < r35 and dist < shortestDist then
                                    shortestDist = dist
                                    closest = player
                                end
                            end
                        end
                    end
                end
            end
            return closest
        end
        r25:BindToRenderStep("AimbotRender", Enum.RenderPriority.Camera.Value + 1, function()
            local center = Vector2.new(r27.ViewportSize.X / 2, r27.ViewportSize.Y / 2)
            r39.Position = center
            r39.Radius = r35
            r39.Visible = r34
            if r34 then
                local target = getClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild(r51) then
                    r27.CFrame = CFrame.new(r27.CFrame.Position, target.Character[r51].Position)
                end
            end
        end)
        local notificationFrame = Instance.new("Frame", r29)
        notificationFrame.Size = UDim2.new(0, 310, 0, 60)
        notificationFrame.Position = UDim2.new(0.5, -155, 1, 100)
        notificationFrame.AnchorPoint = Vector2.new(0.5, 1)
        notificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        notificationFrame.BackgroundTransparency = 0.1
        notificationFrame.BorderSizePixel = 0
        Instance.new("UICorner", notificationFrame).CornerRadius = UDim.new(0, 10)
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 40, 0, 40)
        icon.Position = UDim2.new(0, 5, 0.5, -20)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://77474537431792"
        icon.Parent = notificationFrame
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, -60, 1, 0)
        text.Position = UDim2.new(0, 55, 0, 0)
        text.BackgroundTransparency = 1
        text.Text = "Script Ativado\nBy ZecadaDiv"
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.TextSize = 18
        text.Font = Enum.Font.GothamBold
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.TextYAlignment = Enum.TextYAlignment.Center
        text.TextWrapped = true
        text.Parent = notificationFrame
        local notifSound = Instance.new("Sound", r29)
        notifSound.SoundId = "rbxassetid://6026984224"
        notifSound.Volume = 1
        notifSound:Play()
        if setclipboard then
            setclipboard("https://www.roblox.com/pt/users/7904067601/profile?friendshipSourceType=PlayerSearch")
        end
        local tweenIn = r26:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0.8, -10, 1, -99) })
        tweenIn:Play()
        task.delay(3, function()
            local tweenOut = r26:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new(0.8, -10, 1, 100) })
            tweenOut:Play()
            tweenOut.Completed:Connect(function() notificationFrame:Destroy() end)
        end)
    end
end