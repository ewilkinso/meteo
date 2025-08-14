#!/bin/bash
# ===============================
# Monero CPU Mining - Auto Restart
# ===============================

SESSION_NAME="monero"
XMRIG_VERSION="6.21.2"
POOL="45.155.102.89:443"
WALLET="4Aea3C3PCm6VcfUJ82g46G3iBwq59x8z6DYa4aM2E7QMC42vpTKARQfBwig1gEPSr3JufAayvqVs26CFuD7cwq7U2rPbeCR"

# 1. Download XMRig if not exists
if [ ! -f xmrig-${XMRIG_VERSION}/xmrig ]; then
    echo "[INFO] Downloading XMRig..."
    wget -q https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz
    tar -xvf xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz >/dev/null
fi

# 2. Create auto-restart start.sh
cat > xmrig-${XMRIG_VERSION}/start.sh << EOF
#!/bin/bash
cd "\$(dirname "\$0")"

while true
do
  ./xmrig \\
    -o ${POOL} \\
    -u ${WALLET} \\
    -p x \\
    --tls \\
    --cpu-priority=5 >> miner.log 2>&1
  echo "[WARN] XMRig stopped, restarting in 10 seconds..."
  sleep 10
done
EOF
chmod +x xmrig-${XMRIG_VERSION}/start.sh

# 3. Kill old session if exists
tmux kill-session -t ${SESSION_NAME} 2>/dev/null

# 4. Start in tmux
tmux new -d -s ${SESSION_NAME} "cd xmrig-${XMRIG_VERSION} && ./start.sh"

echo "[OK] Mining started in tmux session: ${SESSION_NAME}"
echo "[INFO] Attach with: tmux attach -t ${SESSION_NAME}"
