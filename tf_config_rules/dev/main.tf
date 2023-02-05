# AWS Config Rule

resource "aws_config_config_rule" "ak3_config_rule" {
  name             = "required-tags"
  description      = "Checks whether your resources have the tags that you specify."
  input_parameters = "{\"tag1Key\":\"OwnerID\",\"tag4Key\":\"Environment\",\"tag5Key\":\"Team\",\"tag3Key\":\"Project\",\"tag2Key\":\"OwnerContact\",\"tag6Key\":\"ManagedBy\"}"
  scope {
    compliance_resource_types = [
      "AWS::S3::Bucket",
      "AWS::EC2::VPC",
      "AWS::EC2::Instance",
      "AWS::EC2::EIP",
      "AWS::EC2::Volume"
    ]
  }
  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "required_tags-dev-ue1-cnfg-001"
    }
  )

  depends_on = [aws_config_configuration_recorder.ak3_config_recorder]
}

resource "aws_config_config_rule" "ak3_config_rule_2" {
  name             = "vpc-sg-open-only-to-authorized-ports"
  description      = "Checks whether any security groups with inbound 0.0.0.0/0 have TCP or UDP ports accessible. The rule is NON_COMPLIANT when a security group with inbound 0.0.0.0/0 has a port accessible which is not specified in the rule parameters."
  
  source {
    owner             = "AWS"
    source_identifier = "VPC_SG_OPEN_ONLY_TO_AUTHORIZED_PORTS"
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "sg_ports-dev-ue1-cnfg-001"
    }
  )

  depends_on = [aws_config_configuration_recorder.ak3_config_recorder]
}

resource "aws_config_config_rule" "ak3_config_rule_3" {
  name             = "s3-bucket-level-public-access-prohibited"
  description      = "Checks if Amazon Simple Storage Service (Amazon S3) buckets are publicly accessible. This rule is NON_COMPLIANT if an Amazon S3 bucket is not listed in the excludedPublicBuckets parameter and bucket level settings are public."
  
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED"
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "s3_public_access-dev-ue1-cnfg-001"
    }
  )

  depends_on = [aws_config_configuration_recorder.ak3_config_recorder]
}

# AWS Config Recorder

resource "aws_config_configuration_recorder" "ak3_config_recorder" {
  name     = "config_recorder-dev-ue1-cnfg-001"
  role_arn = aws_iam_role.ak3_config_role.arn
  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types = [
      "AWS::S3::Bucket",
      "AWS::EC2::VPC",
      "AWS::EC2::Instance",
      "AWS::EC2::EIP",
      "AWS::EC2::Volume"
    ]
  }
}

# AWS Config configuration recorder status

resource "aws_config_configuration_recorder_status" "ak3_config_recorder_status" {
  name       = aws_config_configuration_recorder.ak3_config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.ak3_delivery_channel]
}

# AWS Config IAM Role

resource "aws_iam_role" "ak3_config_role" {
  name               = "config_role-dev-ue1-rl-001"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY

  tags = merge(
    local.common_tags,
    {
      "Name" = "config_role-dev-ue1-rl-001"
    }
  )
}

resource "aws_iam_role_policy_attachment" "a" {
  role       = aws_iam_role.ak3_config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy" "ak3_config_iam_policy_1" {
  name = "PolicyforAmazonS3Bucket"
  role = aws_iam_role.ak3_config_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::config-logs-dev-ue1-s3-1/AWSLogs//*"
            ],
            "Condition": {
                "StringLike": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl"
            ],
            "Resource": "arn:aws:s3:::config-logs-dec-ue1-s3-001"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "ak3_config_iam_policy_2" {
  name = "PolicyforAmazonSNSTopic"
  role = aws_iam_role.ak3_config_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sns:Publish",
          "Effect": "Allow",
          "Resource": "arn:aws:sns:us-east-1:824627440363:config-logs-dev-ue1-sns-001"

      }
  ]
}
POLICY
}

# AWS Config Delivery Channel

resource "aws_config_delivery_channel" "ak3_delivery_channel" {
  name           = "config_delivery_channel-dev-ue1-cnfg-001"
  s3_bucket_name = aws_s3_bucket.ak3_bucket.bucket
  sns_topic_arn  = aws_sns_topic.ak3_sns_topic.arn
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
  depends_on = [aws_config_configuration_recorder.ak3_config_recorder]
}

resource "aws_s3_bucket" "ak3_bucket" {
  bucket        = "config-logs-dev-ue1-s3-001"
  force_destroy = true

  tags = merge(
    local.common_tags,
    {
      "Name" = "config-logs-dev-ue1-s3-001"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "ak3_bucket_access" {
  bucket = aws_s3_bucket.ak3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "ak3_s3_policy" {
  bucket = aws_s3_bucket.ak3_bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSConfigBucketPermissionsCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::config-logs-dev-ue1-s3-001",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceAccount": ""
                }
            }
        },
        {
            "Sid": "AWSConfigBucketExistenceCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::config-logs-dev-ue1-s3-001",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceAccount": ""
                }
            }
        },
        {
            "Sid": "AWSConfigBucketDelivery",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::config-logs-dev-ue1-s3-001/AWSLogs//Config/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceAccount": "",
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_sns_topic" "ak3_sns_topic" {
  name            = "config-logs-dev-ue1-sns-001"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false
  }
}
EOF

  tags = merge(
    local.common_tags,
    {
      "Name" = "config-logs-dev-ue1-sns-001"
    }
  )
}

resource "aws_sns_topic_policy" "ak3_sns_topic" {
  arn    = aws_sns_topic.ak3_sns_topic.arn
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "sns:GetTopicAttributes",
        "sns:SetTopicAttributes",
        "sns:AddPermission",
        "sns:RemovePermission",
        "sns:DeleteTopic",
        "sns:Subscribe",
        "sns:ListSubscriptionsByTopic",
        "sns:Publish"
      ],
      "Resource": "arn:aws:sns:us-east-1::config-logs-dev-ue1-sns-001",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": ""
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "ak3_topic_subscription_1" {
  topic_arn = aws_sns_topic.ak3_sns_topic.arn
  protocol  = "email"
  endpoint  = "example@example.com"
}

# resource "aws_sns_topic_subscription" "ak3_topic_subscription_2" {
#   topic_arn = aws_sns_topic.ak3_sns_topic.arn
#   protocol  = "lambda"
#   endpoint  = aws_lambda_function.ak3_lambda_function.arn
#   depends_on = [aws_lambda_function.ak3_lambda_function]
# }

# Lambda

# data archive_file lambda {
#   type = "zip"
#   output_path = "/tmp/auto_creation_jira_ticket.zip"
#   source {
#     content = file("src/auto_creation_jira_ticket.py")
#     filename = "auto_creation_jira_ticket.py"
#   }
# }

# resource "aws_lambda_function" "ak3_lambda_function" {
#  function_name      = "auto_creation_jira_ticket"
#  filename           = data.archive_file.lambda.output_path #"${path.module}/src/auto_creation_jira_ticket.py"
#  description        = "This function will automatiocally create Jira tickets from AWS Config rule"
#  handler            = "auto_creation_jira_ticket.handler"
#  runtime            = "python3.9"
#  role               = aws_iam_role.ak3_lambda_role.arn
#  source_code_hash   = filebase64sha256(data.archive_file.lambda.output_path)

#  tags = merge(
#    local.common_tags,
#    {
#      "Name" = "lambda_function-shs-ue1-lmd-001"
#    }
#  )
# }

# Lambda IAM Role

# resource "aws_iam_role" "ak3_lambda_role" {
#   name = "lambda_role-shs-ue1-rl-001"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = merge(
#     local.common_tags,
#     {
#       "Name" = "lambda_role-shs-ue1-rl-001"
#     }
#   )
# }