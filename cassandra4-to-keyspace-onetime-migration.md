## One time migration from Cassandra to Keyspaces
1. Refer [Cassandra to Amazon Keyspace Offline migration](https://docs.aws.amazon.com/keyspaces/latest/devguide/migrating.html).
2. For this demo we will be using [Using Bulkload](https://docs.aws.amazon.com/keyspaces/latest/devguide/dsbulk-upload.html).

3. Prepare Keyspaces database. From Cloud9 workspace run following commands. 
   1. Create target keyspace and table.
    ```shell
      aws keyspaces create-keyspace --keyspace-name <keyspace-name>
    ```
   2. Create tables in the keyspace from [keyspaces-schema.cql](./cassandra-templates/keyspaces-schema.cql)
   3. Generate service specific credentials. Refer [Keyspaces Credential Generation](https://docs.aws.amazon.com/keyspaces/latest/devguide/programmatic.credentials.ssc.html) .
    ```shell
    USER_NAME=keyspace-user
    aws iam create-user --user-name ${USER_NAME}
    
    aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonKeyspacesFullAccess --user-name ${USER_NAME}
   
    SECRET_STRING=`aws iam create-service-specific-credential \
    --user-name ${USER_NAME} \
    --service-name cassandra.amazonaws.com --query ServiceSpecificCredential`
    export SERVICE_USER_NAME=`echo $SECRET_STRING | jq -r  .ServiceUserName`
    export SERVICE_USER_PASSWORD=`echo $SECRET_STRING | jq -r  .ServicePassword`
   
    mkdir -p ~/environment/cassandra-bulk
       
    envsubst < ${SOURCE_CODE_ROOT}/cassandra-templates/keyspaces-connector.conf > ~/environment/cassandra-bulk/keyspaces-connector.conf 
    ```
   4. Create secret in AWS Secret Manager.
    ```shell
     aws secretsmanager create-secret \
        --name keyspace-secret1 --region ${REGION} \
        --description "Keyspace Secret for Keyspace Sink Connector." \
        --secret-string "{\"ServiceUserName\":\"$SERVICE_USER_NAME\",\"ServicePassword\":\"${SERVICE_USER_PASSWORD}\"}"
    ```
   4. Update IAM permissions of the use created above to write to Amazon Keyspaces table. You can add arn:aws:iam::aws:policy/AmazonKeyspacesFullAccess policy for the POC or a customized on for narrower permission.   

4. From Cloud9 execute following commands to install dsbulk. 
```
curl -OL https://downloads.datastax.com/dsbulk/dsbulk-1.8.0.tar.gz
tar -zxvf dsbulk-1.8.0.tar.gz
export PATH=$PATH:./dsbulk-1.8.0/bin
```
5. Execute following command to create CSV file for the table you are migrating.
   ```
   . ${SOURCE_CODE_ROOT}/setup-environment.sh
   CASSANDRA_SEED_SERVER_1=`echo ${CASSANDRA_SEED_SERVERS} | cut -f1 -d","`
   ```
   ```
   mkdir -p ~/environment/cassandra-bulk
   cd ~/environment/cassandra-bulk
   envsubst < ${SOURCE_CODE_ROOT}/cassandra-templates/cassandra-bulk-load-template.conf > cassandra-bulk-load.conf 
   dsbulk unload -k ${SOURCE_KEYSPACE} -t ${SOURCE_TABLE_NAME} -f ./cassandra-bulk-load.conf > keyspaces_sample_table.csv
   ```
5. Follow steps in [Data Preparation](https://docs.aws.amazon.com/keyspaces/latest/devguide/dsbulk-upload-prepare-data.html) to prepare and analyze the data. 
   ```
   tail -n +2 keyspaces_sample_table.csv | shuf -o keyspace.table.csv && (head -1 keyspaces_sample_table.csv && cat keyspace.table.csv ) > keyspace.table.csv1 && mv keyspace.table.csv1 keyspace.table.csv
   ```
   ```
   awk -F, 'BEGIN {samp=10000;max=-1;}{if(NR>1){len=length($0);t+=len;avg=t/NR;max=(len>max ? len : max)}}NR==samp{exit}END{printf("{lines: %d, average: %d bytes, max: %d bytes}\n",NR,avg,max);}' keyspace.table.csv
   ```
6. Set throughput for Keyspaces table. Refer [Setting Keyspaces throughput](https://docs.aws.amazon.com/keyspaces/latest/devguide/dsbulk-upload-capacity.html)
7. Execute following commands to load data to Keyspaces.
```
cp ${AWS_DEPLOYMENT_HOME}/../keystore/cassandra_truststore.jks .
dsbulk load -f ./keyspaces-connector.conf  --connector.csv.url keyspace.table.csv -header true --batch.mode DISABLED --executor.maxPerSecond 5 --driver.basic.request.timeout "5 minutes" --driver.advanced.retry-policy.max-retries 10 -k ${TARGET_KEYSPACE} -t ${TARGET_TABLE}
```


