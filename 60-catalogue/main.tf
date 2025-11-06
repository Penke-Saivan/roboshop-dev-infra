#-----------Created the instance----------------
resource "aws_instance" "catalogue" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id              = local.database_subnet_id
  #   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]


  tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- mongodb" }



  )
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



