resource "aws_lb" "frontend_alb" {
  name               = "${local.common_name_suffix}-Frontend-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.frontend-alb_sg-id.value]
  subnets            = local.public_subnets_array

  enable_deletion_protection = false #prevents accidental deletion from UI or anywhere



  tags = merge(
    var.backend_tags,
    local.common_tags,
    {
      Name = "${local.common_name_suffix}-Frontend-ALB-Resource"
    }
  )
}

resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  certificate_arn   = data.aws_ssm_parameter.frontend_alb_certificate_arn.value

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "<h1> I am from HTTPS frontend-alb</h1>"
      status_code  = "200"
    }
  }
}


#Creating Route 53 reord for frontend alb

resource "aws_route53_record" "frontend_alb" {
  zone_id         = var.zone_id
  name            = "roboshop-${var.environment}.${var.zone_name}"
  type            = "A"
  allow_overwrite = true

  alias {
    #these are realted to alb not our domain details
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}


