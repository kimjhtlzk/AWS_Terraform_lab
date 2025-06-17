resource "aws_route_table" "route_table" {
    tags = {
        Name = var.route_table_name
    }

    vpc_id = var.vpc

    dynamic "route" {
        for_each = var.rule
        content {
            cidr_block                = route.value.cidr_block
            nat_gateway_id            = route.value.resource_type == "ngw" ? route.value.resource_id : null
            gateway_id                = route.value.resource_type == "igw" ? route.value.resource_id : null
            vpc_peering_connection_id = route.value.resource_type == "peering" ? route.value.resource_id : null
        }
    }

}

resource "aws_route_table_association" "route_table_att" {
  count           = length(var.asso_subnets)
  
  subnet_id       = var.asso_subnets[count.index]
  route_table_id  = aws_route_table.route_table.id
}