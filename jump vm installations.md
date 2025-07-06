**- Install AWSCLI, Kubectl, Helm:**

```
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

############################################################################################

#!/bin/bash

# Update package list
sudo yum update -y

# Download the latest release of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make the kubectl binary executable
chmod +x ./kubectl

# Move the kubectl binary to a directory in your PATH
sudo mv ./kubectl /usr/local/bin

# Verify the installation
kubectl version --client

echo "kubectl installation completed."


###################################################################################

#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install curl if not already installed
echo "Installing curl..."
sudo yum install -y curl

# Download and install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify Helm installation
echo "Verifying Helm installation..."
helm version

# Check if Helm was successfully installed
if [ $? -eq 0 ]; then
    echo "Helm installation completed successfully!"
else
    echo "Helm installation failed!"
fi

```

**- Install the `MySQL client`**

```
sudo apt install -y mysql-client
```

**- provide aws credentails using `aws configure` on `ec2`**

```
aws configure

access key:
secret key:
region: us-east-1
```

   - aws --version
   - kubectl version --client
   - helm version

  - Connect to your RDS MySQL database

     - Replace <RDS-endpoint>, vijay, and use your actual password when prompted:
   
```
mysql -h <RDS-endpoint> -u vijay -p
```

 - When prompted:

```
Enter password: <your-RDS-password>
```

- If all the set up is correct (RDS is in same VPC and security group allows access), you’ll be in the MySQL prompt.
     


**- Connect to AWS EKS Cluster:**

```
aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster
```

