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
npm i --loglevel silent 2>&1 >/dev/null 
echo "Building app..."
npm run build
cd dist
mkdir in
mkdir out
mkdir final
cd in
echo "Copying ingress into container input..."
rsync --progress /mnt/ingress/ingress/* ./
cd ..
cd ..
echo "Running auto render..."
npm start || exit 1
echo      
echo "-------------------------"
cd dist
cd final
echo "Retriving container output to share..."
rsync --progress ./* /mnt/ingress/
echo      
echo      
echo "-------------------------"
echo "Unmounting share"
umount -l /mnt/ingress 
echo      
echo "done!"
echo      
