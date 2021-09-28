#!/bin/bash
set -x

echo "Starting script"

git branch
git status
git log --pretty=oneline

git checkout master
git pull
git checkout -b testBranch00
git log --pretty=oneline

filepath=pkg/agent/datamodel/osimageconfig.go
flag=0
image_version=""
new_version="2021.09.25"
while read p; do
    if [[ $p == *":"* ]]; then
        image_variable=$(echo $p | awk -F: '{print $1}')
        image_value=$(echo $p | awk -F'\"' '{print $2}')
        if [[ $flag == 0 ]]; then
            if [[ $image_value == "aks" ]]; then
                flag=1
            fi
        fi

        if [[ $flag == 1 ]] && [[ $image_variable == "ImageVersion" ]]; then
            image_version=$image_value
            flag=0
            break
        fi
    fi
done < $filepath

echo $image_version
sed -i "s/${image_version}/${new_version}/g" $filepath

git status
git add .
git commit -m"will this work?"
git push -u origin testBranch00