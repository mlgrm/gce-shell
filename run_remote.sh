#!/bin/bash

set -e
if [ "$DEBUG" == "true" ]; then set -z; fi

sudo apt-get update
sudo apt-get install -y jq git
if [ ! -z "$USER_EMAIL" ]; then git config --global user.email "$USER_EMAIL"; fi
if [ ! -z "$USER_NAME" ]; then git config --global user.name "$USER_NAME"; fi

