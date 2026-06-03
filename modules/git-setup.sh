#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# GIT SETUP MODULE
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_git() {
    section_header "Git Configuration"
    
    if command_exists git; then
        local current_name=$(git config --global user.name 2>/dev/null)
        local current_email=$(git config --global user.email 2>/dev/null)
        
        if [ -n "$current_name" ]; then
            gum style --foreground 212 "Current Git user: $current_name <$current_email>"
            if ! confirm_action "Do you want to update Git configuration?"; then
                return 0
            fi
        fi
        
        local git_name=$(gum input --placeholder "Enter your full name" --value "$current_name")
        local git_email=$(gum input --placeholder "Enter your email address" --value "$current_email")
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        
        # Additional useful Git configurations
        git config --global core.editor "nano"
        git config --global init.defaultBranch main
        git config --global pull.rebase false
        git config --global credential.helper store
        
        # Git aliases
        git config --global alias.co checkout
        git config --global alias.br branch
        git config --global alias.st status
        git config --global alias.lg "log --oneline --graph --all"
        
        gum style --foreground 82 "✅ Git configured successfully!"
        log_success "Git configured for $git_name <$git_email>"
    else
        gum style --foreground 196 "Git not found. Installing..."
        pkg install -y git
        setup_git
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_git
fi
