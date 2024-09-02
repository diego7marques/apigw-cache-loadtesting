# API Gateway Rest API
resource "aws_api_gateway_rest_api" "app_api" {
  name        = "app-api"
  description = "API Gateway for /app with GET method proxying to Lambda"
}

# API Gateway Resource (path /app)
resource "aws_api_gateway_resource" "app_resource" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  parent_id   = aws_api_gateway_rest_api.app_api.root_resource_id
  path_part   = "app"
}

# API Gateway Method (GET /app)
resource "aws_api_gateway_method" "get_app" {
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  resource_id   = aws_api_gateway_resource.app_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Integration (Proxy Integration with Lambda)
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.app_api.id
  resource_id             = aws_api_gateway_resource.app_resource.id
  http_method             = aws_api_gateway_method.get_app.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn

  depends_on = [aws_lambda_permission.api_gateway]
}

# Lambda Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.app_api.execution_arn}/*/*"
}

# API Gateway Stage (nocache - with cache disabled)
resource "aws_api_gateway_stage" "nocache" {
  stage_name    = "nocache"
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  deployment_id = aws_api_gateway_deployment.app_api_deployment["nocache"].id
}

resource "aws_api_gateway_method_settings" "nocache_method" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  stage_name  = aws_api_gateway_stage.nocache.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "OFF"
  }
}

# API Gateway Stage (cache - with cache enabled)
resource "aws_api_gateway_stage" "cache" {
  stage_name    = "cache"
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  deployment_id = aws_api_gateway_deployment.app_api_deployment["cache"].id

  cache_cluster_enabled = true
  cache_cluster_size    = "0.5"  # Smallest cache cluster size
}

resource "aws_api_gateway_method_settings" "cache_method" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  stage_name  = aws_api_gateway_stage.cache.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "OFF"
    caching_enabled = true
    cache_ttl_in_seconds = 180
  }
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "app_api_deployment" {
  for_each = toset(["cache", "nocache"])
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  stage_name = each.value

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = timestamp()
  }
}