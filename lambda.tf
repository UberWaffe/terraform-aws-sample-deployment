data "archive_file" "main" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/tmp/lambda.zip"
}

resource "aws_lambda_function" "test_peculiar_lambda" {
  filename      = data.archive_file.main.output_path
  function_name = local.naming_prefix
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main.lambda_handler"

  source_code_hash = filebase64sha256(data.archive_file.main.output_path)
  runtime          = "python3.8"
  environment {
    variables = {
      par_naming_prefix           = local.naming_prefix
    }
  }
  layers      = []
  memory_size = 128
  timeout     = 30

  tags = {
    Name = "${local.naming_prefix}"
  }
}