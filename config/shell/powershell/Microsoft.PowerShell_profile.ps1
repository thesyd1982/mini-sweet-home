# ==========================================
# 🏠 MINI SWEET HOME - POWERSHELL PROFILE
# ==========================================

# ==========================================
# 🚀 MINIMAL LAMBDA PROMPT
# ==========================================

function Get-GitBranch {
    try {
        $branch = git symbolic-ref --short HEAD 2>$null
        if ($branch) {
            $status = git status --porcelain 2>$null
            $color = if ($status) { "Red" } else { "Green" }
            return " " + (Write-Host $branch -ForegroundColor $color -NoNewline; "")
        }
    }
    catch { }
    return ""
}

function prompt {
    $lastSuccess = $?
    $lambdaColor = if ($lastSuccess) { "Green" } else { "Red" }
    
    # Lambda symbol + white chevron
    Write-Host "λ" -ForegroundColor $lambdaColor -NoNewline
    Write-Host " › " -ForegroundColor White -NoNewline
    
    # Path on the right (simulated)
    $location = Get-Location
    $gitInfo = Get-GitBranch
    
    return ""
}

# Alternative simple si Git pose problème
function prompt-simple {
    $lastSuccess = $?
    $lambdaColor = if ($lastSuccess) { "Green" } else { "Red" }
    
    Write-Host "λ" -ForegroundColor $lambdaColor -NoNewline
    Write-Host " › " -ForegroundColor White -NoNewline
    
    return ""
}

# ==========================================
# 📝 PSREADLINE CONFIGURATION
# ==========================================
if (Get-Module PSReadLine -ErrorAction SilentlyContinue) {
    # Historique et autocomplétion améliorés
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    
    # Raccourcis clavier
    Set-PSReadLineKeyHandler -Key Tab -Function Complete
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
    Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
    
    # Couleurs
    Set-PSReadLineOption -Colors @{
        Command = 'Green'
        Parameter = 'Gray'
        Operator = 'DarkCyan'
        Variable = 'DarkGreen'
        String = 'Blue'
        Number = 'DarkMagenta'
        Type = 'DarkYellow'
        Comment = 'DarkGray'
    }
}

# ==========================================
# 🛡️ SMART TOOL DETECTION & FALLBACKS
# ==========================================

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# ==========================================
# 🔧 SMART ALIASES - WINDOWS EQUIVALENTS
# ==========================================

# Navigation améliorée
Set-Alias -Name ll -Value Get-ChildItemLong -Force
Set-Alias -Name la -Value Get-ChildItemAll -Force
Set-Alias -Name l -Value Get-ChildItemSimple -Force

function Get-ChildItemLong { Get-ChildItem @args | Format-Table -AutoSize }
function Get-ChildItemAll { Get-ChildItem @args -Force | Format-Table -AutoSize }
function Get-ChildItemSimple { Get-ChildItem @args | Select-Object Name, Length, LastWriteTime }

# Remplacement ls intelligent (eza -> exa -> Get-ChildItem)
if (Test-CommandExists "eza") {
    function ls { eza --color=always --group-directories-first --icons @args }
    function ll { eza -la --color=always --group-directories-first --icons @args }
    function la { eza -a --color=always --group-directories-first --icons @args }
    function lt { eza -T --color=always --group-directories-first --icons @args }
    Set-Alias -Name tree -Value lt
} elseif (Test-CommandExists "exa") {
    function ls { exa --color=always --group-directories-first @args }
    function ll { exa -la --color=always --group-directories-first @args }
    function la { exa -a --color=always --group-directories-first @args }
    function lt { exa -T --color=always --group-directories-first @args }
    Set-Alias -Name tree -Value lt
} else {
    # Fallback vers Get-ChildItem natif avec format amélioré
    function ls { Get-ChildItem @args | Format-Wide -AutoSize }
}

# Cat intelligent (bat -> Get-Content)
if (Test-CommandExists "bat") {
    function cat { bat --paging=never @args }
    Set-Alias -Name ccat -Value Get-Content  # Cat original
} else {
    Set-Alias -Name cat -Value Get-Content
    Set-Alias -Name ccat -Value Get-Content
}

# Grep intelligent (rg -> Select-String)
if (Test-CommandExists "rg") {
    function grep { rg @args }
    function search { rg -i @args }
} else {
    function grep { Select-String @args }
    function search { Select-String @args }
}

# Find intelligent (fd -> Get-ChildItem récursif)
if (Test-CommandExists "fd") {
    function ff { fd @args }
    function find-files { fd @args }
} elseif (Test-CommandExists "fdfind") {
    function ff { fdfind @args }
    function find-files { fdfind @args }
} else {
    function ff { Get-ChildItem -Recurse -Name @args }
    function find-files { Get-ChildItem -Recurse -Name @args }
}

# Disk usage intelligent (dust -> Get-FolderSize personnalisé)
if (Test-CommandExists "dust") {
    function du { dust @args }
    function disk { dust @args }
} else {
    function Get-FolderSize {
        param([string]$Path = ".")
        Get-ChildItem $Path -Recurse -File | Measure-Object -Property Length -Sum |
            ForEach-Object { [math]::Round($_.Sum / 1MB, 2) }
    }
    Set-Alias -Name du -Value Get-FolderSize
    Set-Alias -Name disk -Value Get-FolderSize
}

# ==========================================
# 📝 EDITOR DETECTION & FALLBACKS
# ==========================================
if (Test-CommandExists "nvim") {
    Set-Alias -Name v -Value nvim
    Set-Alias -Name vi -Value nvim
    Set-Alias -Name vim -Value nvim
    Set-Alias -Name edit -Value nvim
} elseif (Test-CommandExists "vim") {
    Set-Alias -Name v -Value vim
    Set-Alias -Name vi -Value vim
    Set-Alias -Name edit -Value vim
} elseif (Test-CommandExists "code") {
    Set-Alias -Name v -Value code
    Set-Alias -Name edit -Value code
} else {
    Set-Alias -Name v -Value notepad
    Set-Alias -Name edit -Value notepad
}

# ==========================================
# ⚡ MINI SWEET HOME SPECIFIC
# ==========================================
$configPath = Split-Path $PROFILE -Parent

function Edit-ZshConfig { nvim "$env:USERPROFILE\.mini-sweet-home\configs\shell\zsh\zshrc" }
function Edit-PowerShellConfig { nvim $PROFILE }
function Edit-NeovimConfig { nvim "$env:LOCALAPPDATA\nvim" }
function Edit-GitConfig { nvim "$env:USERPROFILE\.gitconfig" }
Set-Alias -Name vzc -Value Edit-ZshConfig
Set-Alias -Name vps -Value Edit-PowerShellConfig
Set-Alias -Name vnv -Value Edit-NeovimConfig
Set-Alias -Name vgit -Value Edit-GitConfig
# vstarship removed - using minimal lambda prompt instead

# ==========================================
# 📁 SMART NAVIGATION
# ==========================================
Set-Alias -Name c -Value Clear-Host
Set-Alias -Name h -Value Get-History

# Directory operations with smart defaults
function md { New-Item -ItemType Directory @args }
function rd { Remove-Item @args }
function mkd { New-Item -ItemType Directory @args }

# Take function - create directory and navigate into it
function take {
    param([string]$Path)
    if (-not $Path) {
        Write-Host "Usage: take <directory_name>" -ForegroundColor Red
        return
    }
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
    Write-Host "✅ Created and entered: $Path" -ForegroundColor Green
}

# Smart back navigation
function back {
    param([int]$levels = 1)
    $path = ".."
    for ($i = 1; $i -lt $levels; $i++) {
        $path = Join-Path ".." $path
    }
    Set-Location $path
}

# Navigation shortcuts
function .. { Set-Location ".." }
function ... { Set-Location "..\.." }
function .... { Set-Location "..\..\.." }

# ==========================================
# 🐙 GIT ALIASES
# ==========================================
if (Test-CommandExists "git") {
    Set-Alias -Name g -Value git
    
    function ga { git add @args }
    function gaa { git add --all }
    function gc { git commit -v @args }
    function gcm { git commit -m @args }
    function gco { git checkout @args }
    function gcb { git checkout -b @args }
    function gst { git status }
    function gss { git status -s }
    function gl { git pull }
    function gp { git push }
    function gb { git branch }
    function gd { git diff @args }
    function glog { git log --oneline --decorate --graph @args }
}

# ==========================================
# 🛠️ SYSTEM SHORTCUTS
# ==========================================
function reload { & $PROFILE }
function profile { nvim $PROFILE }

# Network shortcuts
function myip {
    try {
        (Invoke-WebRequest -Uri "https://ifconfig.me" -UseBasicParsing).Content.Trim()
    }
    catch {
        Write-Host "Erreur lors de la récupération de l'IP" -ForegroundColor Red
    }
}

function weather {
    param([string]$City)
    if ($City) {
        curl "wttr.in/$City"
    } else {
        curl "wttr.in"
    }
}

# System information
function sysinfo {
    if (Test-CommandExists "neofetch") {
        neofetch
    } else {
        Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory, CsProcessors | Format-List
    }
}

function diskspace { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}} | Format-Table }

function meminfo { Get-WmiObject -Class Win32_OperatingSystem | Select-Object @{Name="Total(GB)";Expression={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}}, @{Name="Available(GB)";Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}} | Format-List }

# ==========================================
# 🚀 DEVELOPMENT TOOLS
# ==========================================

# Node.js tools
if (Test-CommandExists "npm") {
    function ni { npm install @args }
    function nr { npm run @args }
    function ns { npm start }
    function nt { npm test }
}

if (Test-CommandExists "yarn") {
    Set-Alias -Name y -Value yarn
    function ya { yarn add @args }
    function yr { yarn run @args }
}

# Python tools
if (Test-CommandExists "python") {
    function py { python @args }
    function pip-install { pip install @args }
    function serve { python -m http.server 8000 }
}

# ==========================================
# 🪟 TMUX CROSS-PLATFORM VIA MSYS2
# ==========================================
if (Test-Path "C:\msys64\usr\bin\tmux.exe") {
    # Wrapper functions pour tmux via MSYS2
    function Start-Tmux { 
        param([string]$SessionName = "")
        if ($SessionName) {
            & "C:\msys64\usr\bin\bash.exe" -lc "tmux new-session -s '$SessionName'"
        } else {
            & "C:\msys64\usr\bin\bash.exe" -lc "tmux"
        }
    }
    
    function Get-TmuxSessions { 
        & "C:\msys64\usr\bin\bash.exe" -lc "tmux list-sessions" 
    }
    
    function Connect-TmuxSession { 
        param([string]$SessionName)
        if ($SessionName) {
            & "C:\msys64\usr\bin\bash.exe" -lc "tmux attach-session -t '$SessionName'"
        } else {
            & "C:\msys64\usr\bin\bash.exe" -lc "tmux attach-session"
        }
    }
    
    function Remove-TmuxSession { 
        param([string]$SessionName)
        if ($SessionName) {
            & "C:\msys64\usr\bin\bash.exe" -lc "tmux kill-session -t '$SessionName'"
        }
    }
    
    function Start-DevLayout {
        & "C:\msys64\usr\bin\bash.exe" -lc "tmux new-session -d && tmux split-window -h && tmux split-window -v && tmux select-pane -t 0 && tmux split-window -v && tmux attach-session"
    }
    
    # Aliases tmux courts
    Set-Alias -Name tmux -Value Start-Tmux
    Set-Alias -Name tls -Value Get-TmuxSessions  
    Set-Alias -Name ta -Value Connect-TmuxSession
    Set-Alias -Name tnew -Value Start-Tmux
    Set-Alias -Name tkill -Value Remove-TmuxSession
    Set-Alias -Name ide -Value Start-DevLayout
    
    # Lancement direct dans MSYS2 + Tmux
    function Enter-DevEnvironment {
        Write-Host "🚀 Lancement de l'environnement de développement Tmux + Neovim..." -ForegroundColor Cyan
        & "C:\msys64\usr\bin\bash.exe" -lc "tmux new-session -s 'dev' || tmux attach-session -t 'dev'"
    }
    
    Set-Alias -Name dev -Value Enter-DevEnvironment
    Set-Alias -Name devenv -Value Enter-DevEnvironment
}

# ==========================================  
# 🚀 NEOVIM CROSS-PLATFORM
# ==========================================
if (Test-Path "C:\msys64\usr\bin\nvim.exe") {
    # Wrapper pour Neovim via MSYS2 (meilleure compatibilité)
    function Start-NeovimMSYS2 { 
        & "C:\msys64\usr\bin\bash.exe" -lc "nvim $args"
    }
    
    # Préférer Neovim MSYS2 si disponible (meilleure intégration Unix)
    Set-Alias -Name nvim-unix -Value Start-NeovimMSYS2
    Set-Alias -Name vim-unix -Value Start-NeovimMSYS2
}

if (Test-CommandExists "winget") {
    function winget-install { winget install @args }
    function winget-update { winget upgrade --all }
    function winget-search { winget search @args }
}

# ==========================================
# 💡 HELP SYSTEM
# ==========================================
function Show-MiniSweetHomeHelp {
    Write-Host "🏠 Mini Sweet Home - PowerShell Commands" -ForegroundColor Cyan
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📁 Navigation:" -ForegroundColor Green
    Write-Host "  ls, ll, la, lt     - Listing files (eza/exa fallback)"
    Write-Host "  .., ..., ....      - Navigate up directories"
    Write-Host "  take <dir>         - Create and enter directory"
    Write-Host "  back [levels]      - Go back multiple levels"
    Write-Host ""
    Write-Host "🔍 Search:" -ForegroundColor Green
    Write-Host "  ff, grep, search   - File search and content search"
    Write-Host "  cat                - File viewing (bat fallback)"
    Write-Host ""
    Write-Host "📝 Edit:" -ForegroundColor Green
    Write-Host "  v, vi, vim         - Editor (nvim fallback)"
    Write-Host "  vnv                - Edit Neovim config"
    Write-Host "  vps                - Edit PowerShell profile"
    Write-Host ""
    Write-Host "⚡ Git:" -ForegroundColor Green
    Write-Host "  g, ga, gc, gst     - Git shortcuts"
    Write-Host "  gp, gl, gco        - Push, pull, checkout"
    Write-Host ""
    Write-Host "🛠️ System:" -ForegroundColor Green
    Write-Host "  sysinfo            - System information"
    Write-Host "  diskspace          - Disk usage"
    Write-Host "  myip, weather      - Network utilities"
    Write-Host ""
    Write-Host "📦 Packages:" -ForegroundColor Green
    Write-Host "  install <pkg>      - Install package (choco)"
    Write-Host "  update             - Update all packages"
    Write-Host "  search <pkg>       - Search packages"
    Write-Host ""
}

Set-Alias -Name commands -Value Show-MiniSweetHomeHelp
Set-Alias -Name help-msh -Value Show-MiniSweetHomeHelp

# ==========================================
# 🎨 WELCOME MESSAGE
# ==========================================
if ($env:MSH_SHOW_WELCOME -ne "false") {
    Write-Host ""
    Write-Host "🏠 Mini Sweet Home PowerShell Environment Loaded" -ForegroundColor Cyan
    Write-Host "Type 'commands' for available shortcuts" -ForegroundColor Gray
    Write-Host ""
}