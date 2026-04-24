#!/bin/bash
apt-get update
apt-get install
apt-get upgrade
apt-get dist-upgrade
apt-get install git -y
apt-get install curl -y
apt-get install npm -y
apt-get install nvm -y
apt-get install n -y
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
apt-get install nodejs -y 
curl -o /usr/local/bin/n https://raw.githubusercontent.com/visionmedia/n/master/bin/n
chmod +x /usr/local/bin/n
n stable
node -v
cd /var/www/
git clone https://github.com/Bo-Br/backend-test.git
cd /var/www/backend-test
npm install
npm run build
ip addr
npm start
