output "domain_validations" {
  value= aws_acm_certificate.roboshop.domain_validation_options
}
# domain_validations = toset([
#   {
#     "domain_name" = "*.believeinyou.fun"
#     "resource_record_name" = "_4cf8814e4dcb58943fcaa540a127f0b3.believeinyou.fun."
#     "resource_record_type" = "CNAME"
#     "resource_record_value" = "_a964e14775a2854611fa012a7f51aa79.jkddzztszm.acm-validations.aws."
#   },
# ])
