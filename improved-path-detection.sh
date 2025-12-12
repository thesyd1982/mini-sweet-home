#!/bin/bash
# Version améliorée de la détection de chemin MSH v3.0
# Résout les problèmes identifiés dans l'analyse

# ================================================================
# NOUVELLE LOGIQUE DE DÉTECTION DE CHEMIN - Plus Robuste
# ================================================================

detect_msh_directory() {
    local script_path="${BASH_SOURCE[0]}"
    local script_name="$(basename "$0")"
    local script_dir="$(dirname "$0")"
    
    echo "🔍 Détection intelligente du répertoire MSH..."
    echo "   Script: $script_name dans $script_dir"
    
    # 1. DETECTION PAR SYMLINK (méthode la plus fiable)
    if [[ -L "$0" ]]; then
        local real_path="$(readlink -f "$0")"
        local msh_dir="$(dirname "$real_path")"
        echo "   ✅ Symlink détecté, chemin réel: $real_path"
        if validate_msh_directory "$msh_dir"; then
            echo "   ✅ Répertoire MSH validé: $msh_dir"
            echo "$msh_dir"
            return 0
        fi
    fi
    
    # 2. DETECTION PAR FICHIER DE CONFIGURATION
    if [[ -f "$HOME/.msh-config" ]]; then
        local config_dir="$(grep "^MSH_PROJECT_DIR=" "$HOME/.msh-config" | cut -d'=' -f2 | tr -d '"')"
        if [[ -n "$config_dir" ]] && validate_msh_directory "$config_dir"; then
            echo "   ✅ Répertoire trouvé via config: $config_dir"
            echo "$config_dir"
            return 0
        fi
    fi
    
    # 3. DETECTION PAR VARIABLE D'ENVIRONNEMENT
    if [[ -n "${MSH_PROJECT_DIR:-}" ]] && validate_msh_directory "$MSH_PROJECT_DIR"; then
        echo "   ✅ Répertoire trouvé via MSH_PROJECT_DIR: $MSH_PROJECT_DIR"
        echo "$MSH_PROJECT_DIR"
        return 0
    fi
    
    # 4. DETECTION SYSTEME (commande installée)
    if [[ "$script_name" == "msh" && "$script_dir" == "$HOME/.local/bin" ]]; then
        echo "   🔍 Commande système détectée, recherche du projet..."
        
        # Essayer plusieurs emplacements communs
        local common_locations=(
            "$HOME/mini-sweet-home"
            "$HOME/.config/msh"
            "$HOME/Development/mini-sweet-home"
            "$HOME/Projects/mini-sweet-home"
            "$HOME/dev/mini-sweet-home"
        )
        
        for location in "${common_locations[@]}"; do
            if validate_msh_directory "$location"; then
                echo "   ✅ Répertoire trouvé: $location"
                echo "$location"
                return 0
            fi
        done
        
        # Recherche plus large si rien trouvé
        echo "   🔍 Recherche élargie dans le système..."
        local found_dir
        found_dir="$(find "$HOME" -maxdepth 3 -name "msh" -type f -executable 2>/dev/null | while read -r msh_file; do
            local dir="$(dirname "$msh_file")"
            if validate_msh_directory "$dir"; then
                echo "$dir"
                break
            fi
        done | head -n1)"
        
        if [[ -n "$found_dir" ]]; then
            echo "   ✅ Répertoire trouvé par recherche: $found_dir"
            echo "$found_dir"
            return 0
        fi
    fi
    
    # 5. EXECUTION DIRECTE
    local direct_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if validate_msh_directory "$direct_dir"; then
        echo "   ✅ Exécution directe validée: $direct_dir"
        echo "$direct_dir"
        return 0
    fi
    
    # 6. DERNIER RECOURS - répertoire courant
    if validate_msh_directory "$PWD"; then
        echo "   ⚠️  Utilisation du répertoire courant: $PWD"
        echo "$PWD"
        return 0
    fi
    
    echo "   ❌ ERREUR: Impossible de trouver un répertoire MSH valide"
    return 1
}

# Validation stricte d'un répertoire MSH
validate_msh_directory() {
    local dir="$1"
    
    [[ -d "$dir" ]] || return 1
    [[ -f "$dir/msh" ]] || return 1
    [[ -d "$dir/bin" ]] || return 1
    [[ -d "$dir/lib" ]] || return 1
    [[ -d "$dir/config" ]] || return 1
    [[ -f "$dir/lib/core/common.sh" ]] || return 1
    
    return 0
}

# Création d'un fichier de configuration pour mémoriser l'emplacement
create_msh_config() {
    local msh_dir="$1"
    
    cat > "$HOME/.msh-config" << EOF
# Configuration MSH - Généré automatiquement
MSH_PROJECT_DIR="$msh_dir"
MSH_VERSION="3.0.0"
MSH_CONFIG_DATE="$(date -Iseconds)"
EOF
    
    echo "📝 Configuration sauvegardée dans ~/.msh-config"
}

# ================================================================
# TEST DE LA NOUVELLE LOGIQUE
# ================================================================

echo "=== Test de la Nouvelle Logique de Détection ==="
echo

# Test de détection
MSH_DIR="$(detect_msh_directory)"
exit_code=$?

echo
if [[ $exit_code -eq 0 ]]; then
    echo "✅ SUCCÈS: Répertoire MSH détecté: $MSH_DIR"
    
    # Créer la config si elle n'existe pas
    if [[ ! -f "$HOME/.msh-config" ]]; then
        create_msh_config "$MSH_DIR"
    fi
    
    echo
    echo "📁 Structure validée:"
    echo "   BIN_DIR: $MSH_DIR/bin"
    echo "   LIB_DIR: $MSH_DIR/lib"
    echo "   CONFIG_DIR: $MSH_DIR/config"
    
    echo
    echo "🧪 Test des modules critiques:"
    if [[ -f "$MSH_DIR/lib/core/common.sh" ]]; then
        echo "   ✅ lib/core/common.sh"
    else
        echo "   ❌ lib/core/common.sh manquant"
    fi
    
    if [[ -f "$MSH_DIR/lib/utils/validation.sh" ]]; then
        echo "   ✅ lib/utils/validation.sh"
    else
        echo "   ❌ lib/utils/validation.sh manquant"
    fi
    
else
    echo "❌ ÉCHEC: Impossible de détecter le répertoire MSH"
    echo
    echo "💡 Solutions suggérées:"
    echo "   1. Définir MSH_PROJECT_DIR: export MSH_PROJECT_DIR=/path/to/msh"
    echo "   2. Créer un symlink: ln -sf /path/to/msh ~/.local/bin/msh"
    echo "   3. Exécuter depuis le répertoire MSH: cd /path/to/msh && ./msh"
fi

echo
echo "=== Fin du test ==="