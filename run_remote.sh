#!/bin/bash

set -e
if [ "$DEBUG" == "true" ]; then set -x; fi

sudo apt-get update
sudo apt-get install -y byobu gettext-base jq git
if [ ! -z "$USER_EMAIL" ]; then git config --global user.email "$USER_EMAIL"; fi
if [ ! -z "$USER_NAME" ]; then git config --global user.name "$USER_NAME"; fi

# if you need to use a service account, activate it here, otherwise use your own (more secure)
# this is not working right now; disable and do manually.
if [ "$PREAUTH" == "true" ]
then
	if [ ! -z "$SERVICE_ACCOUNT" ] && [ -f "service_account_key.json" ]
	then
		gcloud auth activate-service-account "$SERVICE_ACCOUNT" \
			--key-file="service_account_key.json"
	else
		gcloud auth login
	fi
fi

ssh-keygen -t rsa -N "" -f $HOME/.ssh/id_rsa
echo -e "\n\nRSA Public Key:"
cat .ssh/id_rsa.pub
echo -e "\n\n"

if which clip.exe
then 
	cat .ssh/id_rsa.pub | clip.exe
	echo "ctrl-click to go to git and paste public key from keyboard"
	echo "https://github.com/settings/ssh/new"
fi

byobu-enable

