#!/bin/bash
# MSH v3.0 - Testing Library
# Integrated testing functions

# Colors for testing
readonly TEST_GREEN='\033[0;32m'
readonly TEST_YELLOW='\033[1;33m'
readonly TEST_BLUE='\033[0;34m'
readonly TEST_CYAN='\033[0;36m'
readonly TEST_NC='\033[0m'

# Test shell startup performance
test_shell_startup() {
    echo -n "Shell startup: "
    local time_result
    time_result=$(time -p zsh -i -c exit 2>&1 | awk '/real/ {print $2}')
    echo "${time_result}s"
    
    # Performance evaluation
    local time_ms=$(echo "$time_result * 1000" | bc -l 2>/dev/null | cut -d. -f1 2>/dev/null || echo "100")
    if [[ "$time_ms" -lt 50 ]]; then
        echo -e "  ${TEST_GREEN}⚡ Excellent performance!${TEST_NC}"
    elif [[ "$time_ms" -lt 100 ]]; then
        echo -e "  ${TEST_GREEN}✅ Very good performance${TEST_NC}"
    else
        echo -e "  ${TEST_YELLOW}○ Acceptable performance${TEST_NC}"
    fi
}

# Test modern tools status
test_modern_tools() {
    echo "Modern tools status:"
    
    # Load fallbacks from lib  
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local fallbacks_lib="$script_dir/fallbacks.sh"
    if source "$fallbacks_lib" quiet 2>/dev/null; then
        echo "  Fuzzy finder: $MSH_FUZZY_FINDER"
        echo "  List tool: $MSH_LIST_TOOL" 
        echo "  Grep tool: $MSH_GREP_TOOL"
        echo "  Find tool: $MSH_FIND_TOOL"
        echo "  Cat tool: $MSH_CAT_TOOL"
        echo "  Navigation: $MSH_NAV_TOOL"
    else
        echo -e "  ${TEST_YELLOW}⚠️  Fallbacks not loaded${TEST_NC}"
    fi
}

# Test personal functions
test_personal_functions() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local functions_config="$(dirname "$script_dir")/config/shell/zsh/functions.zsh"
    
    if source "$functions_config" 2>/dev/null; then
        if declare -f tm >/dev/null && declare -f gq >/dev/null && declare -f jp >/dev/null && declare -f kcef >/dev/null; then
            echo -e "${TEST_GREEN}✅ Functions loaded: tm, gq, jp, kcef${TEST_NC}"
            return 0
        else
            echo -e "${TEST_YELLOW}⚠️  Some functions missing${TEST_NC}"
            return 1
        fi
    else
        echo -e "${TEST_YELLOW}⚠️  Functions not loaded${TEST_NC}"
        return 1
    fi
}

# Test individual tools
test_individual_tools() {
    echo "Individual tools check:"
    
    local tools=("fzy" "rg" "fd" "bat" "eza" "dust" "zoxide" "cmake" "delta" "hyperfine" "tokei")
    local available=0
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo -e "  ${TEST_GREEN}✅ $tool${TEST_NC}"
            available=$((available + 1))
        else
            echo -e "  ${TEST_YELLOW}○ $tool (fallback)${TEST_NC}"
        fi
    done
    
    echo "Tools available: $available/${#tools[@]}"
}

# Main test function
run_msh_test() {
    echo -e "${TEST_BLUE}🧪 MSH v3.0 Quick Test${TEST_NC}"
    echo "═══════════════════════════"
    
    test_shell_startup
    echo
    test_modern_tools
    echo
    test_personal_functions
    echo
    test_individual_tools
    echo
    echo -e "${TEST_GREEN}✅ Test complete${TEST_NC}"
}

# Export function for use in msh script
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # Being sourced
    export -f run_msh_test test_shell_startup test_modern_tools test_personal_functions test_individual_tools
fi