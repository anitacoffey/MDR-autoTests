#!/bin/bash

# NVM install for Orc. Docker will already be avaialable
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 8.9
echo node --version

# Local Boot
cd ../orc && npm i && npm run local-noninteractive

# Sleep for a minute
echo "sleeping to let exchange stabalise"

# Run the test suite
docker run --net=host testing 
