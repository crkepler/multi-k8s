terraform {
  backend "gcs" {
    credentials = "./terraform-gke-keyfile.json"
    bucket      = "terraform-state-first-gke"
    prefix      = "terraform/state"
  }
}
