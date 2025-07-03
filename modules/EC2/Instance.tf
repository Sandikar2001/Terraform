resource "aws_instance" "ec2" {
  for_each = var.ec2_instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  key_name               = each.value.key_name
  associate_public_ip_address = try(each.value.associate_public_ip_address, false)
  vpc_security_group_ids = [aws_security_group.ec2_sg[each.key].id]
  dynamic "root_block_device" {
    # This loop runs ONCE if the root_block_device object exists for the instance.
    for_each = try(each.value.root_block_device, null) != null ? [1] : []

    content {
      # We reference the attributes from the object in our tfvars.
      volume_size = each.value.root_block_device.volume_size
      volume_type = each.value.root_block_device.volume_type
      # You can also add iops, throughput, etc. here if using io1/io2/gp3
    }
  }

  # --- NEW: Dynamic EBS Block Devices for Data ---
  dynamic "ebs_block_device" {
    # This loops over the MAP of ebs_block_devices we defined.
    # The iterator will be 'ebs_block_device'.
    for_each = try(each.value.ebs_block_devices, {})

    content {
      # ebs_block_device.key is the device name (e.g., "/dev/sdf")
      device_name = ebs_block_device.key

      # ebs_block_device.value contains the configuration object
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      tags        = try(ebs_block_device.value.tags, {})
      
      # Important for data volumes: ensure they are deleted when the instance is terminated.
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


