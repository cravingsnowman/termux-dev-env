#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# PROMPTS MODULE - Starship, Powerlevel10k, etc.
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_starship() {
    section_header "Starship Prompt Installation"
    
    if command_exists starship; then
        local starship_version=$(starship --version 2>&1 | head -n1)
        gum style --foreground 212 "Found Starship: $starship_version"
        
        if ! confirm_action "Reinstall Starship?"; then
            configure_starship
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Starship prompt..."
    
    # Download and install Starship
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    
    if command_exists starship; then
        local starship_version=$(starship --version 2>&1 | head -n1)
        gum style --foreground 82 "✅ Starship installed: $starship_version"
        configure_starship
        log_success "Starship prompt installed"
    else
        gum style --foreground 196 "❌ Starship installation failed"
        log_error "Starship installation failed"
        return 1
    fi
}

configure_starship() {
    local config_dir="$HOME/.config"
    mkdir -p "$config_dir"
    local config_file="$config_dir/starship.toml"
    
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << 'EOF'
# Starship configuration for Termux
format = """
[](#9A348E)\
$os\
$username\
$hostname\
[](#9A348E)\
$directory\
$git_branch\
$git_status\
$package\
$nodejs\
$rust\
$golang\
$php\
$python\
$docker_context\
$terraform\
$time\
[](#DA627D)\
$line_break\
$character[](#DA627D)"""

[username]
show_always = true
style_user = "bg:#9A348E fg:#FFFFFF"
style_root = "bg:#9A348E fg:#FF0000"

[hostname]
ssh_only = false
style = "bg:#9A348E fg:#F9DC5C"
format = "@[$hostname](bg:#9A348E fg:#F9DC5C) "

[directory]
style = "bg:#F9DC5C fg:#000000"
format = "[ $path ]($style) "

[git_branch]
symbol = ""
style = "bg:#F9DC5C fg:#000000"
format = '[$symbol $branch]($style) '

[nodejs]
symbol = ""
style = "bg:#00FF00 fg:#000000"
format = '[$symbol $version]($style) '

[python]
symbol = ""
style = "bg:#00FF00 fg:#000000"
format = '[$symbol $version]($style) '

[time]
disabled = false
time_format = "%R"
style = "bg:#DA627D fg:#FFFFFF"
format = '[ $time ]($style)'

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
EOF
        gum style --foreground 82 "✅ Starship configuration created"
    fi
    
    # Add to shell configs
    local shells=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.config/fish/config.fish")
    
    for shell_config in "${shells[@]}"; do
        if [ -f "$shell_config" ]; then
            if ! grep -q "starship" "$shell_config"; then
                echo 'eval "$(starship init $(basename $SHELL))"' >> "$shell_config"
                gum style --foreground 82 "✅ Starship added to $(basename "$shell_config")"
            fi
        fi
    done
    
    log_success "Starship configured for all shells"
}

setup_powerlevel10k() {
    section_header "Powerlevel10k for Zsh"
    
    if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        gum style --foreground 226 "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        
        # Set theme in .zshrc
        sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$HOME/.zshrc"
        
        gum style --foreground 82 "✅ Powerlevel10k installed"
        log_success "Powerlevel10k installed"
        
        gum style --foreground 226 "Run 'p10k configure' to set up your prompt"
    else
        gum style --foreground 212 "Powerlevel10k already installed"
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be sourced, not run directly"
    exit 1
fi
