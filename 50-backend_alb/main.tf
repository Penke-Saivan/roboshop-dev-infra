resource "aws_lb" "backend_alb" {
  name               = "${local.common_name_suffix}-Backend-ALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.backend-alb_sg-id.value]
  subnets            = local.private_subnets_array

  enable_deletion_protection = false #prevents accidental deletion from UI or anywhere



  tags = merge(
    var.backend_tags,
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-Backend-ALB-Resource"
    }
  )
}


resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi I am from Backend ALB HTTP Fixed response content"
      status_code  = "200"
    }
  }
}


#Creating Route 53 reord for backend alb

resource "aws_route53_record" "backend-alb" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.zone_name}"
  type    = "A"

  alias {
    #these are realted to alb not our domain details
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}
