# Payment API with AWS Lambda and API Gateway

This repository contains Terraform code to set up a payment processing API using AWS Lambda and API Gateway. The API allows for creating, retrieving, and deleting payments, providing a serverless solution for handling payment operations.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Deployment](#deployment)
- [IAM Roles and Permissions](#iam-roles-and-permissions)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **AWS Account**: You need an AWS account to deploy the infrastructure.
- **Terraform**: Ensure that Terraform is installed on your machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html).
- **AWS CLI**: Configure AWS CLI with your credentials using `aws configure`.

## Usage

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

2. Update the `variables.tf` file to customize your deployment. Set variables like:
   - `lambda_execution_role`: IAM role for Lambda execution
   - `create_payment`: Lambda function name for creating payments
   - `payment_api`: API Gateway name

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the changes to create the resources:
   ```bash
   terraform apply
   ```

6. Confirm the action when prompted.

## API Endpoints

The following API endpoints are created:

- **POST /payments**: Create a new payment
- **GET /payments/{paymentId}**: Retrieve a payment by ID
- **DELETE /payments/{paymentId}**: Delete a payment by ID

### Request Example for Creating a Payment

```bash
curl -X POST https://your-api-id.execute-api.region.amazonaws.com/stage_name/payments \
-H "Content-Type: application/json" \
-H "x-api-key: your_api_key" \
-d '{\
    "amount": 100.00,\
    "currency": "USD"\
}'
```

### Response Example

```json
{
  "paymentId": "abc123",
  "status": "Created"
}
```

## Deployment

This setup uses Terraform to provision AWS resources. The following AWS services are utilized:

- **AWS Lambda**: Serverless compute service to run backend functions.
- **API Gateway**: To expose HTTP endpoints for the Lambda functions.
- **IAM Roles**: To manage permissions for Lambda execution and API Gateway invocation.

## IAM Roles and Permissions

- An IAM role is created for Lambda execution, allowing it to write logs to CloudWatch.
- API Gateway is given permission to invoke the Lambda functions.

## Contributing

Contributions are welcome! If you have suggestions or improvements, please create an issue or submit a pull request.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
