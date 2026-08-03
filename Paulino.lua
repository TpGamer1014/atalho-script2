-- ==========================================
-- PAULINO MM2 - FLING SEPARADO E CORRIGIDO
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local aFazerFling = false

local function runFlingOnPlayer(targetP)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetP or not targetP.Character or not targetP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local savedPos = myRoot.CFrame
    local targetRoot = targetP.Character.HumanoidRootPart
    local startTime = tick()
    aFazerFling = true
    
    for _, part in ipairs(myChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    local connection
    connection = RunService.Stepped:Connect(function()
        if targetRoot and targetRoot.Parent and myRoot and myRoot.Parent then
            myRoot.CFrame = targetRoot.CFrame * CFrame.Angles(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180))
            myRoot.AssemblyLinearVelocity = Vector3.new(30000, 30000, 30000)
            myRoot.AssemblyAngularVelocity = Vector3.new(30000, 30000, 30000)
        end
    end)
    
    while tick() - startTime < 1 do
        task.wait()
    end
    
    if connection then connection:Disconnect() end
    aFazerFling = false
    myRoot.CFrame = savedPos
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero
end

-- Exemplo de uso direto em um botão ou comando:
-- runFlingOnPlayer(Players.FindFirstChild("NomeDoJogador"))
