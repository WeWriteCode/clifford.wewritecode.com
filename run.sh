#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with sudo"
  exit 1
fi

if [ ! -f open-webui.env ]; then
  echo "open-webui.env file is missing. Copy open-webui-default.env to open-webui.env and adjust as necessary."
  exit 1
fi

echo "Update system"
dnf update
dnf upgrade --releasever=2023.8.20250804 -y
dnf groupinstall "Development Tools" -y
dnf install sqlite-devel -y
dnf install python3-devel -y
#dnf install rust cargo -y

# Switch to ec2-user and perform installation of UV
sudo -u ec2-user -i <<EOF
echo "Install UV"
curl -LsSf https://astral.sh/uv/install.sh | sh
EOF

echo "Install open-webui"
./install-open-webui.sh

#echo "Install Kokoro-fastAPI"
#./install-kokoro-fastapi.sh

echo "Install OpenAI-Edge-TTS"
./install-openai-edge-tts.sh

echo "clean up"
sudo -u ec2-user -i <<EOF
uv cache prune
EOF

#dnf remove cargo rust -y
#dnf groupremove "Development Tools" -y
dnf clean all

exit 0
