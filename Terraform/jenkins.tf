module "jenkins" {
  source ="./jenkins-server"

  ami-id = "ami-0742b4e673072066f" # AMI for an Amazon Linux instance for region: us-east-1
  iam-instance-profile = aws_iam_instance_profile.jenkins.name
  key-pair = aws_key_pair.jenkins-key.key_name
  name = "jenkins"
  device-index = 0
  network-interface-id = aws_network_interface.jenkins.id
  repository-url = aws_ecr_repository.simple-web-app.repository_url
  repository-test-url = aws_ecr_repository.simple-web-app-test.repository_url
  repository-staging-url = aws_ecr_repository.simple-web-app-staging.repository_url
  instance-id = module.application-server.instance-id
  public-dns = aws_eip.jenkins.public_dns
  admin-username = var.admin-username 
  admin-password = var.admin-password
  admin-fullname = var.admin-fullname
  admin-email = var.admin-email
  bucket-logs-name = aws_s3_bucket.simple-web-app-logs.id
  bucket-config-name = aws_s3_bucket.jenkins-config.id
  remote-repo = var.remote-repo
  job-name = var.job-name
  job-id = random_id.job-id.id
}