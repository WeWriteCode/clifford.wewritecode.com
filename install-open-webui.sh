#!/bin/bash

current_dir=$(pwd)

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "Installing ffmpeg..."
  cd /usr/local/bin
  curl -L -O "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-arm64-static.tar.xz" &&
  tar -xf "ffmpeg-git-arm64-static.tar.xz" &&
  rm ffmpeg-git-arm64-static.tar.xz

  if [ ! -d "ffmpeg" ]; then
    mv ffmpeg-git-*-arm64-static ffmpeg
  else
    echo "Directory 'ffmpeg' already exists. Rename operation skipped."
  fi

  chown -R root.root ffmpeg/
  [ ! -e /usr/bin/ffmpeg ] && ln -s /usr/local/bin/ffmpeg/ffmpeg /usr/bin/ffmpeg
  [ ! -e /usr/bin/ffprobe ] && ln -s /usr/local/bin/ffmpeg/ffprobe /usr/bin/ffprobe
else
  echo "ffmpeg is already installed."
fi

cd "$current_dir"

cp open-webui.service /usr/lib/systemd/system/open-webui.service
cp open-webui_restart_timer.timer /usr/lib/systemd/system/open-webui_restart_timer.timer

systemctl daemon-reload
systemctl enable open-webui.service
systemctl start open-webui.service
systemctl enable open-webui_restart_timer.timer
systemctl start open-webui_restart_timer.timer


exit 0
