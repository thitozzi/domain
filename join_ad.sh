#!/bin/bash
# Script único para instalação e ingresso no domínio com CID no Ubuntu/Mint

# Verifica se está rodando como root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️ Este script precisa ser executado como root (use sudo)."
  exit 1
fi

# Detectar e definir o comando APT correto
if [ -f /usr/bin/apt ]; then
    APT_CMD="/usr/bin/apt"
    echo "📦 Usando apt nativo: $APT_CMD"
elif command -v apt-get >/dev/null 2>&1; then
    APT_CMD="apt-get"
    echo "📦 Usando apt-get: $APT_CMD"
else
    echo "❌ Não foi possível encontrar apt ou apt-get"
    exit 1
fi

# Função para garantir que temos curl ou wget
garantir_download_tool() {
    if command -v curl >/dev/null 2>&1; then
        echo "✅ curl encontrado."
        DOWNLOADER="curl -fsSL"
    elif command -v wget >/dev/null 2>&1; then
        echo "✅ wget encontrado."
        DOWNLOADER="wget -qO-"
    else
        echo "ℹ️ Instalando curl..."
        $APT_CMD update && $APT_CMD install -y curl
        DOWNLOADER="curl -fsSL"
    fi
}

echo "🔄 Atualizando o sistema..."
$APT_CMD update

echo "⬆️ Fazendo upgrade do sistema..."
$APT_CMD -y upgrade

echo "🧹 Removendo pacotes desnecessários..."
$APT_CMD -y autoremove

echo "📦 Instalando software-properties-common..."
$APT_CMD install -y software-properties-common

echo "📦 Instalando repositório do CID..."
add-apt-repository -y ppa:emoraes25/cid

echo "🔄 Atualizando lista de pacotes..."
$APT_CMD update

echo "⬇️ Instalando CID e dependências..."
$APT_CMD install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" cid cid-gtk

echo "✅ Instalação concluída!"

# Executa o cid-gtk
echo "🚀 Abrindo interface do CID para ingresso no domínio..."
cid-gtk
