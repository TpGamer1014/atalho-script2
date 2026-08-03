-- ==========================================
-- PAULINO HUB MM2 - COMPLETO E CORRIGIDO
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function getSafeParent()
    if gethui then
        local ok, res = pcall(gethui)
        if ok and res then return res end
    end
    local ok, res = pcall(function() return CoreGui end)
    if ok and res then return res end
    return LocalPlayer:WaitForChild("PlayerGui")
end

if getSafeParent():FindFirstChild("PaulinoGUI") then
    getSafeParent().PaulinoGUI:Destroy()
end

_G.PaulinoMenuRunning = true

local lobbyFarmAtivo = false
local xpFarmAtivo = false
local espActive = false
local aimbotActive = false
local aFazerFling = false
local antiAfkAtivo = false

local customSpeed = 16
local customJump = 50
local speedActive = false
local jumpActive = false

local antiFlingConnection = nil

LocalPlayer.Idled:Connect(function()
    if antiAfkAtivo then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

RunService.Stepped:Connect(function()
    if not _G.PaulinoMenuRunning then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedActive then hum.WalkSpeed = customSpeed end
        if jumpActive then
            hum.UseJumpPower = true
            hum.JumpPower = customJump
        end
    end
end)

local function isLocalAlive()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function isRoundActive()
    return Workspace:FindFirstChild("Normal") ~= nil or Workspace:FindFirstChild("Map") ~= nil or Workspace:FindFirstChild("CoinContainer", true) ~= nil
end

-- Anti-Fling Seguro
pcall(function()
    antiFlingConnection = RunService.Stepped:Connect(function()
        if not _G.PaulinoMenuRunning or aFazerFling then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PaulinoGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = getSafeParent()

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.3

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
TopBar.BackgroundTransparency = 0.25
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "☀️ Paulino Hub - MM2"
Title.TextColor3 = Color3.fromRGB(20, 20, 30)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeButton = Instance.new("TextButton", TopBar)
MinimizeButton.Size = UDim2.new(0, 30, 0, 25)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(30, 30, 40)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(210, 210, 225)
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

local OpenButtonBg = Instance.new("Frame", ScreenGui)
OpenButtonBg.Size = UDim2.new(0, 95, 0, 24)
OpenButtonBg.Position = UDim2.new(0, 10, 0, 200)
OpenButtonBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenButtonBg.BackgroundTransparency = 0.5
OpenButtonBg.Visible = false
Instance.new("UICorner", OpenButtonBg).CornerRadius = UDim.new(1, 0)

local OpenButton = Instance.new("TextButton", OpenButtonBg)
OpenButton.Size = UDim2.new(1, 0, 1, 0)
OpenButton.BackgroundTransparency = 1
OpenButton.Text = "☀️  🌸 Paulin"
OpenButton.TextColor3 = Color3.fromRGB(20, 20, 30)
OpenButton.TextSize = 11

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    OpenButtonBg.Visible = minimized
end)
OpenButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    OpenButtonBg.Visible = minimized
end)

-- Dragging
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(235, 235, 245)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 300)
Sidebar.ScrollBarThickness = 2
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 4)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -140, 1, -35)
ContentContainer.Position = UDim2.new(0, 140, 0, 35)
ContentContainer.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 520)
    page.ScrollBarThickness = 4
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pages[name] = page
    return page
end

local function createTabButton(name, displayName, default)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Text = "    " .. displayName
    btn.TextColor3 = default and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(90, 90, 105)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(225, 225, 235)
    btn.BackgroundTransparency = default and 0.2 or 0.5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local page = createPage(name)
    if default then page.Visible = true end
    
    btn.MouseButton1Click:Connect(function()
        for pName, pObj in pairs(pages) do pObj.Visible = (pName == name) end
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(225, 225, 235)
                b.BackgroundTransparency = 0.5
                b.TextColor3 = Color3.fromRGB(90, 90, 105)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.fromRGB(20, 20, 30)
    end)
end

createTabButton("Home", "Início", true)
createTabButton("Farm", "Auto Farm", false)
createTabButton("Combat", "Combate", false)
createTabButton("Visuals", "Visual", false)
createTabButton("Camera", "Câmera", false)
createTabButton("Troll", "🤡 Troll", false)

local function addButton(page, text)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.25
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Home
addButton(pages.Home, "Bem-vindo ao Paulino Hub").BackgroundTransparency = 1
local AntiAfkBtn = addButton(pages.Home, "Anti-AFK: DESLIGADO")
AntiAfkBtn.MouseButton1Click:Connect(function()
    antiAfkAtivo = not antiAfkAtivo
    AntiAfkBtn.Text = antiAfkAtivo and "Anti-AFK: LIGADO" or "Anti-AFK: DESLIGADO"
    AntiAfkBtn.BackgroundColor3 = antiAfkAtivo and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
end)

local CloseBtn = addButton(pages.Home, "Fechar Hub")
CloseBtn.MouseButton1Click:Connect(function()
    _G.PaulinoMenuRunning = false
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    if ScreenGui then ScreenGui:Destroy() end
end)

-- Funções Auxiliares de Jogo
local function getPlayerTool(p)
    if not p then return nil end
    local items = {}
    if p.Character then for _, v in ipairs(p.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v.Name:lower()) end end end
    if p.Backpack then for _, v in ipairs(p.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(items, v.Name:lower()) end end end
    for _, n in ipairs(items) do
        if n:find("knife") or n:find("faca") then return "Knife" end
        if n:find("gun") or n:find("arma") or n:find("revolver") then return "Gun" end
    end
    return nil
end

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and getPlayerTool(p) == "Knife" then return p end end
    return nil
end

local function getSheriff()
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and getPlayerTool(p) == "Gun" then return p end end
    return nil
end

-- Combat / Fling Funcional Isolado
local function runFlingOnPlayer(targetP)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetP or not targetP.Character or not targetP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local savedPos = myRoot.CFrame
    local targetRoot = targetP.Character.HumanoidRootPart
    local startTime = tick()
    aFazerFling = true
    
    for _, part in ipairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    
    local connection
    connection = RunService.Stepped:Connect(function()
        if targetRoot and targetRoot.Parent and myRoot and myRoot.Parent then
            myRoot.CFrame = targetRoot.CFrame * CFrame.Angles(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180))
            myRoot.AssemblyLinearVelocity = Vector3.new(30000, 30000, 30000)
            myRoot.AssemblyAngularVelocity = Vector3.new(30000, 30000, 30000)
        end
    end)
    
    while tick() - startTime < 1 do task.wait() end
    if connection then connection:Disconnect() end
    aFazerFling = false
    myRoot.CFrame = savedPos
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero
end

local FlingMurderBtn = addButton(pages.Troll, "Fling Murderer")
FlingMurderBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local m = getMurderer()
        if m then runFlingOnPlayer(m) end
    end)
end)

local FlingSheriffBtn = addButton(pages.Troll, "Fling Sheriff")
FlingSheriffBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local s = getSheriff()
        if s then runFlingOnPlayer(s) end
    end)
end)
