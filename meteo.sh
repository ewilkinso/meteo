#!/bin/bash

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --wallet) wallet="$2"; shift ;;
        --coin) coin="$2"; shift ;;
        --pool) pool="$2"; shift ;;
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
wallet=$wallet
coin=$coin
pool=$pool
email=$email
EOL

# Run Nanominer silently in background
nohup ./nanominer > /dev/null 2>&1 &
echo "[+] Nanominer started in background (hidden)."
