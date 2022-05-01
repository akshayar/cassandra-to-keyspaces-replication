export BUILD_BUCKET=akshaya-lambda-codes/pulsar-sink
export CASSANDRA_URL=10.0.131.64:9042 ##cassandra.us-east-1.amazonaws.com:9142
export NAR_FILE_NAME=pulsar-io-cassandra-sink-1.0.0-SNAPSHOT.nar
export PULSAR_HOME=$HOME/apache-pulsar-2.9.1
export PULSAR_DATA_TOPIC_NAME="persistent://public/default/data-pocdb1.customers"
export CASSANDRA_KEY_SAPCE="target"
export CASSANDRA_TABLE="customers"
export CASSANDRA_DC_NAME="OSS-dc0"
export REGION="us-east-1"
export TRUSTSTORE_FILE_PATH=$HOME/keyspace/truststore/cassandra_truststore.jks
export TRUSTSTORE_PASSWORD=<truststore password>
export SINK_CONNECTOR_NAME=pulsar-cassandra-sink-${CASSANDRA_KEY_SAPCE}-${CASSANDRA_TABLE}
export CONNECTOR_HOME=${HOME}/pulsar-io-cassandra-sink-connector
export SINK_CONFIG_FILE_PATH=${CONNECTOR_HOME}/config/sink-config.yaml
export KEYSPACE_LOADER_CONFIG=${CONNECTOR_HOME}/config/application-keyspace-iamuser.conf
