terraform {
  required_version = "v1.1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "talento-development-terraform-backend"
    key            = "kubernetes-cluster.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    profile        = "development"
    dynamodb_table = "terraform-state-lock"
  }
}