# Deploy Pulsar sink connector for Keyspaces database
1. Deploy Pulsar sink connector for Keyspaces database. The connector will start pushing changes captured on data-<keyspace-name>.<table-name> topic to Keyspaces database.
3. Build ţhe package and copy nar file to ${AWS_DEPLOYMENT_HOME}/binaries.
   
```shell
cd ${SOURCE_CODE_ROOT}/cassandra-cdc/datastax-cdc-pulsar/pulsar-io-cassandra-sink
./build.sh 
mkdir -p ${AWS_DEPLOYMENT_HOME}/../binaries
cp target/pulsar-io-cassandra-sink-*.nar ${AWS_DEPLOYMENT_HOME}/../binaries
```

4. Deploy Keyspace Sink Connector. 
   1. Create truststore. 
   ```shell
    cd ${AWS_DEPLOYMENT_HOME}
    mkdir ../keystore ; cd ../keystore
    chmod +x ../templates/cdc-connector/*.sh
    ../templates/cdc-connector/keyspaces-sink-setup-truststore.sh 
   
   ```
   2. Update parameters files terraform-ansible/parameters/cassandra-config.json. 
   3. Run following commands to deploy Keyspace Sink Connector.
   ```shell
    cd ${AWS_DEPLOYMENT_HOME}
    TF_STATE=./ TF_KEY_NAME=private_ip  ansible-playbook   --user='ec2-user' --inventory=~/environment/terraform-inventory --extra-vars="@../parameters/cassandra-config.json"  ../keyspace-sink-connector-deploy.yaml
   ```
   4. Run following command to start  Keyspace Sink Connector.
   ```shell
    cd ${AWS_DEPLOYMENT_HOME}
    TF_STATE=./ TF_KEY_NAME=private_ip  ansible-playbook   --user='ec2-user' --inventory=~/environment/terraform-inventory --extra-vars="@../parameters/cassandra-config.json"  ../keyspace-sink-connector-create.yaml
   ```
   5. Run following command to check status of Keyspace Sink Connector. 
   ```shell
    cd ${AWS_DEPLOYMENT_HOME}
    TF_STATE=./ TF_KEY_NAME=private_ip  ansible-playbook   --user='ec2-user' --inventory=~/environment/terraform-inventory --extra-vars="@../parameters/cassandra-config.json"  ../keyspace-sink-connector-check-status.yaml
   ```
   
5. Check 
