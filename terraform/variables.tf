variable "lambda_resolver_bundle_name" {
    type    = string
    default = "./../bundles/resolver.zip"
}

variable "lambda_creator_bundle_name" {
    type    = string
    default = "./../bundles/creator.zip"
}

variable "s3_static_bucket_name" {
    type    = string
    default = "urlshortener-static"
}

variable "dynamodb_links_table_name" {
    type    = string
    default = "urlshortener_links"
}

variable "region" {
    type    = string
    default = "us-west-2"
}
