resource "aws_cloudwatch_log_group" "creator" {
    name = "/aws/lambda/urlshortenerCreator"
}

resource "aws_cloudwatch_log_group" "resolver" {
    name = "/aws/lambda/urlshortenerResolver"
}
