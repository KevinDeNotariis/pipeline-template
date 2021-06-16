# Web App 

resource "aws_iam_instance_profile" "simple-web-app" {
  name = "simple-web-app"
  role = aws_iam_role.simple-web-app.name
}

resource "aws_iam_role" "simple-web-app" {
  name = "simple-web-app"

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

  managed_policy_arns = [aws_iam_policy.ecr-access.arn]
}

# Jenkins 

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins"
  role = aws_iam_role.jenkins.name
}

resource "aws_iam_role" "jenkins" {
  name = "jenkins"

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

    managed_policy_arns = [ aws_iam_policy.ecr-access.arn,
                          aws_iam_policy.s3-access.arn,
                          aws_iam_policy.ec2-access.arn,
                          aws_iam_policy.secrets-access.arn]
}


# Policy: Ec2 Reboot access

resource "aws_iam_policy" "ec2-access" {
  name = "ec2-reboot-access"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:RebootInstances",
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Policy: ECR access --> AmazonEC2ContainerRegistryPowerUser

resource "aws_iam_policy" "ecr-access" {
  name = "ecr-access"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Policy: S3 Access

resource "aws_iam_policy" "s3-access" {
  name = "s3-access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
} 

# Policy: Secrets Access

resource "aws_iam_policy" "secrets-access" {
  name = "secrets-access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "secretsmanager:GetSecretValue",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}