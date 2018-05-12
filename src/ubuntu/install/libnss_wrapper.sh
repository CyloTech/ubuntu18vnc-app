#!/usr/bin/env bash


echo "Install nss-wrapper to be able to execute image as non-root user"
apt-get update 
apt-get install -y libnss-wrapper gettext
apt-get clean -y

echo "add 'souce generate_container_user' to .bashrc"

# have to be added to hold all env vars correctly
echo 'source $STARTUPDIR/generate_container_user' >> $HOME/.bashrc