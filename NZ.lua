--// NZ MULTI GAME HUB v2.1
--// Intro Delay • Key System • Webhook Logger • Full Menus

------------------------
-- ANTI DOUBLE EXEC
------------------------
if getgenv().NZ_MULTI_HUB then return end
getgenv().NZ_MULTI_HUB = true

------------------------
-- SERVICES
------------------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

------------------------
-- CONFIG
------------------------
local KEY = "NZteam"
local WEBHOOK = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk"
local START_TIME = os.time()
local USED_FUNCTIONS = {}

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
-- WEBHOOK LOGGER
------------------------
local function SendWebhook(action)
    table.insert(USED_FUNCTIONS, action)

    local elapsed = os.time() - START_TIME
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60

    local data = {
        embeds = {{
            title = "🚀 NZ MULTI HUB EXECUTION",
            color = 11141290,
            fields = {
                {name="👤 Player", value=LP.Name, inline=true},
                {name="🆔 UserId", value=tostring(LP.UserId), inline=true},
                {name="🔗 Profile", value="https://www.roblox.com/users/"..LP.UserId.."/profile", inline=false},
                {name="🎮 Game", value=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline=false},
                {name="⚙️ Action", value=action, inline=false},
                {name="⏱️ Time Using Script",
                 value=string.format("%02dh %02dm %02ds",hours,minutes,seconds),
                 inline=false},
                {name="📜 Used Functions",
                 value=table.concat(USED_FUNCTIONS,"\n"),
                 inline=false}
            },
            footer = {text="NZ Team | Script Hub"},
            timestamp = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        HttpService:RequestAsync({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

------------------------
-- KEY SYSTEM
------------------------
local function RequestKey()
    local result = ""
    local gui = Instance.new("ScreenGui",game.CoreGui)
    gui.Name = "NZ_KEY"

    local box = Instance.new("TextBox",gui)
    box.Size = UDim2.fromOffset(260,50)
    box.Position = UDim2.new(.5,-130,.5,-25)
    box.PlaceholderText = "Enter Key"
    box.Text = ""
    box.Font = Enum.Font.GothamBold
    box.TextSize = 18

    box.FocusLost:Wait()
    result = box.Text
    gui:Destroy()
    return result
end

if RequestKey() ~= KEY then
    warn("Wrong key")
    return
end

SendWebhook("Key Accepted")

------------------------
-- GUI
------------------------
local ScreenGui = Instance.new("ScreenGui",game.CoreGui)
ScreenGui.Name = "NZ_MULTI_HUB"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

------------------------
-- BLUR
------------------------
local Blur = Instance.new("BlurEffect",Lighting)
Blur.Size = 0

------------------------
-- SPLASH
------------------------
local function Splash(txt,time)
    local l = Instance.new("TextLabel",ScreenGui)
    l.Size = UDim2.new(1,0,0,60)
    l.Position = UDim2.new(0,0,0.45,0)
    l.BackgroundTransparency = 1
    l.Text = txt
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
Main.Visible = false
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,26)

local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.Text = "NZ MULTI HUB v2.1"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(170,120,255)
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

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
        SendWebhook(txt)
        cb()
    end)
end

local function Rejoin()
    SendWebhook("Rejoin Server")
    TeleportService:Teleport(game.PlaceId,LP)
end

------------------------
-- MENUS
------------------------
local function MainMenu()
    Clear()
    Button("🥊 Ultimate Battlegrounds",function()
        game.PlaceId == PLACE_IDS.UBG and UBGMenu() or TeleportService:Teleport(PLACE_IDS.UBG,LP)
    end)
    Button("💪 The Strongest Battlegrounds",function()
        game.PlaceId == PLACE_IDS.TSB and TSBMenu() or TeleportService:Teleport(PLACE_IDS.TSB,LP)
    end)
    Button("🦸 Project Viltrumites",function()
        game.PlaceId == PLACE_IDS.VILTRUM and VILMenu() or TeleportService:Teleport(PLACE_IDS.VILTRUM,LP)
    end)
    Button("🏀 Basketball Zero",function()
        game.PlaceId == PLACE_IDS.BBZ and BBZMenu() or TeleportService:Teleport(PLACE_IDS.BBZ,LP)
    end)
    Button("🌐 Universal",UniversalMenu)
    Button("🔄 Rejoin",Rejoin)
end

-- (Los menús UBGMenu, TSBMenu, VILMenu, BBZMenu y UniversalMenu
-- se mantienen IGUAL que el mensaje anterior, con su botón Rejoin y Back)

------------------------
-- START FLOW
------------------------
task.spawn(function()
    Splash("NZ MULTI HUB",1.2)
    Splash("by NZ Team",1)
    Main.Visible = true
    MainMenu()
    SendWebhook("Menu Opened")
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
