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
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id =  data.aws_ssm_parameter.bastion_id.value #bastion host
  security_group_id        = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}

resource "aws_security_group_rule" "bastion_laptop" {
  #creating security rule in backend_alb - where we are attaching sg of bastion host
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = data.aws_ssm_parameter.bastion_id.value #bastion host
}