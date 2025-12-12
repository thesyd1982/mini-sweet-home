#!/bin/bash
# Test du comportement de la commande système MSH

echo "=== Test de la Commande Système MSH ==="
echo

echo "1. Test de la commande système avec debug:"
echo

# Créer une version de debug de la logique de détection
test_detection() {
    local script_path="$1"
    echo "   Testant: $script_path"
    echo "   basename: $(basename "$script_path")"
    echo "   dirname: $(dirname "$script_path")"
    
    if [[ "$(basename "$script_path")" == "msh" && "$(dirname "$script_path")" == "$HOME/.local/bin" ]]; then
        echo "   ✅ Condition SYSTÈME détectée"
        if [[ -d "$HOME/mini-sweet-home" && -f "$HOME/mini-sweet-home/msh" ]]; then
            DETECTED_SCRIPT_DIR="$HOME/mini-sweet-home"
            echo "   ✅ SCRIPT_DIR résolu: $DETECTED_SCRIPT_DIR"
        else
            echo "   ❌ ERREUR: Répertoire MSH non trouvé"
            return 1
        fi
    else
        echo "   ✅ Condition DIRECTE détectée"
        DETECTED_SCRIPT_DIR="$(cd "$(dirname "$script_path")" && pwd)"
        echo "   ✅ SCRIPT_DIR résolu: $DETECTED_SCRIPT_DIR"
    fi
}

echo "2. Tests avec différents chemins:"
echo
test_detection "/home/thesyd/.local/bin/msh"
echo
test_detection "/home/thesyd/mini-sweet-home/msh"
echo
test_detection "./msh"
echo

echo "3. Test avec la vraie commande système:"
echo "   Execution: /home/thesyd/.local/bin/msh"
echo "   Sortie attendue: Doit utiliser ~/mini-sweet-home comme SCRIPT_DIR"
echo
echo "   Exécution de: /home/thesyd/.local/bin/msh status | head -5"
/home/thesyd/.local/bin/msh status | head -5
echo

echo "4. Test avec exécution directe:"
echo "   Execution: ./msh"  
echo "   Sortie attendue: Doit utiliser répertoire courant comme SCRIPT_DIR"
echo
echo "   Exécution de: ./msh status | head -5"
./msh status | head -5
echo

echo "=== Fin des tests ==="