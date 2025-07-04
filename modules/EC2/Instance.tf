resource "aws_instance" "ec2" {
  for_each = var.ec2_instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  key_name               = each.value.key_name
  associate_public_ip_address = try(each.value.associate_public_ip_address, false)
  vpc_security_group_ids = [aws_security_group.ec2_sg[each.key].id]
  dynamic "root_block_device" {
    # This for_each is a bit complex, let's simplify it.
    # We'll create a list containing our object if it exists, or an empty list if it doesn't.
    for_each = try([each.value.root_block_device], [])

    content {
      # Use the dynamic block's iterator: `root_block_device.value`
      volume_size = root_block_device.value.volume_size
      volume_type = root_block_device.value.volume_type
    }
  }

  # --- CORRECTED EBS Block Devices ---
  dynamic "ebs_block_device" {
    for_each = try(each.value.ebs_block_devices, {})

    content {
      # Use the dynamic block's iterator: `ebs_block_device`
      # `ebs_block_device.key` is the device name (e.g., "/dev/sdf")
      device_name = ebs_block_device.key

      # `ebs_block_device.value` is the configuration object
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      tags        = try(ebs_block_device.value.tags, {})
      delete_on_termination = true
    }
  }


  tags = merge(
    {
      Name = "${var.aws_project}-${var.env}-${each.key}"
    },
    each.value.tags
  )
}


