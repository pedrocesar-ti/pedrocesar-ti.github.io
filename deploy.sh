#!/bin/bash
## Define the working directory and a timestamp
WORK_DIR="_book/"
TIMESTAMP="$(date +'%Y%m%d_%H-%M-%S')"
REVISION=$(git rev-parse --short HEAD)

cd $WORK_DIR

git init
git config user.name "Travis CI"
git config user.email "pedrocesar.ti@gmail.com"

git remote add upstream "https://${GH_TOKEN}@${GH_REF}" 
git fetch upstream
git reset upstream/gh-pages

echo "blog.pedrocesar.info" > CNAME
touch .

git add -A .
git commit -m "Documentation updated at ${TIMESTAMP} - ${REVISION}"
git push -q upstream HEAD:master

