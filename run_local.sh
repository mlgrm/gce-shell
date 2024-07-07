#!/bin/bash

DEBUG=true
if [ -f ".env" ]; then source .env; fi
set -e
if [ ! -z "$DEBUG" ]; then set -x; fi


gcloud compute instances create "$HOST" \
	--project="$PROJECT" \
	--zone=$ZONE \
	--machine-type="e2-micro" \
	--image-project="debian-cloud" \
	--image-family="debian-12" 

# wait for server to boot
sleep 15
until gcloud compute ssh $HOST --command="echo server online."
do
	sleep 5
done

if [ -f "run_remote.sh" ]
then
	envsubst '$HOST $DEBUG $USER_NAME $USER_EMAIL' < run_remote.sh |
		gcloud compute ssh $HOST --command="/bin/bash"
fi
