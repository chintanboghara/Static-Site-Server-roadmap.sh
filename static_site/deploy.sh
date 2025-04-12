#!/bin/bash

# Define variables
LOCAL_SITE_PATH="/path/to/static_site"
REMOTE_USER="your_username"
REMOTE_HOST="your_server_ip"
REMOTE_PATH="/var/www/html/"
SSH_KEY="/path/to/your/private_key.pem"

# Sync files
rsync -avz -e "ssh -i $SSH_KEY" $LOCAL_SITE_PATH/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH
