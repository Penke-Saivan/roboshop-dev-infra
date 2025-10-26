resource "aws_ssm_parameter" "foo" {
  name  = "/${var.project}/${var.environment}/vpc-id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}/${var.environment}/subnet-id"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

# stored public net is'd in the form of string list separated by comma
