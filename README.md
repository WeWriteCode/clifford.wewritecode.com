# clifford.wewritecode.com

This project is the setup and configuration for running open-webui on a personal server.

`scp` all the files to an Amazon Linux machine running in AWS EC2, then run `./run.sh` from the machine.

The scripts make assumptions about Amazon Linux 2 and `ec2-user` being the user account. This is proven to run fine on a `t4g.small` instance.

---

This project uses a `systemd` service to run open-webui. It uses `uvx` to manage the Python environment it runs in.

---

kokoro (text-to-speech) to no longer installed, but scripts remain for posterity. It wasn't worth the overhead and kokoro.js is available in the UI and pretty good. Kokoro.js will rely on your browsers memory to work so not ideal on mobile.

Microsoft's Edge TTS service is leveraged with a wrapper API and is installed alongside Open-WebUI and can be configured via the UI to add speech responses. Seems slightly better than kokoro.js in the browser, especially when memory constrained.