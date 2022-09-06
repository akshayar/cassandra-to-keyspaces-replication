#!/bin/bash
TF_STATE=./ TF_KEY_NAME=private_ip  ansible-playbook   --user='ec2-user' \
--inventory=~/environment/terraform-inventory --extra-vars="@../parameters/cassandra-config.json"  \
../cassandra-source-connector-deploy.yaml

TF_STATE=./ TF_KEY_NAME=private_ip  ansible-playbook   --user='ec2-user' \
--inventory=~/environment/terraform-inventory --extra-vars="@../parameters/cassandra-config.json"  \
../cassandra-source-connector-create.yaml
