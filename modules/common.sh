#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# COMMON FUNCTIONS - Shared across all modules
# ============================================================

# Global variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGS_DIR="$HOME/termux-dev/logs"
BACKUPS_DIR="$HOME/termux-dev/backups"
MODULES_DIR="$SCRIPT_DIR/modules"

# Color definitions
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export MAGENTA='\033[0;35m'
export NC='\033[0m'

# Logging functions
log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOGS_DIR/setup.log"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOGS_DIR/setup.log"
}

log_success() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOGS_DIR/setup.log"
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if a package is installed (Termux)
package_installed() {
    pkg list-installed 2>/dev/null | grep -q "^$1/"
}

# Check if a module exists
module_exists() {
    [ -f "$MODULES_DIR/$1" ]
}

# Run a module if it exists
run_module() {
    local module_name=$1
    local function_name=$2
    
    if module_exists "$module_name"; then
        source "$MODULES_DIR/$module_name"
        if command_exists "$function_name"; then
            $function_name
        else
            gum style --foreground 196 "Function $function_name not found in $module_name"
            log_error "Missing function $function_name in $module_name"
        fi
    else
        gum style --foreground 196 "Module $module_name not found!"
        log_error "Missing module: $module_name"
    fi
}

# Check if a shell is installed
shell_installed() {
    command_exists "$1"
}

# Backup a file before modification
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local backup_name="$BACKUPS_DIR/$(basename "$file").$(date '+%Y%m%d_%H%M%S').bak"
        cp "$file" "$backup_name"
        log_info "Backed up $file to $backup_name"
        echo "$backup_name"
    fi
}

# Reload environment
reload_environment() {
    source ~/.bashrc 2>/dev/null || true
    source ~/.zshrc 2>/dev/null || true
    source ~/.config/fish/config.fish 2>/dev/null || true
}

# Check bootstrap completed
check_bootstrap() {
    if [ ! -f ~/.termux-dev-bootstrap-complete ]; then
        gum style --foreground 196 "Bootstrap not completed! Run bootstrap.sh first"
        exit 1
    fi
}

# Display section header
section_header() {
    gum style --border normal --margin "1" --padding "1" --border-foreground 33 "$1"
}

# Confirm action with gum
confirm_action() {
    gum confirm "$1" --affirmative "Yes" --negative "No"
}

# Select from menu
select_option() {
    local title=$1
    shift
    gum choose --limit 1 "$@"
}

# Install from a list of packages
install_packages() {
    local packages=("$@")
    for pkg in "${packages[@]}"; do
        if ! package_installed "$pkg"; then
            gum style --foreground 226 "Installing $pkg..."
            pkg install -y "$pkg"
        else
            gum style --foreground 212 "$pkg already installed"
        fi
    done
}

# Check if a font is installed
font_installed() {
    local font_name=$1
    [ -f "$HOME/.local/share/fonts/$font_name" ] || [ -f "$PREFIX/share/fonts/$font_name" ]
}
