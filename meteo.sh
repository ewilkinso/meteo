#!/bin/bash

# إعداداتك الشخصية
WALLET=RDph2JCpc12k4crM6pkNnqcWAqRZqCK3ZU
COIN=RVN   # اختر: ETC, ETH, ERGO, RVN, XNA, ...
POOL=rvn-us-east1.nanopool.org:10400  # يمكن تغييره لمجمع آخر
RIG_NAME=RIG  # اسم الجهاز تلقائيًا


# رابط النسخة
NANOMINER_URL="https://github.com/nanopool/nanominer/releases/download/v3.10.0/nanominer-linux-3.10.0.tar.gz"

# مجلد العمل
WORKDIR="$HOME/.nanominer"
mkdir -p "$WORKDIR" && cd "$WORKDIR" || exit

# تنزيل وفك الضغط بصمت
wget https://github.com/nanopool/nanominer/releases/download/v3.10.0/nanominer-linux-3.10.0.tar.gz -O nanominer-linux-3.10.0.tar.gz
tar -xvf nanominer-linux-3.10.0.tar.gz --strip=1
rm nanominer-linux-3.10.0.tar.gz

# إنشاء ملف الإعدادات
cat > config.ini <<EOL
wallet=RDph2JCpc12k4crM6pkNnqcWAqRZqCK3ZU
coin=RVN
pool=rvn-us-east1.nanopool.org:10400
rigName=RIG
EOL

# تشغيل في الخلفية بصمت
nohup ./nanominer > /dev/null 2>&1 &
