resource "aws_dynamodb_table" "links" {
    name = var.dynamodb_links_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"

    tags = {
        project = "urlshortener"
    }

    attribute {
        name = "id"
        type = "S"
    }

    ttl {
        attribute_name = "ttl"
        enabled = true
    }
}