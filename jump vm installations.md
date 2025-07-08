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




# Install Argocd:

  - Install Argocd on EKS Cluster:

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

  - Verify Argocd Pods, Deployments, Services, Secrets etc…

```
kubectl get all -n argocd
kubectl get secrets -n argocd
```

**- Expose ArgoCD Server:**

  - By default, the ArgoCD API server is not exposed externally. You can expose it using `NodePort` (or) `LoadBalancer` service type:

```
kubectl get svc -n argocd

kubectl edit svc argocd-server -n argocd  
```

**- Access Argocd UI using `NodePort` (or) `LoadBalancer`**  -> http://<Public_IP:NodePort>


  - Log In to ArgoCD:

  - 1. Get the `ArgoCD admin password`: The initial password is stored in a `Kubernetes secret`.

```
kubectl get secrets -n argocd
kubectl edit secret argocd-initial-admin-secret -n argocd

echo WWxnVHRyVVF4T0Y5WmlncA== | base64 --decode
```

**Log in to the Argocd UI:**

- Username: `admin`

- Password: (`use the password retrieved from the previous command`)

**Deploy Your Helm Chart on EKS using Argocd:**

Step 1: Generate a `GitHub Personal Access Token (PAT)`

1. Go to GitHub `Settings` -> Navigate to `Developer Settings` → `Personal Access Tokens` → `Generate new token`

2. Select required scopes:

   - `repo` (to access private repositories)
  
3. Copy and save the token securely.


**Step 2: Add `Private GitHub Repo` to `ArgoCD`:**

  - Argocd ->  Go to `Settings` → `Repositories` → Connect Repo Using `HTTPS`.

  - Next `Create Application` on Argocd





# Install Nginx Ingress Controller:

1. Add the Helm repository for NGINX Ingress Controller:

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm repo ls
```

2. Install the NGINX Ingress Controller using Helm:

```
kubectl create namespace ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.publishService.enabled=true
```

  - `controller.publishService.enabled=true` allows it to work properly with AWS LoadBalancer.


3. Verify the installation:

```
helm ls -A

helm status ingress-nginx -n  ingress-nginx

kubectl get all -n ingress-nginx
```


4. vim ingress.yaml

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx  
  rules:
  - host: www.vijaygiduthuri.in  
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service  
            port:
              number: 3000
```

  - verify Ingress:

```
kubectl get ingress
kubectl describe ingressmyapp-ingress
```



# Install Cert-manager:

1. Add the Jetstack Helm repository:
   
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm repo ls
```

2. Install cert-manager:

   - Apply the Cert-Manager CRDs:

```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
```

   - Install Cert-Manager using Helm:

```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.11.0
```

   - Verify that cert-manager is running:

```
kubectl get pods -n cert-manager
```

   - All `pods` in the `cert-manager namespace` should be in the `Running state`.


**vim `cluster-issuer.yaml`**

```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: vijay@gmail.com  # Replace with your email
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

  - Apply the ClusterIssuer:

```
kubectl apply -f cluster-issuer.yaml
```

**3. Update the Ingress Resource for `HTTPS`:**


  - Now, let's modify your Ingress resource to use cert-manager to automatically obtain a TLS certificate for www.vijaygiduthuri.in.



- vim ingress.yaml
  
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx  # Must match your IngressClass name
  tls:
    - hosts:
        - www.vijaygiduthuri.in
      secretName: vijaygiduthuri-tls  # Secret where cert-manager will store the TLS cert
  rules:
    - host: www.vijaygiduthuri.in
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service  
                port:
                  number: 3000
```

  - Apply the Updated Ingress Resource:

```
kubectl apply -f ingress.yaml
kubectl get ingress
kubectl describe ingress hello-ingress
```

  - Cert-manager will now request a certificate from Let's Encrypt. You can check the status of the certificate by running:

```
kubectl get certificate
kubectl describe certificate vijaygiduthuri-tls
```

**Verify HTTPS Access:**

- Once the certificate is issued and configured, access your site using https://vijaygiduthuri.in.

- This will automatically redirect HTTP traffic to HTTPS, ensuring all connections are secure.


