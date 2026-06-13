-- AUTO FARM LEVEL - GUI TỰ CHẾ (Drag được, chạy trên mọi executor kể cả Delta)

-- ============ SERVICES ============
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local plr = Players.LocalPlayer
local CommF = RS.Remotes.CommF_

-- ============ MODULES ============
local Net, Combat
pcall(function()
    Net = require(RS.Modules.Net)
    Combat = require(RS.Modules.CombatUtil)
end)

-- ============ DANH SÁCH QUEST ĐẦY ĐỦ ============
local QuestData = {
    -- SEA 1
    {Name = "Bandit", Quest = "BanditQuest1", Lv = 1, QuestPos = CFrame.new(1059,17,1546), SpawnPos = CFrame.new(943,45,1562)},
    {Name = "Monkey", Quest = "JungleQuest", Lv = 1, QuestPos = CFrame.new(-1598,37,153), SpawnPos = CFrame.new(-1524,50,37)},
    {Name = "Gorilla", Quest = "JungleQuest", Lv = 2, QuestPos = CFrame.new(-1598,37,153), SpawnPos = CFrame.new(-1128,40,-451)},
    {Name = "Pirate", Quest = "BuggyQuest1", Lv = 1, QuestPos = CFrame.new(-1140,4,3829), SpawnPos = CFrame.new(-1262,40,3905)},
    {Name = "Brute", Quest = "BuggyQuest1", Lv = 2, QuestPos = CFrame.new(-1140,4,3829), SpawnPos = CFrame.new(-976,55,4304)},
    {Name = "Desert Bandit", Quest = "DesertQuest", Lv = 1, QuestPos = CFrame.new(897,6,4389), SpawnPos = CFrame.new(924,7,4482)},
    {Name = "Desert Officer", Quest = "DesertQuest", Lv = 2, QuestPos = CFrame.new(897,6,4389), SpawnPos = CFrame.new(1608,9,4371)},
    {Name = "Snow Bandit", Quest = "SnowQuest", Lv = 1, QuestPos = CFrame.new(1385,87,-1298), SpawnPos = CFrame.new(1362,120,-1531)},
    {Name = "Snowman", Quest = "SnowQuest", Lv = 2, QuestPos = CFrame.new(1385,87,-1298), SpawnPos = CFrame.new(1243,140,-1437)},
    {Name = "Chief Petty Officer", Quest = "MarineQuest2", Lv = 1, QuestPos = CFrame.new(-5035,29,4326), SpawnPos = CFrame.new(-4881,23,4274)},
    {Name = "Sky Bandit", Quest = "SkyQuest", Lv = 1, QuestPos = CFrame.new(-4844,718,-2621), SpawnPos = CFrame.new(-4953,296,-2899)},
    {Name = "Dark Master", Quest = "SkyQuest", Lv = 2, QuestPos = CFrame.new(-4844,718,-2621), SpawnPos = CFrame.new(-5260,391,-2229)},
    {Name = "Prisoner", Quest = "PrisonerQuest", Lv = 1, QuestPos = CFrame.new(5306,2,477), SpawnPos = CFrame.new(5099,0,474)},
    {Name = "Dangerous Prisoner", Quest = "PrisonerQuest", Lv = 2, QuestPos = CFrame.new(5306,2,477), SpawnPos = CFrame.new(5655,16,866)},
    {Name = "Toga Warrior", Quest = "ColosseumQuest", Lv = 1, QuestPos = CFrame.new(-1581,7,-2982), SpawnPos = CFrame.new(-1820,51,-2741)},
    {Name = "Gladiator", Quest = "ColosseumQuest", Lv = 2, QuestPos = CFrame.new(-1581,7,-2982), SpawnPos = CFrame.new(-1268,30,-2996)},
    {Name = "Military Soldier", Quest = "MagmaQuest", Lv = 1, QuestPos = CFrame.new(-5319,12,8515), SpawnPos = CFrame.new(-5335,46,8638)},
    {Name = "Military Spy", Quest = "MagmaQuest", Lv = 2, QuestPos = CFrame.new(-5319,12,8515), SpawnPos = CFrame.new(-5803,86,8829)},
    {Name = "Fishman Warrior", Quest = "FishmanQuest", Lv = 1, QuestPos = CFrame.new(61122,18,1567), SpawnPos = CFrame.new(60998,50,1534)},
    {Name = "Fishman Commando", Quest = "FishmanQuest", Lv = 2, QuestPos = CFrame.new(61122,18,1567), SpawnPos = CFrame.new(61866,55,1655)},
    {Name = "God's Guard", Quest = "SkyExp1Quest", Lv = 1, QuestPos = CFrame.new(-4720,846,-1951), SpawnPos = CFrame.new(-4720,846,-1951)},
    {Name = "Shanda", Quest = "SkyExp1Quest", Lv = 2, QuestPos = CFrame.new(-7861,5545,-381), SpawnPos = CFrame.new(-7741,5580,-395)},
    {Name = "Royal Squad", Quest = "SkyExp2Quest", Lv = 1, QuestPos = CFrame.new(-7903,5636,-1412), SpawnPos = CFrame.new(-7727,5650,-1410)},
    {Name = "Royal Soldier", Quest = "SkyExp2Quest", Lv = 2, QuestPos = CFrame.new(-7903,5636,-1412), SpawnPos = CFrame.new(-7894,5640,-1629)},
    {Name = "Galley Pirate", Quest = "FountainQuest", Lv = 1, QuestPos = CFrame.new(5258,39,4052), SpawnPos = CFrame.new(5391,70,4023)},
    {Name = "Galley Captain", Quest = "FountainQuest", Lv = 2, QuestPos = CFrame.new(5258,39,4052), SpawnPos = CFrame.new(5985,70,4790)},
    
    -- SEA 2
    {Name = "Raider", Quest = "Area1Quest", Lv = 1, QuestPos = CFrame.new(-427,73,1835), SpawnPos = CFrame.new(-614,90,2240)},
    {Name = "Mercenary", Quest = "Area1Quest", Lv = 2, QuestPos = CFrame.new(-427,73,1835), SpawnPos = CFrame.new(-867,110,1621)},
    {Name = "Swan Pirate", Quest = "Area2Quest", Lv = 1, QuestPos = CFrame.new(635,73,919), SpawnPos = CFrame.new(635,73,919)},
    {Name = "Factory Staff", Quest = "Area2Quest", Lv = 2, QuestPos = CFrame.new(635,73,919), SpawnPos = CFrame.new(-105,73,-670)},
    {Name = "Marine Lieutenant", Quest = "MarineQuest3", Lv = 1, QuestPos = CFrame.new(-2441,73,-3219), SpawnPos = CFrame.new(-2552,110,-3050)},
    {Name = "Marine Captain", Quest = "MarineQuest3", Lv = 2, QuestPos = CFrame.new(-2441,73,-3219), SpawnPos = CFrame.new(-1695,110,-3299)},
    {Name = "Zombie", Quest = "ZombieQuest", Lv = 1, QuestPos = CFrame.new(-5495,48,-794), SpawnPos = CFrame.new(-5715,90,-917)},
    {Name = "Vampire", Quest = "ZombieQuest", Lv = 2, QuestPos = CFrame.new(-5495,48,-794), SpawnPos = CFrame.new(-6027,50,-1130)},
    {Name = "Snow Trooper", Quest = "SnowMountainQuest", Lv = 1, QuestPos = CFrame.new(607,401,-5371), SpawnPos = CFrame.new(445,440,-5175)},
    {Name = "Winter Warrior", Quest = "SnowMountainQuest", Lv = 2, QuestPos = CFrame.new(607,401,-5371), SpawnPos = CFrame.new(1224,460,-5332)},
    {Name = "Lab Subordinate", Quest = "IceSideQuest", Lv = 1, QuestPos = CFrame.new(-6061,16,-4904), SpawnPos = CFrame.new(-5941,50,-4322)},
    {Name = "Horned Warrior", Quest = "IceSideQuest", Lv = 2, QuestPos = CFrame.new(-6061,16,-4904), SpawnPos = CFrame.new(-6306,50,-5752)},
    {Name = "Magma Ninja", Quest = "FireSideQuest", Lv = 1, QuestPos = CFrame.new(-5430,16,-5298), SpawnPos = CFrame.new(-5233,60,-6227)},
    {Name = "Lava Pirate", Quest = "FireSideQuest", Lv = 2, QuestPos = CFrame.new(-5430,16,-5298), SpawnPos = CFrame.new(-4955,60,-4836)},
    {Name = "Ship Deckhand", Quest = "ShipQuest1", Lv = 1, QuestPos = CFrame.new(1037,125,32911), SpawnPos = CFrame.new(1212,150,33059)},
    {Name = "Ship Engineer", Quest = "ShipQuest1", Lv = 2, QuestPos = CFrame.new(1037,125,32911), SpawnPos = CFrame.new(919,43,32779)},
    {Name = "Ship Steward", Quest = "ShipQuest2", Lv = 1, QuestPos = CFrame.new(968,125,33244), SpawnPos = CFrame.new(919,129,33436)},
    {Name = "Ship Officer", Quest = "ShipQuest2", Lv = 2, QuestPos = CFrame.new(968,125,33244), SpawnPos = CFrame.new(1036,181,33315)},
    {Name = "Arctic Warrior", Quest = "FrostQuest", Lv = 1, QuestPos = CFrame.new(5667,26,-6486), SpawnPos = CFrame.new(5966,62,-6179)},
    {Name = "Snow Lurker", Quest = "FrostQuest", Lv = 2, QuestPos = CFrame.new(5667,26,-6486), SpawnPos = CFrame.new(5407,69,-6880)},
    {Name = "Sea Soldier", Quest = "ForgottenQuest", Lv = 1, QuestPos = CFrame.new(-3054,235,-10142), SpawnPos = CFrame.new(-3028,64,-9775)},
    {Name = "Water Fighter", Quest = "ForgottenQuest", Lv = 2, QuestPos = CFrame.new(-3054,235,-10142), SpawnPos = CFrame.new(-3352,285,-10534)},
    
    -- SEA 3
    {Name = "Pirate Millionaire", Quest = "PiratePortQuest", Lv = 1, QuestPos = CFrame.new(-290,42,5581), SpawnPos = CFrame.new(-245,47,5584)},
    {Name = "Pistol Billionaire", Quest = "PiratePortQuest", Lv = 2, QuestPos = CFrame.new(-290,42,5581), SpawnPos = CFrame.new(-187,86,6013)},
    {Name = "Dragon Crew Warrior", Quest = "AmazonQuest", Lv = 1, QuestPos = CFrame.new(5832,51,-1101), SpawnPos = CFrame.new(6141,51,-1340)},
    {Name = "Dragon Crew Archer", Quest = "AmazonQuest", Lv = 2, QuestPos = CFrame.new(5833,51,-1103), SpawnPos = CFrame.new(6616,441,446)},
    {Name = "Female Islander", Quest = "AmazonQuest2", Lv = 1, QuestPos = CFrame.new(5446,601,749), SpawnPos = CFrame.new(4685,735,815)},
    {Name = "Giant Islander", Quest = "AmazonQuest2", Lv = 2, QuestPos = CFrame.new(5446,601,749), SpawnPos = CFrame.new(4729,590,-36)},
    {Name = "Marine Commodore", Quest = "MarineTreeIsland", Lv = 1, QuestPos = CFrame.new(2180,27,-6741), SpawnPos = CFrame.new(2286,73,-7159)},
    {Name = "Marine Rear Admiral", Quest = "MarineTreeIsland", Lv = 2, QuestPos = CFrame.new(2179,28,-6740), SpawnPos = CFrame.new(3656,160,-7001)},
    {Name = "Fishman Raider", Quest = "DeepForestIsland3", Lv = 1, QuestPos = CFrame.new(-10581,330,-8761), SpawnPos = CFrame.new(-10407,331,-8368)},
    {Name = "Fishman Captain", Quest = "DeepForestIsland3", Lv = 2, QuestPos = CFrame.new(-10581,330,-8761), SpawnPos = CFrame.new(-10994,352,-9002)},
    {Name = "Forest Pirate", Quest = "DeepForestIsland", Lv = 1, QuestPos = CFrame.new(-13234,331,-7625), SpawnPos = CFrame.new(-13274,332,-7769)},
    {Name = "Mythological Pirate", Quest = "DeepForestIsland", Lv = 2, QuestPos = CFrame.new(-13234,331,-7625), SpawnPos = CFrame.new(-13680,501,-6991)},
    {Name = "Jungle Pirate", Quest = "DeepForestIsland2", Lv = 1, QuestPos = CFrame.new(-12680,389,-9902), SpawnPos = CFrame.new(-12256,331,-10485)},
    {Name = "Musketeer Pirate", Quest = "DeepForestIsland2", Lv = 2, QuestPos = CFrame.new(-12682,391,-9901), SpawnPos = CFrame.new(-13098,450,-9831)},
    {Name = "Reborn Skeleton", Quest = "HauntedQuest1", Lv = 1, QuestPos = CFrame.new(-9481,142,5565), SpawnPos = CFrame.new(-8680,190,5852)},
    {Name = "Living Zombie", Quest = "HauntedQuest1", Lv = 2, QuestPos = CFrame.new(-9481,142,5565), SpawnPos = CFrame.new(-10144,140,5932)},
    {Name = "Demonic Soul", Quest = "HauntedQuest2", Lv = 1, QuestPos = CFrame.new(-9515,172,607), SpawnPos = CFrame.new(-9275,210,6166)},
    {Name = "Posessed Mummy", Quest = "HauntedQuest2", Lv = 2, QuestPos = CFrame.new(-9515,172,607), SpawnPos = CFrame.new(-9442,60,6304)},
    {Name = "Peanut Scout", Quest = "NutsIslandQuest", Lv = 1, QuestPos = CFrame.new(-2104,38,-10194), SpawnPos = CFrame.new(-1870,100,-10225)},
    {Name = "Peanut President", Quest = "NutsIslandQuest", Lv = 2, QuestPos = CFrame.new(-2104,38,-10194), SpawnPos = CFrame.new(-2005,100,-10585)},
    {Name = "Ice Cream Chef", Quest = "IceCreamIslandQuest", Lv = 1, QuestPos = CFrame.new(-818,66,-10964), SpawnPos = CFrame.new(-501,100,-10883)},
    {Name = "Ice Cream Commander", Quest = "IceCreamIslandQuest", Lv = 2, QuestPos = CFrame.new(-818,66,-10964), SpawnPos = CFrame.new(-690,100,-11350)},
    {Name = "Cookie Crafter", Quest = "CakeQuest1", Lv = 1, QuestPos = CFrame.new(-2023,38,-12028), SpawnPos = CFrame.new(-2332,90,-12049)},
    {Name = "Cake Guard", Quest = "CakeQuest1", Lv = 2, QuestPos = CFrame.new(-2023,38,-12028), SpawnPos = CFrame.new(-1514,90,-12422)},
    {Name = "Baking Staff", Quest = "CakeQuest2", Lv = 1, QuestPos = CFrame.new(-1931,38,-12840), SpawnPos = CFrame.new(-1930,90,-12963)},
    {Name = "Head Baker", Quest = "CakeQuest2", Lv = 2, QuestPos = CFrame.new(-1931,38,-12840), SpawnPos = CFrame.new(-2123,110,-12777)},
    {Name = "Cocoa Warrior", Quest = "ChocQuest1", Lv = 1, QuestPos = CFrame.new(235,25,-12199), SpawnPos = CFrame.new(110,80,-12245)},
    {Name = "Chocolate Bar Battler", Quest = "ChocQuest1", Lv = 2, QuestPos = CFrame.new(235,25,-12199), SpawnPos = CFrame.new(579,80,-12413)},
    {Name = "Sweet Thief", Quest = "ChocQuest2", Lv = 1, QuestPos = CFrame.new(150,25,-12777), SpawnPos = CFrame.new(-68,80,-12692)},
    {Name = "Candy Rebel", Quest = "ChocQuest2", Lv = 2, QuestPos = CFrame.new(150,25,-12777), SpawnPos = CFrame.new(17,80,-12962)},
    {Name = "Candy Pirate", Quest = "CandyQuest1", Lv = 1, QuestPos = CFrame.new(-1148,14,-14446), SpawnPos = CFrame.new(-1371,70,-14405)},
    {Name = "Snow Demon", Quest = "CandyQuest1", Lv = 2, QuestPos = CFrame.new(-1148,14,-14446), SpawnPos = CFrame.new(-836,70,-14326)},
    {Name = "Isle Outlaw", Quest = "TikiQuest1", Lv = 1, QuestPos = CFrame.new(-16547,56,-172), SpawnPos = CFrame.new(-16431,90,-223)},
    {Name = "Island Boy", Quest = "TikiQuest1", Lv = 2, QuestPos = CFrame.new(-16547,56,-172), SpawnPos = CFrame.new(-16668,70,-243)},
    {Name = "Sun-kissed Warrior", Quest = "TikiQuest2", Lv = 1, QuestPos = CFrame.new(-16540,56,1051), SpawnPos = CFrame.new(-16345,80,1004)},
    {Name = "Isle Champion", Quest = "TikiQuest2", Lv = 2, QuestPos = CFrame.new(-16540,56,1051), SpawnPos = CFrame.new(-16634,85,1106)},
    {Name = "Serpent Hunter", Quest = "TikiQuest3", Lv = 1, QuestPos = CFrame.new(-16665,105,1580), SpawnPos = CFrame.new(-16542,146,1529)},
    {Name = "Skull Slayer", Quest = "TikiQuest3", Lv = 2, QuestPos = CFrame.new(-16665,105,1580), SpawnPos = CFrame.new(-16849,147,1640)},
    {Name = "Reef Bandit", Quest = "SubmergedQuest1", Lv = 1, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(10736,-2087,9338)},
    {Name = "Coral Pirate", Quest = "SubmergedQuest1", Lv = 2, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(10965,-2158,9177)},
    {Name = "Sea Chanter", Quest = "SubmergedQuest2", Lv = 1, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(10621,-2087,10102)},
    {Name = "Ocean Prophet", Quest = "SubmergedQuest2", Lv = 2, QuestPos = CFrame.new(10882,-2086,10034), SpawnPos = CFrame.new(11056,-2001,10117)},
    {Name = "High Disciple", Quest = "SubmergedQuest3", Lv = 1, QuestPos = CFrame.new(9636,-1992,9609), SpawnPos = CFrame.new(9828,-1940,9693)},
    {Name = "Grand Devotee", Quest = "SubmergedQuest3", Lv = 2, QuestPos = CFrame.new(9636,-1992,9609), SpawnPos = CFrame.new(9557,-1928,9859)},
}

-- ============ SETTINGS ============
local Settings = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    AttackRange = 60,
    FarmHeight = 35,
    AutoBring = true,
    FastAttack = true,
    AutoHaki = true,
}

-- ============ VARIABLES ============
local IsUsingFastAttack = false
local LastAttack = 0
local IsBringing = false
local IsTweening = false
local CurrentTween = nil
local StopTweenFlag = false

-- ============ CHECK M1 FRUIT ============
local function HasM1Fruit()
    local char = plr.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.ToolTip == "Blox Fruit" then
        local name = string.lower(tool.Name)
        local m1Fruits = {"kitsune", "t-rex", "trex", "dragon", "pain", "control", "buddha"}
        for _, fruit in pairs(m1Fruits) do
            if string.find(name, fruit) then return true end
        end
    end
    return false
end

-- ============ FAST ATTACK ============
local function FastAttackFruit()
    if IsUsingFastAttack then return end
    local char = plr.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.ToolTip == "Blox Fruit" and HasM1Fruit() then
        IsUsingFastAttack = true
        for i = 1, 15 do
            task.spawn(function()
                pcall(function()
                    tool:Activate()
                    local remote = tool:FindFirstChild("LeftClickRemote") or tool:FindFirstChild("Remote")
                    if remote then remote:FireServer(Vector3.new(0,0,0), 1) end
                    if Net and Net.InvokeServer then Net:InvokeServer("Attack", {}) end
                end)
            end)
            task.wait(0.008)
        end
        IsUsingFastAttack = false
    end
end

local function NormalAttack()
    if not Net or not Combat then return end
    if tick() - LastAttack < 0.05 then return end
    LastAttack = tick()
    local char = plr.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local tool = char:FindFirstChildOfClass("Tool")
    if not (root and tool) then return end
    local weapon = Combat:GetWeaponName(tool)
    local id = string.sub(tostring(plr.UserId), 2, 4)
    pcall(function()
        if RS.Modules and RS.Modules.Net and RS.Modules.Net["RE/RegisterAttack"] then
            RS.Modules.Net["RE/RegisterAttack"]:FireServer()
        end
    end)
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - root.Position).Magnitude
            if dist <= Settings.AttackRange then
                pcall(function()
                    if Net and Net.RemoteEvent then
                        local hitEvent = Net:RemoteEvent("RegisterHit", true)
                        if hitEvent then hitEvent:FireServer(hrp, {{mob, hrp}}, nil, nil, id) end
                    end
                    Combat:ApplyDamageHighlight(mob, char, weapon, hrp)
                end)
            end
        end
    end
end

-- ============ BRING MOB ============
local function BringEnemy(targetPos)
    if not Settings.AutoBring then return end
    if IsBringing then return end
    IsBringing = true
    local char = plr.Character
    if not char then IsBringing = false; return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then IsBringing = false; return end
    local bringPos = targetPos or root.Position
    local count = 0
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if count >= 10 then break end
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - bringPos).Magnitude
            if dist <= 250 and dist > 8 then
                count = count + 1
                pcall(function()
                    hum.WalkSpeed = 0
                    hrp.CanCollide = false
                    local dest = CFrame.new(bringPos.X, hrp.Position.Y, bringPos.Z)
                    local tween = TweenService:Create(hrp, TweenInfo.new(0.4), {CFrame = dest})
                    tween:Play()
                end)
            end
        end
    end
    IsBringing = false
end

-- ============ TWEEN PLAYER ============
local TweenPart = Instance.new("Part")
TweenPart.Size = Vector3.new(1,1,1)
TweenPart.Anchored = true
TweenPart.CanCollide = false
TweenPart.CanTouch = false
TweenPart.Transparency = 1
TweenPart.Parent = Workspace

local function TweenPlayer(pos)
    local char = plr.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local dist = (pos.Position - root.Position).Magnitude
    if dist < 5 then return end
    if IsTweening and CurrentTween then pcall(function() CurrentTween:Cancel() end) end
    IsTweening = true
    StopTweenFlag = false
    TweenPart.CFrame = root.CFrame
    local duration = math.max(0.1, dist / 300)
    CurrentTween = TweenService:Create(TweenPart, TweenInfo.new(duration), {CFrame = pos})
    CurrentTween:Play()
    task.spawn(function()
        while CurrentTween and CurrentTween.PlaybackState == Enum.PlaybackState.Playing do
            if StopTweenFlag then CurrentTween:Cancel(); break end
            local currentChar = plr.Character
            if currentChar and currentChar:FindFirstChild("HumanoidRootPart") then
                currentChar.HumanoidRootPart.CFrame = TweenPart.CFrame
            end
            task.wait()
        end
        IsTweening = false
        CurrentTween = nil
    end)
end

local function StopTween()
    StopTweenFlag = true
    if CurrentTween then pcall(function() CurrentTween:Cancel() end) end
    IsTweening = false
end

-- ============ AUTO HAKI ============
local function AutoHaki()
    if not Settings.AutoHaki then return end
    local char = plr.Character
    if char and not char:FindFirstChild("HasBuso") then
        pcall(function() CommF:InvokeServer("Buso") end)
    end
end

-- ============ EQUIP WEAPON ============
local function EquipWeapon()
    local char = plr.Character
    if not char then return end
    local current = char:FindFirstChildOfClass("Tool")
    if current and current.ToolTip == Settings.SelectedWeapon then return end
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == Settings.SelectedWeapon then
            char.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- ============ GET CURRENT QUEST ============
local function GetCurrentQuest()
    local level = plr.Data.Level.Value
    for i = #QuestData, 1, -1 do
        if level >= 0 then return QuestData[i] end
    end
    return QuestData[1]
end

-- ============ MAIN FARM LOOP ============
task.spawn(function()
    while task.wait(0.15) do
        if not Settings.AutoFarm then task.wait(0.5); goto continue end
        pcall(function()
            local char = plr.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            AutoHaki()
            EquipWeapon()
            local quest = GetCurrentQuest()
            if not quest then return end
            local questUI = plr.PlayerGui.Main.Quest
            local needQuest = true
            if questUI.Visible then
                local title = ""
                pcall(function() title = questUI.Container.QuestTitle.Title.Text end)
                if string.find(title, quest.Name) then
                    needQuest = false
                else
                    pcall(function() CommF:InvokeServer("AbandonQuest") end)
                    task.wait(0.3)
                end
            end
            if needQuest then
                local dist = (quest.QuestPos.Position - root.Position).Magnitude
                if dist > 15 then
                    TweenPlayer(quest.QuestPos)
                    task.wait(0.5)
                else
                    pcall(function() CommF:InvokeServer("StartQuest", quest.Quest, quest.Lv) end)
                    task.wait(0.5)
                end
                return
            end
            local targetMob = nil
            local targetDist = Settings.AttackRange + 1
            for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                local mobHum = mob:FindFirstChild("Humanoid")
                if hrp and mobHum and mobHum.Health > 0 and mob.Name == quest.Name then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < targetDist then
                        targetDist = dist
                        targetMob = mob
                    end
                end
            end
            if targetMob then
                local mobRoot = targetMob.HumanoidRootPart
                local targetPos = mobRoot.CFrame * CFrame.new(0, Settings.FarmHeight, 0)
                if targetDist > 15 then TweenPlayer(targetPos) end
                pcall(function()
                    targetMob.Humanoid.WalkSpeed = 0
                    mobRoot.CanCollide = false
                end)
                if Settings.AutoBring then BringEnemy(mobRoot.Position) end
                if Settings.FastAttack and Settings.SelectedWeapon == "Blox Fruit" and HasM1Fruit() then
                    FastAttackFruit()
                else
                    NormalAttack()
                end
            else
                if quest.SpawnPos then TweenPlayer(quest.SpawnPos) end
            end
        end)
        ::continue::
    end
end)

-- ============ AUTO STATS ============
task.spawn(function()
    while task.wait(1) do
        if not Settings.AutoFarm then goto continue end
        pcall(function()
            local points = plr.Data.Points.Value
            if points > 0 then
                local stat = "Defense"
                if Settings.SelectedWeapon == "Melee" then stat = "Melee"
                elseif Settings.SelectedWeapon == "Sword" then stat = "Sword"
                elseif Settings.SelectedWeapon == "Blox Fruit" then stat = "Demon Fruit"
                elseif Settings.SelectedWeapon == "Gun" then stat = "Gun" end
                CommF:InvokeServer("AddPoint", stat, points)
                CommF:InvokeServer("AddPoint", "Defense", points)
            end
        end)
        ::continue::
    end
end)

-- ============ TẠO GUI TỰ CHẾ (DRAG ĐƯỢC) ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DojoHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = plr.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title Bar (để drag)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
TitleBar.BackgroundTransparency = 0.15
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ Dojo Hub | Auto Farm"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag functionality
local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scroll Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.Parent = MainFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 8)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Parent = ScrollFrame

ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 10)
end)

-- Hàm tạo Toggle
local function CreateToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0.3
    frame.Parent = ScrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 28)
    btn.Position = UDim2.new(1, -65, 0.5, -14)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(100, 100, 120)
    btn.Text = default and "BẬT" or "TẮT"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(100, 100, 120)
        btn.Text = state and "BẬT" or "TẮT"
        callback(state)
    end)
end

-- Hàm tạo Dropdown
local function CreateDropdown(text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0.3
    frame.Parent = ScrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 28)
    btn.Position = UDim2.new(1, -110, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    btn.Text = default
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local index = 1
    for i, opt in ipairs(options) do
        if opt == default then index = i break end
    end
    
    btn.MouseButton1Click:Connect(function()
        index = index % #options + 1
        local selected = options[index]
        btn.Text = selected
        callback(selected)
    end)
end

-- Hàm tạo Slider
local function CreateSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0.3
    frame.Parent = ScrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 180, 80)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 11
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -20, 0, 4)
    slider.Position = UDim2.new(0, 10, 0, 35)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    local percent = (default - min) / (max - min)
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(percent, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Text = ""
    knob.Parent = slider
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local draggingSlider = false
    knob.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - slider.AbsolutePosition.X
            local newPercent = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * newPercent)
            fill.Size = UDim2.new(newPercent, 0, 1, 0)
            knob.Position = UDim2.new(newPercent, -8, 0.5, -8)
            label.Text = text .. ": " .. tostring(value)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
end

-- Hàm tạo Label
local function CreateLabel(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = ScrollFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 180, 80)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    return label
end

-- ============ TẠO UI ELEMENTS ============
CreateToggle("▶ Bật Auto Farm", false, function(v)
    Settings.AutoFarm = v
    if not v then StopTween() end
end)

CreateDropdown("⚔ Vũ Khí", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Melee", function(v)
    Settings.SelectedWeapon = v
end)

CreateSlider("📏 Phạm Vi Tấn Công", 30, 120, 60, function(v)
    Settings.AttackRange = v
end)

CreateSlider("📐 Độ Cao Khi Farm", 15, 60, 35, function(v)
    Settings.FarmHeight = v
end)

CreateToggle("🔄 Kéo Quái Về", true, function(v)
    Settings.AutoBring = v
end)

CreateToggle("⚡ Fast Attack", true, function(v)
    Settings.FastAttack = v
end)

CreateToggle("💠 Tự Động Bật Haki", true, function(v)
    Settings.AutoHaki = v
end)

local LevelLabel = CreateLabel("Level: Đang cập nhật...")
local QuestLabel = CreateLabel("Quest: ---")

-- Cập nhật thông tin
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            LevelLabel:SetText("Level: " .. tostring(plr.Data.Level.Value))
            local quest = GetCurrentQuest()
            if quest then
                QuestLabel:SetText("Quest: " .. quest.Name .. " (Lv." .. tostring(plr.Data.Level.Value) .. ")")
            end
        end)
    end
end)

print("✅ Dojo Hub Auto Farm Level loaded!")
print("📊 Total Quests: " .. #QuestData)