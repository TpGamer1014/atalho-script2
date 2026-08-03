local function grabGunFromFloor()
    task.spawn(function()
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            -- 1. Encontrar a arma caída no mapa
            local gunPart = nil
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj.Name == "GunDrop" or obj.Name == "Gun" or obj.Name:lower():find("gundrop") then
                    if obj:IsA("BasePart") then
                        gunPart = obj
                        break
                    elseif obj:IsA("Model") then
                        gunPart = obj.PrimaryPart or obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                        if gunPart then break end
                    end
                end
            end

            -- 2. Coletar a arma e retornar
            if gunPart then
                local savedCFrame = myRoot.CFrame

                -- Método A: Simulação de Toque via Executor
                if firetouchinterest then
                    firetouchinterest(myRoot, gunPart, 0)
                    task.wait(0.05)
                    firetouchinterest(myRoot, gunPart, 1)
                end

                -- Método B: Teleporte direto para garantir a coleta
                for i = 1, 3 do
                    myRoot.AssemblyLinearVelocity = Vector3.zero
                    myRoot.CFrame = gunPart.CFrame
                    task.wait(0.04)
                end

                -- 3. Voltar para a posição original
                myRoot.CFrame = savedCFrame
                myRoot.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end)
end
