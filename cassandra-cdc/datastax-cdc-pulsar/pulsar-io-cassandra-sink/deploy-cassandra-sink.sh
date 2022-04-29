#!/bin/bash
./deploy-setup.sh
SINK_CONNECTOR_NAME=pulsar-cassandra-sink-${CASSANDRA_KEY_SAPCE}-${CASSANDRA_TABLE}
CONNECTOR_HOME=${HOME}/pulsar-io-cassandra-sink-connector

echo Creating ${SINK_CONNECTOR_NAME} $CASSANDRA_URL ${CONNECTOR_HOME}
echo "Copying s3://${BUILD_BUCKET}/${NAR_FILE_NAME}"
mkdir -p ${CONNECTOR_HOME}
cd ${CONNECTOR_HOME} ; rm -rf *.nar; aws s3 cp  s3://${BUILD_BUCKET}/${NAR_FILE_NAME} . ;
CASSANDRA_SINK_NAR_PATH=`pwd`/${NAR_FILE_NAME}


echo "Delecting connector ${SINK_CONNECTOR_NAME}"
cd ${PULSAR_HOME}
pwd
bin/pulsar-admin sink delete --name ${SINK_CONNECTOR_NAME}

echo "Creating connector ${SINK_CONNECTOR_NAME}"
cd ${PULSAR_HOME}
pwd
bin/pulsar-admin sink create \
--archive ${CASSANDRA_SINK_NAR_PATH} \
--tenant public \
--namespace default \
--name ${SINK_CONNECTOR_NAME} \
--inputs ${PULSAR_DATA_TOPIC_NAME} \
--subs-position Earliest \
--sink-config "{
\"roots\":\"${CASSANDRA_URL}\",
\"keyspace\":\"${CASSANDRA_KEY_SAPCE}\",
\"tableName\":\"${CASSANDRA_TABLE}\",
\"dcName\":\"${CASSANDRA_DC_NAME}\",
\"nullValueAction\":\"DELETE\"
}"
echo "Checking Status ${SINK_CONNECTOR_NAME}"
bin/pulsar-admin sink status --name ${SINK_CONNECTOR_NAME}

echo "Checkikng logs ${SINK_CONNECTOR_NAME}"
cd logs/functions/public/default/${SINK_CONNECTOR_NAME}/
tail -f  ${SINK_CONNECTOR_NAME}-0.log