#!/bin/bash
PROJECT_ROOT=`pwd`

# Устанавливаем packer
sudo rm -f packer*.zip
sudo wget https://releases.hashicorp.com/packer/1.3.1/packer_1.3.1_linux_386.zip
sudo unzip -o packer_1.3.1_linux_386.zip
sudo rm -f packer_1.3.1_linux_386.zip
sudo mv -f packer /usr/local/bin/

#Устанавливаем  ansible-lint
cd /usr/local/src
sudo pip install ansible-lint
ansible-lint --version

sudo wget https://releases.hashicorp.com/terraform/0.11.9/terraform_0.11.9_linux_386.zip
sudo unzip  -o terraform_*.zip
sudo rm -f terraform_*.zip
sudo mv -f /usr/local/src/terraform /usr/local/bin/

# Устанавливаем  tflint

sudo wget https://github.com/wata727/tflint/releases/download/v0.7.2/tflint_linux_386.zip
sudo unzip -o tflint_*.zip
sudo rm -f tflint_*.zip
sudo mv -f  /usr/local/src/tflint /usr/local/bin/

echo '#######################################################################'
echo 'Check version of installed packages'
echo 'packer version:'
packer version
echo 'terraform  version:'
terraform --version
echo 'tflint version:'
tflint -v

cd $PROJECT_ROOT


echo '#######################################################################'
echo 'ansible-lint tests:'
ansible-lint --exclude=roles/jdauphant.nginx ansible/playbooks/*.yml