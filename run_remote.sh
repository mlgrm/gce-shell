#!/bin/bash

set -e
if [ "$DEBUG" == "true" ]; then set -z; fi

sudo apt-get update
sudo apt-get install -y gettext-base jq git
if [ ! -z "$USER_EMAIL" ]; then git config --global user.email "$USER_EMAIL"; fi
if [ ! -z "$USER_NAME" ]; then git config --global user.name "$USER_NAME"; fi

ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
echo "\n\nRSA Public Key:"
cat .ssh/id_rsa.pub
echo "\n\n"

