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

# Verifica se já está no domínio
if [ -f /etc/cid.conf ]; then
  echo "ℹ️ Esta máquina já está ingressada em um domínio."
  read -p "Deseja forçar a reinserção no domínio? (s/n): " forcar
  if [[ "$forcar" != "s" && "$forcar" != "S" ]]; then
    echo "👍 Saindo sem alterações."
    exit 0
  fi
  echo "⚠️ Reinserindo no domínio..."
fi

# Mostra o hostname atual e pergunta se quer trocar
current_host=$(hostname)
echo "🖥️ Hostname atual: $current_host"
read -p "Deseja trocar o hostname? (s/n): " trocar

if [[ "$trocar" == "s" || "$trocar" == "S" ]]; then
  read -p "Informe o novo hostname: " novo_host
  hostnamectl set-hostname "$novo_host"
  echo "✅ Hostname alterado para: $novo_host"
else
  echo "ℹ️ Mantendo hostname atual: $current_host"
fi

echo ""

# Executa o cid-gtk
echo "🚀 Abrindo interface do CID para ingresso no domínio..."
cid-gtk
