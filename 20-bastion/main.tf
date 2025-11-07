resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_id.value]
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name
  user_data              = file("bastion.sh")
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- bastion" }
  )
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion"
  role = "BastionTerraformAdministrator"
}
