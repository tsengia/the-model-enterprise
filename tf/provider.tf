terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    backend "s3" {
        bucket = var.state_s3_bucket_name
        key = var.state_s3_bucket_key
        region = var.aws_region
    }

    required_version = ">=1.7"
}

provider "aws" {
    region = var.aws_region
}