#
# Public main API Gateway
#

resource "aws_api_gateway_rest_api" "public" {
    name = "UrlshortenerAPIGateway"
}

# /s

resource "aws_api_gateway_resource" "public_s" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    parent_id = aws_api_gateway_rest_api.public.root_resource_id

    path_part = "s"
}

resource "aws_api_gateway_resource" "public_s_id" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    parent_id = aws_api_gateway_resource.public_s.id

    path_part = "{id}"
}

resource "aws_api_gateway_method" "public_s_id_get" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_s_id.id

    http_method = "GET"
    authorization = "NONE"

    request_parameters = {
        "method.request.path.id" = true
    }
}

resource "aws_api_gateway_integration" "public_s_id_get" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_s_id.id

    http_method = aws_api_gateway_method.public_s_id_get.http_method
    integration_http_method = "POST"
    type = "AWS"
    uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.resolver.arn}/invocations"
    cache_key_parameters = []
    content_handling = "CONVERT_TO_TEXT"
    passthrough_behavior = "NEVER"
    request_parameters = {}
    request_templates = {
        "application/json" = jsonencode(
            { id = "$input.params('id')"}
        )
    }
}

resource "aws_api_gateway_method_response" "public_s_id_get_301" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_s_id.id

    status_code = 301
    http_method = "GET"
    response_parameters = {
        "method.response.header.Location" = false
    }
}

resource "aws_api_gateway_stage" "public_test" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    deployment_id = aws_api_gateway_deployment.public_test.id
    stage_name = "test"
}

resource "aws_api_gateway_deployment" "public_test" {
    rest_api_id = aws_api_gateway_rest_api.public.id
}
