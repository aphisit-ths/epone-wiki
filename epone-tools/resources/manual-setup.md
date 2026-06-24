# Manual Setup EP One

Manual setup guide for the EP One development environment without using `setup.sh`.

---

## Prerequisites

Ensure these dependencies are installed before starting. The `epone` installer menu can help check or install most of them.

### Required Dependencies

- Python 3.10 or newer: `python3 --version`
- pip: `pip3 --version`
- Node.js: `node --version`
- Yarn: `yarn --version`
- Frappe Manager: `fm --version`

```
python3 -m venv "$HOME/.epone-tools-venv"
"$HOME/.epone-tools-venv/bin/pip" install frappe-manager
mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.epone-tools-venv/bin/fm" "$HOME/.local/bin/fm"
npm install -g yarn
```

- [Frappe Manager](https://github.com/rtCamp/Frappe-Manager)

### Recommended Dependencies

- Git: `git --version`
- Docker, optional: `docker --version`

---

## Installation Steps

### 1. Create Site

```
fm create <app_name> --apps erpnext:version-15 --apps hrms:version-15
```

```
fm create aoth --apps erpnext:version-15 --apps hrms:version-15
```

### 2. Enter fm shell

```
fm shell <app_name>
```

```
fm shell aoth
```

### 3. Setup Node.js

```
npm install -g yarn
node -v
yarn -v
```

### 4. Remove old EP One if exists

```
rm -rf apps/ep_one
rm -rf apps/ep-one-app
```

### 5. Download EP One app

```
bench get-app https://<git_username>:<git_token>@gitlab.weomni.com/ascendcorp/ptvn-ep-one/ep-one-app.git --branch develop
```

```
bench get-app https://aoth:token@gitlab.weomni.com/ascendcorp/ptvn-ep-one/ep-one-app.git --branch develop
cd apps/ep_one
git fetch --all
cd ../..
```

### 6. Install EP One

```
bench --site <site_name>.localhost install-app ep_one
```

```
bench --site aoth.localhost install-app ep_one
```

### 7. Build Frontend

```
cd apps/ep_one
yarn install
yarn build-ui
cd ../../
```

### 8. Build Bench Assets

```
bench build
```

### 9. Configure System

```
bench --site <site> set-maintenance-mode off
bench set-config -g server_script_enabled 1
bench set-config -g developer_mode 1
```

### 10. Run Migration

```
bench --site <site> migrate
```

### 11. Clear Cache

```
bench --site <site> clear-cache
```

### 12. Restart Bench

```
bench restart
```

---

## Verify Installation

```
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

## Useful Commands

### Start development server

```
bench start
```

### Update after pulling new code

```
git pull
bench migrate
bench build
bench clear-cache
bench restart
```

Or:

```
make update
```

---

## Common Issues

### Node is missing

```
node -v
```

### Yarn build fails

```
yarn install --force
```

### Bench build fails

```
bench build --force
```

### Migration errors

```
bench --site <site> migrate --skip-failing
```

---

## Summary

```
fm create
fm shell
bench get-app
bench install-app
yarn build
bench migrate
bench restart
```
