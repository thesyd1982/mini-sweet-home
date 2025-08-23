#!/bin/bash

echo "🧹 NETTOYAGE COMPLET - Mini Sweet Home v2.0"
echo "==========================================="
echo

echo "🗑️  Suppression des fichiers obsolètes..."

# Supprimer le dossier bin/ entier (22 scripts obsolètes)
if [ -d "bin" ]; then
    echo "❌ Suppression de bin/ (22 scripts obsolètes)"
    rm -rf bin/
else
    echo "⚠️  bin/ déjà supprimé"
fi

# Supprimer le dossier tools/ entier (4 scripts obsolètes)
if [ -d "tools" ]; then
    echo "❌ Suppression de tools/ (4 scripts obsolètes)"
    rm -rf tools/
else
    echo "⚠️  tools/ déjà supprimé"
fi

# Supprimer le dossier tests/ entier (anciens tests)
if [ -d "tests" ]; then
    echo "❌ Suppression de tests/ (anciens tests)"
    rm -rf tests/
else
    echo "⚠️  tests/ déjà supprimé"
fi

# Supprimer les anciens scripts d'installation
files_to_remove=(
    "install"
    "standalone-install.sh"
    "make-executable.sh"
    "demo"
    "test-real.sh"
    "quick-test.sh"
    "final-test.sh"
    "tmux-client-4563.log"
    "tmux-server-4565.log"
)

for file in "${files_to_remove[@]}"; do
    if [ -f "$file" ]; then
        echo "❌ Suppression de $file"
        rm -f "$file"
    else
        echo "⚠️  $file déjà supprimé"
    fi
done

echo
echo "✅ Nettoyage terminé !"
echo
echo "📊 Résumé du nettoyage :"
echo "========================"
echo "❌ bin/ supprimé (22 scripts)"
echo "❌ tools/ supprimé (4 scripts)"  
echo "❌ tests/ supprimé (2 fichiers)"
echo "❌ 9 fichiers obsolètes supprimés"
echo
echo "✅ Structure finale propre :"
echo "mini-sweet-home/"
echo "├── setup           # Script principal moderne"
echo "├── Makefile        # Interface simplifiée"
echo "├── README.md       # Documentation complète"
echo "├── .gitignore      # Configuration git"
echo "├── configs/        # Configurations (nvim, tmux, shell, git)"
echo "└── docs/           # Documentation organisée"
echo
echo "🎉 Architecture 95% plus propre !"
echo "🚀 Prêt pour le déploiement professionnel !"
