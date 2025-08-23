# Guide de dépannage MarkdownPreview dans WSL

## Le problème
L'erreur "Can not open browser by using cmd.exe command" se produit parce que `markdown-preview.nvim` essaie d'utiliser `cmd.exe` pour ouvrir le navigateur, ce qui ne fonctionne pas correctement dans WSL.

## Solutions

### Solution 1 : Utiliser wslview (Recommandé)

1. **Installer wslu** (si pas déjà fait) :
   ```bash
   sudo apt update
   sudo apt install wslu
   ```

2. **Vérifier que wslview fonctionne** :
   ```bash
   wslview --help
   ```

3. **Configuration dans Neovim** (déjà appliquée) :
   ```lua
   vim.g.mkdp_browser = 'wslview'
   ```

### Solution 2 : Chemin direct vers le navigateur Windows

Si wslview ne fonctionne pas, utilisez le chemin direct :

```lua
-- Pour Chrome
vim.g.mkdp_browser = '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'

-- Pour Edge
vim.g.mkdp_browser = '/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'

-- Pour Firefox
vim.g.mkdp_browser = '/mnt/c/Program Files/Mozilla Firefox/firefox.exe'
```

### Solution 3 : Utiliser un serveur local

1. **Configuration** :
   ```lua
   vim.g.mkdp_browser = ''  -- Navigateur vide
   vim.g.mkdp_echo_preview_url = 1  -- Affiche l'URL
   ```

2. **Utilisation** :
   - Lancez `:MarkdownPreview`
   - Copiez l'URL affichée (ex: http://127.0.0.1:8080)
   - Ouvrez manuellement dans votre navigateur

## Commandes utiles

- `:MarkdownPreview` - Démarrer la prévisualisation
- `:MarkdownPreviewStop` - Arrêter la prévisualisation
- `:MarkdownPreviewToggle` - Basculer la prévisualisation

## Dépannage avancé

### Vérifier les ports
```bash
# Vérifier si le port 8080 est libre
netstat -lan | grep 8080
```

### Tester wslview
```bash
# Tester avec une URL simple
wslview https://google.com
```

### Logs de débogage
Ajoutez dans votre configuration :
```lua
vim.g.mkdp_echo_preview_url = 1
```

## Configuration actuelle

Le fichier `configs/nvim/lua/plugins/markdown.lua` a été configuré avec :
- `wslview` comme navigateur par défaut
- Port 8080 pour le serveur local
- Affichage de l'URL dans Neovim
- Désactivation du démarrage automatique

## Installation rapide

Exécutez le script de correction :
```bash
~/mini-sweet-home/bin/fix-markdown-preview
```

Ce script :
1. Installe wslu si nécessaire
2. Configure MarkdownPreview optimalement pour WSL
3. Crée une sauvegarde de votre configuration actuelle
