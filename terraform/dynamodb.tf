resource "aws_dynamodb_table" "book" {
  name = "books"
  billing_mode = "PROVISIONED"
  write_capacity = 5
  read_capacity = 5
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}


resource "aws_dynamodb_table" "orders" {
  name = "orders"
  billing_mode = "PROVISIONED"
  write_capacity = 5
  read_capacity = 5
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "customer_id"
    type = "S"
  }

  global_secondary_index {
    name               = "CustomerIdIndex"
    hash_key           = "customer_id"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}
