# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = var.lambda_execution_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.lambda_execution_role}"
    },
    var.tags
  )
}

# Attach a policy to the IAM role for Lambda execution
resource "aws_iam_policy_attachment" "lambda_execution_policy" {
  name       = var.execution_policy
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function for Create Payment
resource "aws_lambda_function" "create_payment" {
  function_name = var.create_payment
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.createPayment"
  runtime       = "nodejs18.x"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  tags = merge(
    {
      Name = "${var.create_payment}"
    },
    var.tags
  )
}

# Lambda Function for Get Payment
resource "aws_lambda_function" "get_payment" {
  function_name = var.get_payment
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.getPayment"
  runtime       = "nodejs18.x"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  tags = merge(
    {
      Name = "${var.get_payment}"
    },
    var.tags
  )
}

# Lambda Function for Delete Payment
resource "aws_lambda_function" "delete_payment" {
  function_name = var.delete_payment
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.deletePayment"
  runtime       = "nodejs18.x"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  tags = merge(
    {
      Name = "${var.delete_payment}"
    },
    var.tags
  )
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "payment_api" {
  name        = var.payment_api
  description = "API Gateway for handling Payroc-style payment operations"

  tags = merge(
    {
      Name = "${var.payment_api}"
    },
    var.tags
  )
}

# Create /payments Resource
resource "aws_api_gateway_resource" "payments_resource" {
  rest_api_id = aws_api_gateway_rest_api.payment_api.id
  parent_id   = aws_api_gateway_rest_api.payment_api.root_resource_id
  path_part   = "payments"
}

# Create API Gateway Model for Create Payment
resource "aws_api_gateway_model" "create_payment_model" {
  rest_api_id  = aws_api_gateway_rest_api.payment_api.id
  name         = "CreatePaymentModel"
  content_type = "application/json"

  schema = jsonencode({
    type       = "object"
    properties = {
      amount   = { type = "number" }
      currency = { type = "string" }
      // Add other properties as required
    }
  })
}

# Create Method for POST /payments
resource "aws_api_gateway_method" "create_payment_method" {
  rest_api_id   = aws_api_gateway_rest_api.payment_api.id
  resource_id   = aws_api_gateway_resource.payments_resource.id
  http_method   = "POST"
  authorization = "NONE" # Change to "AWS_IAM" for IAM-based authorization

  request_models = {
    "application/json" = aws_api_gateway_model.create_payment_model.name
  }
}

# Integration for POST /payments with Lambda
resource "aws_api_gateway_integration" "create_payment_integration" {
  rest_api_id             = aws_api_gateway_rest_api.payment_api.id
  resource_id             = aws_api_gateway_resource.payments_resource.id
  http_method             = aws_api_gateway_method.create_payment_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_payment.invoke_arn
}

# Create API Key for Authentication
resource "aws_api_gateway_api_key" "payment_api_key" {
  name        = "${var.payment_api}-key"
  description = "API Key for accessing the Payment API"
  enabled     = true

  tags = merge(
    {
      Name = "payment-api-key"
    },
    var.tags
  )
}

# Usage Plan for API Key
resource "aws_api_gateway_usage_plan" "payment_api_usage_plan" {
  name = "${var.payment_api}-usage-plan"

  tags = merge(
    {
      Name = "payment-api-usage-plan"
    },
    var.tags
  )
}

# Associate API Key with Usage Plan
resource "aws_api_gateway_usage_plan_key" "payment_api_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.payment_api_key.id
  usage_plan_id = aws_api_gateway_usage_plan.payment_api_usage_plan.id
  key_type      = "API_KEY"
}

# Create /payments/{paymentId} Resource
resource "aws_api_gateway_resource" "payment_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.payment_api.id
  parent_id   = aws_api_gateway_resource.payments_resource.id
  path_part   = "{paymentId}"
}

# Create Method for GET /payments/{paymentId}
resource "aws_api_gateway_method" "get_payment_method" {
  rest_api_id   = aws_api_gateway_rest_api.payment_api.id
  resource_id   = aws_api_gateway_resource.payment_id_resource.id
  http_method   = "GET"
  authorization = "NONE" # Change to "AWS_IAM" for IAM-based authorization
}

# Integration for GET /payments/{paymentId} with Lambda
resource "aws_api_gateway_integration" "get_payment_integration" {
  rest_api_id             = aws_api_gateway_rest_api.payment_api.id
  resource_id             = aws_api_gateway_resource.payment_id_resource.id
  http_method             = aws_api_gateway_method.get_payment_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_payment.invoke_arn
}

# Create Method for DELETE /payments/{paymentId}
resource "aws_api_gateway_method" "delete_payment_method" {
  rest_api_id   = aws_api_gateway_rest_api.payment_api.id
  resource_id   = aws_api_gateway_resource.payment_id_resource.id
  http_method   = "DELETE"
  authorization = "NONE" # Change to "AWS_IAM" for IAM-based authorization
}

# Integration for DELETE /payments/{paymentId} with Lambda
resource "aws_api_gateway_integration" "delete_payment_integration" {
  rest_api_id             = aws_api_gateway_rest_api.payment_api.id
  resource_id             = aws_api_gateway_resource.payment_id_resource.id
  http_method             = aws_api_gateway_method.delete_payment_method.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.delete_payment.invoke_arn
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "payment_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.payment_api.id
  stage_name  = var.stage_name

  depends_on = [
    aws_api_gateway_integration.create_payment_integration,
    aws_api_gateway_integration.get_payment_integration,
    aws_api_gateway_integration.delete_payment_integration
  ]
}

# Lambda Permission for API Gateway to Invoke
resource "aws_lambda_permission" "allow_create_payment_invoke" {
  statement_id  = "AllowAPIGatewayInvokeCreatePayment"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_payment.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.payment_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_get_payment_invoke" {
  statement_id  = "AllowAPIGatewayInvokeGetPayment"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_payment.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.payment_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_delete_payment_invoke" {
  statement_id  = "AllowAPIGatewayInvokeDeletePayment"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_payment.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.payment_api.execution_arn}/*/*"
}
