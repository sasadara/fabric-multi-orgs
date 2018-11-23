#!/bin/bash
HOME=~
CURRENT_DIR=~/fabric-samples/fabric-multi-orgs
cd $CURRENT_DIR
export PATH="$HOME/.nvm/versions/node/v8.12.0/bin:$PATH"
composer card delete -c admin2@bond-network
composer card delete -c PeerAdmin@org1
composer card delete -c PeerAdmin@org2
rm -fr ~/.composer
rm -fr $CURRENT_DIR/composer
rm -rf /tmp/composer/
yes | $CURRENT_DIR/bymn.sh down
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker swarm leave -f
yes | docker volume prune
yes | docker network prune
