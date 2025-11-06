# resource "aws_security_group_rule" "frontend_backend-alb" {
#   #creating security rule in frontend - where we are attaching sg of frontend alb
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = module.catalogue[5].sg_id #frontend_alb
#   security_group_id        = module.catalogue[6].sg_id #frontend
# }

resource "aws_security_group_rule" "backend-alb_bastion" {
  #backen-alb acceptiong connection from bastion on port number 80
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = data.aws_ssm_parameter.bastion_id.value        #bastion host
  security_group_id        = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}

resource "aws_security_group_rule" "bastion_laptop" {
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_ssm_parameter.bastion_id.value #bastion host
}

resource "aws_security_group_rule" "mongodb_bastion" {
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  #mongodb accepting ssh conection from bastion
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.bastion_id.value #bastion host
  security_group_id        = data.aws_ssm_parameter.mongodb_id.value
}

resource "aws_security_group_rule" "redis_bastion" {
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  #mongodb accepting ssh conection from bastion
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.bastion_id.value #bastion host
  security_group_id        = data.aws_ssm_parameter.redis_id.value
}
resource "aws_security_group_rule" "rabbitmq_bastion" {
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  #mongodb accepting ssh conection from bastion
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.bastion_id.value #bastion host
  security_group_id        = data.aws_ssm_parameter.rabbitmq_id.value
}

resource "aws_security_group_rule" "mysql_bastion" {
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  #mongodb accepting ssh conection from bastion
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.bastion_id.value #bastion host
  security_group_id        = data.aws_ssm_parameter.mysql_id.value
}


#catalogue instance accepting traffic from bastion 

resource "aws_security_group_rule" "catalogue_bastion" {

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.bastion_id.value #bastion host
  security_group_id        = data.aws_ssm_parameter.catalogue_id.value
}

#mongodb accepting connection from catalogue from port 27017

resource "aws_security_group_rule" "mongodb_catalogue" {

  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.catalogue_id.value
  security_group_id        = data.aws_ssm_parameter.mongodb_id.value
}