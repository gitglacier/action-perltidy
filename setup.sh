#!/bin/bash

# Move to the action path
cd ${GITHUB_ACTION_PATH}


# Install perltidy
echo "[*] Installing Deps"
export ACCEPT_EULA=Y
sudo apt-get update && \
sudo apt-get install -y perltidy
