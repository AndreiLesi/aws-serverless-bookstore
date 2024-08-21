import json
import boto3

dynamodb = boto3.resource('dynamodb', region_name="eu-central-1")
orders_table = dynamodb.Table('orders')

def lambda_handler(event, context):
    customer_id = event['pathParameters']['customer_id']

    try:
        response = orders_table.query(
            IndexName='CustomerIdIndex',
            KeyConditionExpression='customer_id = :customer_id',
            ExpressionAttributeValues={':customer_id': customer_id}
        )

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps(response['Items'],default=str)
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error retrieving orders'})
        }