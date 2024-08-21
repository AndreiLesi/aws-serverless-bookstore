import json
import boto3

dynamodb = boto3.resource('dynamodb', region_name="eu-central-1")
books_table = dynamodb.Table('books')

def lambda_handler(event, context):
    print(event)
    query_params = event.get('queryStringParameters') or {}
    filter_expression = None
    expression_attribute_values = {}

    if 'title' in query_params:
        filter_expression = 'contains(title, :title)'
        expression_attribute_values = {':title': query_params['title']}
    elif 'author' in query_params:
        filter_expression = 'contains(author, :author)'
        expression_attribute_values = {':author': query_params['author']}

    try:
        if filter_expression:
            response = books_table.scan(
                FilterExpression=filter_expression,
                ExpressionAttributeValues=expression_attribute_values
            )
        else:
            response = books_table.scan()

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
            'body': json.dumps({'message': 'Error retrieving books'})
        }