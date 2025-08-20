# Install WSL 

# Minikube Start

# Install ArgoCD
kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install Cert Manager
kubectl create namespace cert-manager

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

# Create working namespace
kubectl create namespace cybercheck

# Expose the port
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Apply helm config