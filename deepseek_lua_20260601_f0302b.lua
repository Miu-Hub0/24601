-- ============================================
-- LHX OBFUSCATOR GUI + MODULE - FULL INTEGRATED
-- ============================================

-- ========== MODULE OBFUSCATOR (NHÚNG TRỰC TIẾP) ==========
local Obfuscator = {}

local function splitString(str, delimiter)
    delimiter = delimiter or "\n"
    local result = {}
    if not str or type(str) ~= "string" or str == "" then return result end
    for part in string.gmatch(str, "([^" .. delimiter .. "]+)") do
        if part and part ~= "" then
            table.insert(result, part)
        end
    end
    return result
end

local function isNumber(value)
    return type(value) == "number"
end

local function isString(value)
    return type(value) == "string"
end

local function trim(str)
    if not str or type(str) ~= "string" then return "" end
    local trimmed = string.match(str, "^%s*(.-)%s*$")
    return trimmed or ""
end

local function escapeString(str)
    if not str or type(str) ~= "string" then return '""' end
    return string.format("%q", str)
end

local ENCODE_BASE = 6218
local ENCODE_MULTIPLIER = 3

function Obfuscator.encodeChar(char)
    if not char or type(char) ~= "string" or #char ~= 1 then return nil end
    local byte = string.byte(char)
    if not byte then return nil end
    return (byte * ENCODE_MULTIPLIER) + ENCODE_BASE
end

function Obfuscator.encodeString(str)
    if not str or type(str) ~= "string" or str == "" then return {} end
    local encoded = {}
    for i = 1, #str do
        local char = string.sub(str, i, i)
        local encodedChar = Obfuscator.encodeChar(char)
        if encodedChar then
            table.insert(encoded, encodedChar)
        end
    end
    return encoded
end

function Obfuscator.decodeString(encodedTable)
    if not encodedTable or type(encodedTable) ~= "table" then return "" end
    local result = ""
    for _, value in ipairs(encodedTable) do
        if isNumber(value) then
            local byte = math.floor((value - ENCODE_BASE) / ENCODE_MULTIPLIER)
            if byte >= 0 and byte <= 255 then
                result = result .. string.char(byte)
            end
        end
    end
    return result
end

function Obfuscator.makeGarbageNumber(originalNumber)
    if not isNumber(originalNumber) then
        if isString(originalNumber) then
            return escapeString(originalNumber)
        end
        return tostring(originalNumber)
    end
    local a = math.random(50000, 200000)
    local b = math.random(50000, 200000)
    local c = math.random(50000, 200000)
    return string.format("(((%d - %d) - %d) + %d)", originalNumber + a + b + c, a + b, c, originalNumber)
end

local garbagePool = {
    "!_@#$_", "ve@L8v=", "M)s%&f", "|$!L@#", "%?a@U#", "E@#3N%g", "P%.M#", "v@K#0",
    "P#<%_", "YHq;%#", "@bZa@<r", ">0Wa#2", "j%$Ri#", "%%r>e%w", "%v@R>8", "@Aw_.",
    "@C;|_", "4d%%%E", "2%a@P&S", "F6HK_", "%%V@#", "@^@&*#", ")*&k5p", "MQ#ba%",
    "C%<%u", "Y:}$K", ">a$aLg", "<x@@K", "%*kO<", "$<$~<", "Y52#%#", "|pb96>"
}

function Obfuscator.createPayloadEntry(str)
    if not str or type(str) ~= "string" or str == "" then return {} end
    local encodedNumbers = Obfuscator.encodeString(str)
    local result = {}
    for i, num in ipairs(encodedNumbers) do
        table.insert(result, num)
        if i < #encodedNumbers then
            local garbageCount = math.random(0, 2)
            for _ = 1, garbageCount do
                local garbage = garbagePool[math.random(#garbagePool)]
                if garbage then
                    table.insert(result, escapeString(garbage))
                end
            end
        end
    end
    return result
end

function Obfuscator.createPayloadEntryWithGarbageNumbers(str)
    if not str or type(str) ~= "string" or str == "" then return {} end
    local encodedNumbers = Obfuscator.encodeString(str)
    local result = {}
    for i, num in ipairs(encodedNumbers) do
        table.insert(result, Obfuscator.makeGarbageNumber(num))
        if i < #encodedNumbers then
            local garbageCount = math.random(0, 2)
            for _ = 1, garbageCount do
                local garbage = garbagePool[math.random(#garbagePool)]
                if garbage then
                    table.insert(result, escapeString(garbage))
                end
            end
        end
    end
    return result
end

function Obfuscator.generateDecoderFunction()
    return [[
local S={}
S[9]=function(t)
    local r=""
    if type(t)~="table" then return r end
    for i=1,#t do
        local v=t[i]
        if type(v)=="number" then
            local byte=math.floor((v-6218)/3)
            if byte>=0 and byte<=255 then
                r=r..string.char(byte)
            end
        elseif type(v)=="string" and #v==1 then
            r=r..v
        end
    end
    return r
end
]]
end

function Obfuscator.obfuscate(originalCode, options)
    options = options or {}
    local useGarbageNumbers = options.useGarbageNumbers == true
    
    if not originalCode or type(originalCode) ~= "string" or originalCode == "" then
        return "-- No code to obfuscate"
    end
    
    local lines = splitString(originalCode, "\n")
    local validLines = {}
    
    for _, line in ipairs(lines) do
        if line and type(line) == "string" then
            local trimmedLine = trim(line)
            if trimmedLine ~= "" then
                table.insert(validLines, line)
            end
        end
    end
    
    if #validLines == 0 then
        return "-- No valid code lines"
    end
    
    local payloadEntries = {}
    for _, line in ipairs(validLines) do
        if line and type(line) == "string" then
            local trimmedLine = trim(line)
            if trimmedLine ~= "" then
                local entry
                if useGarbageNumbers then
                    entry = Obfuscator.createPayloadEntryWithGarbageNumbers(line)
                else
                    entry = Obfuscator.createPayloadEntry(line)
                end
                if #entry > 0 then
                    table.insert(payloadEntries, entry)
                end
            end
        end
    end
    
    local decoder = Obfuscator.generateDecoderFunction()
    local payloadTable = {}
    
    for _, entry in ipairs(payloadEntries) do
        if entry and type(entry) == "table" then
            local entryStr = "S[9]({"
            for j, item in ipairs(entry) do
                if j > 1 then
                    entryStr = entryStr .. ","
                end
                if isNumber(item) then
                    entryStr = entryStr .. tostring(item)
                elseif isString(item) then
                    entryStr = entryStr .. item
                else
                    entryStr = entryStr .. escapeString(tostring(item))
                end
            end
            entryStr = entryStr .. "})"
            table.insert(payloadTable, entryStr)
        end
    end
    
    if #payloadTable == 0 then
        return "-- Failed to create payload"
    end
    
    local payloadString = table.concat(payloadTable, ",\n")
    
    local obfuscated = string.format([[
--[[ PROTECTED BY LHX PROTECT OBFUSCATOR ]]--
(function(...)
    local getfenv = getfenv or function() return _ENV or _G end
    local env = getfenv and getfenv() or _ENV or _G
    local floor = (env.math and env.math.floor) or math.floor
    local char = (env.string and env.string.char) or string.char
    local concat = (env.table and env.table.concat) or table.concat
    %s
    local Payload = {
    %s
    }
    local Result = {}
    for i = 1, #Payload do
        if Payload[i] then
            Result[i] = Payload[i]
        end
    end
    local FinalCode = concat(Result, "\n")
    local func = loadstring or load
    local compiled, errMsg = func(FinalCode)
    if compiled then
        compiled(...)
    else
        error("Failed to load obfuscated code: " .. tostring(errMsg))
    end
end)(...)
]], decoder, payloadString)

    return obfuscated
end

function Obfuscator.advancedObfuscate(originalCode, options)
    options = options or {}
    
    if not originalCode or type(originalCode) ~= "string" or originalCode == "" then
        return "-- No code to obfuscate"
    end
    
    local obfuscated = Obfuscator.obfuscate(originalCode, options)
    
    if options.addFakeControlFlow then
        local fakeVar1 = "f" .. math.random(10000, 99999)
        local fakeVar2 = "g" .. math.random(10000, 99999)
        local fakeVar3 = "h" .. math.random(10000, 99999)
        local fakeCode = string.format([[
do
    local %s = 0
    local %s = 1
    local %s = 2
    if %s < %s then
        %s = %s + %s
    end
    while %s < 10 do
        %s = %s + 1
    end
end
]], fakeVar1, fakeVar2, fakeVar3, fakeVar1, fakeVar2, fakeVar1, fakeVar1, fakeVar3, fakeVar1, fakeVar1, fakeVar1)
        obfuscated = fakeCode .. obfuscated
    end
    
    if options.addDeadCode then
        local deadCode = [[
do
    local dead = false
    if dead then
        local x = 0
        local y = 1
        for i = 1, 100 do
            x = x + i
            y = y * i
        end
    end
end
]]
        obfuscated = deadCode .. obfuscated
    end
    
    if options.renameVariables then
        local varMap = {}
        local counter = 1
        local keywords = {local=true, function=true, if=true, then=true, else=true, elseif=true,
            end=true, for=true, while=true, do=true, return=true, break=true,
            nil=true, true=true, false=true, and=true, or=true, not=true,
            in=true, repeat=true, until=true, goto=true}
        
        local renamed = obfuscated:gsub("(%a[%w_]*)", function(var)
            if keywords[var] then return var end
            if not varMap[var] then
                varMap[var] = "_v" .. counter
                counter = counter + 1
            end
            return varMap[var]
        end)
        obfuscated = renamed
    end
    
    return obfuscated
end

-- ========== GUI ==========
local GUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local InputBox = Instance.new("TextBox")
local OutputBox = Instance.new("TextBox")
local ObfuscateBtn = Instance.new("TextButton")
local CopyBtn = Instance.new("TextButton")
local DownloadBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")
local StatusBar = Instance.new("TextLabel")
local SettingsFrame = Instance.new("Frame")
local GarbageNumbersCheck = Instance.new("TextButton")
local FakeControlCheck = Instance.new("TextButton")
local DeadCodeCheck = Instance.new("TextButton")
local RenameVarsCheck = Instance.new("TextButton")

local Settings = {
    useGarbageNumbers = false,
    addFakeControlFlow = false,
    addDeadCode = false,
    renameVariables = false
}

local function updateStatus(text, isError)
    StatusBar.Text = text
    if isError then
        StatusBar.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(2.5)
        StatusBar.Text = "✅ Ready | Enter code and click OBFUSCATE"
        StatusBar.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        StatusBar.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(2)
        StatusBar.Text = "✅ Ready | Enter code and click OBFUSCATE"
        StatusBar.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

local function createToggleButton(btn, text, settingKey)
    btn.Text = text .. " ❌"
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    
    btn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        if Settings[settingKey] then
            btn.Text = text .. " ✅"
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        else
            btn.Text = text .. " ❌"
            btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end)
end

-- Setup GUI
GUI.Name = "LHXObfuscatorGUI"
GUI.Parent = game:GetService("CoreGui")
pcall(function() if syn and syn.protect_gui then syn.protect_gui(GUI) end end)

MainFrame.Parent = GUI
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -300)
MainFrame.Size = UDim2.new(0, 700, 0, 600)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "🔒 LHX PROTECT OBFUSCATOR 🔒"
Title.TextColor3 = Color3.fromRGB(255, 200, 100)
Title.TextSize = 18

local InputLabel = Instance.new("TextLabel")
InputLabel.Parent = MainFrame
InputLabel.Position = UDim2.new(0, 10, 0, 50)
InputLabel.Size = UDim2.new(0.45, -15, 0, 25)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "📝 INPUT CODE:"
InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Font = Enum.Font.GothamSemibold

local OutputLabel = Instance.new("TextLabel")
OutputLabel.Parent = MainFrame
OutputLabel.Position = UDim2.new(0.5, 10, 0, 50)
OutputLabel.Size = UDim2.new(0.45, -15, 0, 25)
OutputLabel.BackgroundTransparency = 1
OutputLabel.Text = "🔓 OUTPUT CODE:"
OutputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OutputLabel.TextXAlignment = Enum.TextXAlignment.Left
OutputLabel.Font = Enum.Font.GothamSemibold

InputBox.Parent = MainFrame
InputBox.Position = UDim2.new(0, 10, 0, 80)
InputBox.Size = UDim2.new(0.45, -15, 0, 350)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
InputBox.TextColor3 = Color3.fromRGB(200, 255, 200)
InputBox.TextSize = 12
InputBox.Font = Enum.Font.Code
InputBox.TextWrapped = true
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.ClearTextOnFocus = false
InputBox.PlaceholderText = "-- Paste your Lua code here --\n\nprint('Hello World')\nlocal a = 10\nlocal b = 20\nprint(a + b)"

OutputBox.Parent = MainFrame
OutputBox.Position = UDim2.new(0.5, 10, 0, 80)
OutputBox.Size = UDim2.new(0.45, -15, 0, 350)
OutputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
OutputBox.TextColor3 = Color3.fromRGB(200, 255, 200)
OutputBox.TextSize = 12
OutputBox.Font = Enum.Font.Code
OutputBox.TextWrapped = true
OutputBox.TextXAlignment = Enum.TextXAlignment.Left
OutputBox.TextYAlignment = Enum.TextYAlignment.Top
OutputBox.ClearTextOnFocus = false
OutputBox.PlaceholderText = "Obfuscated code will appear here..."
OutputBox.ReadOnly = true

SettingsFrame.Parent = MainFrame
SettingsFrame.Position = UDim2.new(0, 10, 0, 440)
SettingsFrame.Size = UDim2.new(1, -20, 0, 80)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SettingsFrame.BackgroundTransparency = 0.5

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Parent = SettingsFrame
SettingsTitle.Size = UDim2.new(1, 0, 0, 25)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "⚙️ OBFUSCATION SETTINGS"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
SettingsTitle.TextSize = 14
SettingsTitle.Font = Enum.Font.GothamBold

local btnY = 28
local btnWidth = 0.23

GarbageNumbersCheck.Parent = SettingsFrame
GarbageNumbersCheck.Position = UDim2.new(0.01, 0, 0, btnY)
GarbageNumbersCheck.Size = UDim2.new(btnWidth, 0, 0, 30)
GarbageNumbersCheck.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GarbageNumbersCheck.Text = "Garbage Numbers ❌"
GarbageNumbersCheck.Font = Enum.Font.GothamSemibold
GarbageNumbersCheck.TextSize = 12
createToggleButton(GarbageNumbersCheck, "Garbage Numbers", "useGarbageNumbers")

FakeControlCheck.Parent = SettingsFrame
FakeControlCheck.Position = UDim2.new(0.01 + btnWidth + 0.01, 0, 0, btnY)
FakeControlCheck.Size = UDim2.new(btnWidth, 0, 0, 30)
FakeControlCheck.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FakeControlCheck.Text = "Fake Control ❌"
FakeControlCheck.Font = Enum.Font.GothamSemibold
FakeControlCheck.TextSize = 12
createToggleButton(FakeControlCheck, "Fake Control", "addFakeControlFlow")

DeadCodeCheck.Parent = SettingsFrame
DeadCodeCheck.Position = UDim2.new(0.01 + (btnWidth + 0.01) * 2, 0, 0, btnY)
DeadCodeCheck.Size = UDim2.new(btnWidth, 0, 0, 30)
DeadCodeCheck.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
DeadCodeCheck.Text = "Dead Code ❌"
DeadCodeCheck.Font = Enum.Font.GothamSemibold
DeadCodeCheck.TextSize = 12
createToggleButton(DeadCodeCheck, "Dead Code", "addDeadCode")

RenameVarsCheck.Parent = SettingsFrame
RenameVarsCheck.Position = UDim2.new(0.01 + (btnWidth + 0.01) * 3, 0, 0, btnY)
RenameVarsCheck.Size = UDim2.new(btnWidth, 0, 0, 30)
RenameVarsCheck.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
RenameVarsCheck.Text = "Rename Vars ❌"
RenameVarsCheck.Font = Enum.Font.GothamSemibold
RenameVarsCheck.TextSize = 12
createToggleButton(RenameVarsCheck, "Rename Vars", "renameVariables")

local ButtonFrame = Instance.new("Frame")
ButtonFrame.Parent = MainFrame
ButtonFrame.Position = UDim2.new(0, 10, 0, 530)
ButtonFrame.Size = UDim2.new(1, -20, 0, 55)
ButtonFrame.BackgroundTransparency = 1

ObfuscateBtn.Parent = ButtonFrame
ObfuscateBtn.Position = UDim2.new(0, 0, 0, 0)
ObfuscateBtn.Size = UDim2.new(0.23, -5, 1, -5)
ObfuscateBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ObfuscateBtn.Text = "🔧 OBFUSCATE"
ObfuscateBtn.Font = Enum.Font.GothamBold
ObfuscateBtn.TextSize = 14
ObfuscateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

CopyBtn.Parent = ButtonFrame
CopyBtn.Position = UDim2.new(0.24, 0, 0, 0)
CopyBtn.Size = UDim2.new(0.23, -5, 1, -5)
CopyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
CopyBtn.Text = "📋 COPY"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14

DownloadBtn.Parent = ButtonFrame
DownloadBtn.Position = UDim2.new(0.48, 0, 0, 0)
DownloadBtn.Size = UDim2.new(0.23, -5, 1, -5)
DownloadBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
DownloadBtn.Text = "💾 DOWNLOAD"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14

ClearBtn.Parent = ButtonFrame
ClearBtn.Position = UDim2.new(0.72, 0, 0, 0)
ClearBtn.Size = UDim2.new(0.28, -5, 1, -5)
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ClearBtn.Text = "🗑️ CLEAR ALL"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 14

StatusBar.Parent = MainFrame
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusBar.Text = "✅ Ready | Enter your code and click OBFUSCATE"
StatusBar.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusBar.TextSize = 11

local function copyToClipboard(text)
    if text == "" or text == OutputBox.PlaceholderText then
        updateStatus("⚠️ Nothing to copy!", true)
        return
    end
    local success = pcall(function()
        if setclipboard then setclipboard(text)
        elseif toclipboard then toclipboard(text)
        elseif Clipboard then Clipboard.set(text)
        else error("No clipboard") end
    end)
    if success then updateStatus("📋 Copied! (" .. #text .. " chars)")
    else updateStatus("❌ Copy failed", true) end
end

local function downloadFile(content)
    if content == "" or content == OutputBox.PlaceholderText then
        updateStatus("⚠️ Nothing to download!", true)
        return
    end
    local success = pcall(function()
        local name = "obfuscated_" .. os.time() .. ".lua"
        if writefile then writefile(name, content)
        elseif syn and syn.write_file then syn.write_file(name, content)
        else error("No writefile") end
        updateStatus("💾 Saved as: " .. name)
    end)
    if not success then
        updateStatus("❌ Download failed, trying clipboard", true)
        copyToClipboard(content)
    end
end

local function obfuscateCode()
    local input = InputBox.Text
    if input == "" or input == InputBox.PlaceholderText then
        updateStatus("❌ Please enter code!", true)
        return
    end
    
    updateStatus("🔒 Obfuscating...")
    
    local success, result = pcall(function()
        local opts = {
            useGarbageNumbers = Settings.useGarbageNumbers,
            addFakeControlFlow = Settings.addFakeControlFlow,
            addDeadCode = Settings.addDeadCode,
            renameVariables = Settings.renameVariables
        }
        
        if opts.addFakeControlFlow or opts.addDeadCode or opts.renameVariables then
            return Obfuscator.advancedObfuscate(input, opts)
        else
            return Obfuscator.obfuscate(input, opts)
        end
    end)
    
    if success and result and #result > 10 then
        OutputBox.Text = result
        updateStatus("✅ Success! (" .. #result .. " chars)")
    else
        OutputBox.Text = "-- OBFUSCATION FAILED --\n-- Error: " .. tostring(result)
        updateStatus("❌ Failed: " .. tostring(result), true)
    end
end

local function clearAll()
    InputBox.Text = ""
    OutputBox.Text = ""
    updateStatus("🗑️ Cleared all")
end

ObfuscateBtn.MouseButton1Click:Connect(obfuscateCode)
CopyBtn.MouseButton1Click:Connect(function() copyToClipboard(OutputBox.Text) end)
DownloadBtn.MouseButton1Click:Connect(function() downloadFile(OutputBox.Text) end)
ClearBtn.MouseButton1Click:Connect(clearAll)

print("✅ LHX Obfuscator GUI Loaded Successfully!")