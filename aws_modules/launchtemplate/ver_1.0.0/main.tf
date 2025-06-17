resource "aws_launch_template" "launch_template" {
  name                   = var.launch_template_name
  image_id               = var.image_id
  instance_type          = var.instance_type
  ebs_optimized          = var.ebs_optimized
  update_default_version = var.update_default_version

  dynamic "placement" {
    for_each = var.availability_zone != null ? [1] : []
    content {
      availability_zone = var.availability_zone
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        encrypted             = try(block_device_mappings.value.encrypted, false)
        delete_on_termination = try(block_device_mappings.value.delete_on_termination, true)
      }
    }
  }

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name"        = var.marked_to_ec2_name
    }
  }

  metadata_options {
      http_put_response_hop_limit = var.http_put_response_hop_limit
  }
  
}