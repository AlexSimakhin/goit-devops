#!/bin/bash

sudo apt-get update -y

if command -v docker >/dev/null 2>&1; then
  echo "Docker is already installed"
else
  echo "Installing Docker..."
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if command -v docker-compose >/dev/null 2>&1; then
  echo "Docker Compose is already installed"
else
  echo "Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

if command -v python3 >/dev/null 2>&1; then
  MAJOR=$(python3 -c 'import sys; print(sys.version_info.major)')
  MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')
  
  if [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 9 ]; then
    echo "Python ${MAJOR}.${MINOR} is already installed (satisfies >= 3.9)"
  else
    echo "Installed Python version (${MAJOR}.${MINOR}) is outdated. Upgrading..."
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update -y
    sudo apt-get install -y python3.10 python3.10-venv python3-pip
  fi
else
  echo "Installing Python 3..."
  sudo apt-get install -y python3 python3-pip
fi

if ! command -v pip3 >/dev/null 2>&1; then
  echo "Installing pip3..."
  sudo apt-get install -y python3-pip
fi

if python3 -m django --version >/dev/null 2>&1; then
  echo "Django is already installed"
else
  echo "Installing Django..."
  pip3 install --user django
fi