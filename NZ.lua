--// NZ MULTI GAME HUB v1.0
--// by NZ team

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
local function Splash(text, duration)
    local label = Instance.new("TextLabel", ScreenGui)
    label.Size = UDim2.new(1,0,0,60)
    label.Position = UDim2.new(0,0,0.45,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 30
    label.TextColor3 = Color3.fromHSV(math.random(),1,1)
    label.TextTransparency = 1

    TweenService:Create(label,TweenInfo.new(0.4),{TextTransparency=0}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.4),{Size=18}):Play()

    task.wait(duration)

    TweenService:Create(label,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.4),{Size=0}):Play()

    task.wait(0.4)
    label:Destroy()
end

task.spawn(function()
    Splash("NZ MULTI GAME HUB",1.2)
    Splash("NZ team on top",1.2)
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

------------------------
-- HEADER
------------------------
local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.BorderSizePixel = 0
Header.Text = "NZ MULTI HUB  v1.0"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(170,120,255)
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

------------------------
-- HOLDER
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

------------------------
-- BUTTON
------------------------
local function Button(text, callback)
    local btn = Instance.new("TextButton",Holder)
    btn.Size = UDim2.new(1,0,0,44)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,14)

    btn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        pcall(callback)
    end)
end

------------------------
-- MENU SYSTEM
------------------------
local function Clear()
    for _,v in ipairs(Holder:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

------------------------
-- MAIN MENU
------------------------
local function MainMenu()
    Clear()
    Button("🥊 Ultimate Battlegrounds", function()
        Splash("Ultimate Battlegrounds",1)
        Clear()
        Button("🕺 Emotes",function()
            Splash("UBG - Emotes",1)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"))()
        end)
        Button("⚔️ Kill Aura",function()
            Splash("UBG - Kill Aura",1)
            loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
        end)
        Button("❓ Unnamed",function()
            Splash("UBG - Unnamed",1)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/YourLocalSkidder/ultimate/refs/heads/main/Protected_1855805535235895.lua",true))()
        end)
        Button("⬅️ Back",MainMenu)
    end)

    Button("💪 The Strongest Battlegrounds", function()
        Splash("The Strongest Battlegrounds",1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/NZ-team/refs/heads/main/NZ.lua"))()
    end)

    Button("🦸 Project Viltrumites", function()
        Splash("Project Viltrumites",1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"))()
    end)

    Button("🏀 Basketball Zero", function()
        Splash("Basketball Zero",1)
        loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"))()
    end)

    Button("🌐 Universal Scripts", function()
        Splash("Universal",1)
        Clear()
        Button("♾️ Infinite Yield",function()
            Splash("Infinite Yield",1)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        Button("⬅️ Back",MainMenu)
    end)
end

MainMenu()

------------------------
-- TOGGLE KEY
------------------------
local toggleKey = Enum.KeyCode.Z
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == toggleKey then
        Main.Visible = not Main.Visible
        Shadow.Visible = Main.Visible
    end
end)
