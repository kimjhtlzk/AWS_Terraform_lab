resource "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }

  cidr_block                        = var.cidr_block
  assign_generated_ipv6_cidr_block  = var.use_ipv6_cidr_block
  instance_tenancy                  = var.instance_tenancy
  enable_dns_hostnames              = true  # vpc 피어링을 위해 true 옵션이 필요함
}

// ipv6를 사용하기 위하여 vpc의 use_ipv6_cidr_block의 값을 true로 생성 시, subnets 의 ipv6_cidr_block 값은 null 값으로 유지한 상태로 실행합니다.
// -> 이후 vpc의 ipv6_cidr_block 리소스가 생성되면 그 값을 그대로 사용하거나
//    적절하게 Subnetting하여 subnets 의 ipv6_cidr_block에 작성 후 실행합니다.
//    ipam 방식 미사용.

resource "aws_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.subnet_name => subnet }

  vpc_id    = aws_vpc.vpc.id

  tags = merge(
    {
      Name = each.value.subnet_name
    },
    {
      for key, value in each.value.tags : key => value
    }
  )

  cidr_block              = each.value.subnet_cidr
  ipv6_cidr_block         = each.value.ipv6_cidr_block == null ? null : each.value.ipv6_cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.autoassign_public == "true" ? true : false
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
    
  tags = {
    Name = "${var.vpc_name}-default-sg" 
  }
    
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
