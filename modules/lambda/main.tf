resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "image_resizer" {
  filename         = "${path.module}/lambda_function/image_processor.zip"
  function_name    = var.lambda_name
  handler          = "image_processor.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("${path.module}/lambda_function/image_processor.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

output "lambda_arn" {
  value = aws_lambda_function.image_resizer.arn
}

output "lambda_permission" {
  value = aws_lambda_permission.allow_s3
}
