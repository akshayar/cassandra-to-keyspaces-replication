#!/bin/bash
if [ -z "${SOURCE_CODE_ROOT}" ]
then
  echo "SOURCE_CODE_ROOT is not set, exiting"
  exit 1
fi

if [ -z "${AWS_DEPLOYMENT_HOME}" ]
then
  echo "AWS_DEPLOYMENT_HOME is not set, exiting"
  exit 1
fi

cp -r ${SOURCE_CODE_ROOT}/cassandra-templates ${AWS_DEPLOYMENT_HOME}/..
cp -r ${SOURCE_CODE_ROOT}/parameters ${AWS_DEPLOYMENT_HOME}/..
cp -r ${SOURCE_CODE_ROOT}/cdc-connector ${AWS_DEPLOYMENT_HOME}/../templates
