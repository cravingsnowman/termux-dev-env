#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# EDITORS MODULE - Neovim, Vim, Emacs, Micro
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_neovim() {
    section_header "Neovim Installation"
    
    if command_exists nvim; then
        local nvim_version=$(nvim --version 2>&1 | head -n1)
        gum style --foreground 212 "Found Neovim: $nvim_version"
        
        if ! confirm_action "Reinstall Neovim?"; then
            configure_neovim
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Neovim..."
    pkg install -y neovim
    
    if command_exists nvim; then
        local nvim_version=$(nvim --version 2>&1 | head -n1)
        gum style --foreground 82 "✅ Neovim installed: $nvim_version"
        configure_neovim
        log_success "Neovim installed"
    else
        gum style --foreground 196 "❌ Neovim installation failed"
        log_error "Neovim installation failed"
        return 1
    fi
}

configure_neovim() {
    local config_dir="$HOME/.config/nvim"
    mkdir -p "$config_dir"
    local init_file="$config_dir/init.vim"
    
    if [ ! -f "$init_file" ]; then
        cat > "$init_file" << 'EOF'
" Basic Neovim configuration
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
set clipboard=unnamedplus

" Syntax highlighting
syntax on

" Colorscheme
colorscheme default

" Plugins (using vim-plug)
call plug#begin('~/.local/share/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Key mappings
map <C-n> :NERDTreeToggle<CR>
EOF
        gum style --foreground 82 "✅ Neovim configuration created"
        
        # Install vim-plug
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

setup_micro() {
    section_header "Micro Editor Installation"
    
    if command_exists micro; then
        local micro_version=$(micro --version 2>&1 | head -n1)
        gum style --foreground 212 "Found Micro: $micro_version"
        
        if ! confirm_action "Reinstall Micro?"; then
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Micro editor..."
    pkg install -y micro
    
    if command_exists micro; then
        local micro_version=$(micro --version 2>&1 | head -n1)
        gum style --foreground 82 "✅ Micro installed: $micro_version"
        log_success "Micro installed"
    else
        gum style --foreground 196 "❌ Micro installation failed"
        log_error "Micro installation failed"
        return 1
    fi
}

setup_vim() {
    section_header "Vim Installation"
    
    if command_exists vim; then
        local vim_version=$(vim --version 2>&1 | head -n1)
        gum style --foreground 212 "Found Vim: $vim_version"
        
        if ! confirm_action "Reinstall Vim?"; then
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Vim..."
    pkg install -y vim
    
    if command_exists vim; then
        local vim_version=$(vim --version 2>&1 | head -n1)
        gum style --foreground 82 "✅ Vim installed: $vim_version"
        
        # Basic vimrc
        cat > "$HOME/.vimrc" << 'EOF'
set number
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
EOF
        log_success "Vim installed"
    else
        gum style --foreground 196 "❌ Vim installation failed"
        log_error "Vim installation failed"
        return 1
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be sourced, not run directly"
    exit 1
fi
