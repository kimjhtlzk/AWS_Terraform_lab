resource "aws_cloud9_environment_ec2" "cloud9_env" {
    name          = var.cloud9_name
    instance_type = var.cloud9_size
    subnet_id     = var.subnet
    image_id      = var.image
}

data "aws_instance" "cloud9_instance" {
    filter {
        name = "tag:aws:cloud9:environment"
        values = [
        aws_cloud9_environment_ec2.cloud9_env.id]
    }
}

resource "aws_eip" "eip" {
    domain              = "vpc"   # 고정값
    tags = {
        Name = "eip-${var.cloud9_name}"
    }
    instance = data.aws_instance.cloud9_instance.id

    depends_on = [data.aws_instance.cloud9_instance]
}

resource "aws_cloud9_environment_membership" "cloud9_membership" {
    count           = length(var.permissions_user)
    environment_id  = aws_cloud9_environment_ec2.cloud9_env.id
    permissions     = "read-write"
    user_arn        = var.permissions_user[count.index]
}
