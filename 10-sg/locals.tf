locals {
  common_name = "${var.project}- ${var.environment}"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
}
