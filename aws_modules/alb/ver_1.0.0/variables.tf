variable "alb_name" {
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
variable "cross_zone_subnet" {
  default = null
}
variable "listener" {
  default = null
}
variable "certificate" {
  default = null
}
variable "tags" {
  type   = map(string)
}
