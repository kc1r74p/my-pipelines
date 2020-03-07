#!/bin/bash
set +x
apt-get update 2>&1 >/dev/null
apt-get install -y pv 2>&1 >/dev/null 
apt-get install -y cifs-utils 2>&1 >/dev/null
apt-get install -y --update nodejs npm 2>&1 >/dev/null
#apt install ffmpeg 2>&1 >/dev/null 
mkdir /mnt/ingress
mount -t cifs ${nas_adr} /mnt/ingress -o vers=3.0,username=${nas_adm},password=${nas_pw},dir_mode=0777,file_mode=0777,serverino
cd auto-renderer
echo "Installing render deps..."
npm i 2>&1 >/dev/null 
echo "Building app..."
npm run build
cd dist
mkdir in
mkdir out
mkdir final
cd in
echo "Copying ingress into container input..."
pv /mnt/ingress/ingress/* > ./*
cd ..
cd ..
echo "Running auto render..."
npm start
echo      
echo "-------------------------"
cd dist
cd final
echo "Retriving container output to share..."
pv ./* > /mnt/ingress/
echo      
echo      
echo "-------------------------"
echo      
echo "done!"
echo      
