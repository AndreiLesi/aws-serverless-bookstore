import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb', region_name="eu-central-1")
orders_table = dynamodb.Table('orders')

def lambda_handler(event, context):
    data = json.loads(event['body'])
    order = {
        'id': context.aws_request_id,
        'customer_id': data['customer_id'],
        'book_id': data['book_id'],
        'order_timestamp': int(datetime.now().timestamp()),
        'status': 'pending'
    }

    try:
        orders_table.put_item(Item=order)
        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps(order)
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error creating order'})
        }