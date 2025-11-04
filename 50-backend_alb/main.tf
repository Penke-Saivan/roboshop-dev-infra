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