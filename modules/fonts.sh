#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# FONTS MODULE - Nerd Fonts, Powerline fonts
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_nerd_fonts() {
    section_header "Nerd Fonts Installation"
    
    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"
    
    # List of popular Nerd Fonts
    local fonts=(
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip"
    )
    
    local selected_fonts=$(gum choose --no-limit \
        "JetBrainsMono (recommended)" \
        "Meslo (Powerlevel10k compatible)" \
        "FiraCode" \
        "CascadiaCode" \
        --header "Select Nerd Fonts to install (SPACE to select)")
    
    for font_choice in $selected_fonts; do
        local font_url=""
        case "$font_choice" in
            *"JetBrainsMono"*)
                font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
                ;;
            *"Meslo"*)
                font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Meslo.zip"
                ;;
            *"FiraCode"*)
                font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
                ;;
            *"CascadiaCode"*)
                font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip"
                ;;
        esac
        
        if [ -n "$font_url" ]; then
            local font_name=$(basename "$font_url" .zip)
            gum style --foreground 226 "Downloading $font_name..."
            
            cd "$fonts_dir"
            wget -q "$font_url"
            unzip -q "$(basename "$font_url")"
            rm "$(basename "$font_url")"
            
            gum style --foreground 82 "✅ $font_name installed"
        fi
    done
    
    # Refresh font cache
    fc-cache -fv 2>/dev/null || gum style --foreground 226 "Font cache update skipped (fc-cache not available)"
    
    log_success "Nerd Fonts installed"
}

setup_powerline_fonts() {
    section_header "Powerline Fonts Installation"
    
    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"
    
    gum style --foreground 226 "Installing Powerline fonts..."
    
    # Clone powerline fonts repository
    git clone https://github.com/powerline/fonts.git "$HOME/powerline-fonts-temp"
    cd "$HOME/powerline-fonts-temp"
    ./install.sh
    cd ..
    rm -rf "$HOME/powerline-fonts-temp"
    
    fc-cache -fv 2>/dev/null
    
    gum style --foreground 82 "✅ Powerline fonts installed"
    log_success "Powerline fonts installed"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be sourced, not run directly"
    exit 1
fi
