-- ==========================================
-- PAULINO MM2 - SCRIPT COMPLETO (CORRIGIDO)
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

_G.PaulinoMenuRunning = true

local xpFarmAtivo = false
local espActive = false
local aimbotActive = false
local freecamActive = false
local antiAfkAtivo = false

local xpFarmConnection = nil
local safePlatform = nil
local antiFlingConnection = nil
local freecamConn = nil
local trollSheriffConnection = nil
local trollMurderConnection = nil
local antiAfkConnection = nil

-- ==========================================
-- ANTI-FLING PASSIVO
-- ==========================================
local function iniciarAntiFling()
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    antiFlingConnection = RunService.Stepped:Connect(function()
        if not _G.PaulinoMenuRunning then return end
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
iniciarAntiFling()

-- ==========================================
-- CRIAÇÃO DA GUI
-- ==========================================
local function getGuiContainer()
    if gethui then return gethui() end
    local success, coreGui = pcall(function() return CoreGui end)
    if success and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local parentContainer = getGuiContainer()
if parentContainer:FindFirstChild("PaulinoGUI") then
    parentContainer.PaulinoGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PaulinoGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = parentContainer

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "☀️ Paulino Hub - MM2"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 25)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(240, 240, 245)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeButton.BackgroundTransparency = 0.3
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TopBar

-- ==========================================
-- BOTÃO MINIMIZADO (COM ANIMAÇÃO)
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 32, 0, 32)
OpenButton.Position = UDim2.new(0, -16, 0.5, -16)
OpenButton.Text = ""
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenButton.BackgroundTransparency = 0.5
OpenButton.BorderSizePixel = 0
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(80, 80, 100)
OpenStroke.Transparency = 0.5
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenButton

local minimized = false
local animating = false

local function alternarMenu()
    if animating then return end
    animating = true
    
    if not minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = OpenButton.Position + UDim2.new(0, 16, 0, 16)
        }):Play()
        
        task.wait(0.2)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 520, 0, 360)
        MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
        
        OpenButton.Size = UDim2.new(0, 0, 0, 0)
        OpenButton.Visible = true
        TweenService:Create(OpenButton, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 32, 0, 32)
        }):Play()
        
        minimized = true
    else
        TweenService:Create(OpenButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        task.wait(0.15)
        OpenButton.Visible = false
        OpenButton.Size = UDim2.new(0, 32, 0, 32)
        
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.Visible = true
        
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 360),
            Position = UDim2.new(0.5, -260, 0.5, -180)
        }):Play()
        
        minimized = false
    end
    
    task.wait(0.25)
    animating = false
end

MinimizeButton.MouseButton1Click:Connect(alternarMenu)

OpenButton.MouseButton1Click:Connect(function()
    if not OpenButton:GetAttribute("IsDragging") then
        alternarMenu()
    end
end)

local openDragging = false
local openDragStart, openStartPos

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        OpenButton:SetAttribute("IsDragging", false)
        openDragStart = input.Position
        openStartPos = OpenButton.AbsolutePosition
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if openDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - openDragStart
        if delta.Magnitude > 5 then
            OpenButton:SetAttribute("IsDragging", true)
        end
        local newX = openStartPos.X + delta.X
        local newY = openStartPos.Y + delta.Y
        OpenButton.Position = UDim2.new(0, newX, 0, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if openDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        openDragging = false
        
        local viewportSize = Camera.ViewportSize
        local currentAbsPos = OpenButton.AbsolutePosition
        local targetX = (currentAbsPos.X < viewportSize.X / 2) and -16 or (viewportSize.X - 16)
        local targetY = math.clamp(currentAbsPos.Y, -16, viewportSize.Y - 16)
        
        TweenService:Create(OpenButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetX, 0, targetY)
        }):Play()
        
        task.delay(0.1, function()
            OpenButton:SetAttribute("IsDragging", false)
        end)
    end
end)

-- Arrastar GUI Principal
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
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
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
    page.CanvasSize = UDim2.new(0, 0, 0, 480)
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
    btn.Text = "  " .. displayName
    btn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = default and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(20, 20, 24)
    btn.BackgroundTransparency = default and 0.3 or 0.6
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local page = createPage(name)
    if default then page.Visible = true end
    
    btn.MouseButton1Click:Connect(function()
        for pName, pObj in pairs(pages) do 
            if pName == name then
                pObj.Visible = true
                pObj.Position = UDim2.new(0, 20, 0, 0)
                pObj.BackgroundTransparency = 1
                TweenService:Create(pObj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
            else
                pObj.Visible = false
            end
        end
        
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
                b.BackgroundTransparency = 0.6
                b.TextColor3 = Color3.fromRGB(160, 160, 170)
            end
        end
        
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            BackgroundTransparency = 0.3
        }):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabButton("Home", "Início", true)
createTabButton("Farm", "Farm de XP", false)
createTabButton("Combat", "Combate / TP", false)
createTabButton("Visuals", "Visual / ESP", false)
createTabButton("Camera", "Câmera", false)
createTabButton("Troll", "🤡 Troll", false)

local function addButton(page, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 240, 245)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Parent = page
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local function addLabel(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 190)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = page
    return lbl
end

addLabel(pages.Home, "Bem-vindo ao Paulino Hub!")

local AntiAfkButton = addButton(pages.Home, "Anti-AFK: DESLIGADO")
AntiAfkButton.MouseButton1Click:Connect(function()
    antiAfkAtivo = not antiAfkAtivo
    AntiAfkButton.Text = antiAfkAtivo and "Anti-AFK: LIGADO" or "Anti-AFK: DESLIGADO"
    AntiAfkButton.BackgroundColor3 = antiAfkAtivo and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    
    if antiAfkAtivo then
        if not antiAfkConnection then
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
end)

local CloseBtn = addButton(pages.Home, "Parar Tudo / Fechar Hub")
CloseBtn.MouseButton1Click:Connect(function()
    _G.PaulinoMenuRunning = false
    xpFarmAtivo = false
    espActive = false
    antiAfkAtivo = false
    if xpFarmConnection then xpFarmConnection:Disconnect() end
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    if antiAfkConnection then antiAfkConnection:Disconnect() end
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

local function partidaComecou()
    for _, p in ipairs(Players:GetPlayers()) do
        if getPlayerTool(p) ~= nil then
            return true
        end
    end
    return false
end

local function getPlayerColorAndRole(p)
    local tool = getPlayerTool(p)
    if tool == "Knife" or p == getMurderer() then return Color3.fromRGB(255, 50, 50), "[Murderer]" end
    if tool == "Gun" or p == getSheriff() then return Color3.fromRGB(50, 150, 255), "[Sheriff]" end
    return Color3.fromRGB(50, 220, 80), "[Inocente]"
end

-- ==========================================
-- PEGAR ARMA (CORRIGIDO E OTIMIZADO)
-- ==========================================
local function grabGunFromFloor()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHumanoid then return end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj.Name == "GunDrop" or obj.Name:lower():find("gundrop")) and obj:IsA("BasePart") then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            
            local savedCFrame = myRoot.CFrame
            
            myRoot.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
            
            task.wait(0.05)
            
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myRoot.CFrame = savedCFrame
            break
        end
    end
end

-- ==========================================
-- ABA COMBATE (AIMBOT NORMAL)
-- ==========================================
local AimbotButton = addButton(pages.Combat, "Aimbot (E): DESLIGADO")
local GrabGunButton = addButton(pages.Combat, "Pegar Arma do Chão (G)")
local TpNearestButton = addButton(pages.Combat, "Teleportar Próximo (R)")
local SelectPlayerButton = addButton(pages.Combat, "Selecionar Jogador para TP")

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    AimbotButton.Text = aimbotActive and "Aimbot (E): LIGADO" or "Aimbot (E): DESLIGADO"
    AimbotButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
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
        AimbotButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    end
end)

-- ==========================================
-- FUNÇÃO AUXILIAR: CRIAR LISTA CINEMATOGRÁFICA (BLUR + CANTOS REDONDOS + ESCURO)
-- ==========================================
local function createCinematicList()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 190, 0, 190)
    container.Position = UDim2.new(1, 10, 0, 0)
    container.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.Visible = false
    container.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Camera

    local vignette = Instance.new("ImageLabel")
    vignette.Size = UDim2.new(1, 0, 1, 0)
    vignette.BackgroundTransparency = 1
    vignette.Image = "rbxassetid://4593925761"
    vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
    vignette.ImageTransparency = 0.5
    vignette.Parent = container

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    container:GetPropertyChangedSignal("Visible"):Connect(function()
        if container.Visible then
            TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 12}):Play()
        else
            TweenService:Create(blur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0}):Play()
        end
    end)

    return container, scroll
end

-- ==========================================
-- LISTA DE JOGADORES (COMBATE - TP)
-- ==========================================
local PlayerListFrame, PlayerScroll = createCinematicList()

SelectPlayerButton.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        for _, child in ipairs(PlayerScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 32)
                btn.Text = "  " .. p.Name .. " " .. role
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = PlayerScroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
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
-- ABA FARM (XP LOBBY/AFK)
-- ==========================================
local XpFarmButton = addButton(pages.Farm, "Farm de XP: DESLIGADO")

local function createSafePlatform()
    if not safePlatform then
        safePlatform = Instance.new("Part")
        safePlatform.Size = Vector3.new(50, 2, 50)
        safePlatform.Position = Vector3.new(0, 5000, 0)
        safePlatform.Anchored = true
        safePlatform.Transparency = 1
        safePlatform.Parent = Workspace
    end
end

XpFarmButton.MouseButton1Click:Connect(function()
    xpFarmAtivo = not xpFarmAtivo
    XpFarmButton.Text = xpFarmAtivo and "Farm de XP: LIGADO" or "Farm de XP: DESLIGADO"
    XpFarmButton.BackgroundColor3 = xpFarmAtivo and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    
    if xpFarmAtivo then
        createSafePlatform()
        if not xpFarmConnection then
            xpFarmConnection = RunService.RenderStepped:Connect(function()
                if not _G.PaulinoMenuRunning or not xpFarmAtivo then return end
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    myRoot.CFrame = CFrame.new(0, 5003, 0)
                    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    else
        if xpFarmConnection then 
            xpFarmConnection:Disconnect() 
            xpFarmConnection = nil 
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
end)

-- ==========================================
-- ABA VISUAL / ESP
-- ==========================================
local EspButton = addButton(pages.Visuals, "ESP: DESLIGADO")

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
    EspButton.Text = espActive and "ESP: LIGADO" or "ESP: DESLIGADO"
    EspButton.BackgroundColor3 = espActive and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    if not espActive then clearESP() end
end)

task.spawn(function()
    while ScreenGui.Parent do
        if espActive and partidaComecou() then
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
                if (obj.Name == "GunDrop" or obj.Name:lower():find("gundrop")) and obj:IsA("BasePart") then
                    local gunColor = Color3.fromRGB(0, 170, 255)
                    
                    local hl = obj:FindFirstChild("PaulinoGunHighlight") or Instance.new("Highlight", obj)
                    hl.Name = "PaulinoGunHighlight"
                    hl.OutlineColor = gunColor
                    hl.OutlineTransparency = 0
                    hl.FillColor = gunColor
                    hl.FillTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                    local bb = obj:FindFirstChild("PaulinoGunBillboard") or Instance.new("BillboardGui", obj)
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
        else
            clearESP()
        end
        task.wait(0.4)
    end
end)

-- ==========================================
-- ABA CÂMERA & FREECAM
-- ==========================================
local FreecamLivreBtn = addButton(pages.Camera, "Freecam Livre: DESLIGADO")
local FreecamPlayerButton = addButton(pages.Camera, "Espectar Jogador")
local ResetCamButton = addButton(pages.Camera, "Voltar Câmera ao Normal")

local freecamRotX = 0
local freecamRotY = 0

FreecamLivreBtn.MouseButton1Click:Connect(function()
    freecamActive = not freecamActive
    FreecamLivreBtn.Text = freecamActive and "Freecam Livre: LIGADO" or "Freecam Livre: DESLIGADO"
    FreecamLivreBtn.BackgroundColor3 = freecamActive and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    
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

local CameraListFrame, CameraScroll = createCinematicList()
CameraListFrame.Position = UDim2.new(1, 10, 0, 50)

FreecamPlayerButton.MouseButton1Click:Connect(function()
    CameraListFrame.Visible = not CameraListFrame.Visible
    if CameraListFrame.Visible then
        for _, child in ipairs(CameraScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 32)
                btn.Text = "  👁️ " .. p.Name
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = CameraScroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    if freecamActive then
                        freecamActive = false
                        FreecamLivreBtn.Text = "Freecam Livre: DESLIGADO"
                        FreecamLivreBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    end
                    if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                        Camera.CameraType = Enum.CameraType.Custom
                        Camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
                        FreecamPlayerButton.Text = "Espectando: " .. p.Name
                        FreecamPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
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
        FreecamLivreBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        FreecamPlayerButton.Text = "Espectar Jogador"
        FreecamPlayerButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    end
end)

-- ==========================================
-- ABA TROLL & FLING MATAR
-- ==========================================
local KillMurderBtn = addButton(pages.Troll, "⚔️ Matar Murderer (Fling)")
local KillSheriffBtn = addButton(pages.Troll, "🛡️ Matar Sheriff (Fling)")
local FlingSelectBtn = addButton(pages.Troll, "🎯 Fling em Jogador Selecionado")
local TrollSheriffBtn = addButton(pages.Troll, "Paralisar Sheriff: DESLIGADO")
local TrollMurderBtn = addButton(pages.Troll, "Paralisar Murderer: DESLIGADO")

local function performFling(targetP, duration)
    if not targetP or not targetP.Character then return end
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetP.Character:FindFirstChild("HumanoidRootPart")
    
    if not myHrp or not targetHrp then return end
    
    local savedCFrame = myHrp.CFrame
    local bV = Instance.new("BodyVelocity")
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Velocity = Vector3.new(999999, 999999, 999999)
    bV.Parent = myHrp
    
    local startTime = tick()
    while (tick() - startTime) < (duration or 1.5) and targetHrp and targetHrp.Parent do
        myHrp.CFrame = targetHrp.CFrame + Vector3.new(math.random(-1, 1), 0, math.random(-1, 1))
        myHrp.AssemblyLinearVelocity = Vector3.new(999999, 999999, 999999)
        myHrp.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
        RunService.Heartbeat:Wait()
    end
    
    bV:Destroy()
    myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    myHrp.CFrame = savedCFrame
end

local function ativarFlingTemporario(btn, textoOriginal, getAlvoFunc)
    if btn.BackgroundColor3 == Color3.fromRGB(50, 160, 80) then return end
    btn.Text = textoOriginal .. ": ATIVO..."
    btn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
    
    task.spawn(function()
        performFling(getAlvoFunc(), 1.5)
        btn.Text = textoOriginal
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    end)
end

KillMurderBtn.MouseButton1Click:Connect(function()
    ativarFlingTemporario(KillMurderBtn, "⚔️ Matar Murderer (Fling)", getMurderer)
end)

KillSheriffBtn.MouseButton1Click:Connect(function()
    ativarFlingTemporario(KillSheriffBtn, "🛡️ Matar Sheriff (Fling)", getSheriff)
end)

local TrollListFrame, TrollScroll = createCinematicList()
TrollListFrame.Position = UDim2.new(1, 10, 0, 120)

FlingSelectBtn.MouseButton1Click:Connect(function()
    TrollListFrame.Visible = not TrollListFrame.Visible
    if TrollListFrame.Visible then
        for _, child in ipairs(TrollScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 32)
                btn.Text = "  💥 " .. p.Name
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = TrollScroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    TrollListFrame.Visible = false
                    ativarFlingTemporario(FlingSelectBtn, "🎯 Fling em Jogador Selecionado", function() return p end)
                end)
            end
        end
    end
end)

local function freezeTargetReal(p)
    if p and p.Character then
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        
        if hrp then
            if not p.Character:FindFirstChild("FrozenPos") then
                local posVal = Instance.new("CFrameValue")
                posVal.Name = "FrozenPos"
                posVal.Value = hrp.CFrame
                posVal.Parent = p.Character
            end
            
            local targetPos = p.Character.FrozenPos.Value
            hrp.CFrame = targetPos
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
    end
end

TrollSheriffBtn.MouseButton1Click:Connect(function()
    local active = TrollSheriffBtn.Text:find("DESLIGADO")
    TrollSheriffBtn.Text = active and "Paralisar Sheriff: LIGADO" or "Paralisar Sheriff: DESLIGADO"
    TrollSheriffBtn.BackgroundColor3 = active and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    if active then
        trollSheriffConnection = RunService.RenderStepped:Connect(function() freezeTargetReal(getSheriff()) end)
    else
        if trollSheriffConnection then trollSheriffConnection:Disconnect() end
        local s = getSheriff()
        if s and s.Character and s.Character:FindFirstChild("FrozenPos") then s.Character.FrozenPos:Destroy() end
    end
end)

TrollMurderBtn.MouseButton1Click:Connect(function()
    local active = TrollMurderBtn.Text:find("DESLIGADO")
    TrollMurderBtn.Text = active and "Paralisar Murderer: LIGADO" or "Paralisar Murderer: DESLIGADO"
    TrollMurderBtn.BackgroundColor3 = active and Color3.fromRGB(50, 160, 80) or Color3.fromRGB(35, 35, 42)
    if active then
        trollMurderConnection = RunService.RenderStepped:Connect(function() freezeTargetReal(getMurderer()) end)
    else
        if trollMurderConnection then trollMurderConnection:Disconnect() end
        local m = getMurderer()
        if m and m.Character and m.Character:FindFirstChild("FrozenPos") then m.Character.FrozenPos:Destroy() end
    end
end)
