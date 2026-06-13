-- AUTO FARM LEVEL + FAST ATTACK + BRING MOB - Dojo Hub
-- Tự động nhận quest, kéo quái về, tấn công siêu tốc

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local plr = Players.LocalPlayer
local Net = require(RS.Modules.Net)
local Combat = require(RS.Modules.CombatUtil)

-- ============ REMOTES ============
local hit = Net:RemoteEvent("RegisterHit", true)
local atk = RS.Modules.Net["RE/RegisterAttack"]
local CommF = RS.Remotes.CommF_

-- ============ DANH SÁCH QUÁI THEO LEVEL ============
local QuestData = {}

-- Sea 1
QuestData[1] = {Name = "Bandit", Quest = "BanditQuest1", Lv = 1, QuestPos = CFrame.new(1059,17,1546), SpawnPos = CFrame.new(943,45,1562)}
QuestData[2] = {Name = "Monkey", Quest = "JungleQuest", Lv = 1, QuestPos = CFrame.new(-1598,37,153), SpawnPos = CFrame.new(-1524,50,37)}
QuestData[3] = {Name = "Gorilla", Quest = "JungleQuest", Lv = 2, QuestPos = CFrame.new(-1598,37,153), SpawnPos = CFrame.new(-1128,40,-451)}
QuestData[4] = {Name = "Pirate", Quest = "BuggyQuest1", Lv = 1, QuestPos = CFrame.new(-1140,4,3829), SpawnPos = CFrame.new(-1262,40,3905)}
QuestData[5] = {Name = "Brute", Quest = "BuggyQuest1", Lv = 2, QuestPos = CFrame.new(-1140,4,3829), SpawnPos = CFrame.new(-976,55,4304)}
QuestData[6] = {Name = "Desert Bandit", Quest = "DesertQuest", Lv = 1, QuestPos = CFrame.new(897,6,4389), SpawnPos = CFrame.new(924,7,4482)}
QuestData[7] = {Name = "Desert Officer", Quest = "DesertQuest", Lv = 2, QuestPos = CFrame.new(897,6,4389), SpawnPos = CFrame.new(1608,9,4371)}
QuestData[8] = {Name = "Snow Bandit", Quest = "SnowQuest", Lv = 1, QuestPos = CFrame.new(1385,87,-1298), SpawnPos = CFrame.new(1362,120,-1531)}
QuestData[9] = {Name = "Snowman", Quest = "SnowQuest", Lv = 2, QuestPos = CFrame.new(1385,87,-1298), SpawnPos = CFrame.new(1243,140,-1437)}
QuestData[10] = {Name = "Chief Petty Officer", Quest = "MarineQuest2", Lv = 1, QuestPos = CFrame.new(-5035,29,4326), SpawnPos = CFrame.new(-4881,23,4274)}
QuestData[11] = {Name = "Sky Bandit", Quest = "SkyQuest", Lv = 1, QuestPos = CFrame.new(-4844,718,-2621), SpawnPos = CFrame.new(-4953,296,-2899)}
QuestData[12] = {Name = "Dark Master", Quest = "SkyQuest", Lv = 2, QuestPos = CFrame.new(-4844,718,-2621), SpawnPos = CFrame.new(-5260,391,-2229)}
QuestData[13] = {Name = "Prisoner", Quest = "PrisonerQuest", Lv = 1, QuestPos = CFrame.new(5306,2,477), SpawnPos = CFrame.new(5099,0,474)}
QuestData[14] = {Name = "Dangerous Prisoner", Quest = "PrisonerQuest", Lv = 2, QuestPos = CFrame.new(5306,2,477), SpawnPos = CFrame.new(5655,16,866)}
QuestData[15] = {Name = "Toga Warrior", Quest = "ColosseumQuest", Lv = 1, QuestPos = CFrame.new(-1581,7,-2982), SpawnPos = CFrame.new(-1820,51,-2741)}
QuestData[16] = {Name = "Gladiator", Quest = "ColosseumQuest", Lv = 2, QuestPos = CFrame.new(-1581,7,-2982), SpawnPos = CFrame.new(-1268,30,-2996)}
QuestData[17] = {Name = "Military Soldier", Quest = "MagmaQuest", Lv = 1, QuestPos = CFrame.new(-5319,12,8515), SpawnPos = CFrame.new(-5335,46,8638)}
QuestData[18] = {Name = "Military Spy", Quest = "MagmaQuest", Lv = 2, QuestPos = CFrame.new(-5319,12,8515), SpawnPos = CFrame.new(-5803,86,8829)}
QuestData[19] = {Name = "Fishman Warrior", Quest = "FishmanQuest", Lv = 1, QuestPos = CFrame.new(61122,18,1567), SpawnPos = CFrame.new(60998,50,1534)}
QuestData[20] = {Name = "Fishman Commando", Quest = "FishmanQuest", Lv = 2, QuestPos = CFrame.new(61122,18,1567), SpawnPos = CFrame.new(61866,55,1655)}
QuestData[21] = {Name = "God's Guard", Quest = "SkyExp1Quest", Lv = 1, QuestPos = CFrame.new(-4720,846,-1951), SpawnPos = CFrame.new(-4720,846,-1951)}
QuestData[22] = {Name = "Shanda", Quest = "SkyExp1Quest", Lv = 2, QuestPos = CFrame.new(-7861,5545,-381), SpawnPos = CFrame.new(-7741,5580,-395)}
QuestData[23] = {Name = "Royal Squad", Quest = "SkyExp2Quest", Lv = 1, QuestPos = CFrame.new(-7903,5636,-1412), SpawnPos = CFrame.new(-7727,5650,-1410)}
QuestData[24] = {Name = "Royal Soldier", Quest = "SkyExp2Quest", Lv = 2, QuestPos = CFrame.new(-7903,5636,-1412), SpawnPos = CFrame.new(-7894,5640,-1629)}
QuestData[25] = {Name = "Galley Pirate", Quest = "FountainQuest", Lv = 1, QuestPos = CFrame.new(5258,39,4052), SpawnPos = CFrame.new(5391,70,4023)}
QuestData[26] = {Name = "Galley Captain", Quest = "FountainQuest", Lv = 2, QuestPos = CFrame.new(5258,39,4052), SpawnPos = CFrame.new(5985,70,4790)}

-- Sea 2
QuestData[27] = {Name = "Raider", Quest = "Area1Quest", Lv = 1, QuestPos = CFrame.new(-427,73,1835), SpawnPos = CFrame.new(-614,90,2240)}
QuestData[28] = {Name = "Mercenary", Quest = "Area1Quest", Lv = 2, QuestPos = CFrame.new(-427,73,1835), SpawnPos = CFrame.new(-867,110,1621)}
QuestData[29] = {Name = "Swan Pirate", Quest = "Area2Quest", Lv = 1, QuestPos = CFrame.new(635,73,919), SpawnPos = CFrame.new(635,73,919)}
QuestData[30] = {Name = "Marine Lieutenant", Quest = "MarineQuest3", Lv = 1, QuestPos = CFrame.new(-2441,73,-3219), SpawnPos = CFrame.new(-2552,110,-3050)}
QuestData[31] = {Name = "Marine Captain", Quest = "MarineQuest3", Lv = 2, QuestPos = CFrame.new(-2441,73,-3219), SpawnPos = CFrame.new(-1695,110,-3299)}
QuestData[32] = {Name = "Zombie", Quest = "ZombieQuest", Lv = 1, QuestPos = CFrame.new(-5495,48,-794), SpawnPos = CFrame.new(-5715,90,-917)}
QuestData[33] = {Name = "Vampire", Quest = "ZombieQuest", Lv = 2, QuestPos = CFrame.new(-5495,48,-794), SpawnPos = CFrame.new(-6027,50,-1130)}
QuestData[34] = {Name = "Snow Trooper", Quest = "SnowMountainQuest", Lv = 1, QuestPos = CFrame.new(607,401,-5371), SpawnPos = CFrame.new(445,440,-5175)}
QuestData[35] = {Name = "Winter Warrior", Quest = "SnowMountainQuest", Lv = 2, QuestPos = CFrame.new(607,401,-5371), SpawnPos = CFrame.new(1224,460,-5332)}
QuestData[36] = {Name = "Lab Subordinate", Quest = "IceSideQuest", Lv = 1, QuestPos = CFrame.new(-6061,16,-4904), SpawnPos = CFrame.new(-5941,50,-4322)}
QuestData[37] = {Name = "Horned Warrior", Quest = "IceSideQuest", Lv = 2, QuestPos = CFrame.new(-6061,16,-4904), SpawnPos = CFrame.new(-6306,50,-5752)}
QuestData[38] = {Name = "Magma Ninja", Quest = "FireSideQuest", Lv = 1, QuestPos = CFrame.new(-5430,16,-5298), SpawnPos = CFrame.new(-5233,60,-6227)}
QuestData[39] = {Name = "Lava Pirate", Quest = "FireSideQuest", Lv = 2, QuestPos = CFrame.new(-5430,16,-5298), SpawnPos = CFrame.new(-4955,60,-4836)}
QuestData[40] = {Name = "Ship Deckhand", Quest = "ShipQuest1", Lv = 1, QuestPos = CFrame.new(1037,125,32911), SpawnPos = CFrame.new(1212,150,33059)}
QuestData[41] = {Name = "Ship Engineer", Quest = "ShipQuest1", Lv = 2, QuestPos = CFrame.new(1037,125,32911), SpawnPos = CFrame.new(919,43,32779)}
QuestData[42] = {Name = "Ship Steward", Quest = "ShipQuest2", Lv = 1, QuestPos = CFrame.new(968,125,33244), SpawnPos = CFrame.new(919,129,33436)}
QuestData[43] = {Name = "Ship Officer", Quest = "ShipQuest2", Lv = 2, QuestPos = CFrame.new(968,125,33244), SpawnPos = CFrame.new(1036,181,33315)}
QuestData[44] = {Name = "Arctic Warrior", Quest = "FrostQuest", Lv = 1, QuestPos = CFrame.new(5667,26,-6486), SpawnPos = CFrame.new(5966,62,-6179)}
QuestData[45] = {Name = "Snow Lurker", Quest = "FrostQuest", Lv = 2, QuestPos = CFrame.new(5667,26,-6486), SpawnPos = CFrame.new(5407,69,-6880)}
QuestData[46] = {Name = "Sea Soldier", Quest = "ForgottenQuest", Lv = 1, QuestPos = CFrame.new(-3054,235,-10142), SpawnPos = CFrame.new(-3028,64,-9775)}
QuestData[47] = {Name = "Water Fighter", Quest = "ForgottenQuest", Lv = 2, QuestPos = CFrame.new(-3054,235,-10142), SpawnPos = CFrame.new(-3352,285,-10534)}

-- Sea 3
QuestData[48] = {Name = "Pirate Millionaire", Quest = "PiratePortQuest", Lv = 1, QuestPos = CFrame.new(-290,42,5581), SpawnPos = CFrame.new(-245,47,5584)}
QuestData[49] = {Name = "Pistol Billionaire", Quest = "PiratePortQuest", Lv = 2, QuestPos = CFrame.new(-290,42,5581), SpawnPos = CFrame.new(-187,86,6013)}
QuestData[50] = {Name = "Dragon Crew Warrior", Quest = "AmazonQuest", Lv = 1, QuestPos = CFrame.new(5832,51,-1101), SpawnPos = CFrame.new(6141,51,-1340)}
QuestData[51] = {Name = "Dragon Crew Archer", Quest = "AmazonQuest", Lv = 2, QuestPos = CFrame.new(5833,51,-1103), SpawnPos = CFrame.new(6616,441,446)}
QuestData[52] = {Name = "Female Islander", Quest = "AmazonQuest2", Lv = 1, QuestPos = CFrame.new(5446,601,749), SpawnPos = CFrame.new(4685,735,815)}
QuestData[53] = {Name = "Giant Islander", Quest = "AmazonQuest2", Lv = 2, QuestPos = CFrame.new(5446,601,749), SpawnPos = CFrame.new(4729,590,-36)}
QuestData[54] = {Name = "Marine Commodore", Quest = "MarineTreeIsland", Lv = 1, QuestPos = CFrame.new(2180,27,-6741), SpawnPos = CFrame.new(2286,73,-7159)}
QuestData[55] = {Name = "Marine Rear Admiral", Quest = "MarineTreeIsland", Lv = 2, QuestPos = CFrame.new(2179,28,-6740), SpawnPos = CFrame.new(3656,160,-7001)}
QuestData[56] = {Name = "Fishman Raider", Quest = "DeepForestIsland3", Lv = 1, QuestPos = CFrame.new(-10581,330,-8761), SpawnPos = CFrame.new(-10407,331,-8368)}
QuestData[57] = {Name = "Fishman Captain", Quest = "DeepForestIsland3", Lv = 2, QuestPos = CFrame.new(-10581,330,-8761), SpawnPos = CFrame.new(-10994,352,-9002)}
QuestData[58] = {Name = "Forest Pirate", Quest = "DeepForestIsland", Lv = 1, QuestPos = CFrame.new(-13234,331,-7625), SpawnPos = CFrame.new(-13274,332,-7769)}
QuestData[59] = {Name = "Mythological Pirate", Quest = "DeepForestIsland", Lv = 2, QuestPos = CFrame.new(-13234,331,-7625), SpawnPos = CFrame.new(-13680,501,-6991)}
QuestData[60] = {Name = "Jungle Pirate", Quest = "DeepForestIsland2", Lv = 1, QuestPos = CFrame.new(-12680,389,-9902), SpawnPos = CFrame.new(-12256,331,-10485)}
QuestData[61] = {Name = "Musketeer Pirate", Quest = "DeepForestIsland2", Lv = 2, QuestPos = CFrame.new(-12682,391,-9901), SpawnPos = CFrame.new(-13098,450,-9831)}
QuestData[62] = {Name = "Reborn Skeleton", Quest = "HauntedQuest1", Lv = 1, QuestPos = CFrame.new(-9481,142,5565), SpawnPos = CFrame.new(-8680,190,5852)}
QuestData[63] = {Name = "Living Zombie", Quest = "HauntedQuest1", Lv = 2, QuestPos = CFrame.new(-9481,142,5565), SpawnPos = CFrame.new(-10144,140,5932)}
QuestData[64] = {Name = "Demonic Soul", Quest = "HauntedQuest2", Lv = 1, QuestPos = CFrame.new(-9515,172,607), SpawnPos = CFrame.new(-9275,210,6166)}
QuestData[65] = {Name = "Posessed Mummy", Quest = "HauntedQuest2", Lv = 2, QuestPos = CFrame.new(-9515,172,607), SpawnPos = CFrame.new(-9442,60,6304)}
QuestData[66] = {Name = "Peanut Scout", Quest = "NutsIslandQuest", Lv = 1, QuestPos = CFrame.new(-2104,38,-10194), SpawnPos = CFrame.new(-1870,100,-10225)}
QuestData[67] = {Name = "Peanut President", Quest = "NutsIslandQuest", Lv = 2, QuestPos = CFrame.new(-2104,38,-10194), SpawnPos = CFrame.new(-2005,100,-10585)}
QuestData[68] = {Name = "Ice Cream Chef", Quest = "IceCreamIslandQuest", Lv = 1, QuestPos = CFrame.new(-818,66,-10964), SpawnPos = CFrame.new(-501,100,-10883)}
QuestData[69] = {Name = "Ice Cream Commander", Quest = "IceCreamIslandQuest", Lv = 2, QuestPos = CFrame.new(-818,66,-10964), SpawnPos = CFrame.new(-690,100,-11350)}
QuestData[70] = {Name = "Cookie Crafter", Quest = "CakeQuest1", Lv = 1, QuestPos = CFrame.new(-2023,38,-12028), SpawnPos = CFrame.new(-2332,90,-12049)}
QuestData[71] = {Name = "Cake Guard", Quest = "CakeQuest1", Lv = 2, QuestPos = CFrame.new(-2023,38,-12028), SpawnPos = CFrame.new(-1514,90,-12422)}
QuestData[72] = {Name = "Baking Staff", Quest = "CakeQuest2", Lv = 1, QuestPos = CFrame.new(-1931,38,-12840), SpawnPos = CFrame.new(-1930,90,-12963)}
QuestData[73] = {Name = "Head Baker", Quest = "CakeQuest2", Lv = 2, QuestPos = CFrame.new(-1931,38,-12840), SpawnPos = CFrame.new(-2123,110,-12777)}
QuestData[74] = {Name = "Cocoa Warrior", Quest = "ChocQuest1", Lv = 1, QuestPos = CFrame.new(235,25,-12199), SpawnPos = CFrame.new(110,80,-12245)}
QuestData[75] = {Name = "Chocolate Bar Battler", Quest = "ChocQuest1", Lv = 2, QuestPos = CFrame.new(235,25,-12199), SpawnPos = CFrame.new(579,80,-12413)}
QuestData[76] = {Name = "Sweet Thief", Quest = "ChocQuest2", Lv = 1, QuestPos = CFrame.new(150,25,-12777), SpawnPos = CFrame.new(-68,80,-12692)}
QuestData[77] = {Name = "Candy Rebel", Quest = "ChocQuest2", Lv = 2, QuestPos = CFrame.new(150,25,-12777), SpawnPos = CFrame.new(17,80,-12962)}
QuestData[78] = {Name = "Candy Pirate", Quest = "CandyQuest1", Lv = 1, QuestPos = CFrame.new(-1148,14,-14446), SpawnPos = CFrame.new(-1371,70,-14405)}
QuestData[79] = {Name = "Snow Demon", Quest = "CandyQuest1", Lv = 2, QuestPos = CFrame.new(-1148,14,-14446), SpawnPos = CFrame.new(-836,70,-14326)}
QuestData[80] = {Name = "Isle Outlaw", Quest = "TikiQuest1", Lv = 1, QuestPos = CFrame.new(-16547,56,-172), SpawnPos = CFrame.new(-16431,90,-223)}
QuestData[81] = {Name = "Island Boy", Quest = "TikiQuest1", Lv = 2, QuestPos = CFrame.new(-16547,56,-172), SpawnPos = CFrame.new(-16668,70,-243)}
QuestData[82] = {Name = "Sun-kissed Warrior", Quest = "TikiQuest2", Lv = 1, QuestPos = CFrame.new(-16540,56,1051), SpawnPos = CFrame.new(-16345,80,1004)}
QuestData[83] = {Name = "Isle Champion", Quest = "TikiQuest2", Lv = 2, QuestPos = CFrame.new(-16540,56,1051), SpawnPos = CFrame.new(-16634,85,1106)}
QuestData[84] = {Name = "Serpent Hunter", Quest = "TikiQuest3", Lv = 1, QuestPos = CFrame.new(-16665,105,1580), SpawnPos = CFrame.new(-16542,146,1529)}
QuestData[85] = {Name = "Skull Slayer", Quest = "TikiQuest3", Lv = 2, QuestPos = CFrame.new(-16665,105,1580), SpawnPos = CFrame.new(-16849,147,1640)}
QuestData[86] = {Name = "Reef Bandit", Quest = "SubmergedQuest1", Lv = 1, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(10736,-2087,9338)}
QuestData[87] = {Name = "Coral Pirate", Quest = "SubmergedQuest1", Lv = 2, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(10965,-2158,9177)}
QuestData[88] = {Name = "Sea Chanter", Quest = "SubmergedQuest2", Lv = 1, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(10621,-2087,10102)}
QuestData[89] = {Name = "Ocean Prophet", Quest = "SubmergedQuest2", Lv = 2, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(11056,-2001,10117)}
QuestData[90] = {Name = "High Disciple", Quest = "SubmergedQuest3", Lv = 1, QuestPos = CFrame.new(9636,-1992,9609), SpawnPos = CFrame.new(9828,-1940,9693)}
QuestData[91] = {Name = "Grand Devotee", Quest = "SubmergedQuest3", Lv = 2, QuestPos = CFrame.new(9636,-1992,9609), SpawnPos = CFrame.new(9557,-1928,9859)}

-- ============ VARIABLES ============
_G.AutoFarm = false
_G.AutoBring = true
_G.BringRange = 250
_G.FastAttack = true
_G.AttackRange = 60
_G.AttackSpeed = 0.05
_G.FarmHeight = 35
_G.SelectedWeapon = "Melee"
_G.AutoHaki = true

-- ============ FAST ATTACK MODULE ============
local IsUsingFastAttack = false
local lastAttack = 0

local function HasM1Fruit()
    local char = plr.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if tool and tool.ToolTip == "Blox Fruit" then
        local fruitName = tool.Name:lower()
        local m1Fruits = {"kitsune", "t-rex", "trex", "dragon", "pain", "control", "buddha"}
        for _, name in ipairs(m1Fruits) do
            if fruitName:find(name) then
                return true
            end
        end
    end
    return false
end

local function FastAttackFruit()
    if IsUsingFastAttack then return end
    
    local char = plr.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if tool and tool.ToolTip == "Blox Fruit" and HasM1Fruit() then
        IsUsingFastAttack = true
        
        local speed = _G.AttackSpeedValue or 12
        for i = 1, speed do
            task.spawn(function()
                pcall(function()
                    tool:Activate()
                    
                    local remote = tool:FindFirstChild("LeftClickRemote") or tool:FindFirstChild("Remote")
                    if remote then
                        remote:FireServer(Vector3.new(0,0,0), 1)
                    end
                    
                    Net:InvokeServer("Attack", {
                        [1] = _G.CurrentTarget and _G.CurrentTarget.Character and _G.CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                    })
                end)
            end)
            task.wait(0.008)
        end
        
        IsUsingFastAttack = false
    end
end

local function NormalFastAttack()
    local char = plr.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    if tick() - lastAttack < _G.AttackSpeed then return end
    lastAttack = tick()
    
    local weapon = Combat:GetWeaponName(tool)
    local id = tostring(plr.UserId):sub(2,4)
    
    atk:FireServer()
    
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and (hrp.Position - root.Position).Magnitude <= _G.AttackRange then
                for i = 1, 3 do
                    hit:FireServer(hrp, {{mob, hrp}}, nil, nil, id)
                end
                Combat:ApplyDamageHighlight(mob, char, weapon, hrp)
            end
        end
    end
end

-- ============ BRING MOB MODULE ============
local BringingMobs = false
local CurrentTargetPos = nil

local function BringEnemy()
    if not _G.AutoBring then return end
    if BringingMobs then return end
    BringingMobs = true
    
    pcall(function()
        sethiddenproperty(plr, "SimulationRadius", math.huge)
    end)
    
    local char = plr.Character
    if not char then BringingMobs = false; return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then BringingMobs = false; return end
    
    local targetPos = CurrentTargetPos or root.Position
    local brought = 0
    local maxBring = 12
    
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if brought >= maxBring then break end
        
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - targetPos).Magnitude
            local underDist = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude
            
            if dist <= _G.BringRange and underDist > 5 then
                brought = brought + 1
                
                pcall(function()
                    hum.WalkSpeed = 0
                    hrp.CanCollide = false
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    
                    local destCF = CFrame.new(targetPos.X, hrp.Position.Y, targetPos.Z)
                    local tween = TweenService:Create(hrp, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {CFrame = destCF})
                    tween:Play()
                end)
            end
        end
    end
    
    BringingMobs = false
end

-- ============ TWEEN FUNCTION ============
local TweenPart = Instance.new("Part")
TweenPart.Size = Vector3.new(1,1,1)
TweenPart.Anchored = true
TweenPart.CanCollide = false
TweenPart.CanTouch = false
TweenPart.Transparency = 1
TweenPart.Parent = Workspace

local isTweening = false

local function TweenPlayer(pos)
    local char = plr.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local dist = (pos.Position - root.Position).Magnitude
    if dist < 5 then return end
    
    if isTweening then
        pcall(function() _G.CurrentTween:Cancel() end)
    end
    
    isTweening = true
    _G.StopTween = false
    
    local speed = 325
    local duration = math.max(0.1, dist / speed)
    
    TweenPart.CFrame = root.CFrame
    
    _G.CurrentTween = TweenService:Create(TweenPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = pos})
    _G.CurrentTween:Play()
    
    task.spawn(function()
        while _G.CurrentTween and _G.CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
            if _G.StopTween then
                _G.CurrentTween:Cancel()
                break
            end
            pcall(function()
                local currentChar = plr.Character
                if currentChar and currentChar:FindFirstChild("HumanoidRootPart") then
                    currentChar.HumanoidRootPart.CFrame = TweenPart.CFrame
                end
            end)
            task.wait()
        end
        isTweening = false
    end)
end

local function StopTween()
    _G.StopTween = true
    if _G.CurrentTween then
        pcall(function() _G.CurrentTween:Cancel() end)
    end
    isTweening = false
end

-- ============ AUTO HAKI ============
local function AutoHaki()
    if not _G.AutoHaki then return end
    local char = plr.Character
    if char and not char:FindFirstChild("HasBuso") then
        pcall(function()
            CommF:InvokeServer("Buso")
        end)
    end
end

-- ============ EQUIP WEAPON ============
local function EquipWeapon()
    local char = plr.Character
    if not char then return end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.ToolTip == _G.SelectedWeapon then
        return
    end
    
    for _, tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == _G.SelectedWeapon then
            char.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- ============ GET CURRENT QUEST ============
local function GetCurrentQuest()
    local level = plr.Data.Level.Value
    
    -- Tìm quest theo level
    local bestQuest = nil
    local minDiff = math.huge
    
    for id, data in pairs(QuestData) do
        local reqLevel = tonumber(id) * 25 -- Ước lượng level yêu cầu
        local diff = math.abs(level - reqLevel)
        if diff < minDiff and level >= reqLevel - 10 then
            minDiff = diff
            bestQuest = data
        end
    end
    
    return bestQuest
end

-- ============ FARM LOOP ============
local currentMob = nil
local questCompleted = false

task.spawn(function()
    while task.wait(0.1) do
        if not _G.AutoFarm then 
            task.wait(0.5)
            continue 
        end
        
        pcall(function()
            local char = plr.Character
            if not char then return end
            
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            
            -- Auto Haki
            AutoHaki()
            
            -- Equip weapon
            EquipWeapon()
            
            -- Lấy quest hiện tại
            local quest = GetCurrentQuest()
            if not quest then 
                task.wait(1)
                return 
            end
            
            -- Kiểm tra quest trong UI
            local questUI = plr.PlayerGui.Main.Quest
            local needQuest = true
            
            if questUI.Visible then
                local questTitle = ""
                pcall(function()
                    questTitle = questUI.Container.QuestTitle.Title.Text
                end)
                if questTitle:find(quest.Name) then
                    needQuest = false
                else
                    CommF:InvokeServer("AbandonQuest")
                    task.wait(0.3)
                    needQuest = true
                end
            end
            
            -- Nhận quest nếu cần
            if needQuest then
                local distToNPC = (quest.QuestPos.Position - root.Position).Magnitude
                if distToNPC > 10 then
                    TweenPlayer(quest.QuestPos)
                    task.wait(0.5)
                else
                    CommF:InvokeServer("StartQuest", quest.Quest, quest.Lv)
                    task.wait(0.5)
                end
                continue
            end
            
            -- Tìm quái
            local closestMob = nil
            local closestDist = _G.AttackRange + 1
            
            for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                local mobHum = mob:FindFirstChild("Humanoid")
                
                if hrp and mobHum and mobHum.Health > 0 and mob.Name == quest.Name then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist                        closestMob = mob
                    end
                end
            end
            
            if closestMob then
                currentMob = closestMob
                CurrentTargetPos = closestMob.HumanoidRootPart.Position
                
                -- Di chuyển đến quái
                local mobPos = closestMob.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmHeight, 0)
                if closestDist > 15 then
                    TweenPlayer(mobPos)
                end
                
                -- Disable quái để kéo về
                pcall(function()
                    closestMob.Humanoid.WalkSpeed = 0
                    closestMob.HumanoidRootPart.CanCollide = false
                end)
                
                -- Bring mob
                if _G.AutoBring then
                    BringEnemy()
                end
                
                -- Fast Attack
                if _G.FastAttack then
                    if _G.SelectedWeapon == "Blox Fruit" and HasM1Fruit() then
                        FastAttackFruit()
                    else
                        NormalFastAttack()
                    end
                else
                    NormalFastAttack()
                end
                
                -- Kiểm tra quest hoàn thành
                if not questUI.Visible then
                    questCompleted = true
                end
            else
                -- Không tìm thấy quái, tween đến spawn point
                if quest.SpawnPos then
                    TweenPlayer(quest.SpawnPos)
                end
            end
        end)
    end
end)

-- ============ AUTO STATS ============
task.spawn(function()
    while task.wait(1) do
        if not _G.AutoFarm then continue end
        pcall(function()
            local points = plr.Data.Points.Value
            if points > 0 then
                if _G.SelectedWeapon == "Melee" then
                    CommF:InvokeServer("AddPoint", "Melee", points)
                elseif _G.SelectedWeapon == "Sword" then
                    CommF:InvokeServer("AddPoint", "Sword", points)
                elseif _G.SelectedWeapon == "Blox Fruit" then
                    CommF:InvokeServer("AddPoint", "Demon Fruit", points)
                elseif _G.SelectedWeapon == "Gun" then
                    CommF:InvokeServer("AddPoint", "Gun", points)
                end
                CommF:InvokeServer("AddPoint", "Defense", points)
            end
        end)
    end
end)

-- ============ CREATE GUI ============
local Window = Rayfield:CreateWindow({
    Name = "Dojo Hub | Auto Farm",
    LoadingTitle = "Đang tải...",
    LoadingSubtitle = "By Dojo",
    ConfigurationSaving = {Enabled = true, FolderName = "DojoHub"}
})

local MainTab = Window:CreateTab("Farm", 4483362458)

-- Toggle chính
MainTab:CreateToggle({
    Name = "Bật Auto Farm Level",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarm = v
        if not v then
            StopTween()
        end
    end
})

-- Dropdown chọn vũ khí
MainTab:CreateDropdown({
    Name = "Chọn Vũ Khí",
    Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
    CurrentOption = "Melee",
    Callback = function(v)
        _G.SelectedWeapon = v
    end
})

-- Slider phạm vi tấn công
MainTab:CreateSlider({
    Name = "Phạm Vi Tấn Công",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v)
        _G.AttackRange = v
    end
})

-- Slider tốc độ đánh
MainTab:CreateSlider({
    Name = "Tốc Độ Đánh (ms)",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v)
        _G.AttackSpeed = v / 1000
        _G.AttackSpeedValue = math.floor(1000 / v)
    end
})

-- Slider độ cao khi farm
MainTab:CreateSlider({
    Name = "Độ Cao Khi Farm",
    Range = {15, 60},
    Increment = 5,
    CurrentValue = 35,
    Callback = function(v)
        _G.FarmHeight = v
    end
})

-- Toggle bring mob
MainTab:CreateToggle({
    Name = "Kéo Quái Về",
    CurrentValue = true,
    Callback = function(v)
        _G.AutoBring = v
    end
})

-- Toggle fast attack
MainTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Callback = function(v)
        _G.FastAttack = v
    end
})

-- Toggle auto haki
MainTab:CreateToggle({
    Name = "Tự Động Bật Haki",
    CurrentValue = true,
    Callback = function(v)
        _G.AutoHaki = v
    end
})

-- Hiển thị thông tin
local LevelLabel = MainTab:CreateLabel("Level: Đang cập nhật...")
local QuestLabel = MainTab:CreateLabel("Quest: ---")

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            LevelLabel:SetText("Level: " .. plr.Data.Level.Value)
            local quest = GetCurrentQuest()
            if quest then
                QuestLabel:SetText("Quest: " .. quest.Name)
            end
        end)
    end
end)

-- Notify
Rayfield:Notify({
    Title = "Dojo Hub",
    Content = "Đã tải Auto Farm Level!",
    Duration = 3
})

print("✅ Dojo Hub Auto Farm Level loaded!")
print("🔧 Settings: Fast Attack + Bring Mob + Auto Stats")