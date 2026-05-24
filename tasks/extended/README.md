# Extended Tasks

**For candidates who finish the Primary Tasks with time to spare.**

These tasks build directly on top of the Primary Tasks — complete those first.

---

## Task 4 — API Gateway

> **Note:** LocalStack's free plan only supports API Gateway REST API (v1). The scaffold in
> `starter/environments/dev/main.tf` uses v1 accordingly. If you have a LocalStack Pro license
> you are welcome to use API Gateway HTTP API (v2 — `aws_apigatewayv2_*`) instead.

Expose your Lambda function via an API Gateway REST API:

1. Create an **`aws_api_gateway_rest_api`**
2. Create an **`aws_api_gateway_resource`** for the catch-all proxy path:
   - `path_part = "{proxy+}"`
   - `parent_id` = the API's root resource ID
3. Create an **`aws_api_gateway_method`** on that resource:
   - `http_method = "ANY"`, `authorization = "NONE"`
4. Create an **`aws_api_gateway_integration`** on that resource:
   - `type = "AWS_PROXY"`
   - `integration_http_method = "POST"` — Lambda is always invoked via POST internally
   - `uri = aws_lambda_function.api.invoke_arn`
5. Create an **`aws_api_gateway_deployment`** — add `depends_on` referencing the method and integration so the deployment happens after the routes are configured
6. Create an **`aws_api_gateway_stage`** linked to the deployment
7. Create an **`aws_lambda_permission`** so API Gateway can invoke the function:
   - `principal = "apigateway.amazonaws.com"`
   - `source_arn = "${aws_api_gateway_rest_api.<name>.execution_arn}/*/*"`

The stub in `starter/environments/dev/main.tf` has a commented scaffold for each of these resources.

Verify end-to-end:

```bash
awslocal apigateway get-rest-apis
# note the api id, then:
curl http://localhost:4566/restapis/<api-id>/<stage-name>/_user_request_/
```

---

## Task 5 — Broken Config

The directory `tasks/extended/broken/` contains a Terraform configuration with **three deliberate
errors** of varying subtlety.

1. Identify all three errors by reading the code and, where needed, running `tflocal apply`
2. Fix all three errors in-place
3. Create a `tasks/extended/broken/FIXES.md` file documenting each error:
   - What the error was
   - Why it would cause a problem (and at what point — plan, apply, or runtime)
   - How you fixed it

---

## Submission Checklist

All Primary Task items, plus:

- [ ] API Gateway REST API is created and routes to the Lambda function
- [ ] Lambda permission allows API Gateway to invoke the function
- [ ] `curl http://localhost:4566/restapis/<api-id>/<stage>/_user_request_/` returns a successful response
- [ ] All three errors in `tasks/extended/broken/` are fixed and documented in `FIXES.md`
