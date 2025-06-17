variable "bucket_name" {
  default = null
}
variable "acl" {
  default = null
}
variable "object_ownership" {
  default = null
}
variable "versioning" {
  default = null
}
variable "block_public_acls" {
  default = null
}
variable "ignore_public_acls" {
  default = null
}
variable "block_public_policy" {
  default = null
}
variable "restrict_public_buckets" {
  default = null
}
variable "lifecycle_rule" {
  default = null
}
variable "tags" {
  type   = map(string)
}
