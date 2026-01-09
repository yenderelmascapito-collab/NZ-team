--// NZ MULTI GAME HUB v1.5
--// Anti Double Execution • Safe UI • RGB Intro

------------------------
-- ANTI DOUBLE EXECUTION
------------------------
if getgenv().NZ_MULTI_HUB_LOADED then
    warn("[NZ HUB] Script already loaded.")
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "NZ MULTI HUB",
        Text = "Hub already loaded!",
        Duration = 4
    })
    return
end
getgenv().NZ_MULTI_HUB_LOADED = true

------------------------
-- SERVICES
------------------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
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
-- CLEAN OLD GUI (SAFETY)
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
-- SPLASH RGB
------------------------
local function Splash(text, duration)
    local label = Instance.new("TextLabel", ScreenGui)
    label.Size = UDim2.new(1,0,0,60)
    label.Position = UDim2.new(0,0,0.45,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 32
    label.TextTransparency = 1

    task.spawn(function()
        while label.Parent do
            label.TextColor3 = Color3.fromHSV((tick()%5)/5,1,1)
            task.wait(0.05)
        end
    end)

    TweenService:Create(label,TweenInfo.new(0.4),{TextTransparency=0}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.4),{Size=20}):Play()

    task.wait(duration)

    TweenService:Create(label,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.4),{Size=0}):Play()

    task.wait(0.4)
    label:Destroy()
end

------------------------
-- MENU VISIBILITY
------------------------
local Main, Shadow
local function ShowMenu(state)
    if Main then
        Main.Visible = state
        Shadow.Visible = state
    end
end

------------------------
-- GAME CHECK
------------------------
local function CheckGame(expectedId, name)
    if game.PlaceId ~= expectedId then
        ShowMenu(false)
        Splash("Wrong game! Open "..name,1.6)
        ShowMenu(true)
        return false
    end
    return true
end

------------------------
-- SHADOW
------------------------
Shadow = Instance.new("ImageLabel", ScreenGui)
Shadow.Image = "rbxassetid://1316045217"
Shadow.Size = UDim2.fromOffset(420,560)
Shadow.Position = UDim2.new(0.5,-210,0.5,-280)
Shadow.BackgroundTransparency = 1
Shadow.ImageTransparency = 0.35
Shadow.Visible = false

------------------------
-- MAIN FRAME
------------------------
Main = Instance.new("Frame", ScreenGui)
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
Header.Text = "NZ MULTI HUB v1.5"
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
Holder.ScrollBarThickness = 4
Holder.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout",Holder)
Layout.Padding = UDim.new(0,12)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

------------------------
-- BUTTON
------------------------
local function Button(text, callback)
    local btn = Instance.new("TextButton",Holder)
    btn.Size = UDim2.new(1,0,0,44)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    btn.BorderSizePixel = 0
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,14)

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

------------------------
-- CLEAR
------------------------
local function Clear()
    for _,v in ipairs(Holder:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

------------------------
-- TOGGLE KEY
------------------------
local toggleKey = Enum.KeyCode.Z
local waitingKey = false

------------------------
-- MAIN MENU
------------------------
local function MainMenu()
    Clear()

    Button("🥊 Ultimate Battlegrounds", function()
        if not CheckGame(PLACE_IDS.UBG,"Ultimate Battlegrounds") then return end
        loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
    end)

    Button("💪 The Strongest Battlegrounds", function()
        if not CheckGame(PLACE_IDS.TSB,"The Strongest Battlegrounds") then return end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/TSB-NZ/refs/heads/main/tsb.lua"))()
    end)

    Button("🦸 Project Viltrumites", function()
        if not CheckGame(PLACE_IDS.VILTRUM,"Project Viltrumites") then return end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yenderelmascapito-collab/Proyecto-Viltrumita/refs/heads/main/script.lua"))()
    end)

    Button("🏀 Basketball Zero", function()
        if not CheckGame(PLACE_IDS.BBZ,"Basketball Zero") then return end
        loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-Basketball:-Zero-Basketball-Zero-OP-43354"))()
    end)

    Button("⌨️ Change Toggle Key", function()
        waitingKey = true
        Splash("Press any key...",1)
    end)
end

------------------------
-- INTRO FIRST → MENU
------------------------
task.spawn(function()
    Splash("NZ MULTI GAME HUB",1.2)
    Splash("by NZ Team",1)
    Splash("Anti Double Execution",1)
    Splash("Toggle Key: Z",1)

    MainMenu()
    ShowMenu(true)
end)

------------------------
-- INPUT
------------------------
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end

    if waitingKey then
        toggleKey = input.KeyCode
        waitingKey = false
        Splash("Toggle Key: "..toggleKey.Name,1.2)
        return
    end

    if input.KeyCode == toggleKey then
        ShowMenu(not Main.Visible)
    end
end)
