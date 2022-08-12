credentials        = "/Users/W441139/downloads/gcp/terraform-gke-keyfile.json"
project_id         = "k8s-learning-359216"
region             = "us-east1"
zones              = ["us-east1-b", "us-east1-c"]
name               = "gke-cluster"
machine_type       = "e2-micro"
min_count          = 1
max_count          = 3
disk_size_gb       = 10
service_account    = "terraform-gke@k8s-learning-359216.iam.gserviceaccount.com"
initial_node_count = 1