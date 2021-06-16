# Production Repository

resource "aws_ecr_repository" "simple-web-app" {
  name = "simple-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Elastic Container Registry to store Docker Artifacts"
  }
}

# Staging Repository

resource "aws_ecr_repository" "simple-web-app-staging" {
  name = "simple-web-app-staging"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Elastic Container Registry to store Docker Artifacts"
  }
}

# Test Repository

resource "aws_ecr_repository" "simple-web-app-test" {
  name = "simple-web-app-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Elastic Container Registry to store Docker Artifacts"
  }
}