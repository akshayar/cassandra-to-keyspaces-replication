#!/bin/bash
TF_STATE=./ TF_KEY_NAME=private_ip ansible-playbook   --user='ec2-user'   \
--inventory=~/environment/terraform-inventory  ../pulsar-cluster-deploy.yaml
