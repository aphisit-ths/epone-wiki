ผมลอง polish README ให้ดูเป็น **professional + onboarding friendly + production style** มากขึ้นครับ (ตัดซ้ำ, จัด section, เพิ่ม troubleshooting, best practice) 👨‍💻

---

# Manual Setup EP One (without setup.sh)

This guide explains how to manually setup the EP One development environment without using the automated setup script.

---

# Prerequisites

Ensure the following dependencies are installed before starting.

---

# Required Dependencies

## Python

Frappe requires Python **3.10 or newer**

Check version:

```bash
python3 --version
```

---

## pip

Python package manager:

```bash
pip3 --version
```

---

## Node.js

Required for building EP One frontend assets.

Recommended:

```
Node.js 18.x
```

Check:

```bash
node --version
```

---

## NVM (Node Version Manager)

Used to manage Node.js versions.

Install:
[https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)

Check:

```bash
nvm --version
```

---

## Yarn

Frontend package manager:

Install:

```bash
npm install -g yarn
```

Check:

```bash
yarn --version
```

---

## Frappe Manager (fm CLI)

Used for managing Frappe development environments.

Install:

```bash
pip install frappe-manager
```

Project:
[https://github.com/rtCamp/Frappe-Manager](https://github.com/rtCamp/Frappe-Manager)

Check:

```bash
fm --version
```

---

# Recommended Dependencies

## Git

```bash
git --version
```

---

## Docker (optional)

Only required if using container environments.

```bash
docker --version
```

---

# Installation Steps

---

# 1. Create Site

Create a new Frappe site with ERPNext and HRMS:

```bash
fm create <app_name> --apps erpnext:version-15 --apps hrms:version-15
```

Example:

```bash
fm create aoth --apps erpnext:version-15 --apps hrms:version-15
```

---

# 2. Enter fm shell

```bash
fm shell <app_name>
```

Example:

```bash
fm shell aoth
```

---

# 3. Setup Node.js

Load NVM:

```bash
source /opt/.nvm/nvm.sh
```

Install Node:

```bash
nvm install 18.18.0
```

Use version:

```bash
nvm use 18.18.0
```

Install yarn:

```bash
npm install -g yarn
```

Verify:

```bash
node -v
yarn -v
```

---

# 4. Remove old EP One (if exists)

```bash
rm -rf apps/ep_one
rm -rf apps/ep-one-app
```

---

# 5. Download EP One app

```bash
bench get-app https://<git_username>:<git_token>@gitlab.weomni.com/ascendcorp/ptvn-ep-one/ep-one-app.git --branch develop
```

Example:

```bash
bench get-app https://aoth:token@gitlab.weomni.com/ascendcorp/ptvn-ep-one/ep-one-app.git --branch develop
```

Update repository:

```bash
cd apps/ep_one

git fetch --all

cd ../..
```

---

# 6. Install EP One

```bash
bench --site <site_name>.localhost install-app ep_one
```

Example:

```bash
bench --site aoth.localhost install-app ep_one
```

---

# 7. Build Frontend

```bash
cd apps/ep_one

yarn install

yarn build-ui

cd ../../
```

---

# 8. Build Bench Assets

```bash
bench build
```

---

# 9. Configure System

Disable maintenance mode:

```bash
bench --site <site> set-maintenance-mode off
```

Enable server scripts:

```bash
bench set-config -g server_script_enabled 1
```

Enable developer mode:

```bash
bench set-config -g developer_mode 1
```

---

# 10. Run Migration

```bash
bench --site <site> migrate
```

---

# 11. Clear Cache

```bash
bench --site <site> clear-cache
```

---

# 12. Restart Bench

```bash
bench restart
```

---

# Verify Installation

Check installed apps:

```bash
bench --site <site> list-apps
```

Expected output:

```
frappe
erpnext
hrms
ep_one
```

---

# Useful Commands

## Start development server

```bash
bench start
```

---

## Update after pulling new code

```bash
bench migrate

bench clear-cache

bench restart
```

Or:

```bash
make update
```

---

# Common Issues

## Node version mismatch

Check:

```bash
node -v
```

Fix:

```bash
nvm use 18.18.0
```

---

## Yarn build fails

Try:

```bash
yarn install --force
```

---

## Bench build fails

Try:

```bash
bench build --force
```

---

## Migration errors

Try:

```bash
bench --site <site> migrate --skip-failing
```

---

# Development Tips

Recommended workflow after pulling changes:

```bash
git pull

bench migrate

bench build

bench clear-cache

bench restart
```

---

# Optional Improvements

You may also create:

Makefile:

```bash
make update
```

Install script:

```bash
./install.sh
```

---

# Summary

Manual setup flow:

```
fm create
fm shell
bench get-app
bench install-app
yarn build
bench migrate
bench restart
```

---
