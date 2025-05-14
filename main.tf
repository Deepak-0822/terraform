##ec2

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids
  key_name           = var.key_name
  instance_name      = var.instance_name
}


module "lambda_stop" {
  source               = "./modules/lambda"
  function_name        = "stop-instance"
  lambda_zip_path      = "./py/stop_ec2/lambda_function.zip"
  environment_variables = {
    INSTANCE_ID = module.ec2.instance_id
  }
}

module "lambda_start" {
  source               = "./modules/lambda"
  function_name        = "start-instance"
  lambda_zip_path      = "./py/start_ec2/lambda_function.zip"
  environment_variables = {
    INSTANCE_ID = module.ec2.instance_id
  }
}

module "cloudwatch_start" {
  source     = "./modules/cloudwatch_event"
  rule_name  = "start-schedule"
  schedule   = "cron(0 8 ? * MON-FRI *)"
  lambda_arn = module.lambda_start.lambda_arn
}

module "cloudwatch_stop" {
  source     = "./modules/cloudwatch_event"
  rule_name  = "stop-schedule"
  schedule   = "cron(0 17 ? * MON-FRI *)"
  lambda_arn = module.lambda_stop.lambda_arn
}



resource "aws_cloudwatch_dashboard" "demo-dashboard" {
  dashboard_name = "demo-dashboard-${module.ec2.instance_id}"

  dashboard_body = templatefile("${path.module}/dashboard.json.tpl", {
    instance_id = module.ec2.instance_id
  })
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "high-cpu-${module.ec2.instance_id}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for EC2 instance"
  alarm_actions = [module.sns.topic_arn]
  dimensions = {
    InstanceId = module.ec2.instance_id
  }
  treat_missing_data = "missing"
}

module "sns" {
  source        = "./modules/sns"
  topic_name    = "image-process-topic"
  email_address = "deepak-b@hcltech.com"
}

resource "aws_cloudtrail_event_data_store" "lambda_event_store" {
  name                             = "lambda-event-data-store"
  multi_region_enabled             = true
  organization_enabled             = false
  retention_period                 = 90
  termination_protection_enabled  = false

  advanced_event_selector {
    name = "All Lambda Data Events"

    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }

    field_selector {
      field  = "resources.type"
      equals = ["AWS::Lambda::Function"]
    }
  }
}
