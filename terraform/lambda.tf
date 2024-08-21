##############################
# Create Lambda function for creating a new book
##############################
data "archive_file" "zip_create_book" {
type        = "zip"
source_file  = "${path.module}/../backend/create_book.py"
output_path = "${path.module}/../backend/create_book.zip"
}

resource "aws_lambda_function" "create_book" {
  filename         = "${path.module}/../backend/create_book.zip"
  function_name    = "create-book"
  role             = aws_iam_role.lambda_role.arn
  handler          = "create_book.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.zip_create_book.output_base64sha256
  depends_on = [ data.archive_file.zip_create_book ]
}


resource "aws_lambda_permission" "create_book" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_book.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.bookstore_api.execution_arn}/*/*"
}
##############################
# Create Lambda function for retrieving books
##############################
data "archive_file" "zip_get_books" {
  type        = "zip"
  source_file  = "${path.module}/../backend/get_books.py"
  output_path = "${path.module}/../backend/get_books.zip"
}

resource "aws_lambda_function" "get_books" {
  filename         = "${path.module}/../backend/get_books.zip"
  function_name    = "get-books"
  role             = aws_iam_role.lambda_role.arn
  handler          = "get_books.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.zip_get_books.output_base64sha256
  depends_on = [ data.archive_file.zip_get_books ]
}

resource "aws_lambda_permission" "get_books" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_books.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.bookstore_api.execution_arn}/*/*"
}

##############################
# Create Lambda function for creating a new order
##############################
data "archive_file" "zip_create_order" {
type        = "zip"
source_file  = "${path.module}/../backend/create_order.py"
output_path = "${path.module}/../backend/create_order.zip"
}

resource "aws_lambda_function" "create_order" {
  filename         = "${path.module}/../backend/create_order.zip"
  function_name    = "create-order"
  role             = aws_iam_role.lambda_role.arn
  handler          = "create_order.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.zip_create_order.output_base64sha256
  depends_on = [ data.archive_file.zip_create_order ]
}


resource "aws_lambda_permission" "create_order" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_order.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.bookstore_api.execution_arn}/*/*"
}
##############################
# # Create Lambda function for retrieving orders
##############################
data "archive_file" "zip_get_orders" {
type        = "zip"
source_file  = "${path.module}/../backend/get_orders.py"
output_path = "${path.module}/../backend/get_orders.zip"
}

resource "aws_lambda_function" "get_orders" {
  filename         = "${path.module}/../backend/get_orders.zip"
  function_name    = "get-orders"
  role             = aws_iam_role.lambda_role.arn
  handler          = "get_orders.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.zip_get_orders.output_base64sha256
  depends_on = [ data.archive_file.zip_get_orders ]
}

resource "aws_lambda_permission" "get_orders" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_orders.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.bookstore_api.execution_arn}/*/*"
}

##############################
# IAM role for the Lambda functions
##############################
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the DynamoDB access policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
# Attach the BasicLAmbdaPermissions policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basicexec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}





# "id": "1",
# "title": "Me",
# "author": "Me",
# "price": 11,
# "description": "description",
# "created_at": "datetime-now"