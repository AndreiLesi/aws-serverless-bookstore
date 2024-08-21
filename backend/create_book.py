import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb', region_name="eu-central-1")
books_table = dynamodb.Table('books')

def lambda_handler(event, context):
    data = json.loads(event['body'])
    book = {
        'id': context.aws_request_id,
        'title': data['title'],
        'author': data['author'],
        'price': data['price'],
        'description': data['description'],
        'created_at': datetime.now().isoformat()
    }

    try:
        books_table.put_item(Item=book)
        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps(book)
        }
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error creating book'})
        }