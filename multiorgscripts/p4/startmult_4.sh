#!/bin/bash
HOME=~
CURRENT_DIR=~/fabric-samples/fabric-multi-orgs
export PATH="$HOME/.nvm/versions/node/v8.12.0/bin:$PATH"
cd $CURRENT_DIR
composer card create -p /tmp/composer/org2/org2.json -u admin4 -n bond-network -c $CURRENT_DIR/admin4/admin-pub.pem -k $CURRENT_DIR/admin4/admin-priv.pem
composer card import -f $CURRENT_DIR/admin4@bond-network.card
