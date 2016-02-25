#!/bin/bash

# remove petitions.json
rm -f $1

# pull down data
I=0
while :; do
  # print status
  echo "I = $I"

  # save response in temp file
  curl -s -X GET "https://api.whitehouse.gov/v1/petitions.json?limit=1000&offset=$((I*1000))" > /tmp/petitions.json

  # check if there are any results
  RESULTS=$(cat /tmp/petitions.json | jq '.results[].id' | wc -l)
  if [ "$RESULTS" -eq "0" ]; then
    break
  else
    cat /tmp/petitions.json | jq '.results[]' >> $1
    if [ "$RESULTS" -lt "1000" ]; then
      break
    else
      (( I++ ))
    fi
  fi
done
