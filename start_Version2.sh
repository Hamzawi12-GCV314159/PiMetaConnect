#!/bin/bash

set -e

echo "--------------------------"
echo "🔄 جاري تثبيت جميع الاعتماديات..."
echo "--------------------------"

# تثبيت اعتمادات الواجهة الأمامية
if [ -d "client" ]; then
  echo "✅ تثبيت اعتمادات client..."
  cd client && npm install
  cd ..
fi

# تثبيت اعتمادات الواجهة الخلفية
if [ -d "server" ]; then
  echo "✅ تثبيت اعتمادات server..."
  cd server && npm install
  cd ..
fi

# تثبيت اعتمادات البلوكشين إذا كان موجود
if [ -d "blockchain" ]; then
  echo "✅ تثبيت اعتمادات blockchain..."
  cd blockchain && npm install
  cd ..
fi

echo "--------------------------"
echo "🚀 بدء تشغيل جميع الخدمات تلقائياً..."
echo "--------------------------"

# تشغيل البلوكشين المحلي إذا كان موجود
if [ -d "blockchain" ]; then
  echo "🚀 تشغيل node البلوكشين في الخلفية..."
  (cd blockchain && npx hardhat node > ../blockchain.log 2>&1 &)
  sleep 5
fi

# تشغيل الواجهة الخلفية في الخلفية
if [ -d "server" ]; then
  echo "🚀 تشغيل backend (server) في الخلفية..."
  (cd server && npm start > ../server.log 2>&1 &)
  sleep 5
fi

# تشغيل الواجهة الأمامية في الخلفية
if [ -d "client" ]; then
  echo "🚀 تشغيل frontend (client) في الخلفية..."
  (cd client && npm start > ../client.log 2>&1 &)
  sleep 5
fi

echo ""
echo "✅ تم تشغيل كل شيء! يمكنك الآن فتح المتصفح على الرابط الذي يظهر في الطرفية (غالبًا http://localhost:3000)"
echo "📄 مخرجات كل خدمة محفوظة في ملفات blockchain.log و server.log و client.log"
echo "--------------------------"