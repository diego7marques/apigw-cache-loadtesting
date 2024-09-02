resource "aws_iam_role" "lambda_role" {
  name = "lambda_basic_execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  function_name = "app01"
  role          = aws_iam_role.lambda_role.arn
  handler       = "random_delay.lambda_handler"
  runtime       = "python3.9"

  filename      = "../app/lambda_function.zip"
  source_code_hash = filebase64sha256("../app/lambda_function.zip")

  memory_size   = 128  
  timeout       = 1
  reserved_concurrent_executions = 990

  depends_on = [
    aws_iam_role_policy_attachment.lambda_role_policy
  ]
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
}