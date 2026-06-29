variable "aws_region" {
  description = "aws region resource"
  type        = string
  default     = "us-east-2"

}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name used for resource tags"
  type        = string
  default     = "my-first-vpc"
}
