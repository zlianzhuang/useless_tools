#!/bin/bash

set -x

# the action user is "runner"
if [[ -z "$USER_PASS" ]]; then
  echo "Please set 'USER_PASS' for user: $USER"
  exit 1
fi

echo "### Update user: $USER password ###"
echo -e "$USER_PASS\n$USER_PASS" | sudo passwd "$USER"

ssh -tt -fN -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ServerAliveInterval=60 -R lzzhang-github-action:22:localhost:22 serveo.net
sleep 1800
