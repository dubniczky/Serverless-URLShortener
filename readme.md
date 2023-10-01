# AWS Serverless Global URL Shortener

This URL shortener project uses AWS API Gateway, Lambda, DynamoDB, and S3 to create a global URL shortener

## Components

- Terraform: the entire infrastructure configuration is written in Terraform
- Functions: the Lambda functions are written in Nodejs

## Resources

- Set up S3 header forwarding for Content-Type https://docs.aws.amazon.com/apigateway/latest/developerguide/integrating-api-with-aws-services-s3.html#:~:text=To%20set%20up%20response%20header%20mappings%20for%20the%20GET%20/%20method
- Dynamodb with Nodejs SDK v3 https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/javascript_dynamodb_code_examples.html
