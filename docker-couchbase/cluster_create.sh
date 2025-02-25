#!/bin/bash

set -e

USERNAME="admin"
PASSWORD="admin123"
NODE1_HOST="couchbase.node1"
NODE2_HOST="couchbase.node2"
BUCKET_NAME="default"
BUCKET_RAM=256
CLUSTER_RAM=512
INDEX_RAM=256

# 1.İlk node'da cluster başlatma
docker exec $(docker ps --filter "name=couchbase-node1" --format "{{.Names}}") \
  couchbase-cli node-init -c $NODE1_HOST:8091 \
  --node-init-hostname=$NODE1_HOST \
  --username=$USERNAME --password=$PASSWORD

docker exec $(docker ps --filter "name=couchbase-node1" --format "{{.Names}}") \
  couchbase-cli cluster-init -c $NODE1_HOST:8091 \
  --cluster-username=$USERNAME --cluster-password=$PASSWORD \
  --services=data,index,query,eventing,analytics \
  --cluster-ramsize=$CLUSTER_RAM --cluster-index-ramsize=$INDEX_RAM

# 2️.Bucket oluşturma
docker exec $(docker ps --filter "name=couchbase-node1" --format "{{.Names}}") \
  couchbase-cli bucket-create -c $NODE1_HOST:8091 \
  --username=$USERNAME --password=$PASSWORD \
  --bucket=$BUCKET_NAME --bucket-type=couchbase --bucket-ramsize=$BUCKET_RAM --wait

# 3️.İkinci node'u cluster'a ekle 
docker exec $(docker ps --filter "name=couchbase-node1" --format "{{.Names}}") \
  couchbase-cli server-add -c $NODE1_HOST:8091 \
  --username=$USERNAME --password=$PASSWORD \
  --server-add=$NODE2_HOST \
  --server-add-username=$USERNAME --server-add-password=$PASSWORD \
  --services=data,index,query,eventing,analytics

# 4.Rebalance yapma
docker exec $(docker ps --filter "name=couchbase-node1" --format "{{.Names}}") \
  couchbase-cli rebalance -c $NODE1_HOST:8091 --username=$USERNAME --password=$PASSWORD
