#!/bin/bash

set -e

mkdir -p /var/codedeploy/week09-exercise

cat <<EOF >/var/codedeploy/week09-exercise/env.properties
APPLICATION_NAME=$APPLICATION_NAME
DEPLOYMENT_GROUP_NAME=$DEPLOYMENT_GROUP_NAME
DEPLOYMENT_ID=$DEPLOYMENT_ID
EOF
