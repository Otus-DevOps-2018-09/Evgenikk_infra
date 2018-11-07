#!/bin/bash
#install ruby
apt update
apt install -y ruby-full ruby-bundler build-essential
#install mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update
apt install -y mongodb-org
#Run mongod and  deploy app
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
systemctl start mongod
systemctl enable mongod
puma -d
