--// SCRIPT EN MANTENIMIENTO
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MaintenanceGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LP:WaitForChild("PlayerGui")

-- Crear TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Name = "MaintenanceLabel"
textLabel.Size = UDim2.new(0, 400, 0, 100)
textLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.BackgroundTransparency = 0.3
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 24
textLabel.Font = Enum.Font.GothamBold
textLabel.Text = "Script en mantenimiento\nIntentelo mas tarde"
textLabel.TextWrapped = true
textLabel.Parent = screenGui

-- Esperar 10 segundos
task.wait(10)

-- Eliminar la GUI
screenGui:Destroy()
