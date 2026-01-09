--// NZ MULTI GAME HUB v1.8
--// Fixed Game Menus • Proper Teleport • Full Integration

------------------------
-- ANTI DOUBLE EXEC
------------------------
if getgenv().NZ_MULTI_HUB_LOADED then return end
getgenv().NZ_MULTI_HUB_LOADED = true

------------------------
-- SERVICES
------------------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
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
    game.CoreGui.NZ_MULTI_HUB:Destroy()
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

------------------------
-- SPLASH RGB
------------------------
local function Splash(text, time)
    local l = Instance.new("TextLabel", ScreenGui)
    l.Size = UDim2.new(1,0,0,60)
    l.Position = UDim2.new(0,0,.45,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 32
    l.TextTransparency = 1

    task.spawn(function()
        while l.Parent do
            l.TextColor3 = Color3.fromHSV((tick()%5)/5,1,1)
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
local Shadow = Instance.new("ImageLabel", ScreenGui)
Shadow.Image = "rbxassetid://1316045217"
Shadow.Size = UDim2.fromOffset(420,560)
Shadow.Position = UDim2.new(.5,-210,.5,-280)
Shadow.BackgroundTransparency = 1
Shadow.ImageTransparency = .35
Shadow.Visible = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(380,520)
Main.Position = UDim2.new(.5,-190,.5,-260)
Main.BackgroundColor3 = Color3.fromRGB(10,10,14)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,26)

------------------------
-- HEADER (DRAG)
------------------------
local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.Text = "NZ MULTI HUB v1.8"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(170,120,255)
Header.Active = true
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

do
    local drag, start, pos
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = i.Position
            pos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            Main.Position = pos + UDim2.fromOffset(d.X,d.Y)
            Shadow.Position = Main.Position - UDim2.fromOffset(20,20)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
    end)
end

------------------------
-- HOLDER
------------------------
local Holder = Instance.new("ScrollingFrame",Main)
Holder.Position = UDim2.new(0,16,0,72)
Holder.Size = UDim2.new(1,-32,1,-100)
Holder.ScrollBarThickness = 4
Holder.BackgroundTransparency = 1

local List = Instance.new("UIListLayout",Holder)
List.Padding = UDim.new(0,12)
List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y+10)
end)

------------------------
-- UTILS
------------------------
local function Clear()
    for _,v in pairs(Holder:GetChildren()) do
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
    b.MouseButton1Click:Connect(cb)
end

local function Rejoin()
    TeleportService:Teleport(game.PlaceId, LP)
end

------------------------
-- GAME MENUS
------------------------
local function UBGMenu()
    Clear()
    Button("⚔️ Kill Aura", function()
        loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
    end)
    Button("🕺 Emotes", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"))()
    end)
    Button("❓ Unnamed Script", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua",true))()
    end)
    Button("🔄 Rejoin", Rejoin)
    Button("⬅️ Back", MainMenu)
end

local function VILTRUMMenu()
    Clear()
    Button("🦸 NZ Pv Team", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"))()
    end)
    Button("🔄 Rejoin", Rejoin)
    Button("⬅️ Back", MainMenu)
end

local function BBZMenu()
    Clear()
    Button("🏀 BBZ NZ", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"))()
    end)
    Button("🔄 Rejoin", Rejoin)
    Button("⬅️ Back", MainMenu)
end

local function TSBMenu()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/TSB-NZ/refs/heads/main/tsb.lua"))()
end

------------------------
-- CONFIRM JOIN
------------------------
local function ConfirmJoin(id,name,callback)
    Main.Visible=false
    Shadow.Visible=false

    local f = Instance.new("Frame",ScreenGui)
    f.Size = UDim2.fromOffset(360,180)
    f.Position = UDim2.new(.5,-180,.5,-90)
    f.BackgroundColor3 = Color3.fromRGB(15,15,20)
    Instance.new("UICorner",f).CornerRadius = UDim.new(0,18)

    local t = Instance.new("TextLabel",f)
    t.Size = UDim2.new(1,-20,0,90)
    t.Position = UDim2.new(0,10,0,10)
    t.BackgroundTransparency = 1
    t.Text = "No estás en "..name.."\n¿Quieres unirte?"
    t.Font = Enum.Font.GothamBold
    t.TextSize = 18
    t.TextWrapped = true
    t.TextColor3 = Color3.new(1,1,1)

    local function mk(txt,x,cb)
        local b = Instance.new("TextButton",f)
        b.Size = UDim2.fromOffset(140,40)
        b.Position = UDim2.new(.5,x,1,-55)
        b.BackgroundColor3 = Color3.fromRGB(40,40,60)
        b.Text = txt
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)
        b.MouseButton1Click:Connect(cb)
    end

    mk("✅ Sí",-150,function()
        pcall(function()
            TeleportService:Teleport(id,LP)
        end)
    end)

    mk("❌ No",10,function()
        f:Destroy()
        Main.Visible=true
        Shadow.Visible=true
    end)
end

------------------------
-- MAIN MENU
------------------------
function MainMenu()
    Clear()

    local function Game(name,id,menu)
        Button(name,function()
            if game.PlaceId == id then
                menu()
            else
                ConfirmJoin(id,name,menu)
            end
        end)
    end

    Game("🥊 Ultimate Battlegrounds",PLACE_IDS.UBG,UBGMenu)
    Game("💪 The Strongest Battlegrounds",PLACE_IDS.TSB,TSBMenu)
    Game("🦸 Project Viltrumites",PLACE_IDS.VILTRUM,VILTRUMMenu)
    Game("🏀 Basketball Zero",PLACE_IDS.BBZ,BBZMenu)

    Button("♾️ Infinite Yield", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    Button("🔄 Rejoin", Rejoin)
end

------------------------
-- START
------------------------
task.spawn(function()
    Splash("NZ MULTI GAME HUB",1.2)
    Splash("NZ Team",1)
    MainMenu()
    Main.Visible=true
    Shadow.Visible=true
end)

------------------------
-- TOGGLE
------------------------
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Z then
        Main.Visible = not Main.Visible
        Shadow.Visible = Main.Visible
    end
end)
