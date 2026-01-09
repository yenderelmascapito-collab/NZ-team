--// NZ MULTI GAME HUB v1.2
--// Clean version - No Music

------------------------
-- SERVICES
------------------------
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

------------------------
-- PLACE IDS (USER PROVIDED)
------------------------
local PLACE_IDS = {
    UBG = 11815767793,
    TSB = 10449761463,
    BBZ = 130739873848552,
    VILTRUM = 113318245878384
}

------------------------
-- CLEAN OLD GUI
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
-- SPLASH MESSAGE
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

    TweenService:Create(label,TweenInfo.new(0.35),{TextTransparency=0}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.35),{Size=18}):Play()

    task.wait(duration)

    TweenService:Create(label,TweenInfo.new(0.35),{TextTransparency=1}):Play()
    TweenService:Create(Blur,TweenInfo.new(0.35),{Size=0}):Play()

    task.wait(0.35)
    label:Destroy()
end

------------------------
-- GAME CHECK
------------------------
local function CheckGame(expectedId, name)
    if game.PlaceId ~= expectedId then
        Splash("Wrong game! Open "..name, 1.5)
        return false
    end
    return true
end

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
Holder.Size = UDim2.new(1,-32,1,-100)
Holder.CanvasSize = UDim2.new()
Holder.ScrollBarThickness = 4
Holder.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout",Holder)
Layout.Padding = UDim.new(0,12)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Holder.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

------------------------
-- BUTTON CREATOR
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
-- CLEAR MENU
------------------------
local function Clear()
    for _,v in ipairs(Holder:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
end

------------------------
-- MAIN MENU
------------------------
local function MainMenu()
    Clear()

    Button("🥊 Ultimate Battlegrounds", function()
        if not CheckGame(PLACE_IDS.UBG,"Ultimate Battlegrounds") then return end
        Splash("Ultimate Battlegrounds",1)

        Clear()
        Button("🕺 Emotes", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/WiteHackep/UBG_cosmetic/refs/heads/main/ubg_cosmetic.txt"))()
        end)

        Button("⚔️ Kill Aura", function()
            loadstring(game:HttpGet("https://eltonshub-loader.netlify.app/UBG1.lua"))()
        end)

        Button("⬅️ Back", MainMenu)
    end)

    Button("💪 The Strongest Battlegrounds", function()
        if not CheckGame(PLACE_IDS.TSB,"The Strongest Battlegrounds") then return end
        Splash("Loading TSB...",1)
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

    Button("🌐 Universal", function()
        Clear()
        Button("♾️ Infinite Yield", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        Button("⬅️ Back", MainMenu)
    end)
end

MainMenu()

------------------------
-- TOGGLE KEY
------------------------
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Z then
        Main.Visible = not Main.Visible
        Shadow.Visible = Main.Visible
    end
end)
