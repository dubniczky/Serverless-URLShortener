import { DynamoDBClient } from "@aws-sdk/client-dynamodb"
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb"


// Load Environment
const targetTable = process.env.TARGET_TABLE
const pathId = process.env.PATH_ID

// Load SDK
const dynamodb = new DynamoDBClient({})
const dynamoDoc = DynamoDBDocumentClient.from(dynamodb)

// Defaults
const defaultResponse = {
    statusCode: 301,
    location: '/404.html'
}


export const handler = async(event, context) => {
    try {
        
        console.log('event', event)
        const command = new GetCommand({
            TableName: targetTable,
            Key: {
                id: event[pathId]
            }
        })
        
        const response = await dynamoDoc.send(command)
        console.log('response', response)
        if (!response.Item) {
            return defaultResponse
        }

        const item = response.Item
        return {
            statusCode: 301,
            location: item.url
        }
    }
    catch (e) {
        console.error(e)
        return {
            statusCode: 301,
            location: '/404.html'
        }
    }
}
