

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
