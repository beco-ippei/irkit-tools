#!/bin/sh
# wait and get irkit received ir-data

keys=`cat /var/devel/irkit/data/keys.json`

key="clientkey=`echo $keys | jq -r '.clientkey'`"

api=https://api.getirkit.com/1/messages

curl -XGET "$api?${key}&clear=1"

#TODO: ir-data file prompt.

