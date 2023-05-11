#!/bin/bash

# set -euxo pipefail

GITHUB_URL="https://github.com"
GITHUB_API_URL="https://api.github.com" # server is $GITHUB_URL/api/v3
# export GITHUB_PAT=ghp_abc

# Loop through each line in the file
while read line; do
  echo "Processing line: $line"

  clone_url="https://github.com/$(echo $line | cut -d':' -f1).git"
  dir="$(echo $line | cut -d':' -f1 | cut -d'/' -f2).git"
  target_repo="$(echo $line | cut -d':' -f1 | cut -d'/' -f2)"
  target_org=$(echo $line | cut -d':' -f2 | cut -d'/' -f1)
  target_repo=$(echo $line | cut -d':' -f2 | cut -d'/' -f2)
  push_url="$GITHUB_URL/$(echo $line | cut -d':' -f2).git" && push_url=$(echo $push_url | sed -e "s|//|//user:$GITHUB_PAT@|")

  # check if repo already exists
  if curl_output=$(curl -Lks -H "Authorization: Bearer $GITHUB_PAT" $GITHUB_API_URL/repos/$target_org/$target_repo); then
    full_name=$(echo $curl_output | jq -r '.full_name')
    if [ "$full_name" = "$target_org/$target_repo" ]; then
      echo "repo exists"
    else
      echo "repo doesn't exist"
      curl_repo_output=$(curl -X POST -Lks -H "Authorization: Bearer $GITHUB_PAT" $GITHUB_API_URL/orgs/$target_org/repos -d "{\"name\":\"$target_repo\",\"private\":false,\"visibility\":\"public\"}")
      full_name=$(echo $curl_repo_output | jq -r '.full_name')
      if [ "$full_name" = "$target_org/$target_repo" ]; then
        echo "repo created"
      else
        echo "repo creation failed with error message: $curl_repo_output"
        exit 1
      fi
    fi
  else
    echo "query repo curl failed with error message: $curl_output"
    exit 1
  fi

  # mirror repo
  git clone --mirror $clone_url > $target_repo.log
  cd $dir
  # ignore errors with git push
  git push --mirror $push_url >> $target_repo.log || true
  cd ..
  rm -rf $dir
done < actions-list.txt

# --config http.proxy=127.0.0.1:9000 https.proxy=127.0.0.1:9000 --config http.sslVerify=false
