module "application-server" {
  source = "./application-server"

  ami-id = "ami-0742b4e673072066f" # AMI for an Amazon Linux instance for region: us-east-1

  iam-instance-profile = aws_iam_instance_profile.simple-web-app.id
  key-pair = aws_key_pair.simple-web-app-key.key_name
  name = "Simple Web App"
  device-index = 0
  network-interface-id = aws_network_interface.simple-web-app.id
  repository-url = aws_ecr_repository.simple-web-app.repository_url
}