#!/bin/bash
# Script único para instalação e ingresso no domínio com CID no Ubuntu/Mint

# Verifica se está rodando como root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️ Este script precisa ser executado como root (use sudo)."
  exit 1
fi

# Atualiza o sistema
echo "🔄 Atualizando o sistema..."
apt update && apt -y upgrade && apt -y dist-upgrade

# Remove pacotes desnecessários
echo "🧹 Removendo pacotes desnecessários..."
apt -y autoremove

# Instala repositório do CID
echo "📦 Adicionando repositório do CID..."
add-apt-repository -y ppa:emoraes25/cid

# Atualiza lista de pacotes
echo "🔄 Atualizando lista de pacotes..."
apt update

# Instala o CID e interface gráfica
echo "⬇️ Instalando CID e cid-gtk..."
apt -y install cid cid-gtk

echo "✅ Instalação concluída!"

# Executa o cid-gtk
echo "🚀 Abrindo interface do CID para ingresso no domínio..."
cid-gtk
