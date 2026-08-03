local function grabGunFromFloor()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local gunPart = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name:lower():find("gundrop") then
            if obj:IsA("BasePart") then
                gunPart = obj
                break
            elseif obj:IsA("Model") then
                gunPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if gunPart then break end
            end
        end
    end
    
    if gunPart then
        local savedCFrame = myRoot.CFrame
        
        -- Método 1: Instantâneo via executor (se suportado)
        if firetouchinterest then
            firetouchinterest(myRoot, gunPart, 0)
            task.wait(0.05)
            firetouchinterest(myRoot, gunPart, 1)
        else
            -- Método 2: Teleporte seguro com retorno garantido
            myRoot.AssemblyLinearVelocity = Vector3.zero
            myRoot.AssemblyAngularVelocity = Vector3.zero
            
            -- Vai até a arma
            myRoot.CFrame = gunPart.CFrame + Vector3.new(0, 1, 0)
            task.wait(0.15)
            
            -- Volta para a posição original (3 reforços de CFrame)
            for i = 1, 3 do
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
                myRoot.CFrame = savedCFrame
                task.wait(0.02)
            end
        end
    end
end
