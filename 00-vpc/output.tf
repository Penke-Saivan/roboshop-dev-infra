output "id_vpc" {
  value = module.vpc.vpc_id
}
output "availabile_zones" {
  value = slice(data.aws_availability_zones.availables.names, 0, 2)
  # slicing- slice(list, startindex, endindex)

  # value = data.aws_availability_zones.availables.names
}
# After slicing -  availabile_zones = [
#       + "us-east-1a",
#       + "us-east-1b",
#     ]

# format of availabile_zones

# {
#       + all_availability_zones = null
#       + exclude_names          = null
#       + exclude_zone_ids       = null
#       + filter                 = null
#       + group_names            = [
#           + "us-east-1-zg-1",
#         ]
#       + id                     = "us-east-1"
#       + names                  = [
#           + "us-east-1a",
#           + "us-east-1b",
#           + "us-east-1c",
#           + "us-east-1d",
#           + "us-east-1e",
#           + "us-east-1f",
#         ]
#       + region                 = "us-east-1"
#       + state                  = "available"
#       + timeouts               = null
#       + zone_ids               = [
#           + "use1-az4",
#           + "use1-az6",
#           + "use1-az1",
#           + "use1-az2",
#           + "use1-az3",
#           + "use1-az5",
#         ]
#     }

output "eip-public-IP" {
  value = module.vpc.eip_public_ip
}

output "vpc-default" {
  value = module.vpc.default-vpc-id
}

# {
#       + arn                                  = "arn:aws:ec2:us-east-1:131676642204:vpc/vpc-00c32ae89ad378adf"
#       + cidr_block                           = "172.31.0.0/16"
#       + cidr_block_associations              = [
#           + {
#               + association_id = "vpc-cidr-assoc-0114433282029ce33"
#               + cidr_block     = "172.31.0.0/16"
#               + state          = "associated"
#             },
#         ]
#       + default                              = true
#       + dhcp_options_id                      = "dopt-0a6ed4b077212f8b5"
#       + enable_dns_hostnames                 = true
#       + enable_dns_support                   = true
#       + enable_network_address_usage_metrics = false
#       + filter                               = null
#       + id                                   = "vpc-00c32ae89ad378adf"
#       + instance_tenancy                     = "default"
#       + ipv6_association_id                  = ""
#       + ipv6_cidr_block                      = ""
#       + main_route_table_id                  = "rtb-042de75ce78f1fdb4"
#       + owner_id                             = "131676642204"
#       + region                               = "us-east-1"
#       + state                                = null
#       + tags                                 = {}
#       + timeouts                             = null
#     }

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
# Gives a list
# + public_subnet_ids   = [
#     + (known after apply),
#     + (known after apply),
#   ]

# [
#   "subnet-0639945cbf07b3d5a",
#   "subnet-04f217a7a7d2b60d8",
# ]

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}
