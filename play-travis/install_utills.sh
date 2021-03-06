#!/bin/bash
PROJECT_ROOT=`pwd`

# Устанавливаем packer
echo "download packer"

cd /var/tmp
sudo wget https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_386.zip
echo "unzip packer"
sudo unzip -o packer_1.3.1_linux_386.zip
echo "delete  packer zip "
sudo rm -f packer_1.3.1_linux_386.zip
echo "mv packer"
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

export PATH

echo '#######################################################################'
echo 'Check version of installed packages'
echo 'packer version:'
packer version
echo 'terraform  version:'
terraform --version
echo 'tflint version:'
tflint -v
cd $PROJECT_ROOT

