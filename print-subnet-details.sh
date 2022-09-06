#!/bin/bash
INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
echo ${INSTANCE_ID}

SECURITY_GROUP_ID=`aws ec2 describe-instance-attribute --instance-id $INSTANCE_ID --attribute groupSet --query Groups[0].GroupId --output text`
VPC_ID=`aws ec2 describe-instances   --instance-ids ${INSTANCE_ID} --query Reservations[0].Instances[0].VpcId --output text`

aws ec2 describe-instances   --instance-ids ${INSTANCE_ID} --query Reservations[0].Instances[0].[PublicDnsName,PublicIpAddress,PrivateDnsName,PrivateIpAddress,SubnetId,VpcId] --output text

aws ec2 describe-vpcs  --vpc-ids ${VPC_ID} --query Vpcs[0].CidrBlock --output text

aws ec2 describe-subnets --filters "Name=vpc-id,Values=${VPC_ID}" --query Subnets[].[VpcId,AvailabilityZone,CidrBlock,SubnetId,AvailableIpAddressCount,Tags[].Value] --output text
