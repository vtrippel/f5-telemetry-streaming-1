#!/bin/bash

set -e

# BIG-IP deployment tool variables stored in GitLab:
# CICD_AUTH_OS_USERNAME - VIO user
# CICD_AUTH_OS_PASSWORD - VIO password
# CICD_AUTH_OS_PROJECT  - VIO project
# or
# CICD_AUTH_OS_TOKEN - VIO auth token
# CICD_AUTH_OS_PROJECT - VIO project

# BIG-IP deployment tool variables:
export CUSTOM_DECLARATION="yes"
export PROJECT_DECLARATION="${CI_PROJECT_DIR}/test/functional/deployment/declaration.yml"
export PROJECT_NAME=$([ "${CICD_PROJECT_NAME}" == "" ] && echo "test_functional_harness" || echo "${CICD_PROJECT_NAME}")
export PROJECT_DIR="/root/deploy-projects/${PROJECT_NAME}"

echo "CUSTOM_DECLARATION = ${CUSTOM_DECLARATION}"
echo "PROJECT_NAME = ${PROJECT_NAME}"
echo "PROJECT_DIR = ${PROJECT_DIR}"
echo "PROJECT_DECLARATION = ${PROJECT_DECLARATION}"

declaration=$(sed "s/_DEPLOYMENT_NAME_/${PROJECT_NAME}/g" "${PROJECT_DECLARATION}")
echo "$declaration" > "${PROJECT_DECLARATION}"
cat "${PROJECT_DECLARATION}"

# ready to start deployment
cd /root/cicd-bigip-deploy
make configure
make printvars
make setup

# for debugging purpose only
ls -als ${PROJECT_DIR}

# copy info about deployed harness to project's folder to create artifcat
cp ${PROJECT_DIR}/harness_facts_flat.json ${CI_PROJECT_DIR}/harness_facts_flat.json
