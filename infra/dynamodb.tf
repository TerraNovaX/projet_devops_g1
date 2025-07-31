resource "aws_dynamodb_table" "tasks" {
  name           = "Tasks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "taskId"

  attribute {
    name = "taskId"
    type = "S"
  }
}
