resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]

user_data = file("bastion.sh")
  tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- bastion" }
  )
}
