#!/bin/bash
PROJECT_ROOT=`pwd`

cd /usr/local/src
sudo pip install ansible-lint
ansible-lint --version

cd $PROJECT_ROOT

echo '#######################################################################'
echo 'Ansible-lint test'
ansible-lint --exclude=roles/jdauphant.nginx ansible/playbooks/*.yml