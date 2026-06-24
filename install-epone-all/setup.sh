#!/bin/bash

# EP One Development Environment - Setup Script
# This script creates the site and generates install.sh for use inside fm shell

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

validate_app_name() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print_error "App name cannot be empty"
        return 1
    fi
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        print_error "App name can only contain letters, numbers, hyphens, and underscores"
        return 1
    fi
    return 0
}

echo "=============================================="
echo "  EP One Development Environment Setup"
echo "=============================================="
echo ""

# Get user inputs
while true; do
    read -p "Enter your app name: " APP_NAME
    if validate_app_name "$APP_NAME"; then
        break
    fi
done

read -p "Enter GitLab username (default: username): " GIT_USERNAME
GIT_USERNAME=${GIT_USERNAME:-username}

read -s -p "Enter GitLab token/password: " GIT_TOKEN
echo ""

if [[ -z "$GIT_TOKEN" ]]; then
    print_error "GitLab token cannot be empty"
    exit 1
fi

read -p "Enter branch name (default: develop): " BRANCH
BRANCH=${BRANCH:-develop}

read -p "Enter Node.js version (default: 18.18.0): " NODE_VERSION
NODE_VERSION=${NODE_VERSION:-18.18.0}

# Frappe sites path
FRAPPE_SITES_PATH="$HOME/frappe/sites"

echo ""
echo "=============================================="
echo "Configuration Summary:"
echo "  App Name: $APP_NAME"
echo "  GitLab Username: $GIT_USERNAME"
echo "  Branch: $BRANCH"
echo "  Node.js Version: $NODE_VERSION"
echo "=============================================="
echo ""

read -p "Continue with setup? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    print_warning "Setup cancelled"
    exit 0
fi

echo ""

# Step 1: Create site
print_status "Step 1: Creating site with ERPNext and HRMS..."
if fm create "$APP_NAME" --apps erpnext:version-15 --apps hrms:version-15; then
    print_success "Site created successfully"
else
    print_error "Failed to create site"
    exit 1
fi

# Step 2: Generate install.sh with pre-filled params
print_status "Step 2: Generating install.sh..."

SITE_FOLDER="${APP_NAME}.localhost"
INSTALL_PATH="${FRAPPE_SITES_PATH}/${SITE_FOLDER}/workspace/frappe-bench/install.sh"

cat > "$INSTALL_PATH" << 'SCRIPT_START'
#!/bin/bash

# EP One Installation Script (Auto-generated)
# Run this inside fm shell

set -e

# Pre-configured parameters
SCRIPT_START

cat >> "$INSTALL_PATH" << SCRIPT_PARAMS
SITE_NAME="${APP_NAME}.localhost"
GIT_USERNAME="${GIT_USERNAME}"
GIT_TOKEN="${GIT_TOKEN}"
BRANCH="${BRANCH}"
NODE_VERSION="${NODE_VERSION}"
SCRIPT_PARAMS

cat >> "$INSTALL_PATH" << 'SCRIPT_END'

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "=============================================="
echo "  EP One Installation"
echo "=============================================="
echo ""
echo "Site: $SITE_NAME"
echo "Branch: $BRANCH"
echo "Node.js: $NODE_VERSION"
echo ""

read -p "Start installation? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    print_warning "Cancelled"
    exit 0
fi

echo ""

# Step 1: Setup Node.js
print_status "Step 1/8: Setting up Node.js $NODE_VERSION..."
source /opt/.nvm/nvm.sh
nvm install $NODE_VERSION
nvm use $NODE_VERSION
npm install -g yarn
print_success "Done"

# Step 2: Clean up old ep_one if exists
if [[ -d "apps/ep_one" ]] || [[ -d "apps/ep-one-app" ]]; then
    print_warning "Removing old ep_one..."
    rm -rf apps/ep_one apps/ep-one-app
fi

# Step 3: Get EP One app
print_status "Step 2/8: Downloading EP One app..."
bench get-app https://$GIT_USERNAME:$GIT_TOKEN@gitlab.weomni.com/ascendcorp/ptvn-ep-one/ep-one-app.git --branch $BRANCH
cd apps/ep_one && git fetch --all && cd ../..
print_success "Done"

# Step 4: Install app
print_status "Step 3/8: Installing EP One..."
bench --site $SITE_NAME install-app ep_one
print_success "Done"

# Step 5: Build frontend
print_status "Step 4/8: Building frontend..."
cd apps/ep_one
yarn install
yarn build-ui
cd ../../
print_success "Done"

# Step 6: Build bench
print_status "Step 5/8: Building bench assets..."
bench build
print_success "Done"

# Step 7: Configure
print_status "Step 6/8: Configuring..."
bench --site $SITE_NAME set-maintenance-mode off
bench set-config -g server_script_enabled 1
bench set-config -g developer_mode 1
print_success "Done"

# Step 8: Migrate
print_status "Step 7/8: Running migrations..."
bench --site $SITE_NAME migrate
print_success "Done"

# Step 9: Clear cache & restart
print_status "Step 8/8: Restarting..."
bench --site $SITE_NAME clear-cache
bench restart
print_success "Done"

# Verify
echo ""
print_status "Installed apps:"
bench --site $SITE_NAME list-apps

echo ""
echo "=============================================="
echo -e "${GREEN}  Installation Complete!${NC}"
echo "=============================================="
echo ""
echo "Useful commands:"
echo "  bench start                              - Start dev server"
echo "  bench --site $SITE_NAME migrate          - Run migrations"
echo "  bench --site $SITE_NAME clear-cache      - Clear cache"
echo "  exit                                     - Exit fm shell"
echo ""
SCRIPT_END

chmod +x "$INSTALL_PATH"
print_success "install.sh created at workspace/frappe-bench/"

# Step 3: Generate Makefile
print_status "Step 3: Generating Makefile..."
MAKEFILE_PATH="${FRAPPE_SITES_PATH}/${SITE_FOLDER}/workspace/frappe-bench/Makefile"

cat > "$MAKEFILE_PATH" << 'MAKEFILE_END'
# Makefile for Frappe Bench Commands

.PHONY: all migrate clear-cache clear-browser-cache restart update help

all: migrate clear-cache clear-browser-cache restart

migrate:
	@echo "Running bench migrate..."
	bench migrate

clear-cache:
	@echo "Clearing cache..."
	bench clear-cache

clear-browser-cache:
	@echo "Clearing browser cache..."
	bench clear-website-cache

restart:
	@echo "Restarting bench..."
	bench restart

update:
	@echo "Starting full update process..."
	@echo "Step 1/4: Running migrations..."
	bench migrate
	@echo "Step 2/4: Clearing cache..."
	bench clear-cache
	@echo "Step 3/4: Clearing browser cache..."
	bench clear-website-cache
	@echo "Step 4/4: Restarting services..."
	bench restart
	@echo "Update completed!"

help:
	@echo "Available commands:"
	@echo "  make update     - Run all commands in sequence"
	@echo "  make migrate    - Run bench migrate"
	@echo "  make clear-cache - Clear server cache"
	@echo "  make clear-browser-cache - Clear browser cache"
	@echo "  make restart    - Restart bench services"
	@echo "  make all        - Same as 'make update'"
MAKEFILE_END

print_success "Makefile created at workspace/frappe-bench/"

echo ""
echo "=============================================="
echo -e "${GREEN}  Setup Complete!${NC}"
echo "=============================================="
echo ""
echo "Next steps:"
echo ""
echo "  1. Enter fm shell:"
echo -e "     ${BLUE}fm shell $APP_NAME${NC}"
echo ""
echo "  2. Run install script:"
echo -e "     ${BLUE}./install.sh${NC}"
echo ""
