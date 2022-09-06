#!/bin/bash
ansible-playbook   --user='ubuntu'   --inventory=cassandra.ini \
--extra-vars="@../parameters/cassandra-config.json" \
--extra-vars='{"ansible_ssh_private_key_file":"'${CASSANDRA_KEY_FILE}'", "cassandra_config_file_path":"'${CASSANDRA_CONFIG_FILE_PATH}'"}' \
 ../cassandra-cluster-enable-cdc.yaml
