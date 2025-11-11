data "aws_ssm_parameter" "backend-alb_sg-id" {
  name = "/${var.project}/${var.environment}/backend-alb_sg-id" #/roboshop/dev/backend-alb_sg-id
}

data "aws_ssm_parameter" "frontend-alb_sg-id" {
  name = "/${var.project}/${var.environment}/frontend-lb_sg-id" #/roboshop/dev/backend-alb_sg-id
}
data "aws_ssm_parameter" "bastion_id" {
  name = "/${var.project}/${var.environment}/bastion_sg-id"
}

data "aws_ssm_parameter" "mongodb_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg-id"
}

data "aws_ssm_parameter" "redis_id" {
  name = "/${var.project}/${var.environment}/redis_sg-id"
}

data "aws_ssm_parameter" "mysql_id" {
  name = "/${var.project}/${var.environment}/mysql_sg-id"
}

data "aws_ssm_parameter" "rabbitmq_id" {
  name = "/${var.project}/${var.environment}/rabbitmq_sg-id"
}


data "aws_ssm_parameter" "catalogue_id" {
  name = "/${var.project}/${var.environment}/catalogue_sg-id"
}
