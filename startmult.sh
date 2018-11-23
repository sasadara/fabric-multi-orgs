#!/bin/bash
# prepending $PWD/../bin to PATH to ensure we are picking up the correct binaries
# this may be commented out to resolve installed version of tools if desired
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
export VERBOSE=false
export ORDERER_HOSTNAME="<hostname>"
export ORG1_HOSTNAME0="<hostname>"
export ORG1_HOSTNAME1="<hostname>"
export ORG2_HOSTNAME0="<hostname>"
export ORG2_HOSTNAME1="<hostname>"
export SWARM_NETWORK="bond-network"
export DOCKER_STACK="bond-network"
USER1=ubuntu
USER2=ubuntu
USER3=ubuntu
USER4=ubuntu
PC1=<ip1>
PC2=<ip2>
PC3=<ip3>
PC4=<ip4>
VERSION=0.2.6
BNAFILENAME=bond-network@$VERSION.bna

CURRENT_DIR=~/fabric-samples/fabric-multi-orgs
  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

function removeCaches() {
  ssh $USER2@$PC2 rm -rf "$CURRENT_DIR/multiorgscripts"
  ssh $USER3@$PC3 rm -rf "$CURRENT_DIR/multiorgscripts"
  ssh $USER4@$PC4 rm -rf "$CURRENT_DIR/multiorgscripts"
  rm -rf $CURRENT_DIR/admin2
  rm -rf $CURRENT_DIR/admin2@bond-network.card
  rm -rf $CURRENT_DIR/admin3
  rm -rf $CURRENT_DIR/admin3@bond-network.card
  rm -rf $CURRENT_DIR/admin4
  rm -rf $CURRENT_DIR/admin4@bond-network.card

  rm -rf $CURRENT_DIR/docker-compose-org1peer0.yaml
  rm -rf $CURRENT_DIR/docker-compose-org1peer1.yaml
  rm -rf $CURRENT_DIR/docker-compose-org2peer0.yaml
  rm -rf $CURRENT_DIR/docker-compose-org2peer1.yaml
}

function removeAllUnwanted() {
  composer card delete -c admin1@bond-network
  composer card delete -c PeerAdmin@org1
  composer card delete -c PeerAdmin@org2
  rm -fr ~/.composer
  rm -fr $CURRENT_DIR/composer
  rm -rf /tmp/composer/
  chmod a+x $CURRENT_DIR/bymn.sh
  yes | $CURRENT_DIR/bymn.sh down
  docker kill $(docker ps -q)
  docker rm $(docker ps -a -q)
  docker swarm leave -f
  yes | docker volume prune
  yes | docker network prune
  
  # PC1
  # Copy necessary files 
  # cp $CURRENT_DIR/multiorgscripts/startmult_3_template.sh $CURRENT_DIR/multiorgscripts/startmult_3.sh
  # sed $OPTS "s|USERNAME|$USER1|g" $CURRENT_DIR/multiorgscripts/startmult_3.sh
  # sed $OPTS "s|PCNAME|$PC1|g" $CURRENT_DIR/multiorgscripts/startmult_3.sh
  # sed $OPTS "s|BNAFILENAME|$BNAFILENAME|g" $CURRENT_DIR/multiorgscripts/startmult_3.sh

  # scp -r $CURRENT_DIR/multiorgscripts $USER1@$PC1:$CURRENT_DIR
  # scp $CURRENT_DIR/$BNAFILENAME $USER1@$PC1:$CURRENT_DIR/
  # ssh $USER1@$PC1 chmod a+x "$CURRENT_DIR/multiorgscripts/startmult_1.sh"
  # ssh $USER1@$PC1 "$CURRENT_DIR/multiorgscripts/startmult_1.sh"
  
  #PC2
  #Copy necessary files
  cp $CURRENT_DIR/multiorgscripts/p2/startmult_3_template.sh $CURRENT_DIR/multiorgscripts/p2/startmult_3.sh
  sed $OPTS "s|USERNAME|$USER1|g" $CURRENT_DIR/multiorgscripts/p2/startmult_3.sh
  sed $OPTS "s|PCNAME|$PC1|g" $CURRENT_DIR/multiorgscripts/p2/startmult_3.sh
  sed $OPTS "s|BNAFILENAME|$BNAFILENAME|g" $CURRENT_DIR/multiorgscripts/p2/startmult_3.sh
  
  ssh $USER2@$PC2 rm -rf $CURRENT_DIR
  ssh $USER2@$PC2 mkdir $CURRENT_DIR
  scp -r $CURRENT_DIR/chaincode  $USER2@$PC2:$CURRENT_DIR/
  scp -r $CURRENT_DIR/scripts  $USER2@$PC2:$CURRENT_DIR/
  
  ssh $USER2@$PC2 rm -rf $CURRENT_DIR/multiorgscripts
  ssh $USER2@$PC2 mkdir $CURRENT_DIR/multiorgscripts
  scp -r $CURRENT_DIR/multiorgscripts/p2 $USER2@$PC2:$CURRENT_DIR/multiorgscripts/
  scp $CURRENT_DIR/$BNAFILENAME $USER2@$PC2:$CURRENT_DIR/
  scp $CURRENT_DIR/bymn.sh $USER2@$PC2:$CURRENT_DIR/
  ssh $USER2@$PC2 chmod a+x "$CURRENT_DIR/bymn.sh"
  ssh $USER2@$PC2 chmod a+x "$CURRENT_DIR/multiorgscripts/p2/*.*"
  ssh $USER2@$PC2 "$CURRENT_DIR/multiorgscripts/p2/startmult_1.sh"
  
  #PC3
  #Copy necessary files
  cp $CURRENT_DIR/multiorgscripts/p3/startmult_3_template.sh $CURRENT_DIR/multiorgscripts/p3/startmult_3.sh
  sed $OPTS "s|USERNAME|$USER1|g" $CURRENT_DIR/multiorgscripts/p3/startmult_3.sh
  sed $OPTS "s|PCNAME|$PC1|g" $CURRENT_DIR/multiorgscripts/p3/startmult_3.sh
  sed $OPTS "s|BNAFILENAME|$BNAFILENAME|g" $CURRENT_DIR/multiorgscripts/p3/startmult_3.sh
  
  ssh $USER3@$PC3 rm -rf $CURRENT_DIR
  ssh $USER3@$PC3 mkdir $CURRENT_DIR
  scp -r $CURRENT_DIR/chaincode  $USER3@$PC3:$CURRENT_DIR/
  scp -r $CURRENT_DIR/scripts  $USER3@$PC3:$CURRENT_DIR/
  
  ssh $USER3@$PC3 rm -rf $CURRENT_DIR/multiorgscripts
  ssh $USER3@$PC3 mkdir $CURRENT_DIR/multiorgscripts
  scp -r $CURRENT_DIR/multiorgscripts/p3 $USER3@$PC3:$CURRENT_DIR/multiorgscripts/
  scp $CURRENT_DIR/$BNAFILENAME $USER3@$PC3:$CURRENT_DIR/
  scp $CURRENT_DIR/bymn.sh $USER3@$PC3:$CURRENT_DIR/
  ssh $USER3@$PC3 chmod a+x "$CURRENT_DIR/bymn.sh"
  ssh $USER3@$PC3 chmod a+x "$CURRENT_DIR/multiorgscripts/p3/*.*"
  ssh $USER3@$PC3 "$CURRENT_DIR/multiorgscripts/p3/startmult_1.sh"
  
  #PC4
  #Copy necessary files
  cp $CURRENT_DIR/multiorgscripts/p4/startmult_3_template.sh $CURRENT_DIR/multiorgscripts/p4/startmult_3.sh
  sed $OPTS "s|USERNAME|$USER1|g" $CURRENT_DIR/multiorgscripts/p4/startmult_3.sh
  sed $OPTS "s|PCNAME|$PC1|g" $CURRENT_DIR/multiorgscripts/p4/startmult_3.sh
  sed $OPTS "s|BNAFILENAME|$BNAFILENAME|g" $CURRENT_DIR/multiorgscripts/p4/startmult_3.sh
  
  ssh $USER4@$PC4 rm -rf $CURRENT_DIR
  ssh $USER4@$PC4 mkdir $CURRENT_DIR
  scp -r $CURRENT_DIR/chaincode  $USER4@$PC4:$CURRENT_DIR/
  scp -r $CURRENT_DIR/scripts  $USER4@$PC4:$CURRENT_DIR/
  
  ssh $USER4@$PC4 rm -rf $CURRENT_DIR/multiorgscripts
  ssh $USER4@$PC4 mkdir $CURRENT_DIR/multiorgscripts
  scp -r $CURRENT_DIR/multiorgscripts/p4 $USER4@$PC4:$CURRENT_DIR/multiorgscripts/
  scp $CURRENT_DIR/$BNAFILENAME $USER4@$PC4:$CURRENT_DIR/
  scp $CURRENT_DIR/bymn.sh $USER4@$PC4:$CURRENT_DIR/
  ssh $USER4@$PC4 chmod a+x "$CURRENT_DIR/bymn.sh"
  ssh $USER4@$PC4 chmod a+x "$CURRENT_DIR/multiorgscripts/p4/*.*"
  ssh $USER4@$PC4 "$CURRENT_DIR/multiorgscripts/p4/startmult_1.sh"
}

function generateCrypto() {
  yes | $CURRENT_DIR/bymn.sh generate $CURRENT_DIR/crypto-config.yaml
  
  scp -r $CURRENT_DIR/channel-artifacts  $USER2@$PC2:$CURRENT_DIR/
  scp -r $CURRENT_DIR/crypto-config  $USER2@$PC2:$CURRENT_DIR/
  scp $CURRENT_DIR/docker-compose-org1peer1.yaml $USER2@$PC2:$CURRENT_DIR/
  
  scp -r $CURRENT_DIR/channel-artifacts  $USER3@$PC3:$CURRENT_DIR/
  scp -r $CURRENT_DIR/crypto-config  $USER3@$PC3:$CURRENT_DIR/
  scp $CURRENT_DIR/docker-compose-org2peer0.yaml $USER3@$PC3:$CURRENT_DIR/
  
  scp -r $CURRENT_DIR/channel-artifacts  $USER4@$PC4:$CURRENT_DIR/
  scp -r $CURRENT_DIR/crypto-config  $USER4@$PC4:$CURRENT_DIR/
  scp $CURRENT_DIR/docker-compose-org2peer1.yaml $USER4@$PC4:$CURRENT_DIR/
}

function upNetwork() {
  docker swarm init --advertise-addr $PC1
  docker swarm join-token manager > $CURRENT_DIR/token2.sh
  docker swarm join-token manager > $CURRENT_DIR/token3.sh
  docker swarm join-token manager > $CURRENT_DIR/token4.sh
  
  sed -i "s/To add a manager to this swarm, run the following command://g" $CURRENT_DIR/token2.sh
  sed -i "s/To add a manager to this swarm, run the following command://g" $CURRENT_DIR/token3.sh
  sed -i "s/To add a manager to this swarm, run the following command://g" $CURRENT_DIR/token4.sh
  
  echo -n " --advertise-addr $PC2" >> $CURRENT_DIR/token2.sh
  echo -n " --advertise-addr $PC3" >> $CURRENT_DIR/token3.sh
  echo -n " --advertise-addr $PC4" >> $CURRENT_DIR/token4.sh
  
  sed -i ':a $!N; s/\n//; ta' $CURRENT_DIR/token2.sh
  sed -i ':a $!N; s/\n//; ta' $CURRENT_DIR/token3.sh
  sed -i ':a $!N; s/\n//; ta' $CURRENT_DIR/token4.sh
  
  chmod a+x $CURRENT_DIR/token2.sh
  chmod a+x $CURRENT_DIR/token3.sh
  chmod a+x $CURRENT_DIR/token4.sh
  
  ssh $USER2@$PC2 'bash -s' < $CURRENT_DIR/token2.sh
  ssh $USER3@$PC3 'bash -s' < $CURRENT_DIR/token3.sh
  ssh $USER4@$PC4 'bash -s' < $CURRENT_DIR/token4.sh
  
  rm -rf $CURRENT_DIR/token2.sh
  rm -rf $CURRENT_DIR/token3.sh
  rm -rf $CURRENT_DIR/token4.sh

  docker network create --attachable --driver overlay bond-network

  yes | $CURRENT_DIR/bymn.sh up -f $CURRENT_DIR/docker-compose-orderer.yaml
  yes | $CURRENT_DIR/bymn.sh up -f $CURRENT_DIR/docker-compose-org1peer0.yaml

  ssh $USER2@$PC2 yes | $CURRENT_DIR/bymn.sh up -f $CURRENT_DIR/docker-compose-org1peer1.yaml
  ssh $USER3@$PC3 yes | $CURRENT_DIR/bymn.sh up -f $CURRENT_DIR/docker-compose-org2peer0.yaml
  ssh $USER4@$PC4 yes | $CURRENT_DIR/bymn.sh up -f $CURRENT_DIR/docker-compose-org2peer1.yaml
}

function testNetwork(){
  echo "Waiting 15 sec to init images"
  sleep 15
  ssh $USER4@$PC4 chmod a+x "$CURRENT_DIR/multiorgscripts/p4/startmult_2.sh"
  ssh -t $USER4@$PC4 "$CURRENT_DIR/multiorgscripts/p4/startmult_2.sh"
}

function replacePrivateKey() {
  rm -rf $CURRENT_DIR/composer/
  rm -rf /tmp/composer/
  cp -R $CURRENT_DIR/composertemplate/ $CURRENT_DIR/composer/

  touch $CURRENT_DIR/composer/org1/ca-org1.txt
  touch $CURRENT_DIR/composer/org2/ca-org2.txt
  touch $CURRENT_DIR/composer/ca-orderer.txt
  awk 'NF {sub(/\r/, ""); printf "%s\\\\n",$0;}' $CURRENT_DIR/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt > $CURRENT_DIR/composer/org1/ca-org1.txt
  awk 'NF {sub(/\r/, ""); printf "%s\\\\n",$0;}' $CURRENT_DIR/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt > $CURRENT_DIR/composer/org2/ca-org2.txt
  awk 'NF {sub(/\r/, ""); printf "%s\\\\n",$0;}' $CURRENT_DIR/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt > $CURRENT_DIR/composer/ca-orderer.txt

  # Copy the org1 & org2 templates to the files that will be modified to add the private key
  cd $CURRENT_DIR/composer/org1/
  cp org1-template.json org1.json
  cd $CURRENT_DIR/composer/org2/
  cp org2-template.json org2.json

  # The next steps will replace the template's contents with the
  # actual values of the private key file names for the two CAs.
  
  cd $CURRENT_DIR/composer/
  PRIV_ODR=$(< ca-orderer.txt)
  cd $CURRENT_DIR/composer/org1/
  PRIV_KEY1=$(< ca-org1.txt)
  cd $CURRENT_DIR/composer/org2/
  PRIV_KEY2=$(< ca-org2.txt)
  cd $CURRENT_DIR/composer/org1/
  echo $PRIV_ODR
  echo $PRIV_KEY1
  echo $PRIV_KEY2
  #python replace.py
  sed $OPTS "s|INSERT_ORDERER_CA_CERT|$PRIV_ODR|g" org1.json
  sed $OPTS "s|INSERT_ORG1_CA_CERT|${PRIV_KEY1}|g" org1.json
  sed $OPTS "s|INSERT_ORG2_CA_CERT|${PRIV_KEY2}|g" org1.json
  sed $OPTS "s|PC1|$PC1|g" org1.json
  sed $OPTS "s|PC2|$PC2|g" org1.json
  sed $OPTS "s|PC3|$PC3|g" org1.json
  sed $OPTS "s|PC4|$PC4|g" org1.json

  cd $CURRENT_DIR/composer/org2/
  sed $OPTS "s|INSERT_ORDERER_CA_CERT|${PRIV_ODR}|g" org2.json
  sed $OPTS "s|INSERT_ORG1_CA_CERT|${PRIV_KEY1}|g" org2.json
  sed $OPTS "s|INSERT_ORG2_CA_CERT|${PRIV_KEY2}|g" org2.json
  sed $OPTS "s|PC1|$PC1|g" org2.json
  sed $OPTS "s|PC2|$PC2|g" org2.json
  sed $OPTS "s|PC3|$PC3|g" org2.json
  sed $OPTS "s|PC4|$PC4|g" org2.json

  ORG1=crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  cd $CURRENT_DIR/$ORG1/signcerts/
  cp -p A*.pem $CURRENT_DIR/composer/org1
  cd $CURRENT_DIR/$ORG1/keystore/
  cp -p *_sk $CURRENT_DIR/composer/org1

  ORG2=crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
  cd $CURRENT_DIR/$ORG2/signcerts/
  cp -p A*.pem $CURRENT_DIR/composer/org2
  cd $CURRENT_DIR/$ORG2/keystore/
  cp -p *_sk $CURRENT_DIR/composer/org2

  rm -rf /tmp/composer/
  ssh -t $USER2@$PC2 rm -rf /tmp/composer/
  ssh -t $USER3@$PC3 rm -rf /tmp/composer/
  ssh -t $USER4@$PC4 rm -rf /tmp/composer/
  
  cp -R $CURRENT_DIR/composer /tmp/
  scp -r $CURRENT_DIR/composer $USER2@$PC2:/tmp/
  scp -r $CURRENT_DIR/composer $USER3@$PC3:/tmp/
  scp -r $CURRENT_DIR/composer $USER4@$PC4:/tmp/
}

function createPeers(){
  cd $CURRENT_DIR
  
  rm -rf $CURRENT_DIR/admin1
  rm -rf $CURRENT_DIR/admin1@bond-network.card
  composer card create -p /tmp/composer/org1/org1.json -u PeerAdmin -c /tmp/composer/org1/Admin@org1.example.com-cert.pem -k /tmp/composer/org1/*_sk -r PeerAdmin -r ChannelAdmin -f $CURRENT_DIR/PeerAdmin@org1.card
  composer card import -f $CURRENT_DIR/PeerAdmin@org1.card --card PeerAdmin@org1
  composer network install --card PeerAdmin@org1 --archiveFile $CURRENT_DIR/$BNAFILENAME
  
  composer identity request -c PeerAdmin@org1 -u admin -s adminpw -d $CURRENT_DIR/admin1
  
  
  ssh $USER2@$PC2 chmod a+x "$CURRENT_DIR/multiorgscripts/p2/startmult_3.sh"
  ssh -t $USER2@$PC2 "$CURRENT_DIR/multiorgscripts/p2/startmult_3.sh"

  ssh $USER3@$PC3 chmod a+x "$CURRENT_DIR/multiorgscripts/p3/startmult_3.sh"
  ssh -t $USER3@$PC3 "$CURRENT_DIR/multiorgscripts/p3/startmult_3.sh"
  
  ssh $USER4@$PC4 chmod a+x "$CURRENT_DIR/multiorgscripts/p4/startmult_3.sh"
  ssh -t $USER4@$PC4 "$CURRENT_DIR/multiorgscripts/p4/startmult_3.sh"

  composer network start -c PeerAdmin@org1 -n bond-network -V $VERSION -o endorsementPolicyFile=/tmp/composer/endorsement-policy.json -A admin1 -C $CURRENT_DIR/admin1/admin-pub.pem -A admin2 -C $CURRENT_DIR/admin2/admin-pub.pem  -A admin3 -C $CURRENT_DIR/admin3/admin-pub.pem -A admin4 -C $CURRENT_DIR/admin4/admin-pub.pem

  ####Creating cards!!!
  
  composer card create -p /tmp/composer/org1/org1.json -u admin1 -n bond-network -c $CURRENT_DIR/admin1/admin-pub.pem -k $CURRENT_DIR/admin1/admin-priv.pem
  composer card import -f $CURRENT_DIR/admin1@bond-network.card
  
  ssh $USER2@$PC2 chmod a+x "$CURRENT_DIR/multiorgscripts/p2/startmult_4.sh"
  ssh -t $USER2@$PC2 "$CURRENT_DIR/multiorgscripts/p2/startmult_4.sh"
  
  ssh $USER3@$PC3 chmod a+x "$CURRENT_DIR/multiorgscripts/p3/startmult_4.sh"
  ssh -t $USER3@$PC3 "$CURRENT_DIR/multiorgscripts/p3/startmult_4.sh"
  
  ssh $USER4@$PC4 chmod a+x "$CURRENT_DIR/multiorgscripts/p4/startmult_4.sh"
  ssh -t $USER4@$PC4 "$CURRENT_DIR/multiorgscripts/p4/startmult_4.sh"
}

removeCaches
removeAllUnwanted
generateCrypto
upNetwork
testNetwork
replacePrivateKey
createPeers
removeCaches