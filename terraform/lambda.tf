#
# Lambda: urlshortenerResolver
# https://us-west-2.console.aws.amazon.com/lambda/home#/functions/urlshortenerResolver
#

resource "local_file" "resolver_bundle" {
    filename = var.lambda_resolver_bundle_name
    source = var.lambda_resolver_bundle_name
}

resource "aws_lambda_function" "resolver" {
    function_name = "urlshortenerResolver"
    role =  aws_iam_role.resolver.arn
    tags = {
        project = "urlshortener"
    }

    filename = local_file.resolver_bundle.filename
    source_code_hash = local_file.resolver_bundle.content_base64sha256
    package_type = "Zip"
    handler = "index.handler"
    runtime = "nodejs18.x"
    architectures = [ "arm64" ]
    memory_size = 128
    publish = true

    environment {
        variables = {
            TARGET_TABLE = "urlshortener_links"
            PATH_ID = "id"
        }
    }
}

#
# Lambda: urlshortenerCreator
# https://us-west-2.console.aws.amazon.com/lambda/home#/functions/urlshortenerCreator
#

resource "local_file" "creator_bundle" {
    filename = var.lambda_creator_bundle_name
    source = var.lambda_creator_bundle_name
}

resource "aws_lambda_function" "creator" {
    function_name = "urlshortenerCreator"
    role =  aws_iam_role.creator.arn
    tags = {
        project = "urlshortener"
    }

    filename = local_file.creator_bundle.filename
    source_code_hash = local_file.creator_bundle.content_base64sha256
    package_type = "Zip"
    handler = "index.handler"
    runtime = "nodejs18.x"
    architectures = [ "arm64" ]
    memory_size = 128
    publish = true

    environment {
        variables = {
            APP_URL = "https://unpar.link/s"
            TARGET_TABLE = "urlshortener_links"
            DEF_EXPIRY_DAYS = 1
            MAX_CHAR = 16
            MIN_CHAR = 12
        }
    }
}