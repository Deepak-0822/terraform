resource "aws_iam_role" "test_role" {
  name = "ec2-role-import" # It's good practice to have descriptive names

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  # Attach the AdministratorAccess policy to give full permissions
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]

  tags = {
    tag-key = "tag-value"
    Purpose = "Administrator Role for EC2" # Add a descriptive tag
  }
}

