-- ============================================
-- HAVOC MENU v1.0
-- Авторизация через key.json + Меню
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if not LocalPlayer then return print("❌ Игрок не найден") end

-- ============================================
-- 1. СИСТЕМА КЛЮЧЕЙ (из key.json)
-- ============================================

local KeySystem = {
    KeysFile = "key.json",
    ValidKeys = {},
    
    LoadKeys = function()
        if isfile(KeySystem.KeysFile) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(KeySystem.KeysFile))
            end)
            if success and type(data) == "table" then
                KeySystem.ValidKeys = data
                return true
            end
        end
        return false
    end,
    
    ValidateKey = function(inputKey)
        if not inputKey or inputKey == "" then
            return false, "Введите ключ"
        end
        for key, info in pairs(KeySystem.ValidKeys) do
            if inputKey == key then
                return true, info
            end
        end
        return false, "Неверный ключ"
    end
}

-- Загружаем ключи
if not KeySystem.LoadKeys() then
    -- Создаём тестовый key.json если его нет
    local testKeys = {
        ["FREE-2024"] = { tier = "free", expires = "2024-12-31" },
        ["PREMIUM-2025"] = { tier = "premium", expires = "2025-12-31" },
        ["ADMIN-666"] = { tier = "admin", expires = "never" }
    }
    writefile("key.json", HttpService:JSONEncode(testKeys))
    KeySystem.ValidKeys = testKeys
    print("✅ Создан test key.json с ключами: FREE-2024, PREMIUM-2025, ADMIN-666")
end

-- ============================================
-- 2. ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================

local isAuthorized = false
local currentUserTier = nil
local MainScreenGui = nil
local MenuGui = nil

-- ============================================
-- 3. СОЗДАНИЕ ОКНА АВТОРИЗАЦИИ
-- ============================================

local function CreateAuthWindow()
    -- Удаляем старые GUI
    if MainScreenGui then MainScreenGui:Destroy() end
    
    MainScreenGui = Instance.new("ScreenGui")
    MainScreenGui.Name = "AuthGUI"
    MainScreenGui.Parent = CoreGui
    MainScreenGui.ResetOnSpawn = false
    
    -- Фоновое затемнение
    local Blur = Instance.new("Frame")
    Blur.Name = "Blur"
    Blur.Parent = MainScreenGui
    Blur.Size = UDim2.new(1, 0, 1, 0)
    Blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Blur.BackgroundTransparency = 0.6
    Blur.BorderSizePixel = 0
    
    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MainScreenGui
    MainFrame.Size = UDim2.new(0, 420, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    -- Скругление
    local Corner = Instance.new("UICorner")
    Corner.Parent = MainFrame
    Corner.CornerRadius = UDim.new(0, 14)
    
    -- Градиентный фон
    local Gradient = Instance.new("Frame")
    Gradient.Name = "Gradient"
    Gradient.Parent = MainFrame
    Gradient.Size = UDim2.new(1, 0, 1, 0)
    Gradient.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Gradient.BackgroundTransparency = 0.3
    Gradient.BorderSizePixel = 0
    
    local UIGrad = Instance.new("UIGradient")
    UIGrad.Parent = Gradient
    UIGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 35, 50))
    })
    UIGrad.Rotation = 30
    
    -- Акцентная линия сверху
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Parent = MainFrame
    AccentLine.Size = UDim2.new(1, 0, 0, 3)
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
    AccentLine.BorderSizePixel = 0
    
    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 20)
    Title.Text = "🔐 АВТОРИЗАЦИЯ"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = MainFrame
    SubTitle.Size = UDim2.new(1, 0, 0, 25)
    SubTitle.Position = UDim2.new(0, 0, 0, 55)
    SubTitle.Text = "Введите ключ для доступа к меню"
    SubTitle.TextColor3 = Color3.fromRGB(160, 160, 180)
    SubTitle.TextSize = 14
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.BackgroundTransparency = 1
    
    -- Поле ввода ключа
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "InputFrame"
    InputFrame.Parent = MainFrame
    InputFrame.Size = UDim2.new(0.85, 0, 0, 50)
    InputFrame.Position = UDim2.new(0.075, 0, 0, 105)
    InputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    InputFrame.BorderSizePixel = 0
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.Parent = InputFrame
    InputCorner.CornerRadius = UDim.new(0, 10)
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Parent = InputFrame
    KeyInput.Size = UDim2.new(0.9, -10, 0.8, 0)
    KeyInput.Position = UDim2.new(0.05, 0, 0.1, 0)
    KeyInput.PlaceholderText = "Введите ключ..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.BackgroundTransparency = 1
    KeyInput.ClearTextOnFocus = false
    
    -- Статус (ошибка/успех)
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0, 170)
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.BackgroundTransparency = 1
    
    -- Кнопка входа
    local LoginButton = Instance.new("TextButton")
    LoginButton.Name = "LoginButton"
    LoginButton.Parent = MainFrame
    LoginButton.Size = UDim2.new(0.85, 0, 0, 50)
    LoginButton.Position = UDim2.new(0.075, 0, 0, 210)
    LoginButton.Text = "ВОЙТИ"
    LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginButton.TextSize = 18
    LoginButton.Font = Enum.Font.GothamBold
    LoginButton.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
    LoginButton.BorderSizePixel = 0
    
    local LoginCorner = Instance.new("UICorner")
    LoginCorner.Parent = LoginButton
    LoginCorner.CornerRadius = UDim.new(0, 10)
    
    -- Hover эффект
    LoginButton.MouseEnter:Connect(function()
        LoginButton.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
    end)
    LoginButton.MouseLeave:Connect(function()
        LoginButton.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
    end)
    
    -- Информация о ключах
    local KeyInfo = Instance.new("TextLabel")
    KeyInfo.Name = "KeyInfo"
    KeyInfo.Parent = MainFrame
    KeyInfo.Size = UDim2.new(1, 0, 0, 20)
    KeyInfo.Position = UDim2.new(0, 0, 0, 285)
    KeyInfo.Text = "Тестовые ключи: FREE-2024, PREMIUM-2025, ADMIN-666"
    KeyInfo.TextColor3 = Color3.fromRGB(100, 100, 120)
    KeyInfo.TextSize = 11
    KeyInfo.Font = Enum.Font.Gotham
    KeyInfo.BackgroundTransparency = 1
    
    -- Функция входа
    local function AttemptLogin()
        local key = KeyInput.Text
        local success, info = KeySystem.ValidateKey(key)
        
        if success then
            StatusLabel.Text = "✅ Успешный вход!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            isAuthorized = true
            currentUserTier = info.tier
            task.wait(0.3)
            MainScreenGui:Destroy()
            CreateMainMenu()
        else
            StatusLabel.Text = "❌ " .. info
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            KeyInput.Text = ""
            KeyInput:CaptureFocus()
        end
    end
    
    LoginButton.MouseButton1Click:Connect(AttemptLogin)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then AttemptLogin() end
    end)
    
    -- Enter для входа
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Return then
            AttemptLogin()
        end
    end)
    
    -- Перетаскивание окна
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    MainFrame.InputBegan:Connect(function(input)
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
end

-- ============================================
-- 4. ГЛАВНОЕ МЕНЮ (Aimbot, Visuals, Player, etc.)
-- ============================================

local function CreateMainMenu()
    if MenuGui then MenuGui:Destroy() end
    
    MenuGui = Instance.new("ScreenGui")
    MenuGui.Name = "MainMenu"
    MenuGui.Parent = CoreGui
    MenuGui.ResetOnSpawn = false
    
    -- Главное окно
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MenuGui
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner")
    Corner.Parent = MainFrame
    Corner.CornerRadius = UDim.new(0, 14)
    
    -- Акцентная линия
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Parent = MainFrame
    AccentLine.Size = UDim2.new(1, 0, 0, 3)
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
    AccentLine.BorderSizePixel = 0
    
    -- Заголовок
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Position = UDim2.new(0, 0, 0, 10)
    TitleBar.BackgroundTransparency = 1
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Parent = TitleBar
    TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    TitleText.Position = UDim2.new(0.02, 0, 0, 0)
    TitleText.Text = "🔥 HAVOC MENU v1.0"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 20
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.BackgroundTransparency = 1
    
    -- Информация о пользователе
    local UserInfo = Instance.new("TextLabel")
    UserInfo.Name = "UserInfo"
    UserInfo.Parent = TitleBar
    UserInfo.Size = UDim2.new(0.3, 0, 1, 0)
    UserInfo.Position = UDim2.new(0.7, 0, 0, 0)
    UserInfo.Text = "👤 " .. currentUserTier:upper()
    UserInfo.TextColor3 = Color3.fromRGB(150, 150, 200)
    UserInfo.TextSize = 14
    UserInfo.Font = Enum.Font.Gotham
    UserInfo.TextXAlignment = Enum.TextXAlignment.Right
    UserInfo.BackgroundTransparency = 1
    
    -- Список категорий (левая панель)
    local Categories = {"Aimbot", "Visuals", "Player", "Movement", "Misc"}
    local CategoryButtons = {}
    local CurrentCategory = nil
    
    local CategoryPanel = Instance.new("Frame")
    CategoryPanel.Name = "CategoryPanel"
    CategoryPanel.Parent = MainFrame
    CategoryPanel.Size = UDim2.new(0, 150, 1, -65)
    CategoryPanel.Position = UDim2.new(0, 0, 0, 60)
    CategoryPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    CategoryPanel.BorderSizePixel = 0
    
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.Parent = CategoryPanel
    PanelCorner.CornerRadius = UDim.new(0, 8)
    
    -- Контент (правая панель)
    local ContentPanel = Instance.new("Frame")
    ContentPanel.Name = "ContentPanel"
    ContentPanel.Parent = MainFrame
    ContentPanel.Size = UDim2.new(1, -165, 1, -65)
    ContentPanel.Position = UDim2.new(0, 160, 0, 60)
    ContentPanel.BackgroundTransparency = 1
    
    -- Функция создания кнопки категории
    local function CreateCategoryButton(name, yPos)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Parent = CategoryPanel
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = btn
        btnCorner.CornerRadius = UDim.new(0, 6)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0.1
        end)
        btn.MouseLeave:Connect(function()
            if CurrentCategory ~= name then
                btn.BackgroundTransparency = 0.3
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            -- Сброс всех кнопок
            for _, b in pairs(CategoryButtons) do
                b.BackgroundTransparency = 0.3
                b.TextColor3 = Color3.fromRGB(200, 200, 220)
            end
            btn.BackgroundTransparency = 0
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            CurrentCategory = name
            LoadCategoryContent(name)
        end)
        
        return btn
    end
    
    -- Функция загрузки контента категории
    local function LoadCategoryContent(category)
        -- Очищаем контент
        for _, child in pairs(ContentPanel:GetChildren()) do
            child:Destroy()
        end
        
        local title = Instance.new("TextLabel")
        title.Parent = ContentPanel
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.Text = "📂 " .. category
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Parent = ContentPanel
        scrollFrame.Size = UDim2.new(1, -20, 1, -45)
        scrollFrame.Position = UDim2.new(0, 10, 0, 40)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 255)
        
        local yPos = 0
        
        -- Функция создания элемента в категории
        local function AddToggle(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Parent = scrollFrame
            frame.Size = UDim2.new(1, 0, 0, 30)
            frame.Position = UDim2.new(0, 0, 0, yPos)
            frame.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            
            local btn = Instance.new("TextButton")
            btn.Parent = frame
            btn.Size = UDim2.new(0, 60, 0.7, 0)
            btn.Position = UDim2.new(1, -70, 0.15, 0)
            btn.Text = default and "Вкл" or "Выкл"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Font = Enum.Font.GothamBold
            btn.BackgroundColor3 = default and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(60, 60, 70)
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.Parent = btn
            btnCorner.CornerRadius = UDim.new(0, 4)
            
            local state = default
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = state and "Вкл" or "Выкл"
                btn.BackgroundColor3 = state and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(60, 60, 70)
                if callback then callback(state) end
            end)
            
            yPos = yPos + 35
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
        end
        
        local function AddSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Parent = scrollFrame
            frame.Size = UDim2.new(1, 0, 0, 50)
            frame.Position = UDim2.new(0, 0, 0, yPos)
            frame.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Text = text .. ": " .. tostring(default)
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = frame
            sliderFrame.Size = UDim2.new(1, 0, 0, 20)
            sliderFrame.Position = UDim2.new(0, 0, 0, 25)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            sliderFrame.BorderSizePixel = 0
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.Parent = sliderFrame
            sliderCorner.CornerRadius = UDim.new(0, 4)
            
            local fill = Instance.new("Frame")
            fill.Parent = sliderFrame
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
            fill.BorderSizePixel = 0
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.Parent = fill
            fillCorner.CornerRadius = UDim.new(0, 4)
            
            local value = default
            local dragging = false
            
            sliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local x = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * x
                    value = math.round(value)
                    fill.Size = UDim2.new(x, 0, 1, 0)
                    label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local x = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * x
                    value = math.round(value)
                    fill.Size = UDim2.new(x, 0, 1, 0)
                    label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end
            end)
            
            yPos = yPos + 60
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
        end
        
        -- Контент для каждой категории
        if category == "Aimbot" then
            AddToggle("Включить Aimbot", false, function(s) print("Aimbot:", s) end)
            AddToggle("Цель в голову", true, function(s) print("Headshot:", s) end)
            AddToggle("Авто-стрельба", false, function(s) print("AutoFire:", s) end)
            AddSlider("Радиус цели", 50, 500, 200, function(s) print("Radius:", s) end)
            AddSlider("Скорость наведения", 1, 20, 10, function(s) print("Speed:", s) end)
            
        elseif category == "Visuals" then
            AddToggle("ESP игроков", true, function(s) print("ESP:", s) end)
            AddToggle("Линии к цели", false, function(s) print("Lines:", s) end)
            AddToggle("Чембоксы", true, function(s) print("Chams:", s) end)
            AddToggle("Называние игроков", true, function(s) print("Names:", s) end)
            AddSlider("Дальность ESP", 50, 500, 300, function(s) print("ESP Distance:", s) end)
            
        elseif category == "Player" then
            AddToggle("Бессмертие", false, function(s) print("GodMode:", s) end)
            AddToggle("Бесконечный спринт", true, function(s) print("Infinite Sprint:", s) end)
            AddToggle("Быстрое падение", false, function(s) print("Fast Fall:", s) end)
            AddSlider("Скорость ходьбы", 16, 100, 25, function(s) print("WalkSpeed:", s) end)
            AddSlider("Сила прыжка", 50, 200, 100, function(s) print("JumpPower:", s) end)
            
        elseif category == "Movement" then
            AddToggle("Полет (Noclip)", false, function(s) print("Fly:", s) end)
            AddToggle("Телепорт к цели", false, function(s) print("Teleport:", s) end)
            AddToggle("Быстрое плавание", false, function(s) print("Fast Swim:", s) end)
            AddSlider("Скорость полета", 10, 100, 50, function(s) print("Fly Speed:", s) end)
            
        elseif category == "Misc" then
            AddToggle("Anti-AFK", true, function(s) print("AntiAFK:", s) end)
            AddToggle("Авто-фарм", false, function(s) print("AutoFarm:", s) end)
            AddToggle("Блокировка киков", true, function(s) print("AntiKick:", s) end)
            AddToggle("Скрыть GUI (INSERT)", false, function(s) 
                MainFrame.Visible = not MainFrame.Visible
            end)
        end
    end
    
    -- Создаём кнопки категорий
    for i, cat in ipairs(Categories) do
        local btn = CreateCategoryButton(cat, 10 + (i - 1) * 45)
        CategoryButtons[cat] = btn
    end
    
    -- Выбираем первую категорию
    if CategoryButtons["Aimbot"] then
        CategoryButtons["Aimbot"].MouseButton1Click:Fire()
    end
    
    -- Кнопка закрытия
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -45, 0, 15)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.MouseButton1Click:Connect(function()
        MenuGui:Destroy()
    end)
    
    -- Перетаскивание
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < 60 then
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
end

-- ============================================
-- 5. ЗАПУСК
-- ============================================

print("🔐 Запуск системы авторизации...")
CreateAuthWindow()
print("✅ Готово! Введите ключ из key.json")
print("📋 Тестовые ключи: FREE-2024, PREMIUM-2025, ADMIN-666")
