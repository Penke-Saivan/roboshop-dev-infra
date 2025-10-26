data "aws_ami" "ami" {

  most_recent = true

  owners = ["973714476881"] #Owner ID

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "bastion_id" {
  name = "/${var.project}/${var.environment}/bastion_sg-id"
}
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/subnet-id"
}
