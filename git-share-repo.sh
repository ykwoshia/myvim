#!/bin/bash

GIT_DIR="/data/ykwoshia"
REPO_NAME=$1

mkdir -p "${GIT_DIR}/${REPO_NAME}.git"
cd "${GIT_DIR}/${REPO_NAME}.git"

# git init --bare --shared &> /dev/null
touch git-daemon-export-ok
cp hooks/post-update.sample hooks/post-update
git config http.receivepack true
git update-server-info
chown -Rf www-data:www-data "${GIT_DIR}/${REPO_NAME}.git"
echo "Git repository '${REPO_NAME}' created in ${GIT_DIR}/${REPO_NAME}.git"
