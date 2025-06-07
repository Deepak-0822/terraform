# terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.97.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_start"></a> [cloudwatch\_start](#module\_cloudwatch\_start) | ./modules/cloudwatch_event | n/a |
| <a name="module_cloudwatch_stop"></a> [cloudwatch\_stop](#module\_cloudwatch\_stop) | ./modules/cloudwatch_event | n/a |
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./modules/ec2 | n/a |
| <a name="module_lambda_start"></a> [lambda\_start](#module\_lambda\_start) | ./modules/lambda | n/a |
| <a name="module_lambda_stop"></a> [lambda\_stop](#module\_lambda\_stop) | ./modules/lambda | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ./modules/sns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail_event_data_store.lambda_event_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail_event_data_store) | resource |
| [aws_cloudwatch_dashboard.demo-dashboard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_metric_alarm.cpu_utilization_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | n/a | `any` | n/a | yes |
| <a name="input_db_instance_type"></a> [db\_instance\_type](#input\_db\_instance\_type) | The CIDR of the VPC | `string` | `null` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The CIDR of the VPC | `string` | `null` | no |
| <a name="input_ec2-instance"></a> [ec2-instance](#input\_ec2-instance) | n/a | `string` | `"i-0d267d2f811fba8aa"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | n/a | `map(string)` | `{}` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | n/a | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `any` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `any` | n/a | yes |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | The meantioning per az per nat. | `bool` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The list of private subnets CIDRs. | `list(string)` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The CIDR of the VPC | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | The list of public subnets CIDRs. | `list(string)` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | The meantion single az true or false. | `bool` | `null` | no |
| <a name="input_subnet_azs"></a> [subnet\_azs](#input\_subnet\_azs) | The list of azs where the subnets should be located | `list(string)` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `any` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR of the VPC | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->