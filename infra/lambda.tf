# Package the Lambda function code with Node.js
data "archive_file" "example" {
  type        = "zip"
  source_file = "${path.module}/../server/index.mjs"
  output_path = "${path.module}/infra/function.zip"
}

# Lambda function
resource "aws_lambda_function" "example" {
  filename         = data.archive_file.example.output_path
  function_name    = "example_lambda_function"
  role             = aws_iam_role.lambda_apigateway_role.arn   # corrigé ici
  handler          = "index.handler"
  source_code_hash = data.archive_file.example.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "production"
    Application = "example"
  }
}