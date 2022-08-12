terraform {
  backend "gcs" {
    #variable not allowed
    credentials = "/Users/W441139/downloads/gcp/terraform-gke-keyfile.json"
    bucket      = "terraform-state-first-gke"
    prefix      = "terraform/state"
  }
}
