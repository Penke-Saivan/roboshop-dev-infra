data "aws_ssm_parameter" "backend-alb_sg-id" {
  name = "/${var.project}/${var.environment}/backend-alb_sg-id" #/roboshop/dev/backend-alb_sg-id
}

data "aws_ssm_parameter" "bastion_id" {
  name = "/${var.project}/${var.environment}/bastion_sg-id"
}