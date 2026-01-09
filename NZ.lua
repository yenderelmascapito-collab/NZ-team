--// NZ TSB HUB v1.6
--// Internal Version (NO LOADSTRING MENU)
--// NZ Team On Top

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
-- CLEAN
------------------------
pcall(function()
    if game.CoreGui:FindFirstChild("NZ_TSB_GUI") then
        game.CoreGui.NZ_TSB_GUI:Destroy()
    end
end)

------------------------
-- GUI
------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NZ_TSB_GUI"
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
local function Splash(text,duration)
    local l = Instance.new("TextLabel",ScreenGui)
    l.Size = UDim2.new(1,0,0,60)
    l.Position = UDim2.new(0,0,0.45,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 32
    l.TextColor3 = Color3.fromHSV(math.random(),1,1)
    l.TextTransparency = 1

    TweenService:Create(l,TweenInfo.new(.35),{TextTransparency=0}):Play()
    TweenService:Create(Blur,TweenInfo.new(.35),{Size=18}):Play()
    task.wait(duration)
    TweenService:Create(l,TweenInfo.new(.35),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(.35),{Size=0}):Play()
    task.wait(.35)
    l:Destroy()
end

task.spawn(function()
    Splash("The Strongest Battlegrounds",1.1)
    Splash("NZ Team On Top",1.1)
end)

------------------------
-- FRAME
------------------------
local Main = Instance.new("Frame",ScreenGui)
Main.Size = UDim2.fromOffset(380,520)
Main.Position = UDim2.new(.5,-190,.5,-260)
Main.BackgroundColor3 = Color3.fromRGB(10,10,14)
Main.BorderSizePixel = 0
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,26)

------------------------
-- HEADER (DRAG)
------------------------
local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.Text = "NZ TSB HUB  v1.6"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(170,120,255)
Header.Active = true
Header.Selectable = true
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

------------------------
-- DRAG SYSTEM
------------------------
do
    local dragging, dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
Holder.CanvasSize = UDim2.new()
Holder.ScrollBarThickness = 4
Holder.BackgroundTransparency = 1

local List = Instance.new("UIListLayout",Holder)
List.Padding = UDim.new(0,12)

List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y+10)
end)

------------------------
-- BUTTON MAKER
------------------------
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
        Splash(txt,0.9)
        pcall(cb)
    end)
end

------------------------
-- TSB SCRIPTS
------------------------
Button("🛡️ AUTO BLOCK",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"))()
end)

Button("⚡ AUTO TECHS V2",function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"))()
end)

Button("➡️ SIDE DASH ASSIST",function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"))()
end)

Button("🔁 M1 RESET",function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fa8d49690e680794f761b497742fd1c2.lua"))()
end)

Button("🔥 SUPA TECH",function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"))()
end)

Button("🔄 LOOP DASH TECH",function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/84e2bd29cccc0f5302267e4dc952cff6816db4af36416cbd477daaa26d60863d.lua"))()
end)

Button("🐱 MEOW TECH",function()
    loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"))()
end)

Button("🔄 REJOIN SERVER",function()
    TeleportService:Teleport(game.PlaceId,LP)
end)
