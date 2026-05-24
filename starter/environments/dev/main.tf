# ─────────────────────────────────────────────────────────────────────────────
# Task 2: VPC module
# ─────────────────────────────────────────────────────────────────────────────
# TODO: Uncomment and complete this block once your module is implemented.
#
# module "vpc" {
#   source = "../../modules/vpc"
#
#   name                 = "${var.environment}-vpc"
#   vpc_cidr             = var.vpc_cidr
#   availability_zones   = var.availability_zones
#   public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
#   private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
#   enable_nat_gateway   = false
#
#   tags = {
#     Environment = var.environment
#   }
# }


# ─────────────────────────────────────────────────────────────────────────────
# Task 3: Lambda IAM execution role
# ─────────────────────────────────────────────────────────────────────────────
# TODO: Add an aws_iam_role for Lambda
#   - The trust policy must allow "lambda.amazonaws.com" to assume the role
#
# TODO: Attach the AWS-managed AWSLambdaBasicExecutionRole policy
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#
# TODO: Attach the AWS-managed AWSLambdaVPCAccessExecutionRole policy
#   (required for Lambda functions deployed inside a VPC)
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"


# ─────────────────────────────────────────────────────────────────────────────
# Task 3: Lambda function
# ─────────────────────────────────────────────────────────────────────────────
# TODO: Add an aws_lambda_function resource
#   - function_name: choose a descriptive name
#   - role:          reference the IAM role ARN you created above
#   - handler:       "handler.handler"
#   - runtime:       "python3.12"
#   - filename:      "${path.module}/../../lambda/handler.zip"
#   - Deploy into a private subnet of your VPC (vpc_config block)

# ─────────────────────────────────────────────────────────────────────────────
# Task 4: API Gateway (REST API)
# ─────────────────────────────────────────────────────────────────────────────

# TODO: Add an aws_api_gateway_rest_api resource
#   - name = "${var.environment}-api"

# TODO: Add an aws_api_gateway_resource for the catch-all proxy path
#   - rest_api_id = <rest api id>
#   - parent_id   = <root resource id>  ← aws_api_gateway_rest_api.<name>.root_resource_id
#   - path_part   = "{proxy+}"

# TODO: Add an aws_api_gateway_method on the proxy resource
#   - rest_api_id   = <rest api id>
#   - resource_id   = <proxy resource id>
#   - http_method   = "ANY"
#   - authorization = "NONE"

# TODO: Add an aws_api_gateway_integration on the proxy resource
#   - rest_api_id             = <rest api id>
#   - resource_id             = <proxy resource id>
#   - http_method             = <method>.http_method
#   - type                    = "AWS_PROXY"
#   - integration_http_method = "POST"  ← Lambda is always invoked via POST internally
#   - uri                     = aws_lambda_function.api.invoke_arn

# TODO: Add an aws_api_gateway_deployment
#   - rest_api_id = <rest api id>
#   - Add a depends_on referencing the method and integration
#     (deployment must happen after routes are configured)

# TODO: Add an aws_api_gateway_stage
#   - rest_api_id   = <rest api id>
#   - deployment_id = <deployment id>
#   - stage_name    = var.environment

# TODO: Add an aws_lambda_permission so API Gateway can invoke the function
#   - function_name = aws_lambda_function.api.function_name
#   - action        = "lambda:InvokeFunction"
#   - principal     = "apigateway.amazonaws.com"
#   - source_arn    = "${aws_api_gateway_rest_api.<name>.execution_arn}/*/*"
