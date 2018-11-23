#!/bin/bash
HOME=~
CURRENT_DIR=~/fabric-samples/fabric-multi-orgs
export PATH="$HOME/.nvm/versions/node/v8.12.0/bin:$PATH"
cd $CURRENT_DIR
rm -rf $CURRENT_DIR/admin2
rm -rf $CURRENT_DIR/admin2@bond-network.card
composer card create -p /tmp/composer/org1/org1.json -u PeerAdmin -c /tmp/composer/org1/Admin@org1.example.com-cert.pem -k /tmp/composer/org1/*_sk -r PeerAdmin -r ChannelAdmin -f $CURRENT_DIR/PeerAdmin@org1.card
composer card import -f $CURRENT_DIR/PeerAdmin@org1.card --card PeerAdmin@org1

composer identity request -c PeerAdmin@org1 -u admin -s adminpw -d $CURRENT_DIR/admin2

scp -r $CURRENT_DIR/admin2 USERNAME@PCNAME:$CURRENT_DIR/
