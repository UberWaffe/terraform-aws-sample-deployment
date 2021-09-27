// ======================
// Test lambda
// ======================
resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.naming_prefix}-lambda-python-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${local.naming_prefix}-lambda-policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      }
    ]
  })
}