#!/bin/sh

echo "get ip segment"
ifconf=`ifconfig wlan0 | grep -oE 'inet.[^\ ]*:[0-9\.]+'`
ipseg=`echo $ifconf | sed -E 's/^.*:([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+/\1/'`

echo "scan network devices."
list=`nmap -sP "${ipseg}.0/24" | grep -oE "${ipseg}\.[0-9]+"`

echo "find irkit device and clienttoken."
for ip in $list; do
  st=`curl -LI -XPOST "http://$ip/keys" -o /dev/null -w '%{http_code}\n' -s`
  if [ "$st" = "200" ];then
    token=`curl -XPOST "http://$ip/keys" -s | jq -r '.clienttoken'`
    echo "token = '${token}'"
    break
  fi
done

if [ -z ${token} ]; then
  echo "irkit and not found"
  exit 1
fi

echo "get keys with clienttoken."
echo "curl -s -XPOST http://api.getirkit.com/1/keys -d \"clienttoken=${token}\""
keys=`curl -s -XPOST http://api.getirkit.com/1/keys -d "clienttoken=${token}"`

echo $keys

