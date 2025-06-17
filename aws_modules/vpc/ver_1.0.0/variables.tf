variable "vpc_name" {
  default = null
}
variable "cidr_block" {
  default = null
}
variable "instance_tenancy" {
  default = null
}
variable "use_ipv6_cidr_block" {
  default = null
}
variable "subnets" {
  type = list(object({
    subnet_name         = string
    subnet_cidr         = string
    ipv6_cidr_block     = string
    availability_zone   = string
    autoassign_public   = string
    tags                = map(string)
  }))
  default = []
}
variable "tags" {
  default = null
}
