# LINUMD — lightweight system info without sudo

**LINUMD** is a simple CLI tool that shows PC info, IP addresses, checks internet connection, and can cleanly uninstall itself — **without requiring root privileges**.

## ✨ Features
- `lmd pc` — hardware, OS, CPU, RAM, disk usage
- `lmd ip` — internal + external IP, gateway, DNS servers
- `lmd dns` — check if internet is working (ping + curl fallback)
- `lmd update` — shows update command for LINUMD itself
- `lmd del` — completely uninstall LINUMD (with confirmation prompt)
- `lmd --version` — show version
- `lmd help` — show usage

## 🚀 Install (no sudo)

### One-liner for ALL distributions (recommended)
```bash
curl -sL https://github.com/NellorYT/linumd/install.sh -o ~/.local/bin/linumd && chmod +x ~/.local/bin/linumd && echo "alias lmd='~/.local/bin/linumd'" >> ~/.bashrc && source ~/.bashrc


```bash
curl -sL https://githubusercontent.com -o ~/.local/bin/linumd && chmod +x ~/.local/bin/linumd && echo "alias lmd='~/.local/bin/linumd'" >> ~/.bashrc && source ~/.bashrc

