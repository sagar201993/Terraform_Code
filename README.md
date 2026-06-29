# Terraform Learning Project

This repository is a small, practical Terraform learning project focused on provisioning an AWS S3 bucket and understanding the difference between local state and remote state.

It is organized in two stages:

- `learntf/` shows a basic Terraform setup using local state.
- `backend/` shows the same infrastructure with Terraform state stored remotely in an S3 backend.

## Project Structure

```text
terra/
├── backend/
│   ├── providers.tf
│   └── s3.tf
└── learntf/
    ├── hcl.tf
    ├── providers.tf
    └── s3.tf
```

## What This Project Creates

Both Terraform examples create:

- A random suffix using the `random` provider
- An AWS S3 bucket with a unique name
- An output showing the generated bucket name

Example bucket format:

```text
example-bucket-<random-suffix>
```

## Prerequisites

Before running this project, make sure you have:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `~> 1.7`
- An AWS account
- AWS credentials configured locally
- Permission to create S3 buckets

You can configure AWS credentials with the AWS CLI:

```bash
aws configure
```

## Step 1: Run the Basic Terraform Example

The `learntf/` folder is the beginner-friendly starting point. It uses Terraform local state, which means the state file is stored on your machine.

### 1. Move into the folder

```bash
cd learntf
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads the required providers:

- `hashicorp/aws`
- `hashicorp/random`

### 3. Review the execution plan

```bash
terraform plan
```

This shows what Terraform is going to create before applying any changes.

### 4. Apply the configuration

```bash
terraform apply
```

Type `yes` when prompted.

Terraform will create:

- A `random_id`
- A unique S3 bucket

### 5. View the output

After apply completes, Terraform prints the generated bucket name from:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}
```

### 6. Destroy the resources when finished

```bash
terraform destroy
```

This removes the bucket and keeps your AWS account clean after practice.

## Step 2: Run the Remote Backend Example

The `backend/` folder demonstrates how to store Terraform state remotely in S3 instead of keeping it only on your local machine.

This is closer to a production-style setup because remote state is easier to share and manage safely across environments or teams.

### Important note before you start

In `backend/providers.tf`, the Terraform backend is configured like this:

```hcl
backend "s3" {
  bucket = "sagarmunish-bucket-demo-backend"
  key    = "state.tfstate"
  region = "us-east-2"
}
```

That backend S3 bucket must already exist before you run `terraform init`.

Terraform cannot create the backend bucket using the same configuration that depends on it.

### 1. Create or verify the backend bucket

Make sure this bucket already exists in AWS:

```text
sagarmunish-bucket-demo-backend
```

It should be in:

```text
us-east-2
```

### 2. Move into the backend folder

```bash
cd backend
```

### 3. Initialize Terraform with the backend

```bash
terraform init
```

During initialization, Terraform will connect to the remote S3 backend and use it to store the state file.

### 4. Review the plan

```bash
terraform plan
```

### 5. Apply the configuration

```bash
terraform apply
```

Type `yes` when prompted.

This creates the same kind of S3 bucket as in `learntf/`, but the Terraform state is now stored remotely in S3.

### 6. Destroy the resources when finished

```bash
terraform destroy
```

## Configuration Notes

- The AWS provider region in both examples is set to `eu-west-1`.
- The remote backend bucket is configured in `us-east-2`.
- This means your infrastructure bucket and your Terraform state bucket are in different AWS regions, which is allowed.

## Files Explained

### `learntf/providers.tf`

Defines:

- Terraform version constraint
- Required providers
- AWS provider region

### `learntf/s3.tf`

Defines:

- A `random_id` resource
- An `aws_s3_bucket` resource
- A bucket name output

### `backend/providers.tf`

Defines:

- Terraform version constraint
- Required providers
- S3 backend configuration
- AWS provider region

### `backend/s3.tf`

Defines the same bucket resources as the local example, but uses remote state because of the backend configuration.

### `learntf/hcl.tf`

This file currently exists as an extra placeholder and does not contain any configuration yet.

## Useful Terraform Commands

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Recommended Learning Flow

Follow this order:

1. Start with `learntf/`
2. Understand `terraform init`, `plan`, `apply`, and `destroy`
3. Review the generated local state behavior
4. Move to `backend/`
5. Learn how remote backend configuration changes state management

## Summary

This project is a simple foundation for learning Terraform on AWS. It helps you understand:

- How to define providers and resources
- How to generate unique names dynamically
- How Terraform outputs work
- The difference between local state and remote state in S3

As a next step, you could extend this project by adding:

- Versioned backend state
- DynamoDB state locking
- Variables and `terraform.tfvars`
- Separate environments such as `dev` and `prod`
