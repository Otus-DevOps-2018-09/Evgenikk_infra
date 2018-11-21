#!/bin/bash
PROJECT_ROOT=`pwd`
cd $PROJECT_ROOT

echo '#######################################################################'
echo 'ansible-lint tests:'
ansible-lint --exclude=roles/jdauphant.nginx ansible/playbooks/*.yml

echo '#######################################################################'
echo 'packer tests:'

echo "Validate app.json:"
packer validate -var-file=packer/variables.json.example packer/app.json
echo "Validate db.json:"
packer validate -var-file=packer/variables.json.example packer/db.jsonecho && echo
cd packer

echo "Validate immutable.json:"
packer validate -var-file=variables.json.example immutable.json
echo "Validate ubuntu16.json:"
packer validate -var-file=variables.json.example ubuntu16.json

echo '#######################################################################'
echo 'Terraform tests:'
cd $PROJECT_ROOT/terraform/stage
