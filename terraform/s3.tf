#
# Bucket: static assets
#

resource "aws_s3_bucket" "static_assets" {
    bucket = var.s3_static_bucket_name
    force_destroy = true
    
    tags = {
        project = "urlshortener"
    }
}

resource "aws_s3_bucket_versioning" "static_assets" {
    bucket = aws_s3_bucket.static_assets.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_acl" "static_assets" {
    bucket = aws_s3_bucket.static_assets.id
}

# Files

resource "aws_s3_object" "index_html" {
    bucket = aws_s3_bucket.static_assets.id
    key = "index.html"
    source = "./../static/index.html"
    content_type = "text/html"
    etag = filemd5("./../static/index.html")
}

resource "aws_s3_object" "_404_html" {
    bucket = aws_s3_bucket.static_assets.id
    key = "404.html"
    source = "./../static/404.html"
    content_type = "text/html"
    etag = filemd5("./../static/404.html")
}
