#!/bin/bash

if [[ -z "$TOKEN" ]]; then
  echo "Please set 'TOKEN'"
  exit 2
fi

if [[ -z "$USER_PASS" ]]; then
  echo "Please set 'USER_PASS' for user: $USER"
  exit 3
fi

echo "### Update user: $USER password ###"
echo -e "$USER_PASS\n$USER_PASS" | sudo passwd "$USER"

log=./airport/.log
address=./airport/address

rm -f $log
./airport/ngrok authtoken "$TOKEN"
./airport/ngrok tcp 22 --region jp --log "$log" &

sleep 10
HAS_ERRORS=$(grep "command failed" < $log)

if [[ -z "$HAS_ERRORS" ]]; then
  echo ""
  echo "=========================================="
  echo "To connect: $(grep -o -E "tcp://(.+)" < $log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
  echo "=========================================="

  date +'%Y-%m-%d %H:%M:%S' > $address
  echo "To connect: $(grep -o -E "tcp://(.+)" < $log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")" >> $address
else
  echo "$HAS_ERRORS"
  exit 4
fi
