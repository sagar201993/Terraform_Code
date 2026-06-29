terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "sagarmunish-bucket-demo-backend"
    key    = "state.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "eu-west-1"
}
