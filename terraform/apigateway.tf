resource "aws_api_gateway_rest_api" "bookstore_api" {
  name = "bookstore-api"
}
##############################
# Create the /books resource
##############################
resource "aws_api_gateway_resource" "books" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  parent_id   = aws_api_gateway_rest_api.bookstore_api.root_resource_id
  path_part   = "books"
}
##############################
# Create the GET method for the /books resource
##############################
resource "aws_api_gateway_method" "get_books" {
  rest_api_id   = aws_api_gateway_rest_api.bookstore_api.id
  resource_id   = aws_api_gateway_resource.books.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_books_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.books.id
  http_method             = aws_api_gateway_method.get_books.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_books.invoke_arn
  
}
##############################
# Create the POST method for the /books resource
##############################
resource "aws_api_gateway_method" "create_book" {
  rest_api_id   = aws_api_gateway_rest_api.bookstore_api.id
  resource_id   = aws_api_gateway_resource.books.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_book_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.books.id
  http_method             = aws_api_gateway_method.create_book.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_book.invoke_arn
}

##############################
# Create the OPTIONS method for the /books resource
##############################
# Add the OPTIONS method for /books
resource "aws_api_gateway_method" "books_options" {
  rest_api_id   = aws_api_gateway_rest_api.bookstore_api.id
  resource_id   = aws_api_gateway_resource.books.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "books_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.books.id
  http_method             = aws_api_gateway_method.books_options.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_method_response" "books_options_response" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.books_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "books_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  resource_id = aws_api_gateway_resource.books.id
  http_method = aws_api_gateway_method.books_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [ aws_api_gateway_integration.books_options_integration ]
}


##############################
# Create the /orders resource
##############################
resource "aws_api_gateway_resource" "orders" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  parent_id   = aws_api_gateway_rest_api.bookstore_api.root_resource_id
  path_part   = "orders"
}

##############################
# Create the POST method for the /orders resource
##############################
resource "aws_api_gateway_method" "create_order" {
  rest_api_id   = aws_api_gateway_rest_api.bookstore_api.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_order_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.orders.id
  http_method             = aws_api_gateway_method.create_order.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_order.invoke_arn
}

##############################
# Create the OPTIONS method for the /orders resource
##############################
resource "aws_api_gateway_method" "orders_options" {
    rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
    resource_id = aws_api_gateway_resource.orders.id
    http_method = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "orders_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.orders.id
  http_method             = aws_api_gateway_method.orders_options.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_api_gateway_method_response" "orders_options_response" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.orders_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}


resource "aws_api_gateway_integration_response" "orders_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.orders_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [ aws_api_gateway_integration.orders_options_integration ]
}

##############################
# Create the /orders/{customer_id} resource
##############################
resource "aws_api_gateway_resource" "orders_by_customer" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  parent_id   = aws_api_gateway_resource.orders.id
  path_part   = "{customer_id}"
}

# Create the GET method for the /orders/{customer_id} resource
resource "aws_api_gateway_method" "get_orders" {
  rest_api_id   = aws_api_gateway_rest_api.bookstore_api.id
  resource_id   = aws_api_gateway_resource.orders_by_customer.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_orders_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.orders_by_customer.id
  http_method             = aws_api_gateway_method.get_orders.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_orders.invoke_arn
}

##############################
# Create the OPTIONS method for the /orders/customer_id resource
##############################
resource "aws_api_gateway_method" "orders_by_customer_options" {
    rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
    resource_id = aws_api_gateway_resource.orders_by_customer.id
    http_method = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "orders_by_customer_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.bookstore_api.id
  resource_id             = aws_api_gateway_resource.orders_by_customer.id
  http_method             = aws_api_gateway_method.orders_by_customer_options.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_api_gateway_method_response" "orders_by_customer_options_response" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  resource_id = aws_api_gateway_resource.orders_by_customer.id
  http_method = aws_api_gateway_method.orders_by_customer_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}


resource "aws_api_gateway_integration_response" "orders_by_customer_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  resource_id = aws_api_gateway_resource.orders_by_customer.id
  http_method = aws_api_gateway_method.orders_by_customer_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [ aws_api_gateway_integration.orders_by_customer_options_integration ]
}


##############################
# Create Deployment
##############################
resource "aws_api_gateway_deployment" "bookstore_deployment" {
  rest_api_id = aws_api_gateway_rest_api.bookstore_api.id
  stage_name  = "prod"

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.books.id,
      aws_api_gateway_method.get_books.id,
      aws_api_gateway_integration.get_books_integration.id,
      aws_api_gateway_method.create_book.id,
      aws_api_gateway_integration.create_book_integration.id,
      aws_api_gateway_resource.orders.id,
      aws_api_gateway_method.create_order.id,
      aws_api_gateway_integration.create_order_integration.id,
      aws_api_gateway_resource.orders_by_customer.id,
      aws_api_gateway_method.get_orders.id,
      aws_api_gateway_integration.get_orders_integration.id,
      aws_api_gateway_method.books_options,
      aws_api_gateway_integration.books_options_integration,
      aws_api_gateway_method_response.books_options_response,
      aws_api_gateway_integration_response.books_options_integration_response,
      aws_api_gateway_method.orders_options,
      aws_api_gateway_integration.orders_options_integration,
      aws_api_gateway_method_response.orders_options_response,
      aws_api_gateway_integration_response.orders_options_integration_response,
      aws_api_gateway_method.orders_by_customer_options,
      aws_api_gateway_integration.orders_by_customer_options_integration,
      aws_api_gateway_method_response.orders_by_customer_options_response,
      aws_api_gateway_integration_response.orders_by_customer_options_integration_response,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}