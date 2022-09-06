cp ${AWS_DEPLOYMENT_HOME}/../keystore/cassandra_truststore.jks .

dsbulk load -f ./keyspaces-connector.conf  \
--connector.csv.url keyspace.table.csv \
-header true --batch.mode DISABLED --executor.maxPerSecond 5 \
--driver.basic.request.timeout "5 minutes" \
--driver.advanced.retry-policy.max-retries 10 \
-k ${TARGET_KEYSPACE} -t ${TARGET_TABLE}

