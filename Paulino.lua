-- ==========================================
-- PAULINO HUB MM2 - CORRIGIDO E FUNCIONAL
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remover interface anterior se existir
if PlayerGui:FindFirstChild("PaulinoGUI") then
    PlayerGui.PaulinoGUI:Destroy()
end

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PaulinoGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "☀️ Paulino Hub - MM2 (Aberto com Sucesso)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Botão de Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sistema de Fling Direto
local function runFlingOnPlayer(targetP)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetP or not targetP.Character or not targetP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local savedPos = myRoot.CFrame
    local targetRoot = targetP.Character.HumanoidRootPart
    local startTime = tick()
    
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
    myRoot.CFrame = savedPos
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero
end

-- Botão de Exemplo (Fling no primeiro jogador encontrado)
local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(0, 200, 0, 40)
FlingBtn.Position = UDim2.new(0.5, -100, 0.5, -20)
FlingBtn.Text = "Fling Primeiro Jogador"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 90)
FlingBtn.TextSize = 12
FlingBtn.Font = Enum.Font.GothamBold
FlingBtn.Parent = MainFrame

Instance.new("UICorner", FlingBtn).CornerRadius = UDim.new(0, 8)

FlingBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                runFlingOnPlayer(p)
                break
            end
        end
    end)
end)
