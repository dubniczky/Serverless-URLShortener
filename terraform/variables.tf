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

variable "domain_name" {
    type    = string
    default = "unpar.link"
}

variable "certificate_arn" {
    type    = string
    default = "arn:aws:acm:us-east-1:044477719481:certificate/98f3cbe5-a065-4cbb-806b-29d3742bebd9"
}