#!/bin/bash
HOME=~
CURRENT_DIR=~/fabric-samples/fabric-multi-orgs
export PATH="$HOME/.nvm/versions/node/v8.12.0/bin:$PATH"
cd $CURRENT_DIR
rm -rf $CURRENT_DIR/admin3
rm -rf $CURRENT_DIR/admin3@bond-network.card
composer card create -p /tmp/composer/org2/org2.json -u PeerAdmin -c /tmp/composer/org2/Admin@org2.example.com-cert.pem -k /tmp/composer/org2/*_sk -r PeerAdmin -r ChannelAdmin -f $CURRENT_DIR/PeerAdmin@org2.card
composer card import -f $CURRENT_DIR/PeerAdmin@org2.card --card PeerAdmin@org2
composer network install --card PeerAdmin@org2 --archiveFile $CURRENT_DIR/BNAFILENAME

composer identity request -c PeerAdmin@org2 -u admin -s adminpw -d $CURRENT_DIR/admin3

scp -r $CURRENT_DIR/admin3 USERNAME@PCNAME:$CURRENT_DIR/
