data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}
data "aws_ssm_parameter" "bastion_id" {
  name = "/${var.project}/${var.environment}/bastion_sg-id"
}
data "aws_ssm_parameter" "backend-alb_sg-id" {
  name = "/${var.project}/${var.environment}/backend_alb_sg-id" #/roboshop/dev/backend-alb_sg-id
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}