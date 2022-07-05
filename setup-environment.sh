#!/bin/bash
export REGION="us-east-1"
export SOURCE_KEYSPACE="pocdb1"
export SOURCE_TABLE_NAME="customers"
export TARGET_KEYSPACE="tutorialkeyspace"
export TARGET_TABLE="customers"
export CASSANDRA_CONFIG_FILE_PATH="/usr/share/oss/conf/cassandra.yaml"
export KEYSPACE_SECRET_NAME="keyspace-secret"
export CASSANDRA_SEED_SERVERS=<cassandra-seed-servers comma separated>
export CASSANDRA_KEY_FILE=<path-key-file>
chmod 400 ${CASSANDRA_KEY_FILE}
envsubst < ../parameters/cassandra-config-template.json > ../parameters/cassandra-config.json
