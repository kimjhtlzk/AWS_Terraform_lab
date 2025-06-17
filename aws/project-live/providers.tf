terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.1"
    }    
  }
    backend "http" {}
}

locals {
    project_map_tag = {
        map-migrated = "terraform"
    }
}

#===========================미국동부===========================
provider "aws" {  # 미국동부 (버지니아 북부) -> virginia
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "virginia"
    region      = "us-east-1"
}
provider "aws" {  # 미국동부 (오하이오) -> ohio
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "ohio"
    region      = "us-east-2"
}
#===========================미국서부===========================
provider "aws" {  # 미국서부 (캘리포니아) -> california
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "california"
    region      = "us-west-1"
}
provider "aws" {  # 미국서부 (오레곤) -> oregon
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "oregon"
    region      = "us-west-2"
}
#===========================아시아태평양===========================
provider "aws" {  # 아시아태평양 (도쿄) -> tokyo
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "tokyo"
    region      = "ap-northeast-1"
}
provider "aws" {  # 아시아태평양 (서울) -> seoul
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "seoul"
    region      = "ap-northeast-2"
}
provider "aws" {  # 아시아태평양 (오사카) -> osaka
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "osaka"
    region      = "ap-northeast-3"
}
provider "aws" {  # 아시아태평양 (싱가포르) -> singapore
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "singapore"
    region      = "ap-southeast-1"
}
provider "aws" {  # 아시아태평양 (시드니) -> sydney
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "sydney"
    region      = "ap-southeast-2"
}
provider "aws" {  # 아시아태평양 (뭄바이) -> mumbai
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias       = "mumbai"
    region      = "ap-south-1"
}
#===========================유럽===========================
provider "aws" {  # 유럽 (프랑크푸르트) -> frank
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias      = "frank"
    region     = "eu-central-1"
}
provider "aws" {  # 유럽 (아일랜드) -> ireland
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias      = "ireland"
    region     = "eu-west-1"
}
provider "aws" {  # 유럽 (런던) -> london
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias      = "london"
    region     = "eu-west-2"
}
provider "aws" {  # 유럽 (파리) -> paris
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias      = "paris"
    region     = "eu-west-3"
}
provider "aws" {  # 유럽 (스톡홀름) -> stockholm
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias      = "stockholm"
    region     = "eu-north-1"
}
#===========================남아메리카===========================
provider "aws" {  # 남아메리카 (상파울루) -> saopaulo
    assume_role {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    alias      = "saopaulo"
    region     = "sa-east-1"
}


#===========================아시아태평양===========================
provider "awscc" { 
    assume_role = {
      role_arn    = "arn:aws:iam::*******:role/@owner"
    }
    region      = "ap-northeast-2"
}