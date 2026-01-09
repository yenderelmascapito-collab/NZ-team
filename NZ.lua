--// NZ TSB HUB v1.4
--// for 2Pac | Assushin

------------------------
-- SERVICES
------------------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

print("[NZ TSB HUB] Loaded v1.4 | for 2Pac | Assushin")

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
-- SPLASH TEXT
------------------------
local function Splash(text, duration)
    local label = Instance.new("TextLabel", ScreenGui)
    label.Size = UDim2.new(1,0,0,60)
    label.Position = UDim2.new(0,0,0.45,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 32
    label.TextColor3 = Color3.fromHSV(math.random(),1,1)
    label.TextTransparency = 1

    TweenService:Create(label,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.5),{Size=18}):Play()

    task.wait(duration)

    TweenService:Create(label,TweenInfo.new(0.5),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.5),{Size=0}):Play()

    task.wait(0.5)
    label:Destroy()
end

task.spawn(function()
    Splash("HUB by 2Pac",1.2)
    Splash("NZ team On Top",1.2)
    Splash("for 2Pac | Assushin",1.4)
    Splash("Toggle Key: Z",1.2)
end)

------------------------
-- SHADOW
------------------------
local Shadow = Instance.new("ImageLabel", ScreenGui)
Shadow.Image = "rbxassetid://1316045217"
Shadow.Size = UDim2.fromOffset(420,560)
Shadow.Position = UDim2.new(0.5,-210,0.5,-280)
Shadow.BackgroundTransparency = 1
Shadow.ImageTransparency = 0.35
Shadow.Visible = false

------------------------
-- MAIN FRAME
------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromOffset(380,520)
Main.Position = UDim2.new(0.5,-190,0.5,-260)
Main.BackgroundColor3 = Color3.fromRGB(10,10,14)
Main.BorderSizePixel = 0
Main.Visible = false
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,26)

local UIScale = Instance.new("UIScale",Main)
UIScale.Scale = 1

------------------------
-- HEADER
------------------------
local Header = Instance.new("Frame",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.BorderSizePixel = 0
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

local Title = Instance.new("TextLabel",Header)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "NZ TSB HUB  v1.4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(170,120,255)

------------------------
-- SCROLL HOLDER (ANTI CUT)
------------------------
local Holder = Instance.new("ScrollingFrame",Main)
Holder.Position = UDim2.new(0,16,0,72)
Holder.Size = UDim2.new(1,-32,1,-100)
Holder.CanvasSize = UDim2.new(0,0,0,0)
Holder.ScrollBarImageTransparency = 0.8
Holder.ScrollBarThickness = 4
Holder.BackgroundTransparency = 1

local List = Instance.new("UIListLayout",Holder)
List.Padding = UDim.new(0,12)

List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y + 10)
end)

------------------------
-- SOUNDS
------------------------
local ClickSound = Instance.new("Sound",Main)
ClickSound.SoundId = "rbxassetid://9118823107"
ClickSound.Volume = 0.4

local ToggleSound = Instance.new("Sound",Main)
ToggleSound.SoundId = "rbxassetid://9118828567"
ToggleSound.Volume = 0.5

------------------------
-- BUTTON FUNCTION
------------------------
local function CreateButton(text,color,callback)
    local btn = Instance.new("TextButton",Holder)
    btn.Size = UDim2.new(1,0,0,44)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,14)

    local scale = Instance.new("UIScale",btn)

    btn.MouseEnter:Connect(function()
        TweenService:Create(scale,TweenInfo.new(0.15),{Scale=1.04}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(scale,TweenInfo.new(0.15),{Scale=1}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        TweenService:Create(scale,TweenInfo.new(0.1),{Scale=0.95}):Play()
        task.wait(0.1)
        TweenService:Create(scale,TweenInfo.new(0.1),{Scale=1}):Play()
        pcall(callback)
    end)
end

------------------------
-- SCRIPT BUTTONS (WITH EMOJIS)
------------------------
CreateButton("🛡️ AUTO BLOCK",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/thestrongestbattlegrounds/refs/heads/main/cpsautoblock.lua"))()
end)

CreateButton("⚡ AUTO TECHS V2",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hellattexyss/autotechs/refs/heads/main/cpstechs.lua"))()
end)

CreateButton("➡️ SIDE DASH ASSIST",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/54d6b993fe3a4c1f5c3e375eba35e5ec.lua"))()
end)

CreateButton("🔁 M1 RESET",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fa8d49690e680794f761b497742fd1c2.lua"))()
end)

CreateButton("🔥 SUPA TECH",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/2753546c83053761e44664d36ffe5035d6e20fc8aee1d19f0eb7b933974ae537.lua"))()
end)

CreateButton("🔄 LOOP DASH TECH",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/84e2bd29cccc0f5302267e4dc952cff6816db4af36416cbd477daaa26d60863d.lua"))()
end)

CreateButton("🐱 MEOW TECH (KEY)",Color3.fromRGB(40,40,60),function()
    loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/2345da4cc975b07b3f250f6a83c45687a70c1999b9c46219cd6893771f9dd542/download"))()
end)

CreateButton("🔄 REJOIN SERVER",Color3.fromRGB(90,40,40),function()
    TeleportService:Teleport(game.PlaceId,LP)
end)

------------------------
-- TOGGLE KEY SYSTEM
------------------------
local toggleKey = Enum.KeyCode.Z
local waitingKey = false

CreateButton("⌨️ CHANGE TOGGLE KEY",Color3.fromRGB(70,60,100),function()
    waitingKey = true
    print("[NZ HUB] Waiting for new key...")
end)

UIS.InputBegan:Connect(function(input,gp)
    if gp then return end

    if waitingKey then
        toggleKey = input.KeyCode
        waitingKey = false
        Splash("Toggle Key: "..toggleKey.Name,1.2)
        return
    end

    if input.KeyCode == toggleKey then
        ToggleSound:Play()
        Main.Visible = not Main.Visible
        Shadow.Visible = Main.Visible
    end
end)
