#!/bin/bash
PROJECT_ROOT=`pwd`

# Устанавливаем packer
pwd
ls -la
echo "rm packer from workdir"
sudo rm -rf packer*
ls -la
echo "download packer"
sudo wget https://releases.hashicorp.com/packer/1.3.1/packer_1.3.1_linux_386.zip
ls -la
echo "unzip packer"
sudo unzip -o packer_1.3.1_linux_386.zip
ls -la
echo "delete  packer zip "
sudo rm -f packer_1.3.1_linux_386.zip
ls -la
echo "delete old packer"
sudo rm -rf /usr/local/bin/packer
sudo ls -la /usr/local/bin
echo "mv packer"
sudo mv -f packer /usr/local/bin/
sudo ls -la /usr/local/bin


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

echo '#######################################################################'
echo 'ansible-lint tests:'
ansible-lint --exclude=roles/jdauphant.nginx ansible/playbooks/*.yml

echo '#######################################################################'
echo 'packer tests:'

echo "Validate app.json"
packer validate -var-file=packer/variables.json.example packer/app.json
echo "Validate db.json"
packer validate -var-file=packer/variables.json.example packer/db.json
cd packer
echo "Validate immutable.json"
packer validate -var-file=variables.json.example immutable.json
echo "Validate ubuntu16.json"
packer validate -var-file=variables.json.example ubuntu16.json

echo '#######################################################################'
echo 'Terraform tests:'
cd $PROJECT_ROOT/terraform/stage
