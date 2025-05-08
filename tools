#!/bin/bash

echo "===== Instalador de Herramientas de Red ====="

# Verificar permisos
if [ "$EUID" -ne 0 ]; then
  echo "⚠️ Este script requiere privilegios de superusuario. Ejecuta con: sudo $0"
  exit 1
fi

# Declarar herramientas y los comandos que las representan
declare -A herramientas=(
  ["iputils-ping"]="ping"
  ["traceroute"]="traceroute"
  ["net-tools"]="ifconfig"
  ["curl"]="curl"
  ["wget"]="wget"
  ["nmap"]="nmap"
  ["dnsutils"]="dig"
  ["tcpdump"]="tcpdump"
  ["whois"]="whois"
)

# Identificar qué herramientas no están instaladas
instalar=()
echo "🔍 Verificando herramientas instaladas..."

for paquete in "${!herramientas[@]}"; do
  comando=${herramientas[$paquete]}
  if ! command -v "$comando" &> /dev/null; then
    echo "❌ $comando (de $paquete) no está instalado."
    instalar+=("$paquete")
  else
    echo "✅ $comando ya está instalado."
  fi
done

# Verifica si hay algo que instalar
if [ ${#instalar[@]} -eq 0 ]; then
  echo "🎉 Todas las herramientas ya están instaladas. Nada que hacer."
  exit 0
fi

# Confirmar instalación
echo ""
echo "Las siguientes herramientas serán instaladas:"
for pkg in "${instalar[@]}"; do
  echo " - $pkg"
done

read -p "¿Deseas continuar con la instalación? (s/n): " confirm
if [[ "$confirm" != "s" ]]; then
  echo "❌ Instalación cancelada."
  exit 0
fi

# Actualizar e instalar
echo "🔄 Actualizando lista de paquetes..."
apt update

echo "⬇️ Instalando herramientas faltantes..."
apt install -y "${instalar[@]}"

echo "✅ Instalación completada."
