# Specifying region
aws_region = "ca-central-1"

#Name of the Execution role for Lambda
lambda_execution_role = "lambda_execution_role"

#Name of IAM Policy
execution_policy = "lambda_execution_policy"

# Lambda Function for Create Payment
create_payment = "CreatePaymentFunction"

# Lambda Function for Get Payment
get_payment = "GetPaymentFunction"

# Lambda Function for Delete Payment
delete_payment = "DeletePaymentFunction"

# API Gateway REST API
payment_api = "PaymentAPI"

# Name of Stage Name
stage_name = "prod"

# Tag values for AWS resources
tags = {
  Environment = "Development"
  Project     = "Payment Gateway"
  Owner       = "Anudeep"
}
