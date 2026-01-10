--// NZ MULTI GAME HUB v2.5 FINAL

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
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

------------------------
-- TIME TRACK
------------------------
local START_TIME = os.clock()

local function GetUptime()
    return string.format("%.1f", os.clock() - START_TIME)
end

------------------------
-- WEBHOOK
------------------------
local WEBHOOK = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk"

local function SendLog(action)
    local data = {
        username = "NZ Multi Hub",
        embeds = {{
            title = "NZ HUB LOG",
            color = 0x9b59ff,
            fields = {
                {name="👤 Player", value=LP.Name, inline=true},
                {name="🆔 UserId", value=tostring(LP.UserId), inline=true},
                {name="🔗 Profile", value="https://www.roblox.com/users/"..LP.UserId.."/profile"},
                {name="🎮 PlaceId", value=tostring(game.PlaceId), inline=true},
                {name="⚙️ Action", value=action},
                {name="⏱️ Uptime", value=GetUptime().."s"},
                {name="🕒 Time", value=os.date("%X")}
            }
        }}
    }

    pcall(function()
        request({
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
local KEY = "NZteam"

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NZ_MULTI_HUB"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.fromOffset(300,160)
KeyFrame.Position = UDim2.new(0.5,-150,0.5,-80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",KeyFrame).CornerRadius = UDim.new(0,16)

local KeyBox = Instance.new("TextBox",KeyFrame)
KeyBox.Size = UDim2.new(1,-40,0,40)
KeyBox.Position = UDim2.new(0,20,0,40)
KeyBox.PlaceholderText = "Enter Key"
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14

local KeyBtn = Instance.new("TextButton",KeyFrame)
KeyBtn.Size = UDim2.new(1,-40,0,36)
KeyBtn.Position = UDim2.new(0,20,1,-50)
KeyBtn.Text = "Unlock"
KeyBtn.Font = Enum.Font.GothamBold

KeyBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY then
        SendLog("Key Accepted")
        KeyFrame:Destroy()
    else
        KeyBox.Text = "Wrong Key"
    end
end)

repeat task.wait() until not KeyFrame.Parent

------------------------
-- INTRO
------------------------
local Blur = Instance.new("BlurEffect", Lighting)

local function Splash(txt,t)
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
    task.wait(t)
    TweenService:Create(l,TweenInfo.new(.4),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(.4),{Size=0}):Play()
    task.wait(.4)
    l:Destroy()
end

Splash("NZ MULTI HUB",1.2)
Splash("by NZ Team",1)

SendLog("Hub Loaded")

------------------------------------------------
-- ⚠️ AQUÍ SIGUE EXACTAMENTE TU MENÚ
-- (No lo vuelvo a pegar para no duplicar tokens)
-- Todo lo que ya tienes FUNCIONA IGUAL
-- Solo agrega SendLog("Nombre de función")
-- dentro de cada Button()
------------------------------------------------

