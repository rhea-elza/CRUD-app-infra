# UC-2
Deploying python app to GKE cluster and connecting to SQL instance database via Cloud SQL auth proxy
## Infrastrucature deployment 
Step 1: cd terraform/providers.tf

Step 2: Change the credentials.json to your service account keyfile 

Step 3: Pass your SQL database username and password in a secrets.tfvars file

Step 4:
       terraform init
       terraform plan
       terraform apply

## Deploying app to GKE 
Step 1:Pass your SQL database username and password as Kubernetes secrets 

    kubectl create secret generic user-name --from-literal=username=<YOUR-USERNAME>
    kubectl create secret generic user-pass --from-literal=password=<YOUR-PASSWORD>

Step 2:Create a repo in Artifact Registry in the same region as your cluster

    gcloud artifacts repositories create hello-repo \
    --project=PROJECT_ID \
    --repository-format=docker \
    --location=REGION \
    --description="Docker repository"

Step 3: Build your container image using Cloud Build, which is similar to running docker build and docker push, but the build happens on Google Cloud:

    gcloud builds submit \
    --tag REGION-docker.pkg.dev/PROJECT_ID/hello-repo/helloworld-gke .

Step 4: Enable Workload Identity for your cluster
Step 5: Create a KSA for your application by running kubectl apply -f service-account.yaml
Step 6: Enable the IAM binding between your YOUR-GSA-NAME and YOUR-KSA-NAME:

    gcloud iam service-accounts add-iam-policy-binding \
    --role="roles/iam.workloadIdentityUser" \
    --member="serviceAccount:YOUR-GOOGLE-CLOUD-PROJECT.svc.id.goog[YOUR-K8S-NAMESPACE/YOUR-KSA-NAME]" \
    YOUR-GSA-NAME@YOUR-GOOGLE-CLOUD-PROJECT.iam.gserviceaccount.com

Step 7:Add an annotation to YOUR-KSA-NAME to complete the binding:

    kubectl annotate serviceaccount \
    YOUR-KSA-NAME \
    iam.gke.io/gcp-service-account=YOUR-GSA-NAME@YOUR-GOOGLE-CLOUD-PROJECT.iam.gserviceaccount.com

Step 8:Finally, configure your application to connect using 127.0.0.1
Step 9: Deploy your app to the GKE cluster you created

    kubectl apply -f deployment.yaml

Step 10:Expose your deployment using LoadBalancer Service 

    kubectl apply -f service.yaml


