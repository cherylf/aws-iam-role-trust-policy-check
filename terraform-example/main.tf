terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_function_role" {
  name = var.lambda_function_role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "IamRoleTrustPolicyCheckPermissions"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iam:List*", "iam:Get*", "iam:PutRolePermissionsBoundary"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["s3:GetObject"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}


resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_function_role.arn
  s3_bucket     = var.lambda_function_code_s3_bucket
  s3_key        = var.lambda_function_code_s3_key
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.7"
  timeout       = 60
}


resource "aws_lambda_permission" "allow_event_rule" {
  statement_id  = "AllowExecutionFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}


resource "aws_cloudwatch_event_rule" "event_rule" {
  name = var.event_rule_name

  event_pattern = <<EOF
{
  "source": [ "aws.iam" ],
  "detail-type": [ "AWS API Call via CloudTrail" ],
  "detail": {
    "eventSource": [ "iam.amazonaws.com" ],
    "eventName": ["CreateRole", "UpdateAssumeRolePolicy", "DeleteRolePermissionsBoundary"]
  }
}
EOF
}


resource "aws_cloudwatch_event_target" "event_rule_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.lambda_function.arn
}