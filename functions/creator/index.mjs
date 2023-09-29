import { DynamoDBClient } from "@aws-sdk/client-dynamodb"
import { DynamoDBDocumentClient, GetCommand, PutCommand } from "@aws-sdk/lib-dynamodb"


// Load Environment
const targetTable = process.env.TARGET_TABLE
const appUrl = process.env.APP_URL
const maxChars = process.env.MAX_CHAR
const minChars = process.env.MIN_CHAR
const defaultExpiryDays = process.env.DEF_EXPIRY_DAYS


// Load SDK
const dynamodb = new DynamoDBClient({})
const dynamoDoc = DynamoDBDocumentClient.from(dynamodb)

// Defaults
const defaultResponse = {
    statusCode: 400,
    error: true,
}
const urlCharset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'


function currentTimestamp() {
    return new Date().toISOString()
}

function calculateExpiry(daysDelta) {
    const deltaMs = daysDelta * 24 * 60 * 60 * 1000
    return new Date().getMilliseconds() + deltaMs
}

// TODO check if id exists, implement MAX CHARS
function generateId() {
    let id = ''
    for (let i = 0; i < maxChars; i++) {
        id += urlCharset[Math.floor(Math.random() * urlCharset.length)]
    }
    return id
}


export const handler = async(event, context) => {
    try {

        // Parse body
        const body = JSON.parse(event.body)
        if (!body) {
            return defaultResponse
        }

        const longUrl = body['long_url']
        const shortId = generateId()
        const timestamp = currentTimestamp()

        console.log('event', event)
        const command = new PutCommand({
            TableName: targetTable,
            Item: {
                id: generateId(),
                url: longUrl,
                created_at: timestamp,
                ttl: calculateExpiry(defaultExpiryDays),
            }
        })
        
        const response = await dynamoDoc.send(command)
        console.log('response', response)
        if (!response) {
            return defaultResponse
        }

        return {
            statusCode: 200,
            body: JSON.stringify({
                url: `${appUrl}/${shortId}`,
                long_url: longUrl
            })
        }
    }
    catch (e) {
        console.error(e)
        return defaultResponse
    }
}
