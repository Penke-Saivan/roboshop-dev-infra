#-----------Created the instance----------------
resource "aws_instance" "catalogue" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id              = local.database_subnet_id
  #   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]


  tags = merge(local.common_tags,
  { Name = "${local.common_name_suffix}- catalogue" })
}

# terraform taint terraform_data.bootstrap
# Resource instance terraform_data.bootstrap has been marked as tainted.

#----------------Configured using Ansible--------------------
resource "terraform_data" "catalogue" {


  triggers_replace = [
    aws_instance.catalogue.id #dependent on instaNCE creation
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  #Provisioner used to copy files or directories from the machine executing Terraform to the newly created resource.
  #how to copy a file from terraform to ec2


  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

#------------Now next step is stop the instance before taking AMI ---------------------

resource "aws_ec2_instance_state" "stop_catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on  = [terraform_data.catalogue] #explicitly telling to run after the resource in []
}


#------Taking AMI out of catalogue instance ID-------------
resource "aws_ami_from_instance" "take_catalogue_ami" {
  name               = "${local.common_name_suffix}-Catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on         = [aws_ec2_instance_state.stop_catalogue] #explicitly telling to run after the resource in []

  tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- catalogue-ami" }
  )
}


#Now creating Traget Group

resource "aws_lb_target_group" "catalogue" {
  name                 = "${local.common_name_suffix}-catalogue"
  port                 = 8080
  deregistration_delay = 60 #like a notice period as he has to compleete his current roles' responsibilities

  #  (May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    path = "/health"
    port = 8080
    # The port the load balancer uses when performing health checks on targets. Valid values are either traffic-port, to use the same port as the target group, or a valid port number between 1 and 65536. Default is traffic-port.
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 10
    matcher             = "200-299"

    # The HTTP or gRPC codes to use when checking for a successful response from a target. The health_check.protocol must be one of HTTP or HTTPS or the target_type must be lambda. Values can be comma-separated individual values (e.g., "200,202") or a range of values (e.g., "200-299").
  }
}


#AWS LAunch Templete Terraform

resource "aws_launch_template" "catalogue" {
  name                                 = "${local.common_name_suffix}-catalogue"
  image_id                             = aws_ami_from_instance.take_catalogue_ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  vpc_security_group_ids               = [local.catalogue_sg_id]
  update_default_version               = true
  tag_specifications {
    #tags attached to the instance
    resource_type = "instance"
    tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- catalogue" })
  }
  tag_specifications {
    #tags attached to the volume created by the instance
    resource_type = "volume"
    tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- catalogue" })
  }

  #tags attached to the Launch template
  tags = merge(local.common_tags,
  { Name = "${local.common_name_suffix}- catalogue" })
}


#Autoscaling group

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name_suffix}- catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  #Number of Amazon EC2 instances that should be running in the group
  force_delete = false
  #instead of placement group - target group
  #launch template
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }


  vpc_zone_identifier = local.private_subnet_ids #array of private subnets

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 #atleast 50% of instances should be up
    }
    triggers = ["launch_template"]
  }

  dynamic "tag" {

    #we get the iterationr with name as tag
    for_each = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- catalogue" })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }


  }


  timeouts {
    delete = "15m"
  }
  target_group_arns = [aws_lb_target_group.catalogue.arn]
  # Set of aws_alb_target_group ARNs, for use with Application or Network Load Balancing. To remove all target group attachments an empty list should be specified.

}


#Autoscaling policy

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${local.common_name_suffix}- catalogue"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}


resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }



  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.zone_name}"]
    }
  }
}

resource "terraform_data" "catalogue_local_exec" {


  triggers_replace = [
    aws_instance.catalogue.id #dependent on instaNCE creation
  ]

  depends_on = [aws_autoscaling_policy.catalogue]

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }
}
