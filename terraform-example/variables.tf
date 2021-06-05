variable "lambda_function_role_name" {
  description = "The name of the role to be attached the Lambda function"
  type        = string
  default     = "aws-iam-role-trust-policy-function-role"
}


variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "aws-iam-role-trust-policy-function"
}

variable "lambda_function_code_s3_bucket" {
  description = "The name of the S3 bucket where you stored the Lambda function"
  type        = string
}

variable "lambda_function_code_s3_key" {
  description = "The S3 key for your Lambda function"
  type        = string
  default     = "lambda-deployment-package.zip"
}

variable "event_rule_name" {
  description = "The name of the Eventbridge rule"
  type        = string
  default     = "aws-iam-role-trust-policy-event-rule"
}
