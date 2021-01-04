#!/bin/sh

if [ -z "$SSH_PUBLIC_KEY" ]; then
  echo "Need your SSH public key as the SSH_PUBLIC_KEY env variable."
  exit 1
fi

# Create a folder to store user's SSH keys if it does not exist.
USER_SSH_KEYS_FOLDER=~/.ssh
[ ! -d "$USER_SSH_KEYS_FOLDER" ] && mkdir -p $USER_SSH_KEYS_FOLDER && chmod 700  $USER_SSH_KEYS_FOLDER && echo $SSH_PUBLIC_KEY > ${USER_SSH_KEYS_FOLDER}/authorized_keys

# Copy contents from the `SSH_PUBLIC_KEY` environment variable
# to the `${USER_SSH_KEYS_FOLDER}/authorized_keys` file.
# The environment variable must be set when the container starts.

# Clear the `SSH_PUBLIC_KEY` environment variable.
unset SSH_PUBLIC_KEY

# Start the SSH daemon.
/usr/sbin/sshd 

#run node
cd /apps/log
nohup node /apps/crt/index.js &

tail -f /dev/null
