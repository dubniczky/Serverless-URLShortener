import os
import json
import boto3

ddb = boto3.resource('dynamodb', region_name = 'us-west-2').Table('urlshortener_links')

def lambda_handler(event, context):
    id = event.get('id')
    print(event)
    print('id:', id)

    try:
        item = ddb.get_item(Key={'id': id}) #look up the take the short id value in dynamo
        long_url = item.get('Item').get('url') #take the long_url value corresponding to the short id
        # increase the hit number on the db entry of the url (analytics?)
        #ddb.update_item(
        #    Key={'short_id': id},
        #    UpdateExpression='set hits = hits + :val',
        #    ExpressionAttributeValues={':val': 1}
        #)

    except Exception as e:
        print(e)
        return {
            'statusCode': 301,
            'location': '/404.html'
        }
    
    #return long_url and the redirection http status code 301
    return {
        "statusCode": 301,
        "location": long_url
    }