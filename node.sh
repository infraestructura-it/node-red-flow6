#!/bin/bash

set -e

echo "🔧 Iniciando configuración automática para Node-RED con Git y Proyectos..."

# Variables
NODE_RED_DIR="$HOME/.node-red"
PROJECT_NAME="mi-proyecto"
PROJECT_DIR="$NODE_RED_DIR/projects/$PROJECT_NAME"
PORT=1880

# 1. Verificar Node.js y Node-RED
if ! command -v node &> /dev/null; then
  echo "⚠️ Node.js no está instalado. Instalando..."
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt install -y nodejs
fi

echo "⬇️ Instalando Node-RED..."
npm install -g --unsafe-perm node-red

# 2. Crear .node-red y settings.js si no existen
mkdir -p "$NODE_RED_DIR"
if [ ! -f "$NODE_RED_DIR/settings.js" ]; then
  echo "📄 Generando archivo settings.js..."
  node-red --settings > /dev/null 2>&1 &
  sleep 5
  pkill -f node-red || true
fi

# 3. Habilitar modo proyectos
echo "⚙️ Activando modo proyectos en settings.js..."
sed -i '/\/\/ projects: {/,+2c\projects: {\n    enabled: true\n},' "$NODE_RED_DIR/settings.js"

# 4. Configurar Git globalmente
echo "📝 Configurando Git global..."
git config --global user.name "GitHub User"
git config --global user.email "github@example.com"

# 5. Crear proyecto Node-RED con Git
if [ ! -d "$PROJECT_DIR" ]; then
  echo "📁 Creando proyecto local: $PROJECT_NAME"
  mkdir -p "$PROJECT_DIR"
  cd "$PROJECT_DIR"
  echo "{}" > flow.json
  git init
  git add .
  git commit -m "Inicio del proyecto Node-RED"

  # 6. Conectar a GitHub (opcional si pasas URL como argumento)
  if [ "$1" ]; then
    echo "🔗 Conectando con repositorio remoto: $1"
    git remote add origin "$1"
    git branch -M main
    git push -u origin main
  fi
fi

# 7. Ejecutar Node-RED
echo "🚀 Iniciando Node-RED en el puerto $PORT..."
PORT=$PORT node-red
