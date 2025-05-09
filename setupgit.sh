#!/bin/bash

set -e

echo "🔧 Inicio de configuración paso a paso de Git"

# Paso 1: Configurar identidad global
read -p "¿Deseas configurar tu nombre y correo global en Git? (s/n) " CONFIRM_GIT
if [[ "$CONFIRM_GIT" == "s" ]]; then
  read -p "infraestructura-it: " GIT_NAME
  read -p "jairosepulvedac@gmail.com: " GIT_EMAIL
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  echo "✅ Configuración global hecha."
fi

# Paso 2: Inicializar repositorio
read -p "¿Deseas inicializar un repositorio Git aquí? (s/n) " CONFIRM_INIT
if [[ "$CONFIRM_INIT" == "s" ]]; then
  git init
  echo "✅ Repositorio inicializado."
fi

# Paso 3: Agregar archivos
read -p "¿Deseas agregar todos los archivos al staging? (s/n) " CONFIRM_ADD
if [[ "$CONFIRM_ADD" == "s" ]]; then
  git add .
  echo "✅ Archivos agregados."
fi

# Paso 4: Hacer commit
read -p "¿Deseas hacer un commit ahora? (s/n) " CONFIRM_COMMIT
if [[ "$CONFIRM_COMMIT" == "s" ]]; then
  read -p "Mensaje del commit: " COMMIT_MSG
  git commit -m "$COMMIT_MSG"
  echo "✅ Commit realizado."
fi

# Paso 5: Conectar con repositorio remoto
read -p "¿Deseas agregar un repositorio remoto? (s/n) " CONFIRM_REMOTE
if [[ "$CONFIRM_REMOTE" == "s" ]]; then
  read -p "URL del repositorio remoto: " REMOTE_URL
  git remote add origin "$REMOTE_URL"
  echo "✅ Repositorio remoto agregado."
fi

# Paso 6: Push al repositorio
read -p "¿Deseas hacer push a la rama 'main'? (s/n) " CONFIRM_PUSH
if [[ "$CONFIRM_PUSH" == "s" ]]; then
  git push -u origin main
  echo "✅ Cambios enviados al repositorio remoto."
fi

echo "🚀 Proceso de Git finalizado."
