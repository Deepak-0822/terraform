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
  dashboard_name = "demo-dashboard-${var.ec2-instance}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${var.ec2-instance}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "${var.ec2-instance} - CPU Utilization"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 7
        width  = 3
        height = 3

        properties = {
          markdown = "My Demo Dashboard"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${var.ec2-instance}"
            ]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "${var.ec2-instance} - NetworkIn"
        }
      }
    ]
  })
}
