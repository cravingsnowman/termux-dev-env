#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# TMUX MODULE - Terminal Multiplexer
# ============================================================

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_tmux() {
    section_header "Tmux Installation"
    
    if command_exists tmux; then
        local tmux_version=$(tmux -V)
        gum style --foreground 212 "Found Tmux: $tmux_version"
        
        if ! confirm_action "Reinstall Tmux?"; then
            configure_tmux
            return 0
        fi
    fi
    
    gum style --foreground 226 "Installing Tmux..."
    pkg install -y tmux
    
    if command_exists tmux; then
        local tmux_version=$(tmux -V)
        gum style --foreground 82 "✅ Tmux installed: $tmux_version"
        configure_tmux
        log_success "Tmux installed"
    else
        gum style --foreground 196 "❌ Tmux installation failed"
        log_error "Tmux installation failed"
        return 1
    fi
}

configure_tmux() {
    local config_file="$HOME/.tmux.conf"
    
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << 'EOF'
# Tmux configuration for Termux
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Mouse support
set -g mouse on

# Vi mode
setw -g mode-keys vi

# Status bar
set -g status-bg black
set -g status-fg white
set -g status-left "#[fg=green]#H"
set -g status-right "#[fg=cyan]%H:%M"

# Windows and panes
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on

# Increase scrollback
set -g history-limit 10000

# Easy splitting
bind | split-window -h
bind - split-window -v

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Use vim keys to navigate panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# TPM (Tmux Plugin Manager)
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Install TPM if not present
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

run '~/.tmux/plugins/tpm/tpm'
EOF
        gum style --foreground 82 "✅ Tmux configuration created"
        
        # Install TPM
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || true
    fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be sourced, not run directly"
    exit 1
fi
