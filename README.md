# terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dest_bucket"></a> [dest\_bucket](#module\_dest\_bucket) | ./modules/s3 | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/lambda | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ./modules/sns | n/a |
| <a name="module_source_bucket"></a> [source\_bucket](#module\_source\_bucket) | ./modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_notification.lambda_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_destination_bucket_name"></a> [destination\_bucket\_name](#output\_destination\_bucket\_name) | n/a |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | n/a |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | n/a |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | n/a |
| <a name="output_source_bucket_name"></a> [source\_bucket\_name](#output\_source\_bucket\_name) | n/a |
<!-- END_TF_DOCS -->