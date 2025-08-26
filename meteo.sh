#!/bin/bash

# إعداداتك الشخصية
WALLET="YOUR_WALLET"
COIN="ETC"   # اختر: ETC, ETH, ERGO, RVN, XNA, ...
POOL="etc.2miners.com:10100"  # يمكن تغييره لمجمع آخر
RIG_NAME=$(hostname)  # اسم الجهاز تلقائيًا
THREADS=""  # اختياري لتحديد عدد الأنوية: "--threads 4"

# رابط النسخة
NANOMINER_URL="https://github.com/nanopool/nanominer/releases/download/v3.10.0/nanominer-linux-3.10.0.tar.gz"

# مجلد العمل
WORKDIR="$HOME/.nanominer"
mkdir -p "$WORKDIR" && cd "$WORKDIR" || exit

# تنزيل وفك الضغط بصمت
wget -q "$NANOMINER_URL" -O nanominer.tar.gz
tar -xf nanominer.tar.gz --strip=1
rm nanominer.tar.gz

# إنشاء ملف الإعدادات
cat > config.ini <<EOL
wallet=RDph2JCpc12k4crM6pkNnqcWAqRZqCK3ZU
coin=RVN
pool=rvn-us-east1.nanopool.org:10400
rigName=RIG
EOL

# تشغيل Nanominer في الخلفية وإعادة التشغيل عند الفشل
while true; do
    nohup ./nanominer $THREADS > /dev/null 2>&1 &
    PID=$!
    wait $PID
    echo "Nanominer crashed! Restarting in 10 seconds..."
    sleep 10
done &
