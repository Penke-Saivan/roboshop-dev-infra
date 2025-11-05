resource "aws_instance" "mongodb" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id              = local.database_subnet_id
  #   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]


  tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}- mongodb" }



  )
}

# terraform taint terraform_data.bootstrap
# Resource instance terraform_data.bootstrap has been marked as tainted.

resource "terraform_data" "mongodb" {


  triggers_replace = [
    aws_instance.mongodb.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  #Provisioner used to copy files or directories from the machine executing Terraform to the newly created resource.
  #how to copy a file from terraform to ec2


  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }
}
# provisioner "remote-exec" {
#  inline = [ "echo Hello world" ]
# }
# Installing Terraform 
# https://developer.hashicorp.com/terraform/install#windows
# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# sudo yum -y install terraform


##--Redis

resource "aws_instance" "redis" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id              = local.database_subnet_id
  #   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]


  tags = merge(local.common_tags,
    { Name = "${local.common_name_suffix}-redis" }



  )
}

resource "terraform_data" "redis" {


  triggers_replace = [
    aws_instance.redis.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }

  #Provisioner used to copy files or directories from the machine executing Terraform to the newly created resource.
  #how to copy a file from terraform to ec2


  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = ["chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
    ]
  }
}