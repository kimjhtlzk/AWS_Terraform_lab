module "version" {
  source = "i-gitlab.c.com/common/aws/version"
}

terraform {
    backend "http" {}
}

locals {
    project_map_tag = {
        map-migrated = "terraform"
    }
}

#===========================미국동부===========================
provider "aws" {  # 미국동부 (버지니아 북부) -> virginia
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "virginia"
    region      = "us-east-1"
    profile    = "asdasd"
}
provider "aws" {  # 미국동부 (오하이오) -> ohio
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "ohio"
    region      = "us-east-2"
    profile    = "asdasd"
}
#===========================미국서부===========================
provider "aws" {  # 미국서부 (캘리포니아) -> california
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "california"
    region      = "us-west-1"
    profile    = "asdasd"
}
provider "aws" {  # 미국서부 (오레곤) -> oregon
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "oregon"
    region      = "us-west-2"
    profile    = "asdasd"
}
#===========================아시아태평양===========================
provider "aws" {  # 아시아태평양 (도쿄) -> tokyo
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "tokyo"
    region      = "ap-northeast-1"
    profile    = "asdasd"
}
provider "aws" {  # 아시아태평양 (서울) -> seoul
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "seoul"
    region      = "ap-northeast-2"
    profile    = "asdasd"
}
provider "aws" {  # 아시아태평양 (오사카) -> osaka
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "osaka"
    region      = "ap-northeast-3"
    profile    = "asdasd"
}
provider "aws" {  # 아시아태평양 (싱가포르) -> singapore
    access_key = "*************************"
    secret_key = "*************************"
    alias       = "singapore"
    region      = "ap-southeast-1"
    profile    = "asdasd"
}
provider "aws" {  # 아시아태평양 (시드니) -> sydney
    access_key = "AKIAYBNIRXVV2CNO7JWU"
    secret_key = "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"
    alias       = "sydney"
    region      = "ap-southeast-2"
    profile    = "asdasd"
}
provider "aws" {  # 아시아태평양 (뭄바이) -> mumbai
    access_key = "AKIAYBNIRXVV2CNO7JWU"
    secret_key = "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"
    alias       = "mumbai"
    region      = "ap-south-1"
    profile    = "asdasd"
}
#===========================유럽===========================
provider "aws" {  # 유럽 (프랑크푸르트) -> frank
    access_key = "*************************"
    secret_key = "*************************"
    alias      = "frank"
    region     = "eu-central-1"
    profile    = "asdasd"
}
provider "aws" {  # 유럽 (아일랜드) -> ireland
    access_key = "*************************"
    secret_key = "*************************"
    alias      = "ireland"
    region     = "eu-west-1"
    profile    = "asdasd"
}
provider "aws" {  # 유럽 (런던) -> london
    access_key = "*************************"
    secret_key = "*************************"
    alias      = "london"
    region     = "eu-west-2"
    profile    = "asdasd"
}
provider "aws" {  # 유럽 (파리) -> paris
    access_key = "*************************"
    secret_key = "*************************"
    alias      = "paris"
    region     = "eu-west-3"
    profile    = "asdasd"
}
provider "aws" {  # 유럽 (스톡홀름) -> stockholm
    access_key = "*************************"
    secret_key = "*************************"
    alias      = "stockholm"
    region     = "eu-north-1"
    profile    = "asdasd"
}
#===========================남아메리카===========================
provider "aws" {  # 남아메리카 (상파울루) -> saopaulo
    access_key = "*************************"
    secret_key = "*************************"
    alias      = "saopaulo"
    region     = "sa-east-1"
    profile    = "asdasd"
}

