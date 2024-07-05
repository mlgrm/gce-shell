#!/bin/bash
set -e
DEBUG="true"
if [ ! -z "$DEBUG" ]; then set -x; fi

errf() {
  echo 'Script failed; trying to delete host...' 1>&2
  gcloud compute instances delete "$HOST" --quiet
}

trap 'errf' ERR

if [ -f ".env" ]; then source .env; fi

gcloud compute instances create "$HOST" \
	--project="$PROJECT" \
	--zone="$ZONE" \
	--machine-type=e2-micro \
	--image-project=debian-cloud \
	--image-family=debian-12 \
	--no-restart-on-failure \
	--maintenance-policy=TERMINATE \
	--provisioning-model=SPOT \
	--instance-termination-action=STOP \
	--scopes=https://www.googleapis.com/auth/cloud-platform 

sleep 15
until gcloud compute ssh "$HOST" --command="echo and...we\'re up!"
do sleep 5
done

envsubst '$DEBUG $HOST' < run_on_host.sh | gcloud compute ssh "$HOST" --command="bash"

