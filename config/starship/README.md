# 🌟 Starship Configurations - Mini Sweet Home

## Configurations Disponibles

### 🚀 Minimal (Recommandée pour dev)
```bash
ss minimal
```
**Affiche uniquement :**
- 📁 Répertoire (avec icônes projets)
- 🌿 Git branch + status
- 🚀 Langages détectés (Node, Python, Rust, Go)
- 🐳 Docker (si actif)
- ☁️ AWS région
- ⎈ Kubernetes context
- ❯ Prompt avec codes d'erreur

### 🎨 Full (Complète)
```bash
ss full
```
**Affiche tout :**
- Minimal + OS, user, time, battery, memory
- Plus d'icônes et couleurs
- Format multi-lignes

## Commandes

```bash
# Basculer vers minimal
ss minimal
ss m

# Basculer vers complète  
ss full
ss f

# Voir config actuelle
ss current
ss c

# Éditer config active
ss edit
ss e

# Aide
ss help
```

## Fonctionnalités Intelligentes (Minimal)

### 📁 Icônes Répertoires
- 🏠 `mini-sweet-home`
- 📁 `projects` 
- 💼 `work`
- ⚡ `dev`

### 🚀 Détection Langages
- **Node.js** : package.json, .js, .ts
- **Python** : requirements.txt, .py
- **Rust** : Cargo.toml, .rs  
- **Go** : go.mod, .go

### 🐳 Docker
- Affiché seulement si docker-compose.yml ou Dockerfile présent

### ☁️ AWS
- Région actuelle si configurée

### 🌿 Git Status
- `?` Non suivi
- `!` Modifié  
- `+` Staged
- `⇡` Commits en avance
- `⇣` Commits en retard

## Personnalisation

```bash
# Éditer config minimal
nvim ~/mini-sweet-home/configs/starship/starship-minimal.toml

# Éditer config complète
nvim ~/mini-sweet-home/configs/starship/starship.toml
```

## Exemple Prompts

**Minimal dans projet Node.js :**
```
📁 myproject  main ! 16.20.0  ❯
```

**Minimal avec Docker et AWS :**
```
🏠  main  18.0.0 🐳 dev ☁️ eu-west-3 ❯
```

**Avec erreur :**
```
📁 project  main  18.0.0 [✖130] ❯
```
