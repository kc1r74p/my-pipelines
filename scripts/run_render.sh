#!/bin/bash
# get out of scripts
cd ..
cd ..

set +x
set -e

echo "Mounting remote share..."
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
ls -altrh
cd in
echo "Copying ingress into container input..."
pv /mnt/ingress/ingress/* > ./*
echo "Current dir:"
pwd
cd ..
cd ..

echo "Current dir:"
pwd

echo "Running auto render..."
npm start || exit 1
echo      
echo "-------------------------"
cd dist
cd final
echo "Retriving container output to share..."
pv ./* > /mnt/ingress/*
echo      
echo      
echo "-------------------------"
echo      
echo "done!"
echo      
