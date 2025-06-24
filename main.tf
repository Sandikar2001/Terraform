module "vpc" {
  source             = "./modules/VPC"
  aws_project        = var.aws_project
  env                = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  app_subnet_cidr    = var.app_subnet_cidr
  db_subnet_cidr     = var.db_subnet_cidr
}

module "ec2" {
  source      = "./modules/EC2"
  aws_project = var.aws_project
  env         = var.environment
  ec2_instances = {
    for name, inst in var.ec2_instance_base :
    name => {
      ami           = inst.ami
      instance_type = inst.instance_type
      key_name      = inst.key_name
      subnet_id = (
        inst.subnet_group == "public" ? module.vpc.public_subnet_ids[inst.subnet_key] :
        inst.subnet_group == "app" ? module.vpc.app_subnet_ids[inst.subnet_key] :
        inst.subnet_group == "db" ? module.vpc.db_subnet_ids[inst.subnet_key] :
        null
      )
      tags = inst.tags
      assign_eip  = inst.assign_eip
    }
  }
  source_alb_sg_id = module.app_alb.alb_security_group_id
  sg_egress         = var.sg_egress
  sg_ingress        = var.sg_ingress
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "elb" {
  source = "./modules/ELB"
  vpc_id = module.vpc.vpc_id
  subnet_ids = values(module.vpc.public_subnet_ids)
  aws_project = var.aws_project
  destination_sg_ids = module.ec2.instance_security_group_ids["web1"]
  target_instance_ids = module.ec2.instance_ids["web1"]
  primary_instance_name = var.alb_instance_name
}