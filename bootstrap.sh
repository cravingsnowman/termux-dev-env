#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BOOTSTRAP SCRIPT - One-Command Termux Environment Setup
# 
# Usage from fresh Termux:
#   curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/termux-dev-env/main/bootstrap.sh | bash
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration - CHANGE THESE TO YOUR GITHUB INFO
GITHUB_USERNAME="cravingsnowman"
GITHUB_REPO="termux-dev-env"
GITHUB_BRANCH="main"

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Termux Development Environment - Bootstrap${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Step 1: Request storage permission
echo -e "${YELLOW}📱 Requesting storage permission...${NC}"
termux-setup-storage
sleep 2
echo -e "${GREEN}✅ Storage permission granted${NC}"
echo ""

# Step 2: Update packages
echo -e "${YELLOW}📦 Updating package lists...${NC}"
pkg update -y && pkg upgrade -y
echo -e "${GREEN}✅ Packages updated${NC}"
echo ""

# Step 3: Install essential packages
echo -e "${YELLOW}🔧 Installing essential packages...${NC}"
pkg install -y \
    wget \
    curl \
    git \
    openssl \
    unzip \
    zip \
    tar \
    nano \
    vim \
    openssh \
    termux-api \
    which \
    gum
echo -e "${GREEN}✅ Essential packages installed${NC}"
echo ""

# Step 4: Clone or pull the repository
REPO_DIR="$HOME/termux-dev-env"

if [ -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}📁 Repository already exists, updating...${NC}"
    cd "$REPO_DIR"
    git pull origin "$GITHUB_BRANCH" 2>/dev/null || echo -e "${YELLOW}⚠️  Could not pull updates${NC}"
else
    echo -e "${YELLOW}📥 Cloning repository from GitHub...${NC}"
    git clone "https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git" "$REPO_DIR"
    cd "$REPO_DIR"
fi

echo -e "${GREEN}✅ Repository ready at: $REPO_DIR${NC}"
echo ""

# Step 5: Create directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p "$REPO_DIR/modules"
mkdir -p "$HOME/termux-dev/logs"
mkdir -p "$HOME/termux-dev/backups"
mkdir -p "$HOME/.local/share/fonts"
echo -e "${GREEN}✅ Directory structure created${NC}"
echo ""

# Step 6: Create marker file
date > "$HOME/.termux-dev-bootstrap-complete"
echo -e "${GREEN}✅ Bootstrap marker created${NC}"
echo ""

# Step 7: Make all scripts executable
echo -e "${YELLOW}🔐 Making scripts executable...${NC}"
find "$REPO_DIR" -name "*.sh" -exec chmod +x {} \;
echo -e "${GREEN}✅ Scripts are now executable${NC}"
echo ""

# Step 8: Display next steps
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Bootstrap Complete!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "  ${GREEN}cd ~/termux-dev-env${NC}"
echo -e "  ${GREEN}./setup-main.sh${NC}"
echo ""
echo -e "${CYAN}Quick links:${NC}"
echo -e "  📂 Repository: ${BLUE}https://github.com/$GITHUB_USERNAME/$GITHUB_REPO${NC}"
echo ""

# Step 9: Optionally launch main menu
echo -e "${CYAN}Launch main setup menu now? (y/n)${NC}"
read -p "> " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$REPO_DIR"
    ./setup-main.sh
else
    echo -e "${GREEN}Run './setup-main.sh' when ready!${NC}"
fi
