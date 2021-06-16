# SSH key - Web App

resource "aws_key_pair" "simple-web-app-key" {
  key_name = "simple-web-app"
  public_key = file("./simple_web_app.pem")
}

# SSH key - Jenkins

resource "aws_key_pair" "jenkins-key" {
  key_name = "jenkins"
  public_key = file("./jenkins.pem")
}