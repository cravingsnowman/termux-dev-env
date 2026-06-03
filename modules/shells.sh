#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SHELLS MODULE - Zsh, Fish, Bash enhancements
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_zsh() {
    section_header "Zsh & Oh My Zsh Installation"
    
    if shell_installed zsh; then
        local zsh_version=$(zsh --version)
        gum style --foreground 212 "Found Zsh: $zsh_version"
        
        if ! confirm_action "Reinstall Zsh?"; then
            configure_zsh
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Zsh..."
    pkg install -y zsh
    
    if command_exists zsh; then
        gum style --foreground 226 "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        gum style --foreground 82 "✅ Zsh and Oh My Zsh installed"
        configure_zsh
        log_success "Zsh and Oh My Zsh installed"
    else
        gum style --foreground 196 "❌ Zsh installation failed"
        log_error "Zsh installation failed"
        return 1
    fi
}

configure_zsh() {
    local zshrc="$HOME/.zshrc"
    
    backup_file "$zshrc"
    
    # Add useful plugins
    sed -i 's/plugins=(git)/plugins=(git docker kubectl history sudo web-search)/g' "$zshrc" 2>/dev/null || true
    
    # Set Zsh as default shell (optional)
    if confirm_action "Set Zsh as your default shell?"; then
        chsh -s zsh
        gum style --foreground 82 "✅ Zsh set as default shell"
    fi
}

setup_fish() {
    section_header "Fish Shell Installation"
    
    if shell_installed fish; then
        local fish_version=$(fish --version 2>&1)
        gum style --foreground 212 "Found Fish: $fish_version"
        
        if ! confirm_action "Reinstall Fish?"; then
            configure_fish
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Fish shell..."
    pkg install -y fish
    
    if command_exists fish; then
        local fish_version=$(fish --version 2>&1)
        gum style --foreground 82 "✅ Fish shell installed: $fish_version"
        configure_fish
        log_success "Fish shell installed"
    else
        gum style --foreground 196 "❌ Fish installation failed"
        log_error "Fish installation failed"
        return 1
    fi
}

configure_fish() {
    local config_dir="$HOME/.config/fish"
    mkdir -p "$config_dir"
    
    local config_file="$config_dir/config.fish"
    
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << 'EOF'
# Fish shell configuration
set -gx EDITOR nano

# Aliases
alias ll='ls -lah'
alias la='ls -a'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'

# Path additions
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
EOF
        gum style --foreground 82 "✅ Fish configuration created"
    fi
    
    # Set Fish as default shell (optional)
    if confirm_action "Set Fish as your default shell?"; then
        chsh -s fish
        gum style --foreground 82 "✅ Fish set as default shell"
    fi
}

setup_bash_enhancements() {
    section_header "Bash Enhancements"
    
    local bashrc="$HOME/.bashrc"
    backup_file "$bashrc"
    
    # Add useful aliases if not present
    if ! grep -q "alias ll=" "$bashrc" 2>/dev/null; then
        cat >> "$bashrc" << 'EOF'

# Custom aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'

# Better history
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi
EOF
        gum style --foreground 82 "✅ Bash enhancements added"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be sourced, not run directly"
    exit 1
fi
