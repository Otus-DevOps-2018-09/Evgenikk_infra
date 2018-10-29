#!/bin/bash
set -e

# Install ruby
apt update
apt upgrade -y
apt install -y ruby-full ruby-bundler build-essential