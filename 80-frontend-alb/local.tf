locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = true
  }
  common_name_suffix = "${var.project}-${var.environment}"
  # vpc_id             = data.aws_ssm_parameter.vpc_id
  public_subnets_array = split(",", data.aws_ssm_parameter.public_subnet_ids.value) #gives list of strings
  private_subnets_array = split(",", data.aws_ssm_parameter.private_subnet_ids.value) 
  
  #gives list of strings -data.aws_ssm_parameter.private_subnet_ids.value=subnet-06467d1230d55c1bc,subnet-0168e3d4acc9bf7a2
  #split produces a list by dividing a given string at all occurrences of a given separator.

}
