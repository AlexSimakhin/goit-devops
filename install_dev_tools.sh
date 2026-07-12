#!/bin/bash
set -e

sudo apt-get update -y

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

if is_installed docker; then
  echo "Docker is already installed"
else
  echo "Installing Docker..."
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if is_installed docker-compose; then
  echo "Docker Compose is already installed"
elif docker compose version >/dev/null 2>&1; then
  echo "Docker Compose (plugin) is already installed"
else
  echo "Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

if is_installed python3; then
  MAJOR=$(python3 -c 'import sys; print(sys.version_info.major)')
  MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')
  
  if [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 9 ]; then
    echo "Python ${MAJOR}.${MINOR} is already installed (satisfies >= 3.9)"
  else
    echo "Installed Python version (${MAJOR}.${MINOR}) is outdated. Upgrading to 3.9..."
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update -y
    sudo apt-get install -y python3.9 python3.9-venv python3-pip
  fi
else
  echo "Installing Python 3.9..."
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y ppa:deadsnakes/ppa
  sudo apt-get update -y
  sudo apt-get install -y python3.9 python3.9-venv python3-pip
fi

if ! is_installed pip3; then
  echo "Installing pip3..."
  sudo apt-get install -y python3-pip
fi

if ! is_installed pip3; then
  echo "Error: pip3 is not installed. Cannot proceed with Django installation."
  exit 1
fi

if python3 -m django --version >/dev/null 2>&1; then
  echo "Django is already installed"
else
  echo "Installing Django..."
  pip3 install --user django --break-system-packages || pip3 install --user django
fi
