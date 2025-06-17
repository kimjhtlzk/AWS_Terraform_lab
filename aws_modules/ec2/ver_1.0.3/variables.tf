# variable "key_pair_name" {
#   default = null
# }
variable "vpc" {
  default = null
}
variable "ec2_name" {
  default = null
}
variable "ami" {
  default = null
}
variable "instance_type" {
  default = null
}
variable "availability_zone" {
  default = null
}
variable "subnet" {
  default = null
}
variable "private_ip" {
  default = null
}
variable "associate_public_ip_address" {
  default = null
}
variable "security_groups" {
  type    = list(string)
  default = []
}
# variable "cpu_options" {
#   default = null
# }
variable "spot_options" {
  default = null
}
variable "root_ebs" {
  default = null
}
variable "add_ebs" {
  type = map(object({
    add_ebs_size = number
    add_ebs_type = string
    add_ebs_path = string
    iops         = string
    throughput   = string
    snapshot_id  = string
  }))
}
variable "disable_api_termination" {
  default = null
}
variable "iam_instance_profile" {
  default = null
}
variable "windows_user_data" {
  description = "User data script for Windows instances"
  type        = string
  default     = <<-EOF
    <powershell>
    $token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT -Uri http://169.254.169.254/latest/api/token
    try {
        $instanceName = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri http://169.254.169.254/latest/meta-data/tags/instance/Name -UseBasicParsing
        Rename-Computer -NewName $instanceName -Restart -ErrorAction Stop -force
    } catch {
        $_.Exception.Message | Out-File -FilePath C:\error_log.txt
    }
    </powershell>
  EOF
}
variable "linux_user_data" {
  description = "User data script for Linux instances"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/50-cloud-init.conf
    userdel -r rocky
    systemctl restart sshd
    TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    NAME_TAG=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Name`
    hostnamectl set-hostname $NAME_TAG.com2us.kr
    sed -i "1 i\HOSTNAME=$NAME_TAG" /etc/sysconfig/network
  EOF
}
variable "tags" {
  type   = map(string)
}

variable "metadata_options" {
  description = "Metadata options for EC2 instance"
  type = object({
    http_endpoint           = string
    instance_metadata_tags  = string
    http_tokens             = string
  })
  default = {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
    http_tokens            = "required"
  }
}