#!/bin/bash

USER=pedrocesar-ti
MAIN=pedrocesar-ti.github.io
BRANCH=gh-pages

for lines in `curl -s "https://api.github.com/users/$USER/repos?per_page=1000" | grep -o 'git@[^"]*'`
do 
	REPO=$(echo $lines | awk -F "/" '{print $2}' | awk -F "." '{print $1}')
	echo Verificando $REPO
	[ -d $REPO ] || git clone $lines 
done

cd $MAIN
git checkout $BRANCH
cd ..

for directories in `ls -d */`
do 
	echo "Mandando $directories"
	FILE=$(echo $directories | sed 's/\//\.md/')
	cat $directories/README.md > $MAIN/docs/$FILE
done
