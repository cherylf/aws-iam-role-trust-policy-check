output "lambda_function_role_arn" {
  value       = aws_iam_role.lambda_function_role.arn
  description = "The ARN of the IAM role attached to the Lambda function"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "The ARN of the Lambda function"
}

output "event_rule_arn" {
  value       = aws_cloudwatch_event_rule.event_rule.arn
  description = "The ARN of the Eventbridge rule"
}