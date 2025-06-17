resource "aws_nat_gateway" "ngw" {
  tags = {
    Name = var.ngw_name
  }

  allocation_id     = var.eip == "true" ? aws_eip.eip[0].id : var.eip
  subnet_id         = var.subnet[0]
  private_ip        = var.private_ip
  connectivity_type = "public"

  depends_on        = [aws_eip.eip]
}

resource "aws_eip" "eip" {
    count = var.eip == "true" ? 1 : 0

    tags = {
        Name = "eip-${var.ngw_name}-ngw"
    }
    domain  = "vpc"   # 고정값
}

# data "aws_eip" "eip" {
#   count = var.eip != "true" ? 1 : 0

#   tags = {
#     Name = var.eip
#   }
# }

# -----------------------------------------------
# resource "aws_route_table" "route_table" {
#   tags = {
#     Name = "${var.ngw_name}-route"
#   }

#   vpc_id = var.vpc

#   route {
#     cidr_block      = var.rt_table_cidr
#     nat_gateway_id  = aws_nat_gateway.ngw.id
#   }

#   depends_on = [ aws_nat_gateway.ngw ]
# }

# resource "aws_route_table_association" "route_table_att" {
#   for_each = toset(var.join_subnet)

#   route_table_id  = aws_route_table.route_table.id
#   subnet_id       = each.value
# }
