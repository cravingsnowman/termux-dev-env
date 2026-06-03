#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# UTILITIES MODULE - General development tools
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_utilities() {
    section_header "Development Utilities"
    
    local categories=$(gum choose --limit 1 \
        "🖥️  System Utilities" \
        "🔍 Search & Navigation" \
        "📊 Process & Performance" \
        "🌐 Networking" \
        "📦 Package Management" \
        "🎨 Display & Media" \
        "🔧 All Utilities")
    
    case "$categories" in
        *"System Utilities"*)
            install_system_utils
            ;;
        *"Search & Navigation"*)
            install_search_utils
            ;;
        *"Process & Performance"*)
            install_performance_utils
            ;;
        *"Networking"*)
            install_networking_utils
            ;;
        *"Package Management"*)
            install_package_utils
            ;;
        *"Display & Media"*)
            install_display_utils
            ;;
        *"All Utilities"*)
            install_system_utils
            install_search_utils
            install_performance_utils
            install_networking_utils
            install_package_utils
            install_display_utils
            ;;
    esac
}

install_system_utils() {
    local tools=("htop" "tree" "bat" "exa" "zoxide" "du-dust" "procs")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ System utilities installed"
}

install_search_utils() {
    local tools=("ripgrep" "fd" "fzf" "the_silver_searcher")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ Search utilities installed"
}

install_performance_utils() {
    local tools=("glances" "nmon" "btop")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ Performance utilities installed"
}

install_networking_utils() {
    local tools=("httpie" "jq" "yq" "tldr" "nmap" "netcat-openbsd")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ Networking utilities installed"
}

install_package_utils() {
    local tools=("pkg-show" "pkg-clean" "apt-show-versions")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ Package utilities installed"
}

install_display_utils() {
    local tools=("lolcat" "cowsay" "fortune-mod" "figlet" "toilet")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ Display utilities installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be sourced, not run directly"
    exit 1
fi
