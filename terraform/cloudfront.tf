resource "aws_cloudfront_distribution" "public" {
    origin {
        domain_name = "${aws_api_gateway_deployment.public_test.rest_api_id}.execute-api.us-west-2.amazonaws.com"
        origin_id = "${aws_api_gateway_deployment.public_test.rest_api_id}.execute-api.us-west-2.amazonaws.com"
        origin_path = "/test"

        connection_attempts = 3
        connection_timeout = 10

        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_keepalive_timeout = 5
            origin_protocol_policy = "https-only"
            origin_read_timeout = 30
            origin_ssl_protocols = [ "TLSv1.2" ]
        }
    }

    enabled = true
    is_ipv6_enabled = true
    aliases = [ var.domain_name ]
    price_class = "PriceClass_All"
    tags = {
        project = "urlshortener"
    }

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = "${aws_api_gateway_deployment.public_test.rest_api_id}.execute-api.us-west-2.amazonaws.com"
        origin_request_policy_id = aws_cloudfront_origin_request_policy.public.id
        cache_policy_id = aws_cloudfront_cache_policy.public.id
        compress = true

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 0
        max_ttl = 0
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations = []
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = false
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
        acm_certificate_arn = var.certificate_arn
    }
}

resource "aws_cloudfront_cache_policy" "public" {
    name = "Managed-CachingDisabled"
    comment = "Policy with caching disabled"
    max_ttl = 0
    default_ttl = 0

    parameters_in_cache_key_and_forwarded_to_origin {
        query_strings_config {
            query_string_behavior = "none"
        }
        cookies_config {
            cookie_behavior = "none"
        }
        headers_config {
            header_behavior = "none"
        } 
    }
}

resource "aws_cloudfront_origin_request_policy" "public" {
    name = "Managed-AllViewerExceptHostHeader"
    comment = "Policy to forward all parameters in viewer requests except for the Host header"

    query_strings_config {
        query_string_behavior = "all"
    }
    cookies_config {
        cookie_behavior = "all"
    }
    headers_config {
        header_behavior = "allExcept"
        headers {
            items = [ "host" ]
        }
    } 
}
