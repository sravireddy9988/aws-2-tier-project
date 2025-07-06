



**- Install Jenkins**

```
#!/bin/bash

# Exit on any error
set -e

echo "🔄 Updating package list..."
sudo apt update && sudo apt upgrade -y

echo "☕ Installing Java (OpenJDK 17)..."
sudo apt install openjdk-17-jdk -y

echo "✅ Java version:"
java -version

echo "🔑 Adding Jenkins repository key..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "📦 Adding Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔄 Updating package list..."
sudo apt update

echo "🛠 Installing Jenkins..."
sudo apt install jenkins -y

echo "🚀 Starting Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "✅ Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo "🌐 Configuring firewall (Allow port 8080)..."
sudo ufw allow 8080/tcp
sudo ufw enable -y
sudo ufw status

echo "🔑 Retrieving Jenkins admin password..."
JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

echo "🎉 Jenkins installed successfully!"
echo "🔗 Access Jenkins at: http://$(curl -s ifconfig.me):8080"
echo "🛠 Initial Admin Password: $JENKINS_PASSWORD"
echo "💡 Save this password to log in for the first time."

echo "✅ Done!"
```

  - Connect to Jenkins usig <EC2_Public_IP:8080>

**- Install Docker, Trivy, awscli**

```
# Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

# Check trivy version
trivy --version

# Install Terraform
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

#Verify terraform version:
terraform --version

# Install AWSCLI
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**1. Create AWS Infra using Terraform: VPC, EC2, EKS, RDS**

**2. Connect to EC2 ( jump-server ) & Install kubectl, helm, awscli  -> after provide aws creds on ec2 using "aws configure"**

**3. update RDS Endpoint on K8s -> backend-deployment.yaml -> DB_HOST**

**4. Create 2 ECR Repositorys Manually:  1. frontend-repo,   2. backend-repo**

  - Now build frontend & backend Docker images and push to AWS ECR Repos:

  - login to AWS ECR

```
cd frontend
docker build -t frontend:latest
docker tag frontend:latest 657001761946.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest
docker push 657001761946.dkr.ecr.us-east-1.amazonaws.com/frontend-repo:latest

cd backend
docker build -t backend:latest
docker tag backend:latest 657001761946.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest
docker push 657001761946.dkr.ecr.us-east-1.amazonaws.com/backend-repo:latest
```

**5. Update Images on "K8s yamls" and also provide "rds database credentails" on backend-deployment.yaml & apply them**

```
cd k8s
kubectl apply -f .
```

  - check "frontend & backend service are running or not"

```
kubectl get all
```

**6. access "frontend ui" using "LoadBalancer" DNS Name & provide inputs like "Name, Travelling from, Destination, Food Preference" & check all the data on "backend"**


![image](https://github.com/user-attachments/assets/e46b3672-b46c-468f-be3f-0f65bf223c63)


  - connect to ec2 ( jump server ) & Install MySQL and check your data:

```
sudo apt install -y mysql-client
mysql -h <RDS-endpoint> -u vijay -p
```

  - Example:

```
mysql -h my-rds-instance.ce9wya4k41zv.us-east-1.rds.amazonaws.com -u vijay -p
password: Password123

show databases;
use appdb;
show tables;
select * from bookings;
```

![image](https://github.com/user-attachments/assets/d532c636-c88b-412b-b069-3c678bb6e0f7)


**7. To Destroy entire resources:**

```
terraform destroy --auto-approve
```
