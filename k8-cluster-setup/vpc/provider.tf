terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "mounika-tf-remote-state-prod"
    key = "vpc"
    region = "us-east-1"
    dynamodb_table = "mounika-tf-remote-state-prod"

  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}