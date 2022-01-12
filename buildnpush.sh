#!/usr/bin/env bash
set -e
trap "rm imageid" EXIT

if [ -z "$1" ]
then
  echo "Provide tag"
  exit 1
fi

repo=116562171375.dkr.ecr.eu-west-1.amazonaws.com/cta/delivery-base-image-datadog-integration

docker build --pull --iidfile imageid .
docker tag $(cat imageid) $repo:$1
docker tag $(cat imageid) $repo:latest
docker push $repo:$1
docker push $repo:latest
