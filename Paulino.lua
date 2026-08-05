-- ==========================================
-- 🌟 PAULINO MM2 - SCRIPT COMPLETO & ULTIMATE 🔥
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

_G.PaulinoMenuRunning = true

local xpFarmAtivo = false
local espActive = false
local aimbotActive = false
local freecamActive = false
local antiAfkAtivo = false
local fpsBoostAtivo = false
local noclipActive = false
local flyActive = false
local flySpeed = 50
local flyBodyVelocity = nil
local flyBodyGyro = nil

local xpFarmConnection = nil
local safePlatform = nil
local antiFlingConnection = nil
local freecamConn = nil
local trollSheriffConnection = nil
local trollMurderConnection = nil
local antiAfkConnection = nil
local speedJumpConnection = nil
local noclipConnection = nil
local flyConnection = nil

-- ==========================================
-- 🛡️ ANTI-FLING PASSIVO
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
-- 🎨 CRIAÇÃO DA GUI ESTILIZADA
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
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 90, 255)
MainStroke.Transparency = 0.4
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 280, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "🌟 Paulino Hub ✦ MM2 Edition 🚀"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 32, 0, 26)
MinimizeButton.Position = UDim2.new(1, -38, 0, 6)
MinimizeButton.Text = "➖"
MinimizeButton.TextColor3 = Color3.fromRGB(240, 240, 245)
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
MinimizeButton.BackgroundTransparency = 0.3
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- ==========================================
-- 🔘 BOTÃO FLUTUANTE MINIMIZADO
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 38, 0, 38)
OpenButton.Position = UDim2.new(0, -19, 0.5, -19)
OpenButton.Text = "⭐"
OpenButton.TextSize = 18
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
OpenButton.BackgroundTransparency = 0.3
OpenButton.BorderSizePixel = 0
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(120, 90, 255)
OpenStroke.Transparency = 0.3
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

local minimized = false
local animating = false

local function alternarMenu()
    if animating then return end
    animating = true
    
    if not minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = OpenButton.Position + UDim2.new(0, 19, 0, 19)
        }):Play()
        
        task.wait(0.2)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 520, 0, 360)
        MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
        
        OpenButton.Size = UDim2.new(0, 0, 0, 0)
        OpenButton.Visible = true
        TweenService:Create(OpenButton, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 38, 0, 38)
        }):Play()
        
        minimized = true
    else
        TweenService:Create(OpenButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        task.wait(0.15)
        OpenButton.Visible = false
        OpenButton.Size = UDim2.new(0, 38, 0, 38)
        
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
        local targetX = (currentAbsPos.X < viewportSize.X / 2) and -19 or (viewportSize.X - 19)
        local targetY = math.clamp(currentAbsPos.Y, -19, viewportSize.Y - 19)
        
        TweenService:Create(OpenButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetX, 0, targetY)
        }):Play()
        
        task.delay(0.1, function()
            OpenButton:SetAttribute("IsDragging", false)
        end)
    end
end)

-- Arrastar Painel
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
Sidebar.Size = UDim2.new(0, 145, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 360)
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 8)
SidebarPad.PaddingLeft = UDim.new(0, 5)
SidebarPad.PaddingRight = UDim.new(0, 5)
SidebarPad.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -38)
ContentContainer.Position = UDim2.new(0, 145, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 620)
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
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Text = " " .. displayName
    btn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 175)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = default and Color3.fromRGB(50, 45, 75) or Color3.fromRGB(20, 20, 28)
    btn.BackgroundTransparency = default and 0.2 or 0.6
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local page = createPage(name)
    if default then page.Visible = true end
    
    btn.MouseButton1Click:Connect(function()
        for pName, pObj in pairs(pages) do 
            if pName == name then
                pObj.Visible = true
                pObj.Position = UDim2.new(0, 15, 0, 0)
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
                b.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                b.BackgroundTransparency = 0.6
                b.TextColor3 = Color3.fromRGB(160, 160, 175)
            end
        end
        
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(50, 45, 75),
            BackgroundTransparency = 0.2
        }):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabButton("Home", "🏠 Início", true)
createTabButton("Farm", "⚡ Farm XP", false)
createTabButton("Combat", "⚔️ Combate / TP", false)
createTabButton("Visuals", "👁️ Visual / ESP", false)
createTabButton("Camera", "📷 Câmera", false)
createTabButton("Troll", "🤡 Troll Hub", false)
createTabButton("Settings", "⚙️ Configurações", false)

local function addButton(page, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(245, 245, 250)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.Parent = page
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 70, 95)
    stroke.Transparency = 0.6
    stroke.Thickness = 1
    stroke.Parent = btn
    
    return btn
end

local function addLabel(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 215)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = page
    return lbl
end

addLabel(pages.Home, "✨ Bem-vindo ao Paulino Hub Ultimate!")

local AntiAfkButton = addButton(pages.Home, "🛡️ Anti-AFK: ❌ DESLIGADO")
AntiAfkButton.MouseButton1Click:Connect(function()
    antiAfkAtivo = not antiAfkAtivo
    AntiAfkButton.Text = antiAfkAtivo and "🛡️ Anti-AFK: ✅ LIGADO" or "🛡️ Anti-AFK: ❌ DESLIGADO"
    AntiAfkButton.BackgroundColor3 = antiAfkAtivo and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    
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

local CloseBtn = addButton(pages.Home, "❌ Parar Tudo / Fechar Hub")
CloseBtn.MouseButton1Click:Connect(function()
    _G.PaulinoMenuRunning = false
    xpFarmAtivo = false
    espActive = false
    antiAfkAtivo = false
    noclipActive = false
    
    if flyActive then
        flyActive = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
    
    if xpFarmConnection then xpFarmConnection:Disconnect() end
    if antiFlingConnection then antiFlingConnection:Disconnect() end
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    if speedJumpConnection then speedJumpConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end

    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    if ScreenGui then ScreenGui:Destroy() end
end)

-- ==========================================
-- ⚙️ ABA CONFIGURAÇÕES (FPS & SERVER HOP)
-- ==========================================
addLabel(pages.Settings, "🚀 Otimização e Desempenho:")

local FpsBoostButton = addButton(pages.Settings, "⚡ Otimizador de FPS: ❌ DESLIGADO")

FpsBoostButton.MouseButton1Click:Connect(function()
    fpsBoostAtivo = not fpsBoostAtivo
    FpsBoostButton.Text = fpsBoostAtivo and "⚡ Otimizador de FPS: ✅ LIGADO" or "⚡ Otimizador de FPS: ❌ DESLIGADO"
    FpsBoostButton.BackgroundColor3 = fpsBoostAtivo and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    
    if fpsBoostAtivo then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
        end)
    end
end)

addLabel(pages.Settings, "🌍 Mudança de Servidor:")

local ServerHopButton = addButton(pages.Settings, "🌐 Server Hop (Mudar de Servidor)")

ServerHopButton.MouseButton1Click:Connect(function()
    ServerHopButton.Text = "🌐 A procurar servidor..."
    ServerHopButton.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
    
    pcall(function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if req and req.data then
            for _, s in ipairs(req.data) do
                if type(s) == "table" and s.maxPlayers and s.playing and s.id and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, s.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            ServerHopButton.Text = "❌ Nenhum servidor encontrado"
            task.wait(2)
            ServerHopButton.Text = "🌐 Server Hop (Mudar de Servidor)"
            ServerHopButton.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        end
    end)
end)

-- ==========================================
-- 🎭 ROLES SYSTEM
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
        if getPlayerTool(p) ~= nil then return true end
    end
    return false
end

local function getPlayerColorAndRole(p)
    local tool = getPlayerTool(p)
    if tool == "Knife" or p == getMurderer() then return Color3.fromRGB(255, 60, 60), "🔪 [Murder]" end
    if tool == "Gun" or p == getSheriff() then return Color3.fromRGB(60, 160, 255), "🔫 [Sheriff]" end
    return Color3.fromRGB(60, 220, 100), "2x inocente"
end

-- ==========================================
-- 🔫 PEGAR ARMA DO CHÃO
-- ==========================================
local function grabGunFromFloor()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    
    if not myRoot or not myHumanoid or myHumanoid.Health <= 0 then return end
    if getPlayerTool(LocalPlayer) == "Gun" then return end
    
    local targetPart = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name:lower():find("gundrop") then
            if obj:IsA("BasePart") then
                targetPart = obj
                break
            elseif obj:IsA("Model") then
                targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if targetPart then break end
            end
        end
    end
    
    if targetPart then
        local savedCFrame = myRoot.CFrame
        pcall(function()
            if firetouchinterest and targetPart:IsA("BasePart") then
                firetouchinterest(myRoot, targetPart, 0)
                task.wait()
                firetouchinterest(myRoot, targetPart, 1)
            end
            myRoot.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.1)
            myRoot.CFrame = savedCFrame
        end)
    end
end

-- ==========================================
-- ⚔️ ABA COMBATE / VELOCIDADE & PULO & VOO
-- ==========================================
local AimbotButton = addButton(pages.Combat, "🎯 Aimbot (Tecla E): ❌ DESLIGADO")
local GrabGunButton = addButton(pages.Combat, "🔫 Pegar Arma do Chão (Tecla G)")
local TpNearestButton = addButton(pages.Combat, "⚡ Teleportar Próximo (Tecla R)")
local SelectPlayerButton = addButton(pages.Combat, "👥 Selecionar Jogador para TP ➔")

local NoclipButton = addButton(pages.Combat, "👻 Noclip (Atravessar Paredes): ❌ DESLIGADO")

NoclipButton.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    NoclipButton.Text = noclipActive and "👻 Noclip (Atravessar Paredes): ✅ LIGADO" or "👻 Noclip (Atravessar Paredes): ❌ DESLIGADO"
    NoclipButton.BackgroundColor3 = noclipActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    
    if noclipActive then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if not _G.PaulinoMenuRunning or not noclipActive then return end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = true
                end
            end
        end
    end
end)

-- ==========================================
-- ✈️👻 SISTEMA DE VOO + NOCLIP UNIDOS (TECLA F)
-- ==========================================
local FlyButton = addButton(pages.Combat, "✈️ Voo (Fly - Tecla F): ❌ DESLIGADO")

local function toggleFlyAndNoclip()
    flyActive = not flyActive
    noclipActive = flyActive

    FlyButton.Text = flyActive and "✈️ Voo (Fly - Tecla F): ✅ LIGADO" or "✈️ Voo (Fly - Tecla F): ❌ DESLIGADO"
    FlyButton.BackgroundColor3 = flyActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)

    NoclipButton.Text = noclipActive and "👻 Noclip (Atravessar Paredes): ✅ LIGADO" or "👻 Noclip (Atravessar Paredes): ❌ DESLIGADO"
    NoclipButton.BackgroundColor3 = noclipActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 2)
    local hum = char:WaitForChild("Humanoid", 2)

    if flyActive and hrp and hum then
        hum.PlatformStand = true

        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBodyVelocity.Parent = hrp

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.P = 9e4
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.CFrame = hrp.CFrame
        flyBodyGyro.Parent = hrp

        if flyConnection then flyConnection:Disconnect() end
        flyConnection = RunService.RenderStepped:Connect(function()
            if not _G.PaulinoMenuRunning or not flyActive then return end

            local currentChar = LocalPlayer.Character
            if not currentChar or not currentChar:FindFirstChild("HumanoidRootPart") then return end

            local currentHrp = currentChar.HumanoidRootPart
            local currentHum = currentChar:FindFirstChildOfClass("Humanoid")

            for _, p in ipairs(currentChar:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end

            if not flyBodyVelocity or not flyBodyVelocity.Parent then
                if currentHum then currentHum.PlatformStand = true end
                flyBodyVelocity = Instance.new("BodyVelocity", currentHrp)
                flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyBodyGyro = Instance.new("BodyGyro", currentHrp)
                flyBodyGyro.P = 9e4
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            end

            local cam = Workspace.CurrentCamera
            flyBodyGyro.CFrame = cam.CFrame

            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if hum then hum.PlatformStand = false end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end

        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = true
                end
            end
        end
    end
end

FlyButton.MouseButton1Click:Connect(toggleFlyAndNoclip)

addLabel(pages.Combat, "🏃‍♂️ Configurações de Movimento (0 a 100):")

local customWalkSpeed = 16
local customJumpPower = 50
local speedJumpEnabled = false

local SpeedJumpToggleButton = addButton(pages.Combat, "🚀 Modo Velocidade/Pulo: ❌ DESLIGADO")

SpeedJumpToggleButton.MouseButton1Click:Connect(function()
    speedJumpEnabled = not speedJumpEnabled
    SpeedJumpToggleButton.Text = speedJumpEnabled and "🚀 Modo Velocidade/Pulo: ✅ LIGADO" or "🚀 Modo Velocidade/Pulo: ❌ DESLIGADO"
    SpeedJumpToggleButton.BackgroundColor3 = speedJumpEnabled and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    
    if not speedJumpEnabled then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end)

local function createInputRow(labelText, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundTransparency = 1
    row.Parent = pages.Combat

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.4, 0, 1, 0)
    box.Position = UDim2.new(0.6, 0, 0, 0)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 12
    box.Font = Enum.Font.GothamBold
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    box.BackgroundTransparency = 0.25
    box.BorderSizePixel = 0
    box.Parent = row

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            num = math.clamp(num, 0, 150)
            box.Text = tostring(num)
            callback(num)
        else
            box.Text = tostring(defaultVal)
        end
    end)
    return box
end

createInputRow("⚡ Velocidade (0-100):", 16, function(val)
    customWalkSpeed = val
end)

createInputRow("🦘 Pulo (0-100):", 50, function(val)
    customJumpPower = val
end)

createInputRow("✈️ Vel. Voo (10-150):", 50, function(val)
    flySpeed = val
end)

local ResetSpeedBtn = addButton(pages.Combat, "🔄 Voltar Velocidade/Pulo ao Normal")
ResetSpeedBtn.MouseButton1Click:Connect(function()
    speedJumpEnabled = false
    SpeedJumpToggleButton.Text = "🚀 Modo Velocidade/Pulo: ❌ DESLIGADO"
    SpeedJumpToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    customWalkSpeed = 16
    customJumpPower = 50
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end)

speedJumpConnection = RunService.RenderStepped:Connect(function()
    if not _G.PaulinoMenuRunning or not speedJumpEnabled then return end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = customWalkSpeed
        hum.JumpPower = customJumpPower
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    AimbotButton.Text = aimbotActive and "🎯 Aimbot (Tecla E): ✅ LIGADO" or "🎯 Aimbot (Tecla E): ❌ DESLIGADO"
    AimbotButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
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

-- ==========================================
-- ⌨️ TECLAS DE ATALHO (COM BLOQUEIO DE CHAT)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UserInputService:GetFocusedTextBox() then return end
    
    if input.KeyCode == Enum.KeyCode.G then 
        grabGunFromFloor()
    elseif input.KeyCode == Enum.KeyCode.R then 
        teleportToNearest()
    elseif input.KeyCode == Enum.KeyCode.E then
        aimbotActive = not aimbotActive
        AimbotButton.Text = aimbotActive and "🎯 Aimbot (Tecla E): ✅ LIGADO" or "🎯 Aimbot (Tecla E): ❌ DESLIGADO"
        AimbotButton.BackgroundColor3 = aimbotActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    elseif input.KeyCode == Enum.KeyCode.F then
        toggleFlyAndNoclip()
    end
end)

-- ==========================================
-- 💫 LISTAS FLUTUANTES CINEMATOGRÁFICAS
-- ==========================================
local activeCinematicLists = {}

local function createCinematicList()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 200, 0, 200)
    container.Position = UDim2.new(1, 10, 0, 0)
    container.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.Visible = false
    container.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 80, 200)
    stroke.Transparency = 0.3
    stroke.Thickness = 1.5
    stroke.Parent = container

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Camera

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    container:GetPropertyChangedSignal("Visible"):Connect(function()
        if container.Visible then
            TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 12}):Play()
            table.insert(activeCinematicLists, container)
        else
            TweenService:Create(blur, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = 0}):Play()
            for i, v in ipairs(activeCinematicLists) do
                if v == container then
                    table.remove(activeCinematicLists, i)
                    break
                end
            end
        end
    end)

    return container, scroll
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position
        for _, listFrame in ipairs(activeCinematicLists) do
            if listFrame.Visible then
                local absPos = listFrame.AbsolutePosition
                local absSize = listFrame.AbsoluteSize
                local insideX = mousePos.X >= absPos.X and mousePos.X <= (absPos.X + absSize.X)
                local insideY = mousePos.Y >= absPos.Y and mousePos.Y <= (absPos.Y + absSize.Y)
                if not (insideX and insideY) then
                    listFrame.Visible = false
                end
            end
        end
    end
end)

-- ==========================================
-- 👥 LISTA DE JOGADORES (TP)
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
                btn.Size = UDim2.new(1, 0, 0, 34)
                btn.Text = "👤 " .. p.Name .. " " .. role
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = PlayerScroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
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
-- ⚡ ABA FARM DE XP
-- ==========================================
local XpFarmButton = addButton(pages.Farm, "⚡ Farm de XP (Lobby): ❌ DESLIGADO")

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
    XpFarmButton.Text = xpFarmAtivo and "⚡ Farm de XP (Lobby): ✅ LIGADO" or "⚡ Farm de XP (Lobby): ❌ DESLIGADO"
    XpFarmButton.BackgroundColor3 = xpFarmAtivo and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    
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
-- 👁️ ABA VISUAL / ESP
-- ==========================================
local EspButton = addButton(pages.Visuals, "👁️ ESP Jogadores & Armas: ❌ DESLIGADO")

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
    EspButton.Text = espActive and "👁️ ESP Jogadores & Armas: ✅ LIGADO" or "👁️ ESP Jogadores & Armas: ❌ DESLIGADO"
    EspButton.BackgroundColor3 = espActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
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
                    bb.Size = UDim2.new(0, 130, 0, 42)
                    bb.StudsOffset = Vector3.new(0, -3.5, 0)
                    bb.AlwaysOnTop = true
                    
                    local lbl = bb:FindFirstChild("Tag") or Instance.new("TextLabel", bb)
                    lbl.Name = "Tag"
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = color
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12
                    lbl.Text = "👤 " .. p.Name .. "\n" .. role
                end
            end
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj.Name == "GunDrop" or obj.Name:lower():find("gundrop")) and obj:IsA("BasePart") then
                    local gunColor = Color3.fromRGB(0, 180, 255)
                    
                    local hl = obj:FindFirstChild("PaulinoGunHighlight") or Instance.new("Highlight", obj)
                    hl.Name = "PaulinoGunHighlight"
                    hl.OutlineColor = gunColor
                    hl.OutlineTransparency = 0
                    hl.FillColor = gunColor
                    hl.FillTransparency = 1
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                    local bb = obj:FindFirstChild("PaulinoGunBillboard") or Instance.new("BillboardGui", obj)
                    bb.Name = "PaulinoGunBillboard"
                    bb.Size = UDim2.new(0, 130, 0, 30)
                    bb.StudsOffset = Vector3.new(0, -2, 0)
                    bb.AlwaysOnTop = true

                    local lbl = bb:FindFirstChild("Tag") or Instance.new("TextLabel", bb)
                    lbl.Name = "Tag"
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = gunColor
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12
                    lbl.Text = "🔫 [Arma Droppada]"
                end
            end
        else
            clearESP()
        end
        task.wait(0.4)
    end
end)

-- ==========================================
-- 📷 ABA CÂMERA & FREECAM
-- ==========================================
local FreecamLivreBtn = addButton(pages.Camera, "📷 Freecam Livre: ❌ DESLIGADO")
local FreecamPlayerButton = addButton(pages.Camera, "👁️ Espectar Jogador ➔")
local ResetCamButton = addButton(pages.Camera, "🔄 Voltar Câmera ao Normal")

local freecamRotX = 0
local freecamRotY = 0

FreecamLivreBtn.MouseButton1Click:Connect(function()
    freecamActive = not freecamActive
    FreecamLivreBtn.Text = freecamActive and "📷 Freecam Livre: ✅ LIGADO" or "📷 Freecam Livre: ❌ DESLIGADO"
    FreecamLivreBtn.BackgroundColor3 = freecamActive and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    
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
CameraListFrame.Position = UDim2.new(1, 10, 0, 45)

FreecamPlayerButton.MouseButton1Click:Connect(function()
    CameraListFrame.Visible = not CameraListFrame.Visible
    if CameraListFrame.Visible then
        for _, child in ipairs(CameraScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 34)
                btn.Text = "📺 " .. p.Name
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = CameraScroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    if freecamActive then
                        freecamActive = false
                        FreecamLivreBtn.Text = "📷 Freecam Livre: ❌ DESLIGADO"
                        FreecamLivreBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    end
                    if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                        Camera.CameraType = Enum.CameraType.Custom
                        Camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
                        FreecamPlayerButton.Text = "📺 Espectando: " .. p.Name
                        FreecamPlayerButton.BackgroundColor3 = Color3.fromRGB(40, 140, 70)
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
        FreecamLivreBtn.Text = "📷 Freecam Livre: ❌ DESLIGADO"
        FreecamLivreBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        if freecamConn then freecamConn:Disconnect() freecamConn = nil end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        FreecamPlayerButton.Text = "👁️ Espectar Jogador ➔"
        FreecamPlayerButton.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    end
end)

-- ==========================================
-- 🤡 ABA TROLL & FLING MATAR
-- ==========================================
local KillMurderBtn = addButton(pages.Troll, "⚔️ Matar Murderer (Fling)")
local KillSheriffBtn = addButton(pages.Troll, "🛡️ Matar Sheriff (Fling)")
local FlingSelectBtn = addButton(pages.Troll, "🎯 Fling em Jogador Selecionado ➔")
local TrollSheriffBtn = addButton(pages.Troll, "❄️ Paralisar Sheriff: ❌ DESLIGADO")
local TrollMurderBtn = addButton(pages.Troll, "❄️ Paralisar Murderer: ❌ DESLIGADO")

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
    if btn.BackgroundColor3 == Color3.fromRGB(40, 140, 70) then return end
    btn.Text = textoOriginal .. " ⏳ [A Tentar...]"
    btn.BackgroundColor3 = Color3.fromRGB(40, 140, 70)
    
    task.spawn(function()
        performFling(getAlvoFunc(), 1.5)
        btn.Text = textoOriginal
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    end)
end

KillMurderBtn.MouseButton1Click:Connect(function()
    ativarFlingTemporario(KillMurderBtn, "⚔️ Matar Murderer (Fling)", getMurderer)
end)

KillSheriffBtn.MouseButton1Click:Connect(function()
    ativarFlingTemporario(KillSheriffBtn, "🛡️ Matar Sheriff (Fling)", getSheriff)
end)

local TrollListFrame, TrollScroll = createCinematicList()
TrollListFrame.Position = UDim2.new(1, 10, 0, 115)

FlingSelectBtn.MouseButton1Click:Connect(function()
    TrollListFrame.Visible = not TrollListFrame.Visible
    if TrollListFrame.Visible then
        for _, child in ipairs(TrollScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local color, role = getPlayerColorAndRole(p)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 34)
                btn.Text = "💥 " .. p.Name
                btn.TextColor3 = color
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = TrollScroll
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    TrollListFrame.Visible = false
                    ativarFlingTemporario(FlingSelectBtn, "🎯 Fling em Jogador Selecionado ➔", function() return p end)
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
    TrollSheriffBtn.Text = active and "❄️ Paralisar Sheriff: ✅ LIGADO" or "❄️ Paralisar Sheriff: ❌ DESLIGADO"
    TrollSheriffBtn.BackgroundColor3 = active and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
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
    TrollMurderBtn.Text = active and "❄️ Paralisar Murderer: ✅ LIGADO" or "❄️ Paralisar Murderer: ❌ DESLIGADO"
    TrollMurderBtn.BackgroundColor3 = active and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(30, 30, 42)
    if active then
        trollMurderConnection = RunService.RenderStepped:Connect(function() freezeTargetReal(getMurderer()) end)
    else
        if trollMurderConnection then trollMurderConnection:Disconnect() end
        local m = getMurderer()
        if m and m.Character and m.Character:FindFirstChild("FrozenPos") then m.Character.FrozenPos:Destroy() end
    end
end)
