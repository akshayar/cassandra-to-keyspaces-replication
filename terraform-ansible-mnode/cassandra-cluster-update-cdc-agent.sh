#!/bin/bash
ansible-playbook   --user='ubuntu'   --inventory=cassandra.ini \
--extra-vars='{"ansible_ssh_private_key_file":"'${CASSANDRA_KEY_FILE}'","pulsar_service_url":"'${PULSAR_SERVICE_VALUE}'"}'  \
../cassandra-cluster-update-cdc-agent.yaml
