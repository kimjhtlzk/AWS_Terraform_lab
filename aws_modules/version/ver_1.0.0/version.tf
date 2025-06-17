terraform {
  required_version = "~> 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }    
  }
  
}
