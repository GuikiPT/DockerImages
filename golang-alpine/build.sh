#!/bin/bash

registry="forgejo.guiki.pt"
owner="guikipt"
image="golang-alpine"
tag="latest"

docker build -t ${registry}/${owner}/${image}:${tag} .
docker tag ${registry}/${owner}/${image}:${tag} ${registry}/${owner}/${image}:latest
docker push ${registry}/${owner}/${image}:${tag}