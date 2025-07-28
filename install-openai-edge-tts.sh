#!/bin/bash

current_dir=$(pwd)

#switch to ec2-user and perform installation of openai-edge-tts
sudo -u ec2-user -i <<EOF
if [ ! -d "openai-edge-tts" ]; then
    git clone https://github.com/travisvn/openai-edge-tts.git
fi
cd openai-edge-tts

cp .env.example .env

echo \
"API_KEY=your_api_key_here
PORT=5050

DEFAULT_VOICE=en-US-AndrewMultilingualNeural
DEFAULT_RESPONSE_FORMAT=mp3
DEFAULT_SPEED=1.0

DEFAULT_LANGUAGE=en-US

REQUIRE_API_KEY=False
REMOVE_FILTER=False
EXPAND_API=True" > .env
EOF

cd "$current_dir"

cp openai-edge-tts.service /usr/lib/systemd/system/openai-edge-tts.service
systemctl daemon-reload
systemctl enable openai-edge-tts.service
systemctl start openai-edge-tts.service

exit 0
