#!/bin/bash

if [ -f ".env" ]; then source .env; fi

set -e
if [ ! -z "$DEBUG" ]; then set -x; fi

if [ -z "$SERVICE_ACCOUNT" ]
then
	SERVICE_ACCOUNT=$(gcloud iam service-accounts list \
		--filter='displayName="Compute Engine default service account"' \
		--format=json | jq -r .[0].email)
fi

if [ -z "$SERVICE_ACCOUNT" ]
then	
	echo "No service account specified and no default found." 2>&1
	exit 1
fi

gcloud compute instances create "$HOST" \
	--project="$PROJECT" \
	--zone=$ZONE \
	--machine-type="e2-micro" \
	--image-project="debian-cloud" \
	--image-family="debian-12" \
	--service-account="$SERVICE_ACCOUNT"

# wait for server to boot
sleep 15
until gcloud compute ssh $HOST --command="echo server online."
do
	sleep 5
done

if [ ! -z "$SERVICE_ACCOUNT" ]
then
	if [ ! -f "service_account_key.json" ]
	then
	       gcloud iam service-accounts keys create service_account_key.json \
		       --iam-account="$SERVICE_ACCOUNT"	
	fi
	gcloud compute scp service_account_key.json $HOST:.
fi

if [ -f "run_remote.sh" ]
then
	envsubst '$HOST $DEBUG $USER_NAME $USER_EMAIL $SERVICE_ACCOUNT $PREAUTH' < run_remote.sh |
		gcloud compute ssh $HOST --command="/bin/bash"
fi
