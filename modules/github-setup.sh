#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# GITHUB SETUP MODULE
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_github() {
    section_header "GitHub Authentication Setup"
    
    # Check if SSH key exists
    local ssh_key="$HOME/.ssh/id_ed25519"
    
    if [ -f "$ssh_key" ]; then
        gum style --foreground 82 "✅ SSH key already exists"
        
        if confirm_action "Show your public key?"; then
            echo ""
            cat "$ssh_key.pub"
            echo ""
        fi
        
        if ! confirm_action "Generate a new SSH key?"; then
            return 0
        fi
    fi
    
    # Generate new SSH key
    local git_email=$(git config --global user.email)
    if [ -z "$git_email" ]; then
        git_email=$(gum input --placeholder "Enter your GitHub email")
    fi
    
    mkdir -p "$HOME/.ssh"
    gum style --foreground 226 "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$git_email" -f "$ssh_key" -N ""
    
    gum style --foreground 82 "✅ SSH key generated!"
    echo ""
    gum style --foreground 226 "Your public key is:"
    echo ""
    cat "$ssh_key.pub"
    echo ""
    
    gum style --foreground 226 "Add this key to your GitHub account:"
    gum style --foreground 33 "https://github.com/settings/keys"
    
    if confirm_action "Test SSH connection after adding the key?"; then
        gum style --foreground 226 "Waiting for you to add the key to GitHub..."
        read -p "Press Enter when done"
        
        ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1
    fi
    
    log_success "GitHub SSH key configured"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_github
fi
