#! /bin/bash

sudo yum update -y

# Install Git
sudo yum install -y git

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo yum install -y jenkins java-1.8.0-openjdk-devel
sudo systemctl daemon-reload

# Install Docker
sudo amazon-linux-extras install docker

# Start Jenkins
sudo systemctl start jenkins

# Enable jenkins to run on boot
sudo systemctl enable jenkins

# Start Docker
sudo systemctl start docker

# Enable Docker to run on boot
sudo systemctl enable docker

# Let Jenkins and the current user use docker
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins

# Create the opt folder in the jenkins home
sudo mkdir /var/lib/jenkins/opt
sudo chown jenkins /var/lib/jenkins/opt
sudo chgroup jenkins /var/lib/jenkins/opt

# Download and install arachni as jenkins user
wget https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz 
tar -zxf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz 
rm arachni-1.5.1-0.5.12-linux-x86_64.tar.gz 
sudo chown -R jenkins arachni-1.5.1-0.5.12/
sudo chgrp -R jenkins arachni-1.5.1-0.5.12/
sudo mv arachni-1.5.1-0.5.12 /var/lib/jenkins/opt

# Save the instance_id, repositories urls and bucket name to use in the pipeline
sudo /bin/bash -c "echo ${repository_url} > /var/lib/jenkins/opt/repository_url"
sudo /bin/bash -c "echo ${repository_test_url} > /var/lib/jenkins/opt/repository_test_url"
sudo /bin/bash -c "echo ${repository_staging_url} > /var/lib/jenkins/opt/repository_staging_url"
sudo /bin/bash -c "echo ${instance_id} > /var/lib/jenkins/opt/instance_id"
sudo /bin/bash -c "echo ${bucket_logs_name} > /var/lib/jenkins/opt/bucket_name"

# Change ownership and group of these files
sudo chown -R jenkins /var/lib/jenkins/opt/
sudo chgrp -R jenkins /var/lib/jenkins/opt/

# Wait for Jenkins to boot up
sudo sleep 60

#####################################################
#######            SET UP JENKINS             #######
#####################################################

#---------------------------------------------#
#------> DEFINE THE GLOBAL VARIABLES <--------#
#---------------------------------------------#

export url="http://${public_dns}:8080"
export user="${admin_username}"
export password="${admin_password}"
export admin_fullname="${admin_fullname}"
export admin_email="${admin_email}"
export remote="${remote_repo}"
export jobName="${job_name}"
export jobID="${job_id}"

#---------------------------------------------#
#-----> COPY THE CONFIG FILES FROM S3 <-------#
#---------------------------------------------#

sudo aws s3 cp s3://${bucket_config_name}/ ./ --recursive
sudo chmod +x *.sh

#---------------------------------------------#
#----------> RUN THE CONFIG FILES  <----------#
#---------------------------------------------#

./create_admin_user.sh
./download_install_plugins.sh
sudo sleep 120
./confirm_url.sh
./create_credentials.sh

# Output the credentials id in a credentials_id file
python -c "import sys;import json;print(json.loads(raw_input())['credentials'][0]['id'])" <<< $(./get_credentials_id.sh) > credentials_id

./create_multibranch_pipeline.sh

#---------------------------------------------#
#---------> DELETE THE CONFIG FILES <---------#
#---------------------------------------------#

sudo rm *.sh credentials_id

reboot