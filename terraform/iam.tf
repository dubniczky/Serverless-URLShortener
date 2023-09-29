#
# Role: UrlshortenerCreatorRole
# https://us-east-1.console.aws.amazon.com/iamv2/home#/roles/details/UrlshortenerCreatorRole
#

resource "aws_iam_role" "creator" {
    description = "Role for urlshortenerCreator Lambda function"
    name = "UrlshortenerCreatorRole"
    tags = {
        project = "urlshortener"
    }
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "apigateway.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "creator_dynamodb" {
  name = "AllowDynamodbWrite"
  role = aws_iam_role.creator.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:Get*",
                "dynamodb:List*",
                "dynamodb:PutItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:us-west-2:044477719481:table/urlshortener_links",
                "arn:aws:dynamodb:us-west-2:044477719481:table/urlshortener_links/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "creator_cloudwatch" {
  name = "AllowCloudwatchLogging"
  role = aws_iam_role.creator.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-west-2:044477719481:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-west-2:044477719481:log-group:/aws/lambda/urlshortenerCreator:*"
            ]
        }
    ]
}
EOF
}

#
# Role: UrlshortenerResolverRole
# https://us-east-1.console.aws.amazon.com/iamv2/home#/roles/details/UrlshortenerResolverRole
#

resource "aws_iam_role" "resolver" {
    description = "Role for urlshortenerResolver Lambda function"
    name = "UrlshortenerResolverRole"
    tags = {
        project = "urlshortener"
    }
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "apigateway.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "resolver_dynamodb" {
  name = "AllowDynamodbRead"
  role = aws_iam_role.resolver.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:us-west-2:044477719481:table/urlshortener_links",
                "arn:aws:dynamodb:us-west-2:044477719481:table/urlshortener_links/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "resolver_cloudwatch" {
  name = "AllowCloudwatchLogging"
  role = aws_iam_role.resolver.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-west-2:044477719481:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-west-2:044477719481:log-group:/aws/lambda/urlshortenerResolver:*"
            ]
        }
    ]
}
EOF
}

#
# Role: UrlshortenerStaticAccess
# https://us-east-1.console.aws.amazon.com/iamv2/home#/roles/details/UrlshortenerStaticAccess
#

resource "aws_iam_role" "static" {
    description = "Role for API Gateway to access the static assets in S3"
    name = "UrlshortenerStaticAccess"
    tags = {
        project = "urlshortener"
    }
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "apigateway.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "static_s3" {
  name = "AllowUrlshortenerStaticAccess"
  role = aws_iam_role.static.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::urlshortener-static/*"
            ]
        }
    ]
}
EOF
}