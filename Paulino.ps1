Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CRIAÇÃO DA JANELA PRINCIPAL ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Otimizador Paulino - Windows 11"
$form.Size = New-Object System.Drawing.Size(500, 450)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 43, 73) # Azul escuro elegante
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# --- TÍTULO ---
$labelTitle = New-Object System.Windows.Forms.Label
$labelTitle.Text = "Painel de Otimização - Paulino"
$labelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$labelTitle.ForeColor = [System.Drawing.Color]::White
$labelTitle.Location = New-Object System.Drawing.Point(30, 20)
$labelTitle.Size = New-Object System.Drawing.Size(430, 30)
$labelTitle.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($labelTitle)

# --- BOTÃO 1: LIMPEZA SEGURA DE TEMPORÁRIOS ---
$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "1. Limpar Ficheiros Temporários"
$btnClean.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnClean.Location = New-Object System.Drawing.Point(50, 80)
$btnClean.Size = New-Object System.Drawing.Size(380, 45)
$btnClean.BackColor = [System.Drawing.Color]::FromArgb(41, 128, 185) # Azul médio
$btnClean.ForeColor = [System.Drawing.Color]::White
$btnClean.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnClean.Add_Click({
    try {
        Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        [System.Windows.Forms.MessageBox]::Show("Limpeza concluída com sucesso!", "Paulino Optimizer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Alguns ficheiros estão em uso.", "Aviso", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})
$form.Controls.Add($btnClean)

# --- BOTÃO 2: OTIMIZAR PLANO DE ENERGIA ---
$btnPower = New-Object System.Windows.Forms.Button
$btnPower.Text = "2. Ativar Desempenho Máximo"
$btnPower.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnPower.Location = New-Object System.Drawing.Point(50, 145)
$btnPower.Size = New-Object System.Drawing.Size(380, 45)
$btnPower.BackColor = [System.Drawing.Color]::FromArgb(41, 128, 185)
$btnPower.ForeColor = [System.Drawing.Color]::White
$btnPower.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnPower.Add_Click({
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    [System.Windows.Forms.MessageBox]::Show("Plano de Desempenho Máximo ativado!", "Paulino Optimizer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
$form.Controls.Add($btnPower)

# --- BOTÃO 3: LIMPAR CACHE DE DNS ---
$btnDNS = New-Object System.Windows.Forms.Button
$btnDNS.Text = "3. Limpar Cache DNS (Rede)"
$btnDNS.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnDNS.Location = New-Object System.Drawing.Point(50, 210)
$btnDNS.Size = New-Object System.Drawing.Size(380, 45)
$btnDNS.BackColor = [System.Drawing.Color]::FromArgb(41, 128, 185)
$btnDNS.ForeColor = [System.Drawing.Color]::White
$btnDNS.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnDNS.Add_Click({
    Clear-DnsClientCache
    [System.Windows.Forms.MessageBox]::Show("Cache de DNS limpa com sucesso!", "Paulino Optimizer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
$form.Controls.Add($btnDNS)

# --- BOTÃO 4: EXECUTAR TUDO ---
$btnAll = New-Object System.Windows.Forms.Button
$btnAll.Text = "Executar Otimização Completa"
$btnAll.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnAll.Location = New-Object System.Drawing.Point(50, 285)
$btnAll.Size = New-Object System.Drawing.Size(380, 50)
$btnAll.BackColor = [System.Drawing.Color]::FromArgb(39, 174, 96) # Verde para destaque seguro
$btnAll.ForeColor = [System.Drawing.Color]::White
$btnAll.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAll.Add_Click({
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Clear-DnsClientCache
    [System.Windows.Forms.MessageBox]::Show("Todas as otimizações seguras foram aplicadas!", "Paulino Optimizer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
$form.Controls.Add($btnAll)

# --- RODAPÉ ---
$labelFooter = New-Object System.Windows.Forms.Label
$labelFooter.Text = "Seguro para Windows 11 • Criado para Paulino"
$labelFooter.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$labelFooter.ForeColor = [System.Drawing.Color]::LightGray
$labelFooter.Location = New-Object System.Drawing.Point(30, 355)
$labelFooter.Size = New-Object System.Drawing.Size(430, 20)
$labelFooter.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($labelFooter)

# Mostrar a janela
[void]$form.ShowDialog()