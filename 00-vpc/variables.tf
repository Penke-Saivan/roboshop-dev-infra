variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "roboshop"
}

#CIDR - loop creation 
variable "public-subnet-cidr-block" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "database-subnet-cidr-block" {
  type    = list(any)
  default = ["10.0.11.0/24", "10.0.12.0/24"]

}

variable "private-subnet-cidr-block" {
  type    = list(any)
  default = ["10.0.21.0/24", "10.0.22.0/24"]

}
variable "vpc_tags" {
  default = {
    enable_dns_hostnames = "added in module"
    Terraform_User       = true
  }
}

variable "igw_tags" {
  default = {
    added_ref_to_VpcId = true
    Terraform_User     = true
  }
}

variable "public_subnet_tags" {
  default = {
    availability_zone       = "added by slicing the output received from data sourcing - aws_availability_zones"
    Terraform_User          = true
    map_public_ip_on_launch = true
    subnet                  = "public"

  }
}

variable "private_subnet_tags" {
  default = {
    availability_zone       = "added by slicing the output received from data sourcing - aws_availability_zones"
    Terraform_User          = true
    map_public_ip_on_launch = false
    subnet                  = "private"

  }
}

variable "database_subnet_tags" {
  default = {
    availability_zone       = "added by slicing the output received from data sourcing - aws_availability_zones"
    Terraform_User          = true
    map_public_ip_on_launch = false
    subnet                  = "database"

  }
}

variable "route_table_tags_public" {
  type = map(any)
  default = {
    passed_only_vpc_id = true
    type               = "public"
  }
}

variable "route_table_tags_private" {
  type = map(any)
  default = {
    passed_only_vpc_id = true
    type               = "private"
  }
}

variable "route_table_tags_database" {
  type = map(any)
  default = {
    passed_only_vpc_id = true
    type               = "database"
  }
}

variable "eip_tags" {
  default = {
    added_domain_as_vpc = true
  }
}

variable "nat_tags" {
  default = {
    allocation_id                               = "passed"
    subnet_id_of_first_Element_of_public_subnet = "passed"
    depends_on                                  = "passed"
  }
}
variable "is_peering_required" {
  type    = bool
  default = false
}

#   -upgrade                Install the latest module and provider versions
#                           allowed within configured constraints, overriding the
#                           default behavior of selecting exactly the version
#                           recorded in the dependency lockfile.
# terraform init --help --> when changes the source from local to github repo
