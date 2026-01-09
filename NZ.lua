--// NZ MULTI HUB v2.1 FIXED

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
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

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
ScreenGui.ResetOnSpawn = false

------------------------
-- BLUR
------------------------
local Blur = Instance.new("BlurEffect", Lighting)
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
-- MAIN FRAME
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
Header.Text = "NZ MULTI HUB"
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
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,14)
    b.MouseButton1Click:Connect(cb)
end

local function Rejoin()
    TeleportService:Teleport(game.PlaceId, LP)
end

------------------------
-- TSB MENU (INTEGRADO)
------------------------
function TSBMenu()
    Clear()

    Button("🛡️ AUTO BLOCK", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"))()
    end)

    Button("⚡ AUTO TECHS V2", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"))()
    end)

    Button("➡️ SIDE DASH ASSIST", function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"))()
    end)

    Button("🔁 M1 RESET", function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fa8d49690e680794f761b497742fd1c2.lua"))()
    end)

    Button("🔥 SUPA TECH", function()
        loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"))()
    end)

    Button("🐱 MEOW TECH", function()
        loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"))()
    end)

    Button("🔄 Rejoin", Rejoin)
    Button("⬅ Back", MainMenu)
end

------------------------
-- MAIN MENU
------------------------
function MainMenu()
    Clear()

    Button("💪 The Strongest Battlegrounds", function()
        if game.PlaceId == PLACE_IDS.TSB then
            TSBMenu()
        else
            TeleportService:Teleport(PLACE_IDS.TSB, LP)
        end
    end)

    Button("🔄 Rejoin", Rejoin)
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
