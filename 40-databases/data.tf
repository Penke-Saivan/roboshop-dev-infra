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

data "aws_ssm_parameter" "mongodb_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg-id"
}
data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project}/${var.environment}/database_subnet_ids"

}
