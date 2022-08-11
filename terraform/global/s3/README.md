## Remote State Storage Setup

This setup creates the S3 bucket in AWS to store the Terraform state.

A DynamoDB is also required to manage the locks. For a local project a *_remote state storage_* is overkill, but it's done here as a reference.

```
terraform init

terraform apply
```

Then when it's all done

``
terraform destroy
``