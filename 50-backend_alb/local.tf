locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = true
  }
  common_name_suffix = "${var.project}-${var.environment}"
  # vpc_id             = data.aws_ssm_parameter.vpc_id
  subnets_array = split(",", data.aws_ssm_parameter.public_subnet_ids.value) #gives list of strings

}
