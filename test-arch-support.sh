#!/bin/bash
# MSH Arch Linux Support Test
# Test the new Arch Linux compatibility without actual installation

set -e

# Colors
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

echo -e "${CYAN}🧪 MSH ARCH LINUX SUPPORT TEST${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Load functions
MSH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$MSH_DIR/lib/utils/validation.sh"

echo -e "${BLUE}🔍 Testing OS Detection:${NC}"
echo "  Current OS: $(detect_os)"
echo "  Package Manager: $(detect_package_manager)"
echo

echo -e "${BLUE}🧪 Testing Arch Package Name Mapping:${NC}"
declare -A ARCH_PACKAGES=(
    ["rg"]="ripgrep"
    ["fd"]="fd"
    ["eza"]="eza"
    ["bat"]="bat"
    ["dust"]="dust"
    ["fzy"]="fzy"
    ["zoxide"]="zoxide"
    ["cmake"]="cmake"
)

for tool in "${!ARCH_PACKAGES[@]}"; do
    package="${ARCH_PACKAGES[$tool]}"
    echo "  $tool → $package"
done
echo

echo -e "${BLUE}🔧 Testing AUR Helper Detection:${NC}"
if command -v yay >/dev/null 2>&1; then
    echo -e "  ${GREEN}✅ yay found${NC}"
elif command -v paru >/dev/null 2>&1; then
    echo -e "  ${GREEN}✅ paru found${NC}"
elif command -v pacman >/dev/null 2>&1; then
    echo -e "  ${YELLOW}⚠️  pacman only (no AUR helper)${NC}"
else
    echo -e "  ${RED}❌ No Arch package managers found${NC}"
fi
echo

echo -e "${BLUE}📦 Testing Package Availability (simulation):${NC}"
for tool in "${!ARCH_PACKAGES[@]}"; do
    package="${ARCH_PACKAGES[$tool]}"
    echo "  Would install: $tool via $package"
done
echo

echo -e "${BLUE}🛡️ Testing Fallback System:${NC}"
source "$MSH_DIR/lib/fallbacks.sh" quiet 2>/dev/null || true
echo "  Fuzzy finder: ${MSH_FUZZY_FINDER:-not set}"
echo "  List tool: ${MSH_LIST_TOOL:-not set}"
echo "  Grep tool: ${MSH_GREP_TOOL:-not set}"
echo

echo -e "${GREEN}✅ Arch Linux support test completed!${NC}"
echo -e "${YELLOW}💡 To test on actual Arch Linux:${NC}"
echo "  1. Copy MSH to Arch system"
echo "  2. Run: ./msh install"
echo "  3. Check: ./msh status"