data "aws_ami" "ami" {
  name_regex   = var.ami
  most_recent  = true
}

resource "aws_instance" "ec2" {
    tags = merge(
        {
            Name = var.ec2_name
        },
        try(var.tags, {})
    ) 
    ami                           = data.aws_ami.ami.id
    instance_type                 = var.instance_type
    availability_zone             = var.availability_zone

    iam_instance_profile          = var.iam_instance_profile
    
    network_interface {
        network_interface_id = aws_network_interface.nic.id
        device_index         = 0
    }

    root_block_device {
        tags = merge(
            {
                Name = var.ec2_name
            },
            try(var.tags, {})
        ) 
        volume_type           = var.root_ebs.root_ebs_type
        volume_size           = var.root_ebs.root_ebs_size
        delete_on_termination = var.root_ebs.delete_on_termination
        encrypted             = true    # 볼륨 암호화 여부
    }

    maintenance_options {
        auto_recovery = "default"
    }

    hibernation             = false # 절전모드
    disable_api_stop        = false # 중지방지
    disable_api_termination = var.disable_api_termination  # 종료방지

    dynamic "instance_market_options" {
        for_each = try(var.spot_options != null && var.spot_options.use_spot == true ? [1] : [], [])  # try로 null 처리 및 조건에 따라 빈 리스트 반환
        content {
            market_type                         = "spot"
            spot_options {
                instance_interruption_behavior  = var.spot_options.instance_interruption_behavior
                spot_instance_type              = var.spot_options.spot_instance_type
                max_price                       = var.spot_options.max_price
            }
        }
    }

    # key_name = data.aws_key_pair.key_pair.key_name

    # metadata service enable
    metadata_options {
        http_endpoint           = var.metadata_options.http_endpoint
        instance_metadata_tags  = var.metadata_options.instance_metadata_tags
        http_tokens             = var.metadata_options.http_tokens
    }

    # platform_details값을 통한 OS 구분
    # OS 별 userdata 값 적용
    user_data = startswith(data.aws_ami.ami.platform_details, "Windows") ? var.windows_user_data : (startswith(data.aws_ami.ami.platform_details, "Linux") ? var.linux_user_data : null)

    # user_data 중복 실행 방지
    lifecycle {
        ignore_changes = [ user_data, ami ]
    }

}

# -----------------------------------------------------------------------

resource "aws_network_interface" "nic" {
    tags = {
        Name = "nic-${var.ec2_name}"
    }
    subnet_id       = var.subnet
    private_ips     = [var.private_ip]
    security_groups = var.security_groups != null ? var.security_groups : null
}

resource "aws_eip" "eip" {
    count = var.associate_public_ip_address == "true" ? 1 : 0

    tags = {
        Name = "eip-${var.ec2_name}"
    }
    network_interface   = aws_network_interface.nic.id
    domain              = "vpc"   # 고정값

    depends_on = [aws_instance.ec2]
}

# data "aws_eip" "data_eip" {
#     count = var.associate_public_ip_address != "true" && var.associate_public_ip_address != "false" ? 1 : 0

#     tags = { Name = var.associate_public_ip_address }
# }

resource "aws_eip_association" "eip_att" {
    count = var.associate_public_ip_address != "true" && var.associate_public_ip_address != "false" ? 1 : 0
    
    network_interface_id = aws_network_interface.nic.id
    allocation_id        = var.associate_public_ip_address
}


# -----------------------------------------------------------------------

resource "aws_ebs_volume" "ebs" {
    for_each    = var.add_ebs

    tags = merge(
        {
            Name = "${var.ec2_name}-${each.key}"
        },
        try(var.tags, {})
    )     
    availability_zone = aws_instance.ec2.availability_zone
    size              = each.value.add_ebs_size
    type              = each.value.add_ebs_type
    iops              = each.value.iops
    throughput        = each.value.throughput
    snapshot_id       = each.value.snapshot_id != "null" ? each.value.snapshot_id : null
}

resource "aws_volume_attachment" "ebs_att" {
    for_each    = var.add_ebs

    device_name = each.value.add_ebs_path
    volume_id   = aws_ebs_volume.ebs[each.key].id
    instance_id = aws_instance.ec2.id
}

# -----------------------------------------------------------------------

# data "aws_key_pair" "key_pair" {
#   key_name           = var.key_pair_name
#   include_public_key = true
# }
