output "payment_api_url" {
  description = "The URL of the payment API"
  value       = "${aws_api_gateway_deployment.payment_api_deployment.invoke_url}/${var.stage_name}/payments"
}

output "create_payment_lambda_arn" {
  description = "ARN of the Create Payment Lambda Function"
  value       = aws_lambda_function.create_payment.arn
}

output "get_payment_lambda_arn" {
  description = "ARN of the Get Payment Lambda Function"
  value       = aws_lambda_function.get_payment.arn
}

output "delete_payment_lambda_arn" {
  description = "ARN of the Delete Payment Lambda Function"
  value       = aws_lambda_function.delete_payment.arn
}

output "lambda_execution_role_arn" {
  description = "ARN of the IAM Role for Lambda Execution"
  value       = aws_iam_role.lambda_execution_role.arn
}

# API endpoint and key for integration details
output "api_endpoint" {
  value = "${aws_api_gateway_rest_api.payment_api.execution_arn}/${aws_api_gateway_deployment.payment_api_deployment.stage_name}"
}

output "api_key" {
  description = "The API Key for accessing the Payment API"
  value     = aws_api_gateway_api_key.payment_api_key.value
  sensitive = true
}
