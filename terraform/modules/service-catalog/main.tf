// #Create DynamoDB.track created services.


resource "aws_dynamodb_table" "services" {

  name         = "platform-services"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "service_name"

  attribute {
    name = "service_name"
    type = "S"
  }
}
