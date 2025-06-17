resource "aws_internet_gateway" "igw" {
  tags = {
    Name = var.igw_name
  }
}

resource "aws_internet_gateway_attachment" "igw_att" {
  count = var.vpc != "null" ? 1 : 0

  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = var.vpc
}