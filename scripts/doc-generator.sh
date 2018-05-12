#!/bin/bash -x

USER=pedrocesar-ti
MAIN=pedrocesar-ti.github.io
BRANCH=doc-generator
SUMMARY=$MAIN/docs/SUMMARY.md

for lines in `curl -s "https://api.github.com/users/$USER/repos?per_page=1000" | jq .[].html_url | sed 's/\"//g'`
do
    REPO=$(echo $lines)
    echo Verify $REPO
    [ -d $REPO ] || git clone $lines
done

cd $MAIN
git checkout $BRANCH
cd ..

for dir in `ls -d */`
do
    echo "Sending $dir"
    FILE=$(echo $dir | sed 's/\//\.md/')
    cat $dir/README.md > $MAIN/docs/$FILE 2> /dev/null || cat $dir/README.markdown > $MAIN/docs/$FILE 2> /dev/null

    if grep -q "docs/$FILE" "$SUMMARY"; then
        echo "$FILE OK!"
    else
        if [ "$dir" == "$MAIN/" ]; then
            echo "Directory NOT SUPPORTED"
        else
            BULLET=$(echo $dir | sed 's/\///')
            echo "* [$BULLET](docs/$FILE)" >> $SUMMARY
        fi
    fi
done

cd $MAIN
git init 
git config user.name "Travis CI"
git config user.email "pedrocesar.ti@gmail.com"
git remote add upstream "https://${GH_TOKEN}@${GH_REF}"
git fetch upstream
git reset upstream/gh-pages

git add -A .
git reset .travis ./scripts
git commit -m "Documentation autogenerated by Travis Cron."
git push -q upstream HEAD:gh-pages
