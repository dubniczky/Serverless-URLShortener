resource "aws_route53_zone" "public" {
    name = var.domain_name
    comment = "Managed by Terraform"
    force_destroy = true

    tags = {
        project = "urlshortener"
    }
}

resource "aws_route53_record" "public_A" {
    zone_id = aws_route53_zone.public.zone_id
    name = var.domain_name
    type = "A"

    alias {
        name = "d2akxnk042mnoy.cloudfront.net"
        zone_id = "Z2FDTNDATAQYW2" # TODO
        evaluate_target_health = false
    }
}
