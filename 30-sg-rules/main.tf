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
resource "aws_security_group_rule" "backend-alb_frontend" {
  #backen-alb acceptiong connection from frontend through 80
  
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = data.aws_ssm_parameter.frontend_id.value       
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

#mongodb accepting connection from user from port 27017

resource "aws_security_group_rule" "mongodb_user" {

  type      = "ingress"
  from_port = 27017
  to_port   = 27017
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.user_id.value
  security_group_id        = data.aws_ssm_parameter.mongodb_id.value
}

#redis accepting connection from user from port 6379

resource "aws_security_group_rule" "redis_user" {

  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.user_id.value
  security_group_id        = data.aws_ssm_parameter.redis_id.value
}

#redis accepting connection from cart from port 6379

resource "aws_security_group_rule" "redis_cart" {

  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.cart_id.value
  security_group_id        = data.aws_ssm_parameter.redis_id.value
}

#mysql accepting connection from shipping from port 3306

resource "aws_security_group_rule" "mysql_shipping" {

  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.shipping_id.value
  security_group_id        = data.aws_ssm_parameter.mysql_id.value
}

#rabbitmq accepting connection from payment from port 5672

resource "aws_security_group_rule" "rabbitmq_payment" {

  type      = "ingress"
  from_port = 5672
  to_port   = 5672
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  source_security_group_id = data.aws_ssm_parameter.payment_id.value
  security_group_id        = data.aws_ssm_parameter.rabbitmq_id.value
}
# Every backend should accept traffic from Backend ALB by open the port 8080

resource "aws_security_group_rule" "catalogue_backend_alb" {
  #catalogue accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.catalogue_id.value
  source_security_group_id = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}
resource "aws_security_group_rule" "catalogue_cart" {
  #catalogue accepting traffic from cart through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.catalogue_id.value
  source_security_group_id = data.aws_ssm_parameter.cart_id.value
}

resource "aws_security_group_rule" "user_backend_alb" {
  #User accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.user_id.value
  source_security_group_id = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}
resource "aws_security_group_rule" "cart_backend_alb" {
  #Cart accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.cart_id.value
  source_security_group_id = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}
resource "aws_security_group_rule" "cart_shipping" {
  #Cart accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.cart_id.value
  source_security_group_id = data.aws_ssm_parameter.shipping_id.value #backend_alb 
}

resource "aws_security_group_rule" "cart_payment" {
  #Cart accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.cart_id.value
  source_security_group_id = data.aws_ssm_parameter.payment_id.value #backend_alb 
}
resource "aws_security_group_rule" "user_payment" {
  #Cart accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.user_id.value
  source_security_group_id = data.aws_ssm_parameter.payment_id.value #backend_alb 
}


resource "aws_security_group_rule" "shipping_backend_alb" {
  #shipping accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.shipping_id.value
  source_security_group_id = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}
resource "aws_security_group_rule" "payment_backend_alb" {
  #payment accepting traffic from baxkend alb through port 8080
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = data.aws_ssm_parameter.payment_id.value
  source_security_group_id = data.aws_ssm_parameter.backend-alb_sg-id.value #backend_alb 
}

resource "aws_security_group_rule" "frontend_alb_public" {
  #frontend_alb accepting traffic from public through 443
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = data.aws_ssm_parameter.frontend-alb_sg-id.value
  cidr_blocks  = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  #frontend_alb accepting traffic from public through 443
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = data.aws_ssm_parameter.frontend_id.value
  source_security_group_id = data.aws_ssm_parameter.frontend-alb_sg-id.value
}