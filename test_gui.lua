-- ============================================
-- ГАРАНТИРОВАННО РАБОЧИЙ GUI (v2.0)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if not LocalPlayer then
    return print("❌ Игрок не найден. Скрипт остановлен.")
end

-- --- 1. ПОИСК ПОДХОДЯЩЕГО РОДИТЕЛЯ ---
local function FindParent()
    local candidates = {
        CoreGui,
        LocalPlayer:FindFirstChild("PlayerGui"),
        game:GetService("StarterGui"),
        LocalPlayer:WaitForChild("PlayerGui", 0.5)
    }
    for _, parent in ipairs(candidates) do
        if parent and parent:IsA("Instance") then
            return parent
        end
    end
    return nil
end

local parent = FindParent()
if not parent then
    return print("❌ Не найден подходящий родитель для GUI. Попробуй другой экзекьютор.")
end

print("✅ Родитель для GUI найден: " .. parent.Name)

-- --- 2. СОЗДАНИЕ GUI ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestGUI_v2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parent

-- Защита от удаления
local function Reattach()
    if not ScreenGui.Parent then
        ScreenGui.Parent = parent
    end
end
game:GetService("RunService").Stepped:Connect(Reattach)

-- --- 3. ГЛАВНОЕ ОКНО ---
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 10)

-- --- 4. ЗАГОЛОВОК ---
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Text = "✅ GUI РАБОТАЕТ"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- --- 5. КОНТЕНТ ---
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.Size = UDim2.new(1, -20, 1, -55)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Parent = Content
InfoLabel.Size = UDim2.new(1, 0, 0, 25)
InfoLabel.Position = UDim2.new(0, 0, 0, 5)
InfoLabel.Text = "Игра: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.BackgroundTransparency = 1

local TestBtn = Instance.new("TextButton")
TestBtn.Name = "TestBtn"
TestBtn.Parent = Content
TestBtn.Size = UDim2.new(1, 0, 0, 35)
TestBtn.Position = UDim2.new(0, 0, 0, 45)
TestBtn.Text = "🔄 Нажми, чтобы проверить"
TestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TestBtn.TextSize = 14
TestBtn.Font = Enum.Font.GothamBold
TestBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
TestBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.Parent = TestBtn
BtnCorner.CornerRadius = UDim.new(0, 6)

TestBtn.MouseButton1Click:Connect(function()
    TestBtn.Text = "✅ Успешно!"
    TestBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    task.wait(1)
    TestBtn.Text = "🔄 Нажми, чтобы проверить"
    TestBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = Content
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 95)
StatusLabel.Text = "Статус: GUI загружен и работает"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.BackgroundTransparency = 1

-- --- 6. ПЕРЕТАСКИВАНИЕ ОКНА ---
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("============================================")
print("✅ GUI успешно создан и отображается!")
print("📍 Родитель: " .. parent.Name)
print("🎮 Игра: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
print("🟢 Статус: Работает")
print("============================================")
