#!/bin/bash
export REGION="us-east-1"
export CASSANDRA_USER_ID="cassandra"
export CASSANDRA_PASSWORD="cassandra"
export SOURCE_KEYSPACE="pocdb1"
export SOURCE_TABLE_NAME="customers"
export TARGET_KEYSPACE="targetkeyspace"
export TARGET_TABLE="customers"
export CASSANDRA_CONFIG_FILE_PATH="/usr/share/oss/conf/cassandra.yaml"
export PULSAR_HOME="/opt/pulsar"
export KEYSPACES_TRUSTSTORE_PASSWORD="password"
export KEYSPACES_SINK_TOPIC_READ_FROM="Earliest"
#A secret with this name will be created in REGION with Keyspace user and password
export KEYSPACES_SECRET_NAME="keyspace-secret"
# Get private ip addresses of seeed servers. If you are createing
# Cassandra with https://aws-quickstart.github.io/quickstart-datastax-oss/#_launch_the_quick_start
# Refer Seed1PrivateIpAddress and Seed2PrivateIpAddress
export CASSANDRA_SEED_SERVERS=<cassandra-seed-servers comma separated>
# Full path to key file.
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
