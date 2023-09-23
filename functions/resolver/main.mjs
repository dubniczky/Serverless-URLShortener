import { GetItemCommand, DynamoDBClient } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});


export const handler = async (event) => {
  
  try {
    const segments = event.path.split('/')

    const command = new GetItemCommand({
        TableName: "urlshortener_links",
        Key: {
          TreatId: { S: segments[1] },
        },
    });

    const response = await client.send(command);
    
    return {
      statusCode: 301,
      headers: {
        Location: response.url
      }
    }
  }
  catch (err) {
    return {
      statusCode: 404,
    }
  }
}