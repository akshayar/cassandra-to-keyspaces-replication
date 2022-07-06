## Data Validation Process
1. To do the data validation , the script will compare data from source and target table for a list of ids which are provided in a file. 
2. The data insert script creates a file with name id.txt which will be used to do this comparison. 
3. On the cloud9 follow these steps to compare data. 
```shell
cd ~/environment/cassandra-to-keyspaces-replication/cassandra-java-samples
```
4. Copy the Keyspace configuration file and keystore from bulk load directory
```shell
cp ~/environment/cassandra-bulk/keyspaces-connector.conf .
cp ~/environment/cassandra-bulk/cassandra_truststore.jks .
```
5. Compare records for created id.txt file which is generated from the insert script. 
```shell
. ../setup-environment.sh
./comare-records.sh -sconf cassandra-source.conf -skey ${SOURCE_KEYSPACE} -stab ${SOURCE_TABLE_NAME} \
-tconf keyspaces-connector.conf -tkey ${TARGET_KEYSPACE} -ttab ${TARGET_TABLE} \
-idfile id.txt
```
6. Refer to the results in compare-result.log file. 