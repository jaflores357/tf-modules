data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                                   = var.vpc_name
  cidr                                   = var.vpc_cidr
  azs                                    = data.aws_availability_zones.available.names
  private_subnets                        = var.vpc_private_subnets_cidr
  public_subnets                         = var.vpc_public_subnets_cidr
  enable_nat_gateway                     = true
  single_nat_gateway                     = true
  enable_dns_hostnames                   = true
  //enable_ecr_dkr_endpoint              = true
  //ecr_dkr_endpoint_private_dns_enabled = true
  //ecr_dkr_endpoint_security_group_ids  = [aws_security_group.vpc_endpoint.id]
  enable_s3_endpoint                     = true

  public_subnet_tags = merge(
      var.tags,
      local.module_tags,
      map("Type","public")
  )

  private_subnet_tags = merge(
      var.tags,
      local.module_tags,
      map("Type", "private")
  )

  vpc_tags = merge(
      var.tags,
      local.module_tags,
      map("Name", var.vpc_name)
  )
}