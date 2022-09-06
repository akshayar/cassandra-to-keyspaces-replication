. ${SOURCE_CODE_ROOT}/setup-environment.sh

export CASSANDRA_SEED_SERVER_1=`echo ${CASSANDRA_SEED_SERVERS} | cut -f1 -d","`

mkdir -p ~/environment/cassandra-bulk
cd ~/environment/cassandra-bulk

envsubst < ${SOURCE_CODE_ROOT}/cassandra-templates/cassandra-bulk-load-template.conf > cassandra-bulk-load.conf

dsbulk unload -k ${SOURCE_KEYSPACE} -t ${SOURCE_TABLE_NAME} -f ./cassandra-bulk-load.conf > keyspaces_sample_table.csv

tail -n +2 keyspaces_sample_table.csv | shuf -o keyspace.table.csv && (head -1 keyspaces_sample_table.csv && cat keyspace.table.csv ) > keyspace.table.csv1 && mv keyspace.table.csv1 keyspace.table.csv

awk -F, 'BEGIN {samp=10000;max=-1;}{if(NR>1){len=length($0);t+=len;avg=t/NR;max=(len>max ? len : max)}}NR==samp{exit}END{printf("{lines: %d, average: %d bytes, max: %d bytes}\n",NR,avg,max);}' keyspace.table.csv
