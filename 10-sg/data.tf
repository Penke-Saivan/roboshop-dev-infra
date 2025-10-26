data "aws_ssm_parameter" "vpc_through_ssm" {
  name = "/${var.project}/${var.environment}/vpc-id"
}
