#!/bin/bash

# Define the working directory and a timestamp
WORK_DIR="_book/"
TIMESTAMP="$(date +'%Y%m%d_%H-%M-%S')"
REVISION=$(git rev-parse --short HEAD)

# Enterinf in the Work Directory
cd $WORK_DIR

# Adding repository and create the branch to deploy
git init
git config user.name "Travis CI"
git config user.email "pedrocesar.ti@gmail.com"
git remote add upstream "https://${GH_TOKEN}@${GH_REF}" 
git fetch upstream
git reset upstream/gh-pages

# Create CNAME to expose the site 
echo "readme.pedrocesar.info" > CNAME
touch .

# Sending the deployed app to especific branch
git add -A .
git commit -m "Documentation updated at ${TIMESTAMP} - ${REVISION}"
git push -q upstream HEAD:gh-pages

