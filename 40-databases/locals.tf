locals {
  common_name = "${var.project}- ${var.environment}"
  # vpc_id      = data.aws_ssm_parameter.vpc_id.value
  mongodb_sg_id= data.aws_ssm_parameter.mongodb_id.value
  database_subnet_id= split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
    common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = true
  }
  common_name_suffix = "${var.project}-${var.environment}"
}
