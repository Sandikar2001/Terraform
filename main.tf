module "vpc" {
  source             = "./modules/VPC"
  aws_project        = var.aws_project
  env                = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  app_subnet_cidr    = var.app_subnet_cidr
  db_subnet_cidr     = var.db_subnet_cidr
}

locals {
  processed_instances = {
    for name, inst in var.ec2_instance_base :
    name => merge(
      inst,
      {
        subnet_id = (
          inst.subnet_group == "public" ? module.vpc.public_subnet_ids[inst.subnet_key] :
          inst.subnet_group == "app"    ? module.vpc.app_subnet_ids[inst.subnet_key] :
          null
        )
      }
    )
  }
}


module "ec2" {
  source      = "./modules/EC2"
  aws_project = var.aws_project
  env         = var.environment
  ec2_instances = local.processed_instances
  sg_egress         = var.sg_egress
  sg_ingress        = var.sg_ingress
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = values(module.vpc.public_subnet_ids)

  depends_on = [module.vpc]
}


module "rds" {
  source = "./modules/RDS"
  vpc_id = module.vpc.vpc_id
  db_subnets = values(module.vpc.db_subnet_ids)
  aws_project = var.aws_project
  db_name = var.rds_db_name
  env = var.environment
  instance_class = var.rds_instance_class
  engine = var.rds_engine
  engine_version = var.rds_engine_version
  multi_az = var.rds_multi_az
  username = var.rds_user
  password = var.rds_password
  storage = var.rds_storage
}


#RDS SG LOGIC

 locals {
  instances_requiring_db_access = {
    for name, inst in local.processed_instances : name => inst
    if try(inst.connect_to_rds, false) == true
  }
}

resource "aws_security_group_rule" "allow_app_to_db" {
  for_each = local.instances_requiring_db_access

  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.ec2.instance_security_group_ids[each.key]
  source_security_group_id = module.rds.db_security_group_id
  description              = "Allow instance ${each.key} to connect to the RDS database"
}


resource "aws_security_group_rule" "allow_db_from_app" {
  for_each = local.instances_requiring_db_access
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.rds.db_security_group_id
  source_security_group_id = module.ec2.instance_security_group_ids[each.key]
  description              = "Allow RDS to receive connections from instance ${each.key}"
}

module "waf" {
  source = "./modules/WAF"
  environment = var.environment
  aws_project = var.aws_project
  rules = var.waf_rules
  resource_arns_to_associate = values(module.ec2.alb_arns)
}