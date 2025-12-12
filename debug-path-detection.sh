#!/bin/bash
# Debug script pour analyser la logique de détection de chemin MSH v3.0

echo "=== Analyse de la Détection de Chemin MSH v3.0 ==="
echo

echo "1. Variables d'environnement actuelles:"
echo "   HOME: $HOME"
echo "   PWD: $PWD"
echo "   SCRIPT_NAME: $(basename "$0")"
echo "   SCRIPT_DIR: $(dirname "$0")"
echo "   BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
echo

echo "2. Test de la logique actuelle:"
echo "   basename \"\$0\": $(basename "$0")"
echo "   dirname \"\$0\": $(dirname "$0")"
echo "   \$HOME/.local/bin: $HOME/.local/bin"
echo

echo "3. Test de la condition système:"
if [[ "$(basename "$0")" == "msh" && "$(dirname "$0")" == "$HOME/.local/bin" ]]; then
    echo "   ✅ Condition SYSTÈME détectée"
    echo "   🔍 Recherche du répertoire MSH..."
    if [[ -d "$HOME/mini-sweet-home" && -f "$HOME/mini-sweet-home/msh" ]]; then
        SCRIPT_DIR="$HOME/mini-sweet-home"
        echo "   ✅ Répertoire MSH trouvé: $SCRIPT_DIR"
    else
        echo "   ❌ Répertoire MSH NON TROUVÉ à $HOME/mini-sweet-home"
    fi
else
    echo "   ✅ Condition DIRECTE détectée"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "   📁 Utilisation du répertoire du script: $SCRIPT_DIR"
fi
echo

echo "4. Vérifications des chemins critiques:"
echo "   MSH Project: $(ls -d "$HOME/mini-sweet-home" 2>/dev/null || echo "NOT FOUND")"
echo "   MSH Script: $(ls "$HOME/mini-sweet-home/msh" 2>/dev/null || echo "NOT FOUND")"
echo "   System MSH: $(ls "$HOME/.local/bin/msh" 2>/dev/null || echo "NOT FOUND")"
echo "   ~/.local/bin exists: $(ls -d "$HOME/.local/bin" 2>/dev/null && echo "YES" || echo "NO")"
echo

echo "5. Problèmes potentiels identifiés:"
echo "   🚨 HARDCODED PATH: Code assume MSH toujours à ~/mini-sweet-home"
echo "   🚨 NO VALIDATION: Pas de validation que SCRIPT_DIR contient MSH valide"
echo "   🚨 SINGLE CHECK: Seulement ~/.local/bin vérifié, pas d'autres emplacements"
echo "   🚨 NO FALLBACK: Pas de mécanisme de fallback si détection échoue"
echo

echo "6. Cas d'échec possibles:"
echo "   ❌ MSH installé dans un répertoire différent"
echo "   ❌ Répertoire mini-sweet-home renommé"
echo "   ❌ Installation system dans un chemin différent de ~/.local/bin"
echo "   ❌ Permissions insuffisantes sur ~/.local/bin"
echo "   ❌ Installations multiples de MSH"
echo

echo "7. Variables résultantes actuelles:"
echo "   SCRIPT_DIR: ${SCRIPT_DIR:-"NOT SET"}"
if [[ -n "${SCRIPT_DIR:-}" ]]; then
    echo "   BIN_DIR: $SCRIPT_DIR/bin"
    echo "   LIB_DIR: $SCRIPT_DIR/lib"
    echo "   CONFIG_DIR: $SCRIPT_DIR/config"
    echo "   Bin exists: $(ls -d "$SCRIPT_DIR/bin" 2>/dev/null && echo "YES" || echo "NO")"
    echo "   Lib exists: $(ls -d "$SCRIPT_DIR/lib" 2>/dev/null && echo "YES" || echo "NO")"
    echo "   Config exists: $(ls -d "$SCRIPT_DIR/config" 2>/dev/null && echo "YES" || echo "NO")"
fi
echo

echo "=== Fin de l'analyse ==="