#!/bin/bash
CONTAINER_NAME=$(docker ps | grep name_org2cli | awk '{print $1}')
docker exec -i -t $CONTAINER_NAME chmod a+x "./scripts/script.sh"
docker exec -i -t $CONTAINER_NAME bash -c "./scripts/script.sh"
