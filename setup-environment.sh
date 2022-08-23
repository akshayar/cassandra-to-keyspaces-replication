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
SUBSTITUTE_ENV_IN_CONFIG=$1
if [ -z "$SUBSTITUTE_ENV_IN_CONFIG" ]
then
  echo "No environment substitution"
else
  echo "Doing environment substitution in ${AWS_DEPLOYMENT_HOME}/../parameters/cassandra-config.json"
  envsubst < ${AWS_DEPLOYMENT_HOME}/../parameters/cassandra-config-template.json > ${AWS_DEPLOYMENT_HOME}/../parameters/cassandra-config.json
  envsubst < ${AWS_DEPLOYMENT_HOME}/../cassandra-templates/schema.cql > ${AWS_DEPLOYMENT_HOME}/../cassandra-templates/schema_sub.cql
  cp ${AWS_DEPLOYMENT_HOME}/../cassandra-templates/schema_sub.cql ${AWS_DEPLOYMENT_HOME}/../cassandra-templates/schema.cql

fi
