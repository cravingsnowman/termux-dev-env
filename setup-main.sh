#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# MAIN SETUP SCRIPT - Extensible TUI Menu System
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/common.sh"

check_bootstrap

# Main menu - Organized by categories for extensibility
show_main_menu() {
    while true; do
        clear
        gum style --border double --margin "1" --padding "1" --border-foreground 33 "
╔═══════════════════════════════════════════════════════════════════════════╗
║                    Termux Development Environment                         ║
║                     Power User Setup                                      ║
╚═══════════════════════════════════════════════════════════════════════════╝
"
        
        local choice=$(gum choose --cursor.foreground 33 --header.foreground 226 \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "📦 CORE TOOLS" \
            "   ├── Install Core Development Tools" \
            "   └── Install Language Runtimes (Java, Kotlin, Gradle)" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "🔧 VERSION CONTROL" \
            "   ├── Configure Git" \
            "   └── Setup GitHub Authentication (SSH)" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "🐚 SHELLS & PROMPTS" \
            "   ├── Install Zsh + Oh My Zsh" \
            "   ├── Install Fish Shell" \
            "   ├── Install Starship Prompt" \
            "   ├── Install Powerlevel10k (Zsh only)" \
            "   ├── Install Nerd Fonts" \
            "   ├── Install Powerline Fonts" \
            "   └── Enhance Bash" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "🖥️  TERMINAL MULTIPLEXER" \
            "   └── Install Tmux + TPM" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "📝 EDITORS" \
            "   ├── Install Neovim (with config)" \
            "   ├── Install Vim (with config)" \
            "   ├── Install Micro Editor" \
            "   └── Install All Editors" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "🛠️  UTILITIES" \
            "   └── Install Development Utilities (htop, ripgrep, etc.)" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "📱 ANDROID DEVELOPMENT" \
            "   ├── Install Android SDK" \
            "   ├── Install ADB" \
            "   └── Install Complete Android Stack" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "🚀 LANGUAGE STACKS" \
            "   ├── Install Python + pip" \
            "   ├── Install Node.js + nvm" \
            "   ├── Install Rust + cargo" \
            "   ├── Install Go" \
            "   └── Install All Languages" \
            "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" \
            "⚡ QUICK ACTIONS" \
            "   ├── Install Everything (Complete Setup)" \
            "   ├── View Installation Status" \
            "   ├── Update Environment (Pull from GitHub)" \
            "   └── Exit")
        
        case "$choice" in
            *"Install Core Development Tools")
                install_core_tools
                ;;
            *"Install Language Runtimes (Java, Kotlin, Gradle)")
                install_language_runtimes
                ;;
            *"Configure Git")
                run_module "git-setup.sh" "setup_git"
                ;;
            *"Setup GitHub Authentication (SSH)")
                run_module "github-setup.sh" "setup_github"
                ;;
            *"Install Zsh + Oh My Zsh")
                run_module "shells.sh" "setup_zsh"
                ;;
            *"Install Fish Shell")
                run_module "shells.sh" "setup_fish"
                ;;
            *"Install Starship Prompt")
                run_module "prompts.sh" "setup_starship"
                ;;
            *"Install Powerlevel10k (Zsh only)")
                run_module "prompts.sh" "setup_powerlevel10k"
                ;;
            *"Install Nerd Fonts")
                run_module "fonts.sh" "setup_nerd_fonts"
                ;;
            *"Install Powerline Fonts")
                run_module "fonts.sh" "setup_powerline_fonts"
                ;;
            *"Enhance Bash")
                run_module "shells.sh" "setup_bash_enhancements"
                ;;
            *"Install Tmux + TPM")
                run_module "tmux-setup.sh" "setup_tmux"
                ;;
            *"Install Neovim (with config)")
                run_module "editors.sh" "setup_neovim"
                ;;
            *"Install Vim (with config)")
                run_module "editors.sh" "setup_vim"
                ;;
            *"Install Micro Editor")
                run_module "editors.sh" "setup_micro"
                ;;
            *"Install All Editors")
                run_module "editors.sh" "setup_neovim"
                run_module "editors.sh" "setup_vim"
                run_module "editors.sh" "setup_micro"
                ;;
            *"Install Development Utilities (htop, ripgrep, etc.)")
                run_module "utilities.sh" "setup_utilities"
                ;;
            *"Install Android SDK")
                run_module "android-sdk.sh" "setup_android_sdk"
                ;;
            *"Install ADB")
                run_module "adb-setup.sh" "setup_adb"
                ;;
            *"Install Complete Android Stack")
                run_module "android-sdk.sh" "setup_android_sdk"
                run_module "adb-setup.sh" "setup_adb"
                ;;
            *"Install Python + pip")
                run_module "python-setup.sh" "setup_python"
                ;;
            *"Install Node.js + nvm")
                run_module "nodejs-setup.sh" "setup_nodejs"
                ;;
            *"Install Rust + cargo")
                run_module "rust-setup.sh" "setup_rust"
                ;;
            *"Install Go")
                run_module "go-setup.sh" "setup_go"
                ;;
            *"Install All Languages")
                run_module "python-setup.sh" "setup_python"
                run_module "nodejs-setup.sh" "setup_nodejs"
                run_module "rust-setup.sh" "setup_rust"
                run_module "go-setup.sh" "setup_go"
                ;;
            *"Install Everything (Complete Setup)")
                install_everything
                ;;
            *"View Installation Status")
                show_status
                ;;
            *"Update Environment (Pull from GitHub)")
                update_from_github
                ;;
            *"Exit")
                gum style --foreground 82 "Goodbye! 🚀"
                exit 0
                ;;
        esac
        
        echo ""
        gum style --foreground 226 "Press any key to return to main menu..."
        read -n 1
    done
}

install_core_tools() {
    section_header "Installing Core Development Tools"
    local tools=("wget" "curl" "git" "openssl" "unzip" "zip" "tar" "nano" "vim" "openssh" "termux-api")
    install_packages "${tools[@]}"
    gum style --foreground 82 "✅ Core tools installed"
    log_success "Core development tools installed"
}

install_language_runtimes() {
    section_header "Installing Language Runtimes"
    run_module "java-setup.sh" "setup_java"
    run_module "kotlin-setup.sh" "setup_kotlin"
    run_module "gradle-setup.sh" "setup_gradle"
    gum style --foreground 82 "✅ Language runtimes installed"
}

install_everything() {
    section_header "Complete Environment Installation"
    
    gum style --foreground 226 "This will install all development tools (may take 45-60 minutes)"
    
    if ! confirm_action "Continue with complete installation?"; then
        return
    fi
    
    # Core
    install_core_tools
    
    # Version Control
    run_module "git-setup.sh" "setup_git"
    run_module "github-setup.sh" "setup_github"
    
    # Languages
    install_language_runtimes
    
    # Shells & Prompts
    run_module "shells.sh" "setup_zsh"
    run_module "shells.sh" "setup_bash_enhancements"
    run_module "prompts.sh" "setup_starship"
    
    # Terminal
    run_module "tmux-setup.sh" "setup_tmux"
    
    # Editors
    run_module "editors.sh" "setup_neovim"
    run_module "editors.sh" "setup_micro"
    
    # Utilities
    run_module "utilities.sh" "setup_utilities"
    
    # Android
    run_module "android-sdk.sh" "setup_android_sdk"
    run_module "adb-setup.sh" "setup_adb"
    
    gum style --foreground 82 "✅ Complete environment installed!"
    log_success "Full development environment installed"
}

show_status() {
    section_header "Installation Status"
    
    echo ""
    
    # Core
    command_exists git && gum style --foreground 82 "✅ Git: $(git --version | cut -d' ' -f3)" || gum style --foreground 196 "❌ Git: Not installed"
    command_exists java && gum style --foreground 82 "✅ Java: $(java -version 2>&1 | head -n1 | cut -d'"' -f2)" || gum style --foreground 196 "❌ Java: Not installed"
    command_exists gradle && gum style --foreground 82 "✅ Gradle: $(gradle --version 2>&1 | head -n1 | cut -d' ' -f2)" || gum style --foreground 196 "❌ Gradle: Not installed"
    command_exists kotlinc && gum style --foreground 82 "✅ Kotlin: $(kotlinc -version 2>&1 | cut -d' ' -f3)" || gum style --foreground 196 "❌ Kotlin: Not installed"
    
    # Shells
    command_exists zsh && gum style --foreground 82 "✅ Zsh: $(zsh --version | cut -d' ' -f2)" || gum style --foreground 196 "❌ Zsh: Not installed"
    command_exists fish && gum style --foreground 82 "✅ Fish: $(fish --version | cut -d' ' -f3)" || gum style --foreground 196 "❌ Fish: Not installed"
    
    # Prompts
    command_exists starship && gum style --foreground 82 "✅ Starship: $(starship --version | head -n1 | cut -d' ' -f2)" || gum style --foreground 196 "❌ Starship: Not installed"
    [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ] && gum style --foreground 82 "✅ Powerlevel10k: Installed" || gum style --foreground 196 "❌ Powerlevel10k: Not installed"
    
    # Terminal
    command_exists tmux && gum style --foreground 82 "✅ Tmux: $(tmux -V | cut -d' ' -f2)" || gum style --foreground 196 "❌ Tmux: Not installed"
    
    # Editors
    command_exists nvim && gum style --foreground 82 "✅ Neovim: $(nvim --version 2>&1 | head -n1 | cut -d' ' -f2)" || gum style --foreground 196 "❌ Neovim: Not installed"
    command_exists micro && gum style --foreground 82 "✅ Micro: $(micro --version 2>&1 | head -n1 | cut -d' ' -f2)" || gum style --foreground 196 "❌ Micro: Not installed"
    
    # Android
    [ -d "$HOME/android-sdk" ] && gum style --foreground 82 "✅ Android SDK: Installed" || gum style --foreground 196 "❌ Android SDK: Not installed"
    command_exists adb && gum style --foreground 82 "✅ ADB: $(adb --version 2>&1 | head -n1 | cut -d' ' -f2)" || gum style --foreground 196 "❌ ADB: Not installed"
    
    # Fonts
    [ -d "$HOME/.local/share/fonts" ] && gum style --foreground 82 "✅ Custom Fonts: $(ls -1 $HOME/.local/share/fonts 2>/dev/null | wc -l) installed" || gum style --foreground 196 "❌ Custom Fonts: None"
    
    echo ""
}

update_from_github() {
    section_header "Updating Environment from GitHub"
    
    cd "$SCRIPT_DIR"
    git pull origin main
    
    if [ $? -eq 0 ]; then
        gum style --foreground 82 "✅ Successfully updated"
        log_success "Environment updated from GitHub"
        exec "$SCRIPT_DIR/setup-main.sh"
    else
        gum style --foreground 196 "Failed to update"
        log_error "GitHub update failed"
    fi
}

# Run the main menu
show_main_menu
