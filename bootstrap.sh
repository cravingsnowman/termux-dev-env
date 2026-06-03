#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BOOTSTRAP SCRIPT - Handles dpkg conflicts gracefully
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Termux Development Environment - Bootstrap${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Function to safely run dpkg commands
safe_dpkg() {
    yes '' | dpkg --configure -a 2>/dev/null || true
}

# Step 1: Fix any stuck dpkg processes
echo -e "${YELLOW}🔧 Checking for stuck package manager...${NC}"
pkill dpkg 2>/dev/null || true
pkill apt 2>/dev/null || true
rm -f /data/data/com.termux/files/usr/var/lib/dpkg/lock
rm -f /data/data/com.termux/files/usr/var/lib/apt/lists/lock
safe_dpkg
echo -e "${GREEN}✅ Package manager ready${NC}"
echo ""

# Step 2: Handle storage permission
echo -e "${YELLOW}📱 Setting up storage access...${NC}"
if [ -d ~/storage/downloads ] && [ -w ~/storage/downloads ]; then
    echo -e "${GREEN}✅ Storage already accessible${NC}"
else
    if [ -L ~/storage ] || [ -d ~/storage ]; then
        rm -rf ~/storage
    fi
    termux-setup-storage
    sleep 2
    echo -e "${GREEN}✅ Storage permission requested${NC}"
fi
echo ""

# Step 3: Update packages with conflict handling
echo -e "${YELLOW}📦 Updating package lists...${NC}"
apt update -y --allow-releaseinfo-change || {
    echo -e "${YELLOW}⚠️  Update failed, fixing sources...${NC}"
    safe_dpkg
    apt update -y --allow-releaseinfo-change
}
echo -e "${GREEN}✅ Package lists updated${NC}"
echo ""

# Step 4: Upgrade with force options
echo -e "${YELLOW}📦 Upgrading packages...${NC}"
apt upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" || {
    echo -e "${YELLOW}⚠️  Upgrade had issues, continuing...${NC}"
    safe_dpkg
}
echo -e "${GREEN}✅ Packages upgraded${NC}"
echo ""

# Step 5: Install essentials
echo -e "${YELLOW}🔧 Installing essential packages...${NC}"
for pkg in wget curl git openssl unzip zip tar nano vim openssh termux-api which gum; do
    echo -e "${BLUE}Installing $pkg...${NC}"
    apt install -y -o Dpkg::Options::="--force-confold" $pkg || {
        echo -e "${YELLOW}⚠️  $pkg installation had issues, continuing...${NC}"
        safe_dpkg
    }
done
echo -e "${GREEN}✅ Essential packages installed${NC}"
echo ""

# Step 6: Clone repository
REPO_DIR="$HOME/termux-dev-env"
if [ -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}📁 Repository exists, updating...${NC}"
    cd "$REPO_DIR"
    git pull origin main 2>/dev/null || echo -e "${YELLOW}⚠️  Could not pull${NC}"
else
    echo -e "${YELLOW}📥 Cloning repository...${NC}"
    git clone https://github.com/cravingsnowman/termux-dev-env.git "$REPO_DIR"
    cd "$REPO_DIR"
fi
echo -e "${GREEN}✅ Repository ready${NC}"
echo ""

# Step 7: Create directories
echo -e "${YELLOW}📁 Creating directories...${NC}"
mkdir -p "$HOME/termux-dev/logs" "$HOME/termux-dev/backups" "$HOME/.local/share/fonts"
echo -e "${GREEN}✅ Directories created${NC}"
echo ""

# Step 8: Make scripts executable
echo -e "${YELLOW}🔐 Making scripts executable...${NC}"
find "$REPO_DIR" -name "*.sh" -exec chmod +x {} \;
echo -e "${GREEN}✅ Scripts ready${NC}"
echo ""

# Step 9: Create marker
date > "$HOME/.termux-dev-bootstrap-complete"
echo -e "${GREEN}✅ Bootstrap complete!${NC}"
echo ""

# Step 10: Launch menu
echo -e "${CYAN}Launch main setup menu now? (y/n)${NC}"
read -p "> " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$REPO_DIR"
    ./setup-main.sh
else
    echo -e "${GREEN}Run 'cd ~/termux-dev-env && ./setup-main.sh' when ready${NC}"
fi