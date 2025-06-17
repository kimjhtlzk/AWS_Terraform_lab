variable "nlb_name" {
  default = null
}
variable "lb_type" {
  default = null
}
variable "idle_timeout" {
  default = null
}
variable "security_groups" {
  default = null
}
variable "subnet" {
  default = null
}
variable "private_ip" {
  default = null
}
variable "listener" {
  default = null
}
variable "tags" {
  type   = map(string)
}