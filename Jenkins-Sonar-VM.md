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

  - Connect to Jenkins using <EC2_Public_IP:8080>

  - Install Below Plugins on Jenkins

      - docker
      - terraform
      - owasp
      - sonarqube scanner
      - aws credentials
      - pipeline stage view
      - blue ocean ( optional )

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
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**- Install Docker & Run Sonarqube container:**

  - Install Docker:
```
apt install docker.io -y
systemctl start docker
systemctl enable docker
systemctl status docker
```

  - Run Sonarqube Docker Container:

```
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# List all the Docker Images
docker images

# List all the Running Docker Containers
docker ps
```

  - Access Sonarqube <EC2_Public_ip:9000>
