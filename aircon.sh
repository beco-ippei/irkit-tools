#!/bin/sh

keys=`cat /var/devel/irkit/data/keys.json`

device="deviceid=`echo $keys | jq -r '.deviceid'`"
key="clientkey=`echo $keys | jq -r '.clientkey'`"

cd `dirname $0`
if [ "$1" = "off" ]; then
  sw='off'
else
  sw='on'
fi
data=`cat data/${sw}.json`

api=https://api.getirkit.com/1/messages

curl -i "$api" -d "${key}" -d "${device}" -d "message=${data}"

