# EP One Development Environment Setup

Automation script for setting up a local EP One development environment on Frappe/ERPNext.
This script helps developers quickly bootstrap a working environment with consistent configuration.

---

# Overview

This setup script will:

- Create a new Frappe site
- Install ERPNext v15
- Install HRMS v15
- Generate EP One install script
- Generate Makefile for common development commands

After setup, EP One can be installed and ready for development within minutes.

---

# Prerequisites

Make sure the following dependencies are installed before running the script.

## Required

### Python

Frappe requires Python 3.10 or newer.

```bash
python3 --version
```

---

### pip

Python package manager:

```bash
pip3 --version
```

---

### Node.js

Required for building EP One frontend assets.

Recommended version:

```
Node.js 18.x
```

Check:

```bash
node --version
```

---

### NVM (Node Version Manager)

Used by the installer to manage Node versions.

Install:
[https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)

Check:

```bash
nvm --version
```

---

### Yarn

Frontend package manager:

```bash
npm install -g yarn
```

Check:

```bash
yarn --version
```

---

### Frappe Manager (fm CLI)

Used to manage Frappe environments:

[https://github.com/rtCamp/Frappe-Manager](https://github.com/rtCamp/Frappe-Manager)

Install:

```bash
pip install frappe-manager
```

Check:

```bash
fm --version
```

---

## Recommended

### Git

```bash
git --version
```

---

### Docker (if using container environment)

```bash
docker --version
```

---

# Usage

## Step 1 — Run setup script

```bash
chmod +x setup.sh    
./setup.sh
```

You will be prompted for:

* App name
* GitLab username
* GitLab token
* Branch name
* Node version

---

## Step 2 — Enter fm shell

```bash
fm shell <app_name>
```

Example:

```bash
fm shell myapp
```

---

## Step 3 — Install EP One

Inside the fm shell:

```bash
./install.sh
```

This will:

* Setup Node.js
* Download EP One
* Install EP One app
* Build frontend
* Build bench assets
* Configure site
* Run migrations
* Restart services

---

# Project Structure

After setup:

```
frappe/
 ├── sites/
 │    ├── <app>.localhost
 │    │     ├── workspace/
 │    │     │     ├── frappe-bench/
 │    │     │     │     ├── install.sh
 │    │     │     │     ├── Makefile
```

---

# Development Commands

Navigate to:

```
workspace/frappe-bench
```

## Update environment

```
make update
```

Equivalent to:

```
bench migrate
bench clear-cache
bench clear-website-cache
bench restart
```

---

## Run migration

```
make migrate
```

---

## Clear cache

```
make clear-cache
```

---

## Restart bench

```
make restart
```

---

# Useful Commands

Start development server:

```
bench start
```

Run migrations manually:

```
bench --site <site> migrate
```

Clear cache:

```
bench --site <site> clear-cache
```

List installed apps:

```
bench --site <site> list-apps
```

---

# Troubleshooting

## Node not found

```
source /opt/.nvm/nvm.sh
```

---

## Yarn not found

```
npm install -g yarn
```

---

## Migration issues

```
bench --site <site> migrate
bench restart
```

---

# Notes

* This script is intended for development use only
* Not recommended for production environments
* GitLab token is required to access the EP One repository

---

# Maintainer

EP One Development Team

---

# Version

v1.0
