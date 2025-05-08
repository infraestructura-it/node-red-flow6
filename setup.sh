#!/bin/bash

echo "===== Setup interactivo para GitHub Codespaces ====="

# Crear package.json si no existe
if [ ! -f package.json ]; then
  read -p "No se encontró package.json. ¿Deseas crear uno básico ahora? (s/n): " confirm_pkg
  if [[ "$confirm_pkg" == "s" ]]; then
    npm init -y
    echo "✅ package.json creado"
  else
    echo "⚠️ No se creó package.json"
  fi
else
  echo "✅ package.json ya existe"
fi

# Workflow de GitHub Actions
read -p "¿Deseas crear el archivo main.yml de GitHub Actions? (s/n): " confirm_yml
if [[ "$confirm_yml" == "s" ]]; then
  mkdir -p .github/workflows
  cat <<EOF > .github/workflows/main.yml
name: Node.js CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '20'
    - name: Instalar dependencias si package.json existe
      run: |
        if [ -f package.json ]; then
          npm install
        else
          echo "⚠️ No se encontró package.json, saltando npm install"
        fi
    - name: Ejecutar pruebas si están definidas
      run: |
        if [ -f package.json ] && jq -e '.scripts.test' package.json > /dev/null; then
          npm test
        else
          echo "⚠️ No se encontró script de prueba, saltando npm test"
        fi
EOF
  echo "✅ main.yml creado"
else
  echo "❌ main.yml no fue creado"
fi

# Devcontainer
read -p "¿Deseas crear el archivo devcontainer.json para Codespaces? (s/n): " confirm_dev
if [[ "$confirm_dev" == "s" ]]; then
  mkdir -p .devcontainer
  cat <<EOF > .devcontainer/devcontainer.json
{
  "name": "Node-RED DevContainer",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    }
  },
  "postCreateCommand": "npm install -g --unsafe-perm node-red"
}
EOF
  echo "✅ devcontainer.json creado"
else
  echo "❌ devcontainer.json no fue creado"
fi

# Instalar Node-RED globalmente ahora
read -p "¿Deseas instalar Node-RED globalmente ahora? (s/n): " confirm_nodered
if [[ "$confirm_nodered" == "s" ]]; then
  npm install -g --unsafe-perm node-red
  echo "✅ Node-RED instalado globalmente"
else
  echo "❌ Node-RED no fue instalado"
fi

echo "🎉 Setup completado."

