resource "aws_ssm_parameter" "foo" {
  name  = "/${var.project}/${var.environment}/vpc-id"
  type  = "String"
  value = module.vpc.vpc_id
}
