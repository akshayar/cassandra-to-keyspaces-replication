## Data Validation Process
1. To do the data validation , the script will compare data from source and target table for a list of ids which are provided in a file. 
2. The data insert script creates a file with name id.txt which will be used to do this comparison. 
3. On the cloud9 follow these steps to compare data. 
```shell
cd ~/environment/
cd cassandra-samples/cassandra-java-samples
```
4. Create the Keyspace configuration file
```shell
envsubst < ${SOURCE_CODE_ROOT}/cassandra-templates/keyspaces-connector.conf > keyspaces-connector.conf 
```
5. Compare records for created id.txt file which is generated from the insert script. 
```shell
./comare-records.sh -sconf src/main/resources/source.conf -skey pocdb -stab customers \
-tconf src/main/resources/target.conf -tkey pocdb1 -ttab customers \
-idfile id.txt
```