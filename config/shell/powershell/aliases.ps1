# ===============================
# 🏠 MINI SWEET HOME - POWERSHELL ALIASES
# ===============================

# ===============================
# 🛡️ SMART TOOL DETECTION & FALLBACKS
# ===============================

# Function to check if command exists
function Test-CommandExists {
    param([string]$Command)
    return (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null
}

# ===============================
# 📁 SMART LISTING (eza -> exa -> Get-ChildItem fallback)
# ===============================
if (Test-CommandExists "eza") {
    function ls { eza --color=always --group-directories-first --icons @args }
    function ll { eza -la --color=always --group-directories-first --icons @args }
    function la { eza -a --color=always --group-directories-first --icons @args }
    function lt { eza -T --color=always --group-directories-first --icons @args }
    function tree { eza -T --color=always --group-directories-first --icons @args }
    function l { eza -l --icons @args }
    function lall { eza -la --icons @args }
    function lh { eza -lah --icons @args }
    function ltime { eza -lt modified --icons @args }
    function lr { eza -lR --icons @args }
}  else {
    # Fallback to PowerShell Get-ChildItem with improvements
    function ls { Get-ChildItem @args | Format-Wide Name -AutoSize }
    function ll { Get-ChildItem @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
    function la { Get-ChildItem -Force @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
    function lt { Get-ChildItem @args | Format-Table Name, LastWriteTime -AutoSize }
    function tree { Get-ChildItem -Recurse @args | ForEach-Object { "  " * ($_.FullName.Split('\').Count - (Get-Location).Path.Split('\').Count) + $_.Name } }
    function l { Get-ChildItem @args | Format-Table Name, Length, LastWriteTime -AutoSize }
    function lall { Get-ChildItem -Force @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
    function lh { Get-ChildItem -Force @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
    function ltime { Get-ChildItem @args | Sort-Object LastWriteTime | Format-Table LastWriteTime, Name -AutoSize }
    function lr { Get-ChildItem -Recurse @args | Format-Table Name, FullName -AutoSize }
}

# ===============================
# 📝 SMART CAT (bat -> Get-Content fallback)
# ===============================
if (Test-CommandExists "bat") {
    function cat { bat --paging=never @args }
    Set-Alias -Name ccat -Value Get-Content -Force  # Original cat for piping
} elseif (Test-CommandExists "batcat") {  # Ubuntu package name
    function cat { batcat --paging=never @args }
    Set-Alias -Name ccat -Value Get-Content -Force
} else {
    function cat { Get-Content @args }
    Set-Alias -Name ccat -Value Get-Content -Force  # Keep original
}

# ===============================
# 🔍 SMART FILE SEARCH (fd -> Get-ChildItem fallback)
# ===============================
if (Test-CommandExists "fd") {
    Set-Alias -Name ff -Value fd -Force
    Set-Alias -Name find_files -Value fd -Force
} elseif (Test-CommandExists "fdfind") {  # Ubuntu package name
    Set-Alias -Name ff -Value fdfind -Force
    Set-Alias -Name find_files -Value fdfind -Force
} else {
    function ff { Get-ChildItem -Recurse -Name @args }
    function find_files { Get-ChildItem -Recurse -Name @args }
}

# ===============================
# 🔍 SMART GREP (rg -> Select-String fallback)
# ===============================
if (Test-CommandExists "rg") {
    Set-Alias -Name grep -Value rg -Force
    Set-Alias -Name grepr -Value rg -Force
    function search { rg -i @args }
} else {
    function grep { Select-String @args }
    function grepr { Select-String -Path * -Recurse @args }
    function search { Select-String -Pattern @args }
}

# ===============================
# 💾 SMART DISK USAGE (dust -> Get-ChildItem fallback)
# ===============================
if (Test-CommandExists "dust") {
    Set-Alias -Name du -Value dust -Force
    Set-Alias -Name disk -Value dust -Force
    function dush { dust -d 1 @args }
} else {
    function disk { 
        Get-ChildItem | ForEach-Object { 
            $size = (Get-ChildItem $_.FullName -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            "$([math]::Round($size/1MB,2)) MB - $($_.Name)" 
        }
    }
    function dush { 
        (Get-ChildItem | Measure-Object -Property Length -Sum).Sum / 1MB
    }
}

# ===============================
# 🖥️ SMART PROCESS VIEWER (fallback pour Windows)
# ===============================
if (Test-CommandExists "btop") {
    Set-Alias -Name top -Value btop -Force
    Set-Alias -Name htop -Value btop -Force
} elseif (Test-CommandExists "htop") {
    Set-Alias -Name top -Value htop -Force
} else {
    # Windows Task Manager ou Get-Process
    function top { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 }
    function htop { taskmgr }
}

# ===============================
# 📝 EDITOR DETECTION & FALLBACKS
# ===============================
if (Test-CommandExists "nvim") {
    Set-Alias -Name v -Value nvim -Force
    Set-Alias -Name vi -Value nvim -Force
    Set-Alias -Name vim -Value nvim -Force
    Set-Alias -Name nano -Value nvim -Force
    Set-Alias -Name edit -Value nvim -Force
} elseif (Test-CommandExists "vim") {
    Set-Alias -Name v -Value vim -Force
    Set-Alias -Name vi -Value vim -Force
    Set-Alias -Name edit -Value vim -Force
    Set-Alias -Name nano -Value vim -Force
} elseif (Test-CommandExists "code") {  # VS Code
    Set-Alias -Name v -Value code -Force
    Set-Alias -Name vi -Value code -Force
    Set-Alias -Name vim -Value code -Force
    Set-Alias -Name edit -Value code -Force
} else {
    Set-Alias -Name v -Value notepad -Force
    Set-Alias -Name vi -Value notepad -Force
    Set-Alias -Name vim -Value notepad -Force
    Set-Alias -Name edit -Value notepad -Force
    Set-Alias -Name nano -Value notepad -Force
}

# ===============================
# ⚡ MINI SWEET HOME SPECIFIC
# ===============================
function Edit-ZshConfig { $env:EDITOR "$env:USERPROFILE\.mini-sweet-home\configs\shell\zsh\zshrc" }
function Edit-PowerShellConfig { $env:EDITOR $PROFILE }
function Edit-NvimConfig { $env:EDITOR "$env:LOCALAPPDATA\nvim\init.lua" }
function Edit-GitConfig { $env:EDITOR "$env:USERPROFILE\.gitconfig" }
function Edit-AliasesConfig { $env:EDITOR "$env:USERPROFILE\.mini-sweet-home\configs\shell\powershell\aliases.ps1" }
function Edit-FunctionsConfig { $env:EDITOR "$env:USERPROFILE\.mini-sweet-home\configs\shell\powershell\functions.ps1" }

Set-Alias -Name vzc -Value Edit-ZshConfig -Force
Set-Alias -Name vpc -Value Edit-PowerShellConfig -Force
Set-Alias -Name vnv -Value Edit-NvimConfig -Force
Set-Alias -Name vgit -Value Edit-GitConfig -Force
Set-Alias -Name valiases -Value Edit-AliasesConfig -Force
Set-Alias -Name vfunctions -Value Edit-FunctionsConfig -Force

# ===============================
# 📁 SMART NAVIGATION
# ===============================
Set-Alias -Name c -Value Clear-Host -Force
Set-Alias -Name h -Value Get-History -Force
Set-Alias -Name .. -Value Set-LocationUp -Force
Set-Alias -Name ... -Value Set-LocationUpUp -Force
Set-Alias -Name .... -Value Set-LocationUpUpUp -Force

function Set-LocationUp { Set-Location .. }
function Set-LocationUpUp { Set-Location ..\.. }
function Set-LocationUpUpUp { Set-Location ..\..\.. }

# Directory operations with smart defaults
function md { New-Item -ItemType Directory -Force @args }
function rd { Remove-Item -Recurse @args }
function mkd { New-Item -ItemType Directory -Force @args }
function take { 
    param([string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
    Write-Host "✅ Created and entered: $Path" -ForegroundColor Green
}

# File operations with confirmations (PowerShell style)
function cp { Copy-Item @args }
function mv { Move-Item @args }
function rm { Remove-Item @args }

# System information with smart tools
function df { Get-PSDrive -PSProvider FileSystem }
function free { 
    $memory = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    "Total Memory: $([math]::Round($memory.Sum/1GB,2)) GB"
}

# Quick file viewing with smart pagination
function head { 
    param([int]$n = 20, [string]$Path)
    Get-Content $Path | Select-Object -First $n 
}

function tail { 
    param([int]$n = 20, [string]$Path)
    Get-Content $Path | Select-Object -Last $n 
}

# Archive operations (Windows style)
function Expand-Archive7z { 7z x @args }
function Compress-Archive7z { 7z a @args }

# Windows-specific shortcuts
function tarx { tar -xvf @args }
function tarc { tar -cvf @args }

# Permission shortcuts (Windows style)
function take-ownership { takeown /f @args }
function grant-fullcontrol { icacls @args /grant Users:F }

# ===============================
# 🐙 GIT ALIASES (IDENTICAL TO ZSH)
# ===============================
if (Test-CommandExists "git") {
    # Basic Git commands (harmonized with ZSH)
    Set-Alias -Name g -Value git -Force
    function ga { git add @args }
    function gaa { git add . @args }
    function gc { git commit -m @args }
    function gca { git commit -am @args }
    function gp { git push @args }
    function gpl { git pull @args }
    function gst { git status @args }
    function gd { git diff @args }
    function gl { git log --oneline --graph @args }
    function gb { git branch @args }
    function gco { git checkout @args }
    function gcob { git checkout -b @args }
    
    # Advanced git aliases
    function gundo { git reset HEAD~1 @args }
    function gclean { git clean -fd @args }
    function greset { git reset --hard @args }
    function gstash { git stash @args }
    function gpop { git stash pop @args }
    
    # Additional useful git aliases
    function gf { git fetch @args }
    function gm { git merge @args }
    function gr { git rebase @args }
    function gsh { git show @args }
    function gre { git remote -v @args }
    function gt { git tag @args }
    function glp { git log --pretty=format:"%h %s" --graph @args }
    
    # Power user aliases
    function gwip { git add -A; git commit -m "WIP" @args }
    function gunwip { 
        $lastCommit = git log -n 1 --pretty=format:"%s"
        if ($lastCommit -match "WIP") { git reset HEAD~1 @args }
    }
    function gcp { git cherry-pick @args }
    function gmt { git mergetool @args }
}

# ===============================
# 🖥️ WINDOWS TERMINAL ALIASES
# ===============================
if (Test-CommandExists "wt") {
    function wt-new { wt new-tab @args }
    function wt-split { wt split-pane @args }
    function wt-hsplit { wt split-pane -H @args }
    function wt-vsplit { wt split-pane -V @args }
}

# ===============================
# 🛠️ SYSTEM SHORTCUTS
# ===============================
function reload { 
    . $PROFILE
    Write-Host "🔄 PowerShell profile reloaded!" -ForegroundColor Green
}

# Network shortcuts with smart tools
function ping5 { ping -n 5 @args }

if (Test-CommandExists "curl") {
    function myip { curl -s ifconfig.me }
    function weather { 
        param([string]$City = "")
        if ($City) { curl "wttr.in/$City" } else { curl wttr.in }
    }
    function cheat { curl "cheat.sh/$args" }
}

# System information with smart fallbacks
if (Test-CommandExists "neofetch") {
    Set-Alias -Name sysinfo -Value neofetch -Force
} else {
    function sysinfo {
        Write-Host "System Information:" -ForegroundColor Cyan
        Write-Host "OS: $((Get-WmiObject -Class Win32_OperatingSystem).Caption)"
        Write-Host "Version: $((Get-WmiObject -Class Win32_OperatingSystem).Version)"
        Write-Host "Architecture: $env:PROCESSOR_ARCHITECTURE"
        Write-Host "Memory: $([math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory/1GB,2)) GB"
        Write-Host "Uptime: $((Get-Date) - (Get-WmiObject -Class Win32_OperatingSystem).ConvertToDateTime((Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime))"
    }
}

Set-Alias -Name diskspace -Value df -Force
function meminfo { Get-WmiObject -Class Win32_PhysicalMemory | Format-Table Capacity, Speed, Manufacturer -AutoSize }
function cpuinfo { Get-WmiObject -Class Win32_Processor | Format-Table Name, NumberOfCores, MaxClockSpeed -AutoSize }

# ===============================
# 📦 PACKAGE MANAGER DETECTION
# ===============================
if (Test-CommandExists "winget") {
    function install { winget install @args }
    function search { winget search @args }
    function update-all { winget upgrade --all }
} elseif (Test-CommandExists "choco") {
    function install { choco install @args }
    function search { choco search @args }
    function update-all { choco upgrade all }
} elseif (Test-CommandExists "scoop") {
    function install { scoop install @args }
    function search { scoop search @args }
    function update-all { scoop update * }
}

# ===============================
# 📋 PRODUCTIVITY
# ===============================
function week { Get-Date -UFormat %V }
function path { $env:PATH -split ';' | ForEach-Object { $_ } }
function env { Get-ChildItem Env: | Sort-Object Name }

# Development shortcuts
if (Test-CommandExists "python") {
    function serve { python -m http.server 8000 @args }
    Set-Alias -Name py -Value python -Force
} elseif (Test-CommandExists "python3") {
    function serve { python3 -m http.server 8000 @args }
    Set-Alias -Name py -Value python3 -Force
}

# ===============================
# 📋 CLIPBOARD
# ===============================
function copy { $input | Set-Clipboard }
function paste { Get-Clipboard }

# ===============================
# 🔧 DEVELOPMENT TOOLS
# ===============================

# Node.js tools
if (Test-CommandExists "npm") {
    function ni { npm install @args }
    function nr { npm run @args }
    function ns { npm start @args }
    function nt { npm test @args }
}

if (Test-CommandExists "yarn") {
    Set-Alias -Name y -Value yarn -Force
    function ya { yarn add @args }
    function yr { yarn run @args }
}

# .NET tools
if (Test-CommandExists "dotnet") {
    function dn { dotnet @args }
    function dnr { dotnet run @args }
    function dnb { dotnet build @args }
    function dnt { dotnet test @args }
}

# ===============================
# 🎨 FUN EXTRAS
# ===============================
if (Test-CommandExists "fortune") {
    Set-Alias -Name quote -Value fortune -Force
}

# ===============================
# 📊 SMART ALIASES INFO
# ===============================
function Show-AliasesHelp {
    Write-Host @"
🏠 Mini Sweet Home Smart Aliases (PowerShell):
📁 Navigation: ls, ll, la, lt, tree (eza/exa/Get-ChildItem)
🔍 Search: ff, grep (fd/rg fallbacks)  
📝 Edit: v, vi, vim (nvim fallback)
📊 System: top, disk, cat (modern tools + Windows)
🐙 Git: g, ga, gc, gst, gp, gl
🖥️ Windows: wt-*, take-ownership, grant-fullcontrol
📦 Package: install, search, update-all (winget/choco/scoop)
🚀 Tools auto-fallback to available alternatives!
"@ -ForegroundColor Green
}

Set-Alias -Name aliases-help -Value Show-AliasesHelp -Force
