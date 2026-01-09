--// NZ MULTI GAME HUB v1.7
--// Draggable UI • Join Confirmation • Anti Double Exec

------------------------
-- ANTI DOUBLE EXEC
------------------------
if getgenv().NZ_MULTI_HUB_LOADED then
    warn("[NZ HUB] Already loaded")
    return
end
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
-- VISIBILITY
------------------------
local Main, Shadow
local function ShowMenu(state)
    Main.Visible = state
    Shadow.Visible = state
end

------------------------
-- CONFIRM JOIN
------------------------
local function ConfirmJoin(placeId, name)
    ShowMenu(false)

    local frame = Instance.new("Frame", ScreenGui)
    frame.Size = UDim2.fromOffset(360,180)
    frame.Position = UDim2.new(0.5,-180,0.5,-90)
    frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    frame.BorderSizePixel = 0
    Instance.new("UICorner",frame).CornerRadius = UDim.new(0,18)

    local txt = Instance.new("TextLabel",frame)
    txt.Size = UDim2.new(1,-20,0,80)
    txt.Position = UDim2.new(0,10,0,10)
    txt.BackgroundTransparency = 1
    txt.Text = "No estás en "..name.."\n¿Quieres unirte?"
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 18
    txt.TextWrapped = true
    txt.TextColor3 = Color3.fromRGB(235,235,235)

    local function makeBtn(text,x,callback)
        local b = Instance.new("TextButton",frame)
        b.Size = UDim2.fromOffset(140,40)
        b.Position = UDim2.new(0.5,x,1,-55)
        b.BackgroundColor3 = Color3.fromRGB(40,40,60)
        b.Text = text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)
        b.MouseButton1Click:Connect(callback)
    end

    makeBtn("✅ Sí",-150,function()
        TeleportService:Teleport(placeId, LP)
    end)

    makeBtn("❌ No",10,function()
        frame:Destroy()
        ShowMenu(true)
    end)
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
-- HEADER (DRAG)
------------------------
local Header = Instance.new("TextLabel",Main)
Header.Size = UDim2.new(1,0,0,60)
Header.BackgroundColor3 = Color3.fromRGB(18,18,28)
Header.Text = "NZ MULTI HUB v1.7"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(170,120,255)
Header.Active = true
Header.Selectable = true
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,26)

-- Drag system
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
            Main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
            Shadow.Position = Main.Position - UDim2.fromOffset(20,20)
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
    btn.MouseButton1Click:Connect(callback)
end

------------------------
-- CLEAR
------------------------
local function Clear()
    for _,v in ipairs(Holder:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
end

------------------------
-- REJOIN
------------------------
local function Rejoin()
    TeleportService:Teleport(game.PlaceId, LP)
end

------------------------
-- MENUS
------------------------
local function UniversalMenu()
    Clear()
    Button("♾️ Infinite Yield", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    Button("🔄 Rejoin", Rejoin)
    Button("⬅️ Back", MainMenu)
end

function MainMenu()
    Clear()

    local function GameButton(text, id)
        Button(text,function()
            if game.PlaceId ~= id then
                ConfirmJoin(id, text)
            end
        end)
    end

    GameButton("🥊 Ultimate Battlegrounds", PLACE_IDS.UBG)
    GameButton("💪 The Strongest Battlegrounds", PLACE_IDS.TSB)
    GameButton("🦸 Project Viltrumites", PLACE_IDS.VILTRUM)
    GameButton("🏀 Basketball Zero", PLACE_IDS.BBZ)

    Button("🌐 Universal Scripts", UniversalMenu)
    Button("🔄 Rejoin", Rejoin)
end

------------------------
-- INTRO
------------------------
task.spawn(function()
    Splash("NZ MULTI GAME HUB",1.2)
    Splash("by NZ Team",1)
    MainMenu()
    ShowMenu(true)
end)

------------------------
-- TOGGLE
------------------------
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Z then
        ShowMenu(not Main.Visible)
    end
end)
