
resource "google_cloudbuild_trigger" "example_trigger" {
  name = "Deployment-trigger"

  build {
    source = "./app"
    steps = [
      {
        name = "gcr.io/cloud-builders/docker"
        args = [
          "build",
          "-t",
          "gcr.io/sadaindia-tvm-poc-de/my-image",
          "./app"
        ]
      },
      {
        name = "gcr.io/cloud-builders/docker"
        args = [
          "push",
          "gcr.io/sadaindia-tvm-poc-de/my-image"
        ]
      },
      {
        name = "gcr.io/cloud-builders/kubectl"
        env = [
          "CLOUDSDK_COMPUTE_REGION=us-central1",
          "CLOUDSDK_CONTAINER_CLUSTER=uc2-flask-app-cluster",
          "CLOUDSDK_COMPUTE_ZONE=us-central1"
        ]
        args = [
          "apply",
          "-f",
          "./app/k8s/"
        ]
      }
    ]
  }

  trigger_template {
    repository {
      name = "UC-2"
    }

    branch = "master"
  }
}
