#
# Public main API Gateway
#

resource "aws_api_gateway_rest_api" "public" {
    name = "UrlshortenerAPIGateway"
}

resource "aws_api_gateway_stage" "public_test" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    deployment_id = aws_api_gateway_deployment.public_test.id
    stage_name = "test"
}

resource "aws_api_gateway_deployment" "public_test" {
    rest_api_id = aws_api_gateway_rest_api.public.id
}

# /

resource "aws_api_gateway_resource" "public_index" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    parent_id = aws_api_gateway_rest_api.public.root_resource_id

    path_part = ""
}

resource "aws_api_gateway_method" "public_index_get" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_index.id

    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "public_index_get" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_index.id

    http_method = aws_api_gateway_method.public_index_get.http_method
    integration_http_method = "GET"
    type = "AWS"
    credentials = aws_iam_role.static.arn
    uri = "arn:aws:apigateway:${var.region}:s3:path/${aws_s3_bucket.static_assets.bucket}/create.html"
    passthrough_behavior = "WHEN_NO_MATCH"
    request_parameters = {}
}

resource "aws_api_gateway_method_response" "public_index_get_200" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_index.id

    status_code = 200
    http_method = "GET"
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {
        "method.response.header.Content-Length" = false
        "method.response.header.Content-Type" = false
        "method.response.header.Timestamp" = false
    }
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


# /create

resource "aws_api_gateway_resource" "public_create" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    parent_id = aws_api_gateway_rest_api.public.root_resource_id

    path_part = "create"
}

resource "aws_api_gateway_method" "public_create_post" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_create.id

    http_method = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "public_create_post" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_create.id

    http_method = aws_api_gateway_method.public_create_post.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.creator.arn}/invocations"
    cache_key_parameters = []
    content_handling = "CONVERT_TO_TEXT"
    passthrough_behavior = "WHEN_NO_MATCH"
    request_parameters = {}
    timeout_milliseconds = 3000
}

resource "aws_api_gateway_method_response" "public_create_post_200" {
    rest_api_id = aws_api_gateway_rest_api.public.id
    resource_id = aws_api_gateway_resource.public_create.id

    status_code = 200
    http_method = "POST"
    response_models = {
        "application/json" = "Empty"
    }
    response_parameters = {}
}
