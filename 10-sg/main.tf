# module "catalogue" {
#   source = "terraform-aws-modules/security-group/aws"

#   name        = "${local.common_name}-catalogue" #roooshop-dev-catalogue
#   description = "Security group for catalogue"

#   #   vpc_id      = "vpc-12345678" - we needed output from other repo - 00-vpc
#   # make sure the source that is 00 vpc stores the vpc id in ssm parameter store (resource)
#   # now the sg which requires ssm param uses data source to retrieve the vpc id 
#   vpc_id          = data.aws_ssm_parameter.vpc_through_ssm.value
#   use_name_prefix = false

# }
module "catalogue" {
  count       = length(var.sg_name)
  source      = "git::https://github.com/Penke-Saivan/terraform-aws-sg-module.git?ref=main"
  environment = var.environment

  project        = var.project
  sg_name        = var.sg_name[count.index]
  sg_description = "Created for ${var.sg_name[count.index]}"

  vpc_id = local.vpc_id


}
