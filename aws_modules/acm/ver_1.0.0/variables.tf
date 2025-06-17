variable "cert_name" {
  default = null
}
variable "certificate_body" {
  default = null
}
variable "private_key" {
  default = null
}
variable "certificate_chain" {
  default = null
}
variable "tags" {
  type   = map(string)
}