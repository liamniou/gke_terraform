The application is a small microservice application that consists of frontend+backend part (based on Python Flask), RabbitMQ and a consumer (python script) that reads a queue and stores the populated data on a persistent storage.


How to deploy it:

1. Create GKE cluster:
> cd terraform && terraform apply -target=module.cluster

2. Build "frontend" image and upload it to Docker registry:
> cd /frontend && docker build . -t yourname/frontend:1.0.0 && docker push yourname/frontend:1.0.0

3. Build "consumer" image and upload it to Docker registry:
> cd /consumer && docker build . -t yourname/consumer:1.0.0 && docker push yourname/consumer:1.0.0

4. Create Google disk in the same region as your cluster:
> gcloud compute disks create disk_name --size=1GB --zone us-central1-a

5. Deploy containers into k8s cluster:
> cd terraform && terraform apply -target=module.deployments