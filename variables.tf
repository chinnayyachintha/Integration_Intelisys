# Specifying the AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

# Name of the Execution role for Lambda
variable "lambda_execution_role" {
  description = "The name of the execution role for Lambda functions"
  type        = string
}

# Name of the IAM Policy
variable "execution_policy" {
  description = "The name of the IAM policy for Lambda execution"
  type        = string
}

# Lambda Function for Create Payment
variable "create_payment" {
  description = "The name of the Lambda function for creating payments"
  type        = string
}

# Lambda Function for Get Payment
variable "get_payment" {
  description = "The name of the Lambda function for retrieving payments"
  type        = string
}

# Lambda Function for Delete Payment
variable "delete_payment" {
  description = "The name of the Lambda function for deleting payments"
  type        = string
}

# API Gateway REST API
variable "payment_api" {
  description = "The name of the API Gateway REST API for payment operations"
  type        = string
}

# Name of the API Gateway Stage
variable "stage_name" {
  description = "The name of the API Gateway deployment stage"
  type        = string
}

# Name of the tags
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
}
