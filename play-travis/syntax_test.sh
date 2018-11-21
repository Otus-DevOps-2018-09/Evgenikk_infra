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
packer validate -var-file=packer/variables.json.example packer/db.json
cd packer

echo "Validate immutable.json:"
packer validate -var-file=variables.json.example immutable.json
echo "Validate ubuntu16.json:"
packer validate -var-file=variables.json.example ubuntu16.json

echo '#######################################################################'
echo 'Terraform tests (stage):'
cd $PROJECT_ROOT/terraform/stage
rm backend.tf
terraform get
terraform init
terraform validate -check-variables=false -var-file=terraform.tfvars.example
tflint


echo '#######################################################################'
echo 'Terraform tests (prod):'
cd $PROJECT_ROOT/terraform/prod
rm backend.tf
terraform get
terraform init
terraform validate -check-variables=false -var-file=terraform.tfvars.example
tflint

