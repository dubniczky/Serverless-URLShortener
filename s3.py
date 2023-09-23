import boto3

s3 = boto3.resource('s3')

bucket = s3.Bucket('urlshortener-multiplexer')

bucket.put_object(Key='asd', Body='0', WebsiteRedirectLocation='http://google.com')
