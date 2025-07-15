#!/bin/bash
set -e

echo "🔧 初始化守护进程开始部署..."

# 1. 安装 sing-box
ARCH=$(dpkg --print-architecture)
VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest | grep tag_name | cut -d '"' -f 4)
URL="https://github.com/SagerNet/sing-box/releases/download/${VERSION}/sing-box-${VERSION}-linux-${ARCH}.tar.gz"

mkdir -p /tmp/sb && cd /tmp/sb
curl -LO $URL
tar -xzf sing-box-${VERSION}-linux-${ARCH}.tar.gz
install -m 755 sing-box-${VERSION}-linux-${ARCH}/sing-box /usr/local/bin/sing-box

# 2. 配置文件
mkdir -p /etc/sing-box
curl -fsSL https://raw.githubusercontent.com/yunan888/init-daemon/main/config.json -o /etc/sing-box/config.json

# 3. 添加 systemd 服务
curl -fsSL https://raw.githubusercontent.com/yunan888/init-daemon/main/init-daemon.service -o /etc/systemd/system/init-daemon.service

systemctl daemon-reload
systemctl enable init-daemon
systemctl restart init-daemon

echo "✅ 部署完成"
echo "🎯 sing-box 已运行，监听 127.0.0.1 本地端口，安全模式启用"
