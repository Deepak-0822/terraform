resource "aws_servicecatalog_portfolio" "this" {
  name          = var.portfolio_name
  description   = var.portfolio_description
  provider_name = var.provider_name
}

resource "aws_servicecatalog_product" "this" {
  name  = var.product_name
  owner = var.owner
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    name         = var.artifact_name
    type         = "CLOUD_FORMATION_TEMPLATE"
    template_url = var.template_url
  }
}

resource "aws_servicecatalog_product_portfolio_association" "this" {
  portfolio_id = aws_servicecatalog_portfolio.this.id
  product_id   = aws_servicecatalog_product.this.id
}

resource "aws_servicecatalog_constraint" "template_constraint" {
  portfolio_id = aws_servicecatalog_portfolio.this.id
  product_id   = aws_servicecatalog_product.this.id
  type         = "TEMPLATE"
  parameters   = jsonencode({
    "Rules": {
    "RegionConstraint": {
        "Assertions": [
        {
            "Assert": {
            "Fn::Equals": [
                {
                "Ref": "Region"
                },
                "us-east-1"
            ]
            },
            "AssertDescription": "Region must be us-east-1"
        }
        ]
    }
    }
  })
}

resource "aws_servicecatalog_constraint" "launch_constraint" {
  portfolio_id = aws_servicecatalog_portfolio.this.id
  product_id   = aws_servicecatalog_product.this.id
  type         = "LAUNCH"
  parameters   = jsonencode({
    RoleArn = var.launch_role_arn
  })
}

resource "aws_servicecatalog_tag_option" "env" {
  key   = var.tag_key
  value = var.tag_value
}

resource "aws_servicecatalog_tag_option_resource_association" "this" {
  resource_id   = aws_servicecatalog_product.this.id
  tag_option_id = aws_servicecatalog_tag_option.env.id
}

resource "aws_servicecatalog_principal_portfolio_association" "this" {
  portfolio_id   = aws_servicecatalog_portfolio.this.id
  principal_arn  = var.user_arn
  principal_type = "IAM"
}
