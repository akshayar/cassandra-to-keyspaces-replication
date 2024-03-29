#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

resource "aws_security_group" "cluster" {
  name   = "apache-pulsar-cluster"
  vpc_id = var.pulsar_vpc_id

  ## Self referencing for all ports
  ingress {
   from_port = 0
   to_port = 0
   protocol = -1
   self = true
  }
  # All ports open within the VPC
    ingress {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [var.base_cidr_block]
  }
  # outbound internet access
  egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "Pulsar-Security-Group"
  }
}

resource "aws_iam_role" "role" {
  name = "pulsar-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "random_string" "id_name" {
  length = 4
}
resource "aws_iam_instance_profile" "instance_profile" {
  name = "pulsar-instance-profile-${random_string.id_name.result}"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "managed_instance" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "secrets_manager_access" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}