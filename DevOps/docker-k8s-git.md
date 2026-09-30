# DevOps

## Docker

### Tomcat image, deploy WAR, push to registry

Dockerfile:

```dockerfile
FROM tomcat:9.0
COPY sample.war /usr/local/tomcat/webapps/
EXPOSE 8080
```

Build and run:

```bash
docker build -t my-tomcat-app .
docker run -d -p 8080:8080 my-tomcat-app
```

Push to Docker Hub:

```bash
docker login
docker tag my-tomcat-app nourshweiki0/my-tomcat-app
docker push nourshweiki0/my-tomcat-app
```

Repo: https://hub.docker.com/r/nourshweiki0/my-tomcat-app

### Run Nginx and PostgreSQL as containers

```bash
docker run -d -p 80:80 nginx:latest
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword postgres:latest
```

---

## Kubernetes

### Master vs Worker Nodes

Master node manages the cluster, it decides where pods run and keeps track of the cluster state. Worker nodes are the machines that actually run the pods/containers.

To check which is which:

```bash
kubectl get nodes
```

The ROLES column shows `control-plane` for the master and blank for workers.

### Install K3s and Deploy Nginx

Install K3s:

```bash
curl -sfL https://get.k3s.io | sh -
```

Check it's running:

```bash
sudo k3s kubectl get nodes
```

Deploy nginx and expose it:

```bash
sudo k3s kubectl create deployment nginx --image=nginx && sudo k3s kubectl expose deployment nginx --port=80 --type=NodePort
```

Check the pod is running:

```bash
sudo k3s kubectl get pods
```

---

## Version Control (GitHub)

Upload files to GitHub using the command line:

```bash
git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/NourShweiki/PS.git
git push -u origin main
```

Download files from GitHub using the command line:

```bash
git clone https://github.com/NourShweiki/PS.git
```
