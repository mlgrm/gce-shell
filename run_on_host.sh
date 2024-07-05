#!/bin/bash
set -e
if [ ! -z "$DEBUG" ]; then set -x; fi

sudo apt-get update
sudo apt-get install -y jq
