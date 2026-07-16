-- ============================================
-- БЕЗОПАСНЫЙ ТЕСТОВЫЙ GUI
-- Только визуальные элементы, без читерских функций
-- ============================================

-- Проверяем, что мы в игре
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    return print("❌ Не удалось найти игрока")
end

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestGUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0

-- Заголовок окна
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Text = "🧪 Тестовый GUI (Безопасный)"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.BackgroundTransparency = 1

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundTransparency = 1
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контент
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1

-- Функция создания секции
local function CreateSection(parent, text, yPos)
    local section = Instance.new("Frame")
    section.Name = "Section"
    section.Parent = parent
    section.Size = UDim2.new(1, 0, 0, 30)
    section.Position = UDim2.new(0, 0, 0, yPos)
    section.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = section
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    return section
end

-- Функция создания кнопки
local function CreateButton(parent, text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Parent = parent
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    button.BorderSizePixel = 0
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Создаем контент
local currentY = 0

-- Информация об игре
CreateSection(ContentFrame, "📊 Информация об игре", currentY)
currentY = currentY + 35

local GameInfo = Instance.new("TextLabel")
GameInfo.Name = "GameInfo"
GameInfo.Parent = ContentFrame
GameInfo.Size = UDim2.new(1, 0, 0, 20)
GameInfo.Position = UDim2.new(0, 0, 0, currentY)
GameInfo.Text = "Игра: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
GameInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
GameInfo.TextSize = 12
GameInfo.Font = Enum.Font.Gotham
GameInfo.TextXAlignment = Enum.TextXAlignment.Left
GameInfo.BackgroundTransparency = 1

currentY = currentY + 25

-- Создаем секции
CreateSection(ContentFrame, "🎮 Действия", currentY)
currentY = currentY + 35

-- Кнопка с подтверждением
CreateButton(ContentFrame, "✅ Показать сообщение", currentY, function()
    local notification = Instance.new("TextLabel")
    notification.Name = "Notification"
    notification.Parent = ScreenGui
    notification.Size = UDim2.new(0, 250, 0, 40)
    notification.Position = UDim2.new(0.5, -125, 0.8, 0)
    notification.Text = "Привет! Это тестовое сообщение"
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextSize = 14
    notification.Font = Enum.Font.Gotham
    notification.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    notification.BorderSizePixel = 0
    
    task.wait(2)
    notification:Destroy()
end)

currentY = currentY + 40

CreateButton(ContentFrame, "🔄 Сменить цвет фона", currentY, function()
    local colors = {
        Color3.fromRGB(30, 30, 35),
        Color3.fromRGB(40, 30, 35),
        Color3.fromRGB(35, 40, 35),
        Color3.fromRGB(35, 30, 40)
    }
    MainFrame.BackgroundColor3 = colors[math.random(1, #colors)]
end)

currentY = currentY + 40

CreateButton(ContentFrame, "💥 Анимация", currentY, function()
    local startTime = tick()
    local originalSize = MainFrame.Size
    local originalPos = MainFrame.Position
    
    game:GetService("RunService").RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > 1.5 then
            MainFrame.Size = originalSize
            MainFrame.Position = originalPos
            return
        end
        
        local scale = 1 + math.sin(elapsed * 10) * 0.05
        MainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset * scale, 
                                   originalSize.Y.Scale, originalSize.Y.Offset * scale)
    end)
end)

currentY = currentY + 40

-- Секция с настройками
CreateSection(ContentFrame, "⚙️ Настройки", currentY)
currentY = currentY + 35

-- Toggle (чекбокс)
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Name = "ToggleFrame"
ToggleFrame.Parent = ContentFrame
ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
ToggleFrame.Position = UDim2.new(0, 0, 0, currentY)
ToggleFrame.BackgroundTransparency = 1

local ToggleText = Instance.new("TextLabel")
ToggleText.Name = "ToggleText"
ToggleText.Parent = ToggleFrame
ToggleText.Size = UDim2.new(0.9, 0, 1, 0)
ToggleText.Text = "Показывать FPS"
ToggleText.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleText.TextSize = 13
ToggleText.Font = Enum.Font.Gotham
ToggleText.TextXAlignment = Enum.TextXAlignment.Left
ToggleText.BackgroundTransparency = 1

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleFrame
ToggleButton.Size = UDim2.new(0, 50, 1, 0)
ToggleButton.Position = UDim2.new(1, -50, 0, 0)
ToggleButton.Text = "Выкл"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ToggleButton.BorderSizePixel = 0

local toggled = false
ToggleButton.MouseButton1Click:Connect(function()
    toggled = not toggled
    ToggleButton.Text = toggled and "Вкл" or "Выкл"
    ToggleButton.BackgroundColor3 = toggled and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(60, 60, 65)
    
    if toggled then
        -- Создаем FPS счетчик
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSLabel"
        fpsLabel.Parent = ScreenGui
        fpsLabel.Size = UDim2.new(0, 100, 0, 30)
        fpsLabel.Position = UDim2.new(0, 10, 0, 10)
        fpsLabel.Text = "FPS: 0"
        fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        fpsLabel.TextSize = 14
        fpsLabel.Font = Enum.Font.Gotham
        fpsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        fpsLabel.BorderSizePixel = 0
        
        local lastTime = tick()
        local frames = 0
        
        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            frames = frames + 1
            local currentTime = tick()
            if currentTime - lastTime >= 1 then
                fpsLabel.Text = "FPS: " .. frames
                frames = 0
                lastTime = currentTime
            end
        end)
        
        -- Сохраняем соединение для отключения
        ToggleButton.Connection = connection
        ToggleButton.FPSLabel = fpsLabel
    else
        if ToggleButton.Connection then
            ToggleButton.Connection:Disconnect()
            ToggleButton.Connection = nil
        end
        if ToggleButton.FPSLabel then
            ToggleButton.FPSLabel:Destroy()
            ToggleButton.FPSLabel = nil
        end
    end
end)

currentY = currentY + 35

-- Кнопка для перезагрузки GUI
CreateButton(ContentFrame, "🔄 Перезапустить GUI", currentY, function()
    ScreenGui:Destroy()
    print("🔁 GUI перезапущен")
    task.wait(0.5)
    -- Перезапускаем скрипт (этот код выполнится снова)
    loadstring(game:HttpGet("raw.githubusercontent.com/your_script_url_here"))()
end)

-- Делаем окно перетаскиваемым
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
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

print("✅ Безопасный тестовый GUI загружен!")
print("⚠️ Этот GUI не использует игровые функции и безопасен для тестирования")