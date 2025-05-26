resource "aws_cloudtrail" "trail" {
  name                          = "org-console-login-trail"
  s3_bucket_name                = var.cloudtrail_s3_bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cw_role.arn
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.log_group_name
  retention_in_days = 14
}

resource "aws_iam_role" "cloudtrail_cw_role" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "cloudtrail-cloudwatch-access"
  role = aws_iam_role.cloudtrail_cw_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ],
        Resource = "${aws_cloudwatch_log_group.log_group.arn}:*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_metric_filter" "console_login_filter" {
  name           = "console-login-events"
  log_group_name = aws_cloudwatch_log_group.log_group.name

  pattern = "{ ($.eventName = \"ConsoleLogin\") && ($.responseElements.ConsoleLogin = \"Success\") }"

  metric_transformation {
    name      = "ConsoleLoginSuccessCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_login_alarm" {
  alarm_name          = "console-login-success-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.console_login_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.console_login_filter.metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alert on successful AWS Console logins"
  alarm_actions       = var.sns_arn
}
