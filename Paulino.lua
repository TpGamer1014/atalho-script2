-- ==========================================
-- PAULINO MM2 - SCRIPT COMPLETO (FINAL)
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Limpa versões antigas antes de carregar
local function cleanOldGui()
    local target = gethui and gethui() or (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if target and target:FindFirstChild("PaulinoGUI") then
        target.PaulinoGUI:Destroy()
    end
end
cleanOldGui()

_G.PaulinoMenuRunning = true

local lobbyFarmAtivo = false
local xpFarmAtivo = false
local espActive = false
local aimbotActive = false
local freecamActive = false
local aFazerFling = false
local antiAfkAtivo = false

-- Variáveis de Velocidade e Pulo
local customSpeed = 16
local customJump = 50
local speedActive = false
local jumpActive = false

local antiFlingConnection = nil
local freecamConn = nil

-- ==========================================
-- ANTI-AFK LOGIC
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if antiAfkAtivo then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- LOOP DE VELOCIDADE E PULO (0 A 100)
-- ==========================================
RunService.Stepped:Connect(function()
    if not _G.PaulinoMenuRunning then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedActive then
            hum.WalkSpeed = customSpeed
        end
        if jumpActive then
            hum.UseJumpPower = true
            hum.JumpPower = customJump
        end
    end
end)

-- ==========================================
-- VERIFICAÇÕES DE ROUND E VIDA
-- ==========================================
local function isLocalAlive()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function isRoundActive()
    local map = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("Map")
    local coinContainer = Workspace:FindFirstChild("CoinContainer", true)
    return (map ~= nil or coinContainer ~= nil)
end

-- ==========================================
-- ANTI-FLING PASSIVO
-- ==========================================
local function iniciarAntiFling()
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    antiFlingConnection = RunService.Stepped:Connect(function()
        if not _G.PaulinoMenuRunning or aFazerFling then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end
pcall(iniciarAntiFling)

-- ==========================================
-- CRIAÇÃO DA GUI
-- ==========================================
local function getGuiContainer()
    if gethui then return gethui() end
    local success, coreGui = pcall(function() return CoreGui end)
    if success and coreGui then return coreGui end
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
end

local parentContainer = getGuiContainer()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PaulinoGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = parentContainer

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Transparency = 0.3
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
TopBar.BackgroundTransparency = 0.25
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "☀️ Paulino Hub - MM2"
Title.TextColor3 = Color3.fromRGB(20, 20, 30)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 25)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(30, 30, 40)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BackgroundColor3 = Color3.fromRGB(210, 210, 225)
MinimizeButton.BackgroundTransparency = 0.3
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- BOTÃO MINIMIZADO CUSTOMIZADO (AJUSTADO PARA CIMA: Y = 0.35)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 135, 0, 38)
OpenButton.AnchorPoint = Vector2.new(0, 0.5)
OpenButton.Position = UDim2.new(0, 0, 0.35, 0) -- Movido mais para cima
OpenButton.Text = "☀️  🌸 Paulin"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 15
OpenButton.Font = Enum.Font.GothamBold
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 18, 22)
OpenButton.BackgroundTransparency = 0.05
OpenButton.BorderSizePixel = 0
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 19)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 2.5
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OpenStroke.Parent = OpenButton

local OpenGradient = Instance.new("UIGradient")
OpenGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 160))
})
OpenGradient.Parent = OpenStroke

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    OpenButton.Visible = minimized
end)

OpenButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Visible = not minimized
    OpenButton.Visible = minimized
end)

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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Sidebar & Páginas
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(235, 235, 245)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 300)
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -140, 1, -35)
ContentContainer.Position = UDim2.new(0, 140, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 520)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = page
    
    pages[name] = page
    return page
end

local function createTabButton(name, displayName, default)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Text = "    " .. displayName
    btn.TextColor3 = default and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(90, 90, 105)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(225, 225, 235)
    btn.BackgroundTransparency = default and 0.2 or 0.5
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
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
createTabButton("Combat", "Combate / TP", false)
createTabButton("Visuals", "Visual / ESP", false)
createTabButton("Camera", "Câmera", false)
createTabButton("Troll", "🤡 Troll", false)

local function addButton(page, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.Parent = page
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(220, 220, 235)
    stroke.Transparency = 0.4
    stroke.Parent = btn
    return btn
end

local function addLabel(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(50, 50, 65)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = page
    return lbl
end

local function addNumberInput(page, labelText, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.4
    frame.Parent = page

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(30, 30, 40)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.28, 0, 0.7, 0)
    box.Position = UDim2.new(0.7, -5, 0.15, 0)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(20, 20, 30)
    box.TextSize = 12
    box.Font = Enum.Font.GothamBold
    box.BackgroundColor3 = Color3.fromRGB(230, 230, 240)
    box.Parent = frame

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = box

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            val = math.clamp(val, 0, 100)
            box.Text = tostring(val)
            callback(val)
        else
            box.Text = tostring(defaultVal)
        end
    end)
end

addLabel(pages.Home, "Bem-vindo ao Paulino Hub!")

local AntiAfkBtn = addButton(pages.Home, "Anti-AFK: DESLIGADO")
AntiAfkBtn.MouseButton1Click:Connect(function()
    antiAfkAtivo = not antiAfkAtivo
    AntiAfkBtn.Text = antiAfkAtivo and "Anti-AFK: LIGADO" or "Anti-AFK: DESLIGADO"
    AntiAfkBtn.BackgroundColor3 = antiAfkAtivo and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    AntiAfkBtn.TextColor3 = antiAfkAtivo and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
end)

local CloseBtn = addButton(pages.Home, "Parar Tudo / Fechar Hub")
CloseBtn.MouseButton1Click:Connect(function()
    _G.PaulinoMenuRunning = false
    lobbyFarmAtivo = false
    xpFarmAtivo = false
    espActive = false
    antiAfkAtivo = false
    speedActive = false
    jumpActive = false
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    if ScreenGui then ScreenGui:Destroy() end
end)

-- ==========================================
-- ROLES
-- ==========================================
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
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getPlayerTool(p) == "Knife" then return p end
    end
    return nil
end

local function getSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getPlayerTool(p) == "Gun" then return p end
    end
    return nil
end

local function getPlayerColorAndRole(p)
    local tool = getPlayerTool(p)
    if tool == "Knife" or p == getMurderer() then return Color3.fromRGB(220, 40, 40), "[Murderer]" end
    if tool == "Gun" or p == getSheriff() then return Color3.fromRGB(20, 120, 220), "[Sheriff]" end
    return Color3.fromRGB(50, 255, 50), "[Inocente]"
end

-- ==========================================
-- PEGAR ARMA
-- ==========================================
local function grabGunFromFloor()
    task.spawn(function()
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local gunPart = Workspace:FindFirstChild("GunDrop")
        if not gunPart then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name == "GunDrop" or obj.Name == "Gun" or obj.Name:lower():find("gundrop") then
                    gunPart = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                    if gunPart then break end
                end
            end
        end

        if gunPart then
            local savedCFrame = myRoot.CFrame
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.CFrame = gunPart.CFrame
            task.wait(0.25)
            myRoot.CFrame = savedCFrame
            myRoot.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

-- ==========================================
-- ABA COMBATE & MOVIMENTO
-- ==========================================
local SpeedToggleBtn = addButton(pages.Combat, "Alterar Velocidade: DESLIGADO")
addNumberInput(pages.Combat, "Velocidade (0-100):", 16, function(val)
    customSpeed = val
end)

SpeedToggleBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    SpeedToggleBtn.Text = speedActive and "Alterar Velocidade: LIGADO" or "Alterar Velocidade: DESLIGADO"
    SpeedToggleBtn.BackgroundColor3 = speedActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    SpeedToggleBtn.TextColor3 = speedActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
    if not speedActive then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

local JumpToggleBtn = addButton(pages.Combat, "Alterar Pulo: DESLIGADO")
addNumberInput(pages.Combat, "Força do Pulo (0-100):", 50, function(val)
    customJump = val
end)

JumpToggleBtn.MouseButton1Click:Connect(function()
    jumpActive = not jumpActive
    JumpToggleBtn.Text = jumpActive and "Alterar Pulo: LIGADO" or "Alterar Pulo: DESLIGADO"
    JumpToggleBtn.BackgroundColor3 = jumpActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    JumpToggleBtn.TextColor3 = jumpActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
    if not jumpActive then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = 50 end
    end
end)

local AimbotButton = addButton(pages.Combat, "Aimbot (E): DESLIGADO")
local GrabGunButton = addButton(pages.Combat, "Pegar Arma do Chão (G)")
local TpNearestButton = addButton(pages.Combat, "Teleportar Próximo (R)")
local SelectPlayerButton = addButton(pages.Combat, "Selecionar Jogador para TP")

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    AimbotButton.Text = aimbotActive and "Aimbot (E): LIGADO" or "Aimbot (E): DESLIGADO"
    AimbotButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    AimbotButton.TextColor3 = aimbotActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
end)

RunService.RenderStepped:Connect(function()
    if not _G.PaulinoMenuRunning or not aimbotActive then return end
    local targetP = getMurderer() or getSheriff()
    if targetP and targetP.Character then
        local targetPart = targetP.Character:FindFirstChild("HumanoidRootPart") or targetP.Character:FindFirstChild("Head")
        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

GrabGunButton.MouseButton1Click:Connect(grabGunFromFloor)

local function teleportToNearest()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local nearest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d nearest = p.Character.HumanoidRootPart end
        end
    end
    if nearest then myRoot.CFrame = nearest.CFrame + Vector3.new(0, 3, 0) end
end
TpNearestButton.MouseButton1Click:Connect(teleportToNearest)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then grabGunFromFloor()
    elseif input.KeyCode == Enum.KeyCode.R then teleportToNearest()
    elseif input.KeyCode == Enum.KeyCode.E then
        aimbotActive = not aimbotActive
        AimbotButton.Text = aimbotActive and "Aimbot (E): LIGADO" or "Aimbot (E): DESLIGADO"
        AimbotButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
        AimbotButton.TextColor3 = aimbotActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
    end
end)

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0, 180, 0, 180)
PlayerListFrame.Position = UDim2.new(1, 10, 0, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
PlayerListFrame.BackgroundTransparency = 0.2
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
PlayerListFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerListFrame

SelectPlayerButton.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        for _, child in ipairs(PlayerListFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Text = " " .. p.Name .. " " .. role
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.BorderSizePixel = 0
                btn.Parent = PlayerListFrame
                
                btn.MouseButton1Click:Connect(function()
                    local targetRoot = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and myRoot then myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0) end
                    PlayerListFrame.Visible = false
                end)
            end
        end
    end
end)

-- ==========================================
-- ABA AUTO FARM
-- ==========================================
local AutoLobbyBtn = addButton(pages.Farm, "Auto Lobby Farm: DESLIGADO")
local FarmXpBtn = addButton(pages.Farm, "FarmXP (Lobby All Rounds): DESLIGADO")

AutoLobbyBtn.MouseButton1Click:Connect(function()
    lobbyFarmAtivo = not lobbyFarmAtivo
    AutoLobbyBtn.Text = lobbyFarmAtivo and "Auto Lobby Farm: LIGADO" or "Auto Lobby Farm: DESLIGADO"
    AutoLobbyBtn.BackgroundColor3 = lobbyFarmAtivo and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    AutoLobbyBtn.TextColor3 = lobbyFarmAtivo and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
end)

FarmXpBtn.MouseButton1Click:Connect(function()
    xpFarmAtivo = not xpFarmAtivo
    FarmXpBtn.Text = xpFarmAtivo and "FarmXP (Lobby All Rounds): LIGADO" or "FarmXP (Lobby All Rounds): DESLIGADO"
    FarmXpBtn.BackgroundColor3 = xpFarmAtivo and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    FarmXpBtn.TextColor3 = xpFarmAtivo and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
end)

task.spawn(function()
    while ScreenGui.Parent do
        if lobbyFarmAtivo or xpFarmAtivo then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = CFrame.new(0, 150, 0)
                myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
        task.wait(1)
    end
end)

-- ==========================================
-- ABA VISUAL / ESP
-- ==========================================
local EspButton = addButton(pages.Visuals, "ESP Roles: DESLIGADO")

local function clearESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("PaulinoHighlight")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hl then hl:Destroy() end
            if hrp and hrp:FindFirstChild("PaulinoBillboard") then hrp.PaulinoBillboard:Destroy() end
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name:lower():find("gundrop") then
            local hl = obj:FindFirstChild("PaulinoGunHighlight")
            local bb = obj:FindFirstChild("PaulinoGunBillboard")
            if hl then hl:Destroy() end
            if bb then bb:Destroy() end
        end
    end
end

EspButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    EspButton.Text = espActive and "ESP Roles: LIGADO" or "ESP Roles: DESLIGADO"
    EspButton.BackgroundColor3 = espActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    EspButton.TextColor3 = espActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
    if not espActive then clearESP() end
end)

task.spawn(function()
    while ScreenGui.Parent do
        if espActive and isLocalAlive() and isRoundActive() then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local color, role = getPlayerColorAndRole(p)
                    
                    local hl = p.Character:FindFirstChild("PaulinoHighlight") or Instance.new("Highlight", p.Character)
                    hl.Name = "PaulinoHighlight"
                    hl.OutlineColor = color
                    hl.OutlineTransparency = 0
                    hl.FillColor = color
                    hl.FillTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    
                    local hrp = p.Character.HumanoidRootPart
                    local bb = hrp:FindFirstChild("PaulinoBillboard") or Instance.new("BillboardGui", hrp)
                    bb.Name = "PaulinoBillboard"
                    bb.Size = UDim2.new(0, 120, 0, 40)
                    bb.StudsOffset = Vector3.new(0, -3.5, 0)
                    bb.AlwaysOnTop = true
                    
                    local lbl = bb:FindFirstChild("Tag") or Instance.new("TextLabel", bb)
                    lbl.Name = "Tag"
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = color
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12
                    lbl.Text = p.Name .. "\n" .. role
                end
            end
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj.Name == "GunDrop" or obj.Name:lower():find("gundrop")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                    local targetPart = obj:IsA("BasePart") and obj or (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
                    if targetPart then
                        local gunColor = Color3.fromRGB(0, 150, 255)
                        
                        local hl = targetPart:FindFirstChild("PaulinoGunHighlight") or Instance.new("Highlight", targetPart)
                        hl.Name = "PaulinoGunHighlight"
                        hl.OutlineColor = gunColor
                        hl.OutlineTransparency = 0
                        hl.FillColor = gunColor
                        hl.FillTransparency = 1
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                        local bb = targetPart:FindFirstChild("PaulinoGunBillboard") or Instance.new("BillboardGui", targetPart)
                        bb.Name = "PaulinoGunBillboard"
                        bb.Size = UDim2.new(0, 120, 0, 30)
                        bb.StudsOffset = Vector3.new(0, -2, 0)
                        bb.AlwaysOnTop = true

                        local lbl = bb:FindFirstChild("Tag") or Instance.new("TextLabel", bb)
                        lbl.Name = "Tag"
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = gunColor
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 12
                        lbl.Text = "[Arma Droppada]"
                    end
                end
            end
        else
            clearESP()
        end
        task.wait(0.4)
    end
end)

-- ==========================================
-- ABA CÂMERA
-- ==========================================
local FreecamLivreBtn = addButton(pages.Camera, "Freecam Livre: DESLIGADO")
local FreecamPlayerButton = addButton(pages.Camera, "Espectar Jogador")
local ResetCamButton = addButton(pages.Camera, "Voltar Câmera ao Normal")

local freecamRotX = 0
local freecamRotY = 0

FreecamLivreBtn.MouseButton1Click:Connect(function()
    freecamActive = not freecamActive
    FreecamLivreBtn.Text = freecamActive and "Freecam Livre: LIGADO" or "Freecam Livre: DESLIGADO"
    FreecamLivreBtn.BackgroundColor3 = freecamActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(255, 255, 255)
    FreecamLivreBtn.TextColor3 = freecamActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(25, 25, 35)
    
    if freecamActive then
        Camera.CameraType = Enum.CameraType.Scriptable
        local rx, ry, _ = Camera.CFrame:ToOrientation()
        freecamRotX = rx
        freecamRotY = ry
        
        if freecamConn then freecamConn:Disconnect() end
        
        freecamConn = RunService.RenderStepped:Connect(function()
            if not freecamActive then return end
            
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                local delta = UserInputService:GetMouseDelta()
                local sens = 0.004
                freecamRotY = freecamRotY - delta.X * sens
                freecamRotX = math.clamp(freecamRotX - delta.Y * sens, math.rad(-89), math.rad(89))
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
            
            local camRot = CFrame.Angles(0, freecamRotY, 0) * CFrame.Angles(freecamRotX, 0, 0)
            local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 2 or 0.8
            local moveDir = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camRot.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camRot.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRot.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRot.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            Camera.CFrame = CFrame.new(Camera.CFrame.Position + (moveDir * speed)) * camRot
        end)
    else
        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)

local CameraListFrame = Instance.new("ScrollingFrame")
CameraListFrame.Size = UDim2.new(0, 180, 0, 180)
CameraListFrame.Position = UDim2.new(1, 10, 0, 60)
CameraListFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
CameraListFrame.BackgroundTransparency = 0.2
CameraListFrame.BorderSizePixel = 0
CameraListFrame.Visible = false
CameraListFrame.Parent = MainFrame

local CamListLayout = Instance.new("UIListLayout")
CamListLayout.Parent = CameraListFrame

FreecamPlayerButton.MouseButton1Click:Connect(function()
    CameraListFrame.Visible = not CameraListFrame.Visible
    if CameraListFrame.Visible then
        for _, child in ipairs(CameraListFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Text = " 👁️ " .. p.Name
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.BorderSizePixel = 0
                btn.Parent = CameraListFrame
                
                btn.MouseButton1Click:Connect(function()
                    if freecamActive then
                        freecamActive = false
                        FreecamLivreBtn.Text = "Freecam Livre: DESLIGADO"
                        FreecamLivreBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        FreecamLivreBtn.TextColor3 = Color3.fromRGB(25, 25, 35)
                        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    end
                    if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                        Camera.CameraType = Enum.CameraType.Custom
                        Camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
                        FreecamPlayerButton.Text = "Espectando: " .. p.Name
                        FreecamPlayerButton.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
                        FreecamPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                    CameraListFrame.Visible = false
                end)
            end
        end
    end
end)

ResetCamButton.MouseButton1Click:Connect(function()
    if freecamActive then
        freecamActive = false
        FreecamLivreBtn.Text = "Freecam Livre: DESLIGADO"
        FreecamLivreBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FreecamLivreBtn.TextColor3 = Color3.fromRGB(25, 25, 35)
        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        FreecamPlayerButton.Text = "Espectar Jogador"
        FreecamPlayerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FreecamPlayerButton.TextColor3 = Color3.fromRGB(25, 25, 35)
    end
end)

-- ==========================================
-- ABA TROLL
-- ==========================================
local KillMurderBtn = addButton(pages.Troll, "⚔️ Matar Murderer (Fling)")
local KillSheriffBtn = addButton(pages.Troll, "🛡️ Matar Sheriff (Fling)")
local SelectFlingBtn = addButton(pages.Troll, "🌀 Fling em Jogador Específico")

local function performFling(targetP, duration)
    if not targetP or not targetP.Character then return end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetHrp = targetP.Character:FindFirstChild("HumanoidRootPart")
    
    if not myHrp or not targetHrp then return end
    
    aFazerFling = true
    local savedCFrame = myHrp.CFrame
    
    local bV = Instance.new("BodyVelocity")
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Velocity = Vector3.new(0, 0, 0)
    bV.Parent = myHrp
    
    local bAV = Instance.new("BodyAngularVelocity")
    bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bAV.AngularVelocity = Vector3.new(0, 99999, 0)
    bAV.Parent = myHrp
    
    local startTime = tick()
    while (tick() - startTime) < (duration or 1.0) and targetHrp and targetHrp.Parent do
        myHrp.CFrame = targetHrp.CFrame
        RunService.Heartbeat:Wait()
    end
    
    bV:Destroy()
    bAV:Destroy()
    
    myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    if myHum then myHum.Sit = false end
    
    task.wait(0.05)
    myHrp.CFrame = savedCFrame
    task.wait(0.05)
    myHrp.CFrame = savedCFrame
    myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    aFazerFling = false
end

local function ativarFlingTemporario(btn, textoOriginal, getAlvoFunc)
    if btn.BackgroundColor3 == Color3.fromRGB(40, 180, 90) then return end
    btn.Text = textoOriginal .. ": ATIVO..."
    btn.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    task.spawn(function()
        performFling(getAlvoFunc(), 1.0)
        btn.Text = textoOriginal
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextColor3 = Color3.fromRGB(25, 25, 35)
    end)
end

KillMurderBtn.MouseButton1Click:Connect(function()
    ativarFlingTemporario(KillMurderBtn, "⚔️ Matar Murderer (Fling)", getMurderer)
end)

KillSheriffBtn.MouseButton1Click:Connect(function()
    ativarFlingTemporario(KillSheriffBtn, "🛡️ Matar Sheriff (Fling)", getSheriff)
end)

local FlingListFrame = Instance.new("ScrollingFrame")
FlingListFrame.Size = UDim2.new(0, 180, 0, 180)
FlingListFrame.Position = UDim2.new(1, 10, 0, 100)
FlingListFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
FlingListFrame.BackgroundTransparency = 0.2
FlingListFrame.BorderSizePixel = 0
FlingListFrame.Visible = false
FlingListFrame.Parent = MainFrame

local FlingListLayout = Instance.new("UIListLayout")
FlingListLayout.Parent = FlingListFrame

SelectFlingBtn.MouseButton1Click:Connect(function()
    FlingListFrame.Visible = not FlingListFrame.Visible
    if FlingListFrame.Visible then
        for _, child in ipairs(FlingListFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Text = " 💥 " .. p.Name .. " " .. role
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.BorderSizePixel = 0
                btn.Parent = FlingListFrame
                
                btn.MouseButton1Click:Connect(function()
                    FlingListFrame.Visible = false
                    task.spawn(function()
                        performFling(p, 1.0)
                    end)
                end)
            end
        end
    end
end)
