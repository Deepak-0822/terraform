resource "aws_sns_topic" "sns_topic" {
  name = var.topic_name
}

output "topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}

