#!/bin/bash
PROJECT_ROOT=`pwd`


#Устанавливаем  ansible-lint
cd /usr/local/src
sudo pip install ansible-lint
ansible-lint --version
echo 'packer version:'
packer version
echo 'terraform  version:'
terraform --version
echo 'tflint version:'
tflint -v

cd $PROJECT_ROOT

#Проверяем все playbook-и при помощи  ansible-lint
ansible-lint --exclude=roles/jdauphant.nginx ansible/playbooks/*.yml