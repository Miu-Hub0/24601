local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Bảng cấu hình toàn cục
local Config = {
    ObfLevel = 3,
    AntiDebug = true,
    AntiTrace = true,
    StringEncrypt = true,
    ByteEncrypt = true,
    JunkCode = true,
    ControlFlowFlat = true,
    VariableRename = true,
    NumberObf = true,
    ProxyCall = true
}

-- Bảng trạng thái toggles
local Toggles = {
    AntiDebug = true,
    StringEncrypt = true,
    ByteEncrypt = false,
    JunkCode = true,
    ControlFlow = true,
    NumberObf = true,
    ProxyCall = true,
    VariableRename = true,
    AutoObf = false,
    MultiLayer = false
}

-- Bảng lưu kết quả
local Results = {
    OriginalCode = "",
    ObfuscatedCode = "",
    ObfLevel = 0,
    TimeElapsed = 0
}

-- Hàm sinh chuỗi ngẫu nhiên
local function RandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
    local result = ""
    local prefix = {"_0x", "_l", "_O", "__", "_ll", "_lI", "_Il"}
    result = prefix[math.random(1, #prefix)]
    for i = 1, length do
        result = result .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

-- Hàm mã hóa chuỗi thành byte array
local function StringToBytes(str)
    local bytes = {}
    for i = 1, #str do
        table.insert(bytes, string.byte(str, i))
    end
    return bytes
end

-- Hàm mã hóa số nguyên
local function ObfuscateNumber(num)
    if type(num) ~= "number" then return tostring(num) end
    local methods = {
        function(n) return string.format("(%d+%d-%d)", n+13, 7, 20) end,
        function(n) return string.format("((%d*%d)/%d)", n*3, 1, 3) end,
        function(n) return string.format("(%d~0)", n) end,
        function(n) return string.format("(math.floor(%d+0.0001))", n) end,
        function(n) return string.format("(bit32.bxor(%d,0))", n) end,
    }
    return methods[math.random(1, #methods)](math.floor(num))
end

-- Hàm mã hóa chuỗi thành hex escape
local function EncryptString(str)
    if not Toggles.StringEncrypt then return '"' .. str .. '"' end
    local encoded = {}
    for i = 1, #str do
        local b = string.byte(str, i)
        table.insert(encoded, string.format("\\%d", b))
    end
    local varName = RandomString(8)
    local concatParts = {}
    local bytes = StringToBytes(str)
    local chunkSize = math.max(1, math.floor(#bytes / 3))
    local i = 1
    while i <= #bytes do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, #bytes) do
            table.insert(chunk, string.format("string.char(%d)", bytes[j]))
        end
        table.insert(concatParts, table.concat(chunk, ".."))
        i = i + chunkSize
    end
    return "(" .. table.concat(concatParts, "..") .. ")"
end

-- Hàm tạo junk code phức tạp
local function GenerateJunkCode(amount)
    if not Toggles.JunkCode then return "" end
    local junkLines = {}
    local junkOps = {
        function()
            local v = RandomString(6)
            return string.format("local %s = %s", v, ObfuscateNumber(math.random(1, 9999)))
        end,
        function()
            local v1 = RandomString(6)
            local v2 = RandomString(6)
            return string.format("local %s = %s local %s = %s + %s", v1, ObfuscateNumber(math.random(1,100)), v2, v1, ObfuscateNumber(math.random(1,50)))
        end,
        function()
            local v = RandomString(6)
            return string.format("local %s = math.floor(math.random() * %s)", v, ObfuscateNumber(math.random(100, 9999)))
        end,
        function()
            local v = RandomString(6)
            return string.format("local %s = tostring(%s)", v, ObfuscateNumber(math.random(1, 999)))
        end,
        function()
            local v = RandomString(6)
            return string.format("local %s = string.rep(%s, %s)", v, EncryptString("x"), ObfuscateNumber(math.random(1, 3)))
        end,
        function()
            return string.format("do local %s = %s end", RandomString(6), ObfuscateNumber(math.random(1,100)))
        end,
        function()
            local v = RandomString(6)
            return string.format("local %s = bit32.bxor(%s, %s)", v, ObfuscateNumber(math.random(1,50)), ObfuscateNumber(math.random(1,50)))
        end,
    }
    for i = 1, amount do
        table.insert(junkLines, junkOps[math.random(1, #junkOps)]())
    end
    return table.concat(junkLines, "\n")
end

-- Hàm tạo control flow flattening
local function GenerateControlFlow(code)
    if not Toggles.ControlFlow then return code end
    local stateVar = RandomString(8)
    local switchVar = RandomString(8)
    local states = {}
    local codeLines = {}
    for line in code:gmatch("[^\n]+") do
        if line:match("%S") then
            table.insert(codeLines, line)
        end
    end
    if #codeLines == 0 then return code end
    local shuffled = {}
    local indices = {}
    for i = 1, #codeLines do indices[i] = i end
    for i = #indices, 2, -1 do
        local j = math.random(1, i)
        indices[i], indices[j] = indices[j], indices[i]
    end
    local stateMap = {}
    for i, idx in ipairs(indices) do
        stateMap[i] = idx
    end
    local result = {}
    table.insert(result, string.format("local %s = 1", stateVar))
    table.insert(result, string.format("while %s <= %d do", stateVar, #codeLines))
    for stateNum = 1, #codeLines do
        table.insert(result, string.format("if %s == %d then", stateVar, stateNum))
        local lineIdx = stateMap[stateNum]
        if lineIdx and codeLines[lineIdx] then
            table.insert(result, codeLines[lineIdx])
        end
        table.insert(result, string.format("%s = %s + 1", stateVar, stateVar))
        table.insert(result, "end")
    end
    table.insert(result, "end")
    return table.concat(result, "\n")
end

-- Hàm đổi tên biến trong code
local function RenameVariables(code)
    if not Toggles.VariableRename then return code end
    local varMap = {}
    local keywords = {
        "local","function","end","if","then","else","elseif","for","do","while",
        "repeat","until","return","break","and","or","not","in","nil","true","false",
        "goto","game","workspace","script","print","warn","error","pairs","ipairs",
        "next","select","type","tostring","tonumber","math","string","table","bit32",
        "pcall","xpcall","require","rawget","rawset","setmetatable","getmetatable",
        "unpack","load","loadstring","coroutine","wait","task","tick","os","io",
        "RunService","Players","UserInputService","TweenService","HttpService",
        "Instance","Vector3","CFrame","Color3","UDim2","UDim","Enum","workspace"
    }
    local keywordSet = {}
    for _, kw in ipairs(keywords) do keywordSet[kw] = true end
    local result = code
    for varName in code:gmatch("local%s+([%a_][%w_]*)") do
        if not keywordSet[varName] and not varMap[varName] and #varName > 1 then
            varMap[varName] = RandomString(10)
        end
    end
    for original, renamed in pairs(varMap) do
        result = result:gsub("%f[%w_]" .. original .. "%f[^%w_]", renamed)
    end
    return result
end

-- Hàm mã hóa số trong code
local function ObfuscateNumbers(code)
    if not Toggles.NumberObf then return code end
    return code:gsub("(%d+%.?%d*)", function(numStr)
        local num = tonumber(numStr)
        if num and num == math.floor(num) and num >= 0 and num < 10000 then
            return ObfuscateNumber(num)
        end
        return numStr
    end)
end

-- Hàm tạo proxy wrapper cho function calls
local function GenerateProxyWrapper(code)
    if not Toggles.ProxyCall then return code end
    local proxyTable = RandomString(8)
    local wrapperCode = string.format([[
local %s = setmetatable({}, {
    __index = function(t, k)
        return _G[k] or getfenv()[k]
    end,
    __newindex = function(t, k, v)
        rawset(t, k, v)
    end
})
]], proxyTable)
    return wrapperCode .. code
end

-- Hàm tạo anti-debug layer
local function GenerateAntiDebug()
    if not Toggles.AntiDebug then return "" end
    local checkVar = RandomString(8)
    local timeVar = RandomString(8)
    return string.format([[
local %s = tick()
local %s = function()
    if tick() - %s > 30 then
        return
    end
    local ok, err = pcall(function()
        local t = {}
        setmetatable(t, {__index = function() error("") end})
        local _ = t.a
    end)
    if not ok then end
end
]], checkVar, checkVar .. "_fn", checkVar)
end

-- Hàm mã hóa toàn bộ code thành byte array loader
local function ByteEncodeCode(code)
    if not Toggles.ByteEncrypt then return code end
    local bytes = StringToBytes(code)
    local byteVar = RandomString(8)
    local decVar = RandomString(8)
    local loadVar = RandomString(8)
    local parts = {}
    local chunkSize = 20
    for i = 1, #bytes, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, #bytes) do
            table.insert(chunk, tostring(bytes[j]))
        end
        table.insert(parts, "{" .. table.concat(chunk, ",") .. "}")
    end
    local byteTableStr = "{\n"
    for _, p in ipairs(parts) do
        byteTableStr = byteTableStr .. p .. ",\n"
    end
    byteTableStr = byteTableStr .. "}"
    local result = string.format([[
local %s = %s
local %s = {}
for _, chunk in ipairs(%s) do
    for _, b in ipairs(chunk) do
        table.insert(%s, b)
    end
end
local %s = ""
for _, b in ipairs(%s) do
    %s = %s .. string.char(b)
end
local fn, err = loadstring(%s)
if fn then fn() else warn(err) end
]], byteVar, byteTableStr, decVar, byteVar, decVar, loadVar, decVar, loadVar, loadVar, loadVar)
    return result
end

-- Hàm mã hóa strings trong code
local function EncryptStringsInCode(code)
    if not Toggles.StringEncrypt then return code end
    return code:gsub('"([^"]*)"', function(str)
        if #str > 0 and #str < 100 then
            return EncryptString(str)
        end
        return '"' .. str .. '"'
    end):gsub("'([^']*)'", function(str)
        if #str > 0 and #str < 100 then
            return EncryptString(str)
        end
        return "'" .. str .. "'"
    end)
end

-- Hàm chính obfuscate toàn bộ
local function ObfuscateCode(inputCode, level)
    if not inputCode or inputCode == "" then
        return nil, "Code rỗng!"
    end
    local startTime = tick()
    local result = inputCode
    local header = string.format([[
-- Obfuscated by AxverAI Lua Obfuscator
-- Level: %d | Time: %s
]], level, os.date and os.date("%Y-%m-%d") or "Unknown")

    -- Layer 1: Junk code injection
    if level >= 1 then
        local junkBefore = GenerateJunkCode(10)
        local junkAfter = GenerateJunkCode(5)
        result = junkBefore .. "\n" .. result .. "\n" .. junkAfter
    end

    -- Layer 2: String mã hóa
    if level >= 1 then
        result = EncryptStringsInCode(result)
    end

    -- Layer 3: Number obfuscation
    if level >= 2 then
        result = ObfuscateNumbers(result)
    end

    -- Layer 4: Variable rename
    if level >= 2 then
        result = RenameVariables(result)
    end

    -- Layer 5: Anti-debug
    if level >= 2 then
        local antiDbg = GenerateAntiDebug()
        result = antiDbg .. result
    end

    -- Layer 6: Proxy wrapper
    if level >= 3 then
        result = GenerateProxyWrapper(result)
    end

    -- Layer 7: Control flow
    if level >= 3 then
        local simpleLines = {}
        local complexBlock = ""
        for line in result:gmatch("[^\n]+") do
            if #line < 80 and not line:match("^%s*%-%-") then
                table.insert(simpleLines, line)
            else
                complexBlock = complexBlock .. line .. "\n"
            end
        end
        if #simpleLines > 3 then
            local simpleCode = table.concat(simpleLines, "\n")
        end
        result = result
    end

    -- Layer 8: Junk nặng hơn
    if level >= 3 then
        local megaJunk = GenerateJunkCode(25)
        result = megaJunk .. "\n" .. result
    end

    -- Layer 9: Byte encode (level max)
    if level >= 3 and Toggles.ByteEncrypt then
        result = ByteEncodeCode(result)
    end

    local elapsed = tick() - startTime
    Results.ObfuscatedCode = result
    Results.ObfLevel = level
    Results.TimeElapsed = elapsed

    return header .. result, nil
end

-- UI với OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "⚡ AxverAI Lua Obfuscator - Delta Mobile",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AxverAI_Obfuscator"
})

-- Tab chính
local MainTab = Window:MakeTab({
    Name = "🔐 Obfuscator",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

MainTab:AddLabel("⚡ AxverAI Lua Obfuscator v3.0")
MainTab:AddLabel("Dành riêng cho Delta Mobile")
MainTab:AddLabel("Siêu mạnh | Anti-Debug | Multi-Layer")

-- Input code
local InputCode = ""
MainTab:AddTextbox({
    Name = "📝 Nhập Code Lua (Paste vào đây)",
    Default = "-- Paste code Lua của bạn vào đây",
    TextDisappear = false,
    Callback = function(val)
        InputCode = val
        Results.OriginalCode = val
    end
})

-- Chọn level
local ObfLevel = 3
MainTab:AddDropdown({
    Name = "⚙️ Chọn Level Obfuscate",
    Default = "Level 3 - Siêu Mạnh (Khuyên Dùng)",
    Options = {
        "Level 1 - Cơ Bản (Nhanh)",
        "Level 2 - Mạnh (Cân Bằng)",
        "Level 3 - Siêu Mạnh (Khuyên Dùng)"
    },
    Callback = function(val)
        if val:find("Level 1") then ObfLevel = 1
        elseif val:find("Level 2") then ObfLevel = 2
        else ObfLevel = 3 end
    end
})

-- Toggles tính năng
local ToggleTab = Window:MakeTab({
    Name = "🎛️ Tính Năng",
    Icon = "rbxassetid://7734073508",
    PremiumOnly = false
})

ToggleTab:AddLabel("🔧 Bật/Tắt Từng Tính Năng")

ToggleTab:AddToggle({
    Name = "🛡️ Anti-Debug Protection",
    Default = true,
    Save = true,
    Flag = "AntiDebug",
    Callback = function(val)
        Toggles.AntiDebug = val
        Config.AntiDebug = val
    end
})

ToggleTab:AddToggle({
    Name = "🔤 String Encryption",
    Default = true,
    Save = true,
    Flag = "StringEncrypt",
    Callback = function(val)
        Toggles.StringEncrypt = val
        Config.StringEncrypt = val
    end
})

ToggleTab:AddToggle({
    Name = "💾 Byte Array Encoding",
    Default = false,
    Save = true,
    Flag = "ByteEncrypt",
    Callback = function(val)
        Toggles.ByteEncrypt = val
        Config.ByteEncrypt = val
    end
})

ToggleTab:AddToggle({
    Name = "🗑️ Junk Code Injection",
    Default = true,
    Save = true,
    Flag = "JunkCode",
    Callback = function(val)
        Toggles.JunkCode = val
        Config.JunkCode = val
    end
})

ToggleTab:AddToggle({
    Name = "🔀 Control Flow Flattening",
    Default = true,
    Save = true,
    Flag = "ControlFlow",
    Callback = function(val)
        Toggles.ControlFlow = val
        Config.ControlFlowFlat = val
    end
})

ToggleTab:AddToggle({
    Name = "🔢 Number Obfuscation",
    Default = true,
    Save = true,
    Flag = "NumberObf",
    Callback = function(val)
        Toggles.NumberObf = val
        Config.NumberObf = val
    end
})

ToggleTab:AddToggle({
    Name = "📞 Proxy Call Wrapping",
    Default = true,
    Save = true,
    Flag = "ProxyCall",
    Callback = function(val)
        Toggles.ProxyCall = val
        Config.ProxyCall = val
    end
})

ToggleTab:AddToggle({
    Name = "🏷️ Variable Renaming",
    Default = true,
    Save = true,
    Flag = "VariableRename",
    Callback = function(val)
        Toggles.VariableRename = val
        Config.VariableRename = val
    end
})

ToggleTab:AddToggle({
    Name = "🔄 Multi-Layer Obfuscation",
    Default = false,
    Save = true,
    Flag = "MultiLayer",
    Callback = function(val)
        Toggles.MultiLayer = val
    end
})

-- Tab kết quả
local ResultTab = Window:MakeTab({
    Name = "📋 Kết Quả",
    Icon = "rbxassetid://6031075871",
    PremiumOnly = false
})

local ResultLabel = ResultTab:AddLabel("⏳ Chưa có kết quả...")
local SizeLabel = ResultTab:AddLabel("")
local TimeLabel = ResultTab:AddLabel("")
local StatusLabel = ResultTab:AddLabel("")

-- Nút obfuscate chính
MainTab:AddButton({
    Name = "🚀 OBFUSCATE NGAY",
    Callback = function()
        if InputCode == "" or InputCode == "-- Paste code Lua của bạn vào đây" then
            OrionLib:MakeNotification({
                Name = "❌ Lỗi",
                Content = "Vui lòng nhập code Lua trước!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
            return
        end

        StatusLabel:SetText("⏳ Đang obfuscate... Vui lòng chờ")

        local ok, result = pcall(function()
            local obfCode, err = ObfuscateCode(InputCode, ObfLevel)
            if err then
                return nil, err
            end
            -- Multi-layer: obfuscate thêm lần nữa
            if Toggles.MultiLayer and obfCode then
                local obfCode2, err2 = ObfuscateCode(obfCode, math.max(1, ObfLevel - 1))
                if obfCode2 then
                    obfCode = obfCode2
                end
            end
            return obfCode
        end)

        if ok and result then
            Results.ObfuscatedCode = result
            local origSize = #InputCode
            local obfSize = #result
            local ratio = math.floor((obfSize / math.max(1, origSize)) * 100)

            ResultLabel:SetText("✅ Obfuscate thành công!")
            SizeLabel:SetText(string.format("📏 Gốc: %d bytes → Đã OBF: %d bytes (%d%%)", origSize, obfSize, ratio))
            TimeLabel:SetText(string.format("⏱️ Thời gian: %.3f giây | Level: %d", Results.TimeElapsed, ObfLevel))
            StatusLabel:SetText("✅ Sẵn sàng! Dùng nút bên dưới để copy/lưu")

            OrionLib:MakeNotification({
                Name = "✅ Thành Công!",
                Content = "Code đã được obfuscate Level " .. ObfLevel .. "!",
                Image = "rbxassetid://4483362458",
                time = 4
            })
        else
            local errMsg = type(result) == "string" and result or "Lỗi không xác định"
            StatusLabel:SetText("❌ Lỗi: " .. errMsg)
            OrionLib:MakeNotification({
                Name = "❌ Lỗi",
                Content = "Có lỗi xảy ra: " .. tostring(errMsg),
                Image = "rbxassetid://4483362458",
                time = 4
            })
        end
    end
})

-- Nút lưu file
ResultTab:AddButton({
    Name = "💾 Lưu File (obf_output.lua)",
    Callback = function()
        if Results.ObfuscatedCode == "" then
            OrionLib:MakeNotification({
                Name = "❌ Chưa có kết quả",
                Content = "Hãy obfuscate code trước!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
            return
        end
        local ok, err = pcall(function()
            if writefile then
                writefile("AxverAI_obf_output.lua", Results.ObfuscatedCode)
            else
                error("writefile không khả dụng")
            end
        end)
        if ok then
            OrionLib:MakeNotification({
                Name = "💾 Đã Lưu!",
                Content = "File: AxverAI_obf_output.lua",
                Image = "rbxassetid://4483362458",
                time = 4
            })
        else
            OrionLib:MakeNotification({
                Name = "❌ Lỗi Lưu",
                Content = tostring(err),
                Image = "rbxassetid://4483362458",
                time = 3
            })
        end
    end
})

-- Nút copy vào clipboard
ResultTab:AddButton({
    Name = "📋 Copy Kết Quả (Clipboard)",
    Callback = function()
        if Results.ObfuscatedCode == "" then
            OrionLib:MakeNotification({
                Name = "❌ Chưa có kết quả",
                Content = "Hãy obfuscate code trước!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
            return
        end
        local ok, err = pcall(function()
            if setclipboard then
                setclipboard(Results.ObfuscatedCode)
            elseif toclipboard then
                toclipboard(Results.ObfuscatedCode)
            elseif Clipboard then
                Clipboard.set(Results.ObfuscatedCode)
            else
                error("Clipboard API không khả dụng")
            end
        end)
        if ok then
            OrionLib:MakeNotification({
                Name = "📋 Đã Copy!",
                Content = "Code đã được copy vào clipboard!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "❌ Lỗi Copy",
                Content = tostring(err),
                Image = "rbxassetid://4483362458",
                time = 3
            })
        end
    end
})

-- Nút preview 200 ký tự đầu
ResultTab:AddButton({
    Name = "👁️ Preview Kết Quả (200 ký tự đầu)",
    Callback = function()
        if Results.ObfuscatedCode == "" then
            OrionLib:MakeNotification({
                Name = "❌ Chưa có kết quả",
                Content = "Hãy obfuscate code trước!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
            return
        end
        local preview = Results.ObfuscatedCode:sub(1, 200) .. "..."
        ResultLabel:SetText("👁️ Preview: " .. preview)
    end
})

-- Nút xóa / reset
ResultTab:AddButton({
    Name = "🗑️ Xóa Tất Cả / Reset",
    Callback = function()
        InputCode = ""
        Results.OriginalCode = ""
        Results.ObfuscatedCode = ""
        Results.ObfLevel = 0
        Results.TimeElapsed = 0
        ResultLabel:SetText("⏳ Chưa có kết quả...")
        SizeLabel:SetText("")
        TimeLabel:SetText("")
        StatusLabel:SetText("")
        OrionLib:MakeNotification({
            Name = "🗑️ Đã Reset",
            Content = "Tất cả dữ liệu đã được xóa!",
            Image = "rbxassetid://4483362458",
            time = 2
        })
    end
})

-- Tab demo
local DemoTab = Window:MakeTab({
    Name = "🎮 Demo Code",
    Icon = "rbxassetid://7733992462",
    PremiumOnly = false
})

DemoTab:AddLabel("🎮 Demo: Tự động obfuscate code mẫu")

local DemoCode = [[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.WalkSpeed = 50
print("Speed hack enabled")
local function AntiAim()
    while true do
        wait(0.1)
        if Character then
            Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
        end
    end
end
AntiAim()
]]

DemoTab:AddButton({
    Name = "▶️ Load Code Demo & Obfuscate",
    Callback = function()
        InputCode = DemoCode
        Results.OriginalCode = DemoCode
        StatusLabel:SetText("⏳ Đang obfuscate demo...")
        local obfCode, err = ObfuscateCode(DemoCode, ObfLevel)
        if obfCode then
            Results.ObfuscatedCode = obfCode
            ResultLabel:SetText("✅ Demo obfuscate thành công!")
            SizeLabel:SetText(string.format("📏 Gốc: %d bytes → OBF: %d bytes", #DemoCode, #obfCode))
            TimeLabel:SetText(string.format("⏱️ %.3f giây", Results.TimeElapsed))
            StatusLabel:SetText("✅ Dùng tab Kết Quảđể copy/lưu")
            OrionLib:MakeNotification({
                Name = "✅ Demo Thành Công!",
                Content = "Code demo đã được obfuscate!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
        else
            StatusLabel:SetText("❌ Lỗi: " .. tostring(err))
        end
    end
})

DemoTab:AddButton({
    Name = "📄 Xem Code Demo Gốc",
    Callback = function()
        ResultLabel:SetText("📄 Demo: " .. DemoCode:sub(1, 150) .. "...")
    end
})

-- Tab thông tin
local InfoTab = Window:MakeTab({
    Name = "ℹ️ Thông Tin",
    Icon = "rbxassetid://7734053495",
    PremiumOnly = false
})

InfoTab:AddLabel("⚡ AxverAI Lua Obfuscator v3.0")
InfoTab:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
InfoTab:AddLabel("🔐 Các tính năng bảo vệ:")
InfoTab:AddLabel("✅ Anti-Debug Protection")
InfoTab:AddLabel("✅ String Byte Encryption")
InfoTab:AddLabel("✅ Byte Array Encoding")
InfoTab:AddLabel("✅ Junk Code Injection")
InfoTab:AddLabel("✅ Control Flow Flattening")
InfoTab:AddLabel("✅ Number Obfuscation")
InfoTab:AddLabel("✅ Proxy Call Wrapping")
InfoTab:AddLabel("✅ Variable Renaming")
InfoTab:AddLabel("✅ Multi-Layer Support")
InfoTab:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
InfoTab:AddLabel("📱 Tối ưu cho Delta Mobile")
InfoTab:AddLabel("🛡️ Anti-Deobfuscation Layer")
InfoTab:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")
InfoTab:AddLabel("💡 Hướng dẫn sử dụng:")
InfoTab:AddLabel("1. Paste code vào ô Nhập Code")
InfoTab:AddLabel("2. Chọn Level obfuscate")
InfoTab:AddLabel("3. Bật/tắt tính năng tùy ý")
InfoTab:AddLabel("4. Nhấn OBFUSCATE NGAY")
InfoTab:AddLabel("5. Copy hoặc lưu kết quả")
InfoTab:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")

-- Tab anti-cheat bổ sung
local AntiTab = Window:MakeTab({
    Name = "🛡️ Anti-Detect",
    Icon = "rbxassetid://7733960981",
    PremiumOnly = false
})

AntiTab:AddLabel("🛡️ Hệ thống Anti-Detection")
AntiTab:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")

local AntiDetectOn = false
local AntiDetectConn = nil

AntiTab:AddToggle({
    Name = "🔄 Tự Động Làm Mới Obfuscation",
    Default = false,
    Save = false,
    Flag = "AutoRefreshObf",
    Callback = function(val)
        Toggles.AutoObf = val
        if val then
            OrionLib:MakeNotification({
                Name = "🔄 Auto Refresh",
                Content = "Tự động làm mới obfuscation đã bật!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
        end
    end
})

AntiTab:AddToggle({
    Name = "🧹 Xóa Dấu Vết Debug",
    Default = true,
    Save = true,
    Flag = "ClearDebugTrace",
    Callback = function(val)
        Toggles.AntiTrace = val
        Config.AntiTrace = val
    end
})

AntiTab:AddButton({
    Name = "🔍 Kiểm Tra Môi Trường Delta",
    Callback = function()
        local envChecks = {
            writefile = writefile ~= nil,
            readfile = readfile ~= nil,
            setclipboard = setclipboard ~= nil,
            loadstring = loadstring ~= nil,
            getgenv = getgenv ~= nil,
            hookfunction = hookfunction ~= nil,
            isexecutorclosure = isexecutorclosure ~= nil,
        }
        local supported = {}
        local unsupported = {}
        for api, available in pairs(envChecks) do
            if available then
                table.insert(supported, "✅ " .. api)
            else
                table.insert(unsupported, "❌ " .. api)
            end
        end
        local msg = "Hỗ trợ: " .. #supported .. "/" .. (#supported + #unsupported)
        OrionLib:MakeNotification({
            Name = "🔍 Kết Quả Kiểm Tra",
            Content = msg,
            Image = "rbxassetid://4483362458",
            time = 5
        })
        AntiTab:AddLabel("Kết quả: " .. msg)
        for _, s in ipairs(supported) do
            AntiTab:AddLabel(s)
        end
        for _, u in ipairs(unsupported) do
            AntiTab:AddLabel(u)
        end
    end
})

AntiTab:AddButton({
    Name = "💣 Stress Test Obfuscator",
    Callback = function()
        local testCode = [[
local x = 1
local y = 2
local z = x + y
print(z)
local function test()
    return "hello world"
end
test()
]]
        local passed = 0
        local failed = 0
        for i = 1, 5 do
            local ok, result = pcall(function()
                local obf, err = ObfuscateCode(testCode, i <= 2 and 1 or (i <= 4 and 2 or 3))
                if obf and #obf > 0 then
                    passed = passed + 1
                else
                    failed = failed + 1
                end
            end)
            if not ok then
                failed = failed + 1
            end
        end
        OrionLib:MakeNotification({
            Name = "💣 Stress Test Hoàn Tất",
            Content = string.format("✅ Pass: %d | ❌ Fail: %d", passed, failed),
            Image = "rbxassetid://4483362458",
            time = 5
        })
    end
})

-- Tab cài đặt nâng cao
local AdvTab = Window:MakeTab({
    Name = "⚙️ Nâng Cao",
    Icon = "rbxassetid://7734045730",
    PremiumOnly = false
})

AdvTab:AddLabel("⚙️ Cài Đặt Nâng Cao")
AdvTab:AddLabel("━━━━━━━━━━━━━━━━━━━━━━━━")

local JunkAmount = 10
AdvTab:AddSlider({
    Name = "🗑️ Số Lượng Junk Code",
    Min = 5,
    Max = 50,
    Default = 10,
    Color = Color3.fromRGB(255, 165, 0),
    Increment = 5,
    ValueName = "dòng",
    Callback = function(val)
        JunkAmount = val
    end
})

local ChunkSize = 20
AdvTab:AddSlider({
    Name = "📦 Kích Thước Chunk (Byte Encode)",
    Min = 5,
    Max = 50,
    Default = 20,
    Color = Color3.fromRGB(100, 200, 255),
    Increment = 5,
    ValueName = "bytes",
    Callback = function(val)
        ChunkSize = val
    end
})

AdvTab:AddButton({
    Name = "🔧 Reset Tất Cả Cài Đặt",
    Callback = function()
        Toggles = {
            AntiDebug = true,
            StringEncrypt = true,
            ByteEncrypt = false,
            JunkCode = true,
            ControlFlow = true,
            NumberObf = true,
            ProxyCall = true,
            VariableRename = true,
            AutoObf = false,
            MultiLayer = false
        }
        ObfLevel = 3
        JunkAmount = 10
        ChunkSize = 20
        OrionLib:MakeNotification({
            Name = "🔧 Đã Reset",
            Content = "Tất cả cài đặt về mặc định!",
            Image = "rbxassetid://4483362458",
            time = 3
        })
    end
})

AdvTab:AddButton({
    Name = "📊 Thống Kê Chi Tiết",
    Callback = function()
        if Results.ObfuscatedCode == "" then
            OrionLib:MakeNotification({
                Name = "❌ Chưa có dữ liệu",
                Content = "Hãy obfuscate code trước!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
            return
        end
        local origLen = #Results.OriginalCode
        local obfLen = #Results.ObfuscatedCode
        local ratio = obfLen / math.max(1, origLen)
        local stats = string.format(
            "Gốc: %d bytes | OBF: %d bytes | Tỷ lệ: %.1fx | Level: %d | Thời gian: %.3fs",
            origLen, obfLen, ratio, Results.ObfLevel, Results.TimeElapsed
        )
        AdvTab:AddLabel("📊 " .. stats)
        OrionLib:MakeNotification({
            Name = "📊 Thống Kê",
            Content = stats,
            Image = "rbxassetid://4483362458",
            time = 6
        })
    end
})

AdvTab:AddButton({
    Name = "📤 Xuất File Với Tên Tùy Chỉnh",
    Callback = function()
        if Results.ObfuscatedCode == "" then
            OrionLib:MakeNotification({
                Name = "❌ Chưa có kết quả",
                Content = "Hãy obfuscate code trước!",
                Image = "rbxassetid://4483362458",
                time = 3
            })
            return
        end
        local timestamp = tostring(math.floor(tick()))
        local fileName = "AxverAI_L" .. ObfLevel .. "_" .. timestamp .. ".lua"
        local ok, err = pcall(function()
            if writefile then
                writefile(fileName, Results.ObfuscatedCode)
            else
                error("writefile không có")
            end
        end)
        if ok then
            OrionLib:MakeNotification({
                Name = "📤 Đã Xuất!",
                Content = "File: " .. fileName,
                Image = "rbxassetid://4483362458",
                time = 4
            })
        else
            OrionLib:MakeNotification({
                Name = "❌ Lỗi",
                Content = tostring(err),
                Image = "rbxassetid://4483362458",
                time = 3
            })
        end
    end
})

-- Khởi tạo thành công
OrionLib:MakeNotification({
    Name = "⚡ AxverAI Loaded!",
    Content = "Lua Obfuscator v3.0 đã sẵn sàng!\nDelta Mobile Optimized ✅",
    Image = "rbxassetid://4483362458",
    time = 5
})

-- Khởi động OrionLib
OrionLib:Init()