variable "aws_region" {
    type = string
    default = "us-east-1"
    description = "The AWS region to create and manage resources in."
}

variable "state_s3_bucket_name" {
    type = string
    default = "the-model-enterprise"
    description = "The name of the S3 bucket to store the OpenTofu state in."
}

variable "state_s3_bucket_key" {
  type = string
  default = "opentofu-state"
  description = "The S3 bucket key to the OpenTofu state file."
}

variable "iam_path_prefix" {
  type = string
  default = "TME/"
  description = "The path to place all IAM Groups, Users, and Roles."
}