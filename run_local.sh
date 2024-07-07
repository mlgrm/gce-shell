#!/bin/bash

DEBUG=true
set -e
if [ ! -z "$DEBUG" ]; then set -x; fi

gcloud compute instances create "$HOST" \
	--project="$PROJECT" \
	--zone=$ZONE \
	--machine-type="e2-micro" \
	--image-project="debian-cloud" \
	--image-family="debian-12" \

