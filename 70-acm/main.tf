#Creation of certificate
resource "aws_acm_certificate" "roboshop" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(

    local.common_tags,
    {
      Name = "${local.common_name_suffix}-acm-certificate-creation-Resource"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
#Creating records to prove the ownership of the domain added in the certificate
 resource "aws_route53_record" "roboshop" {
  for_each = {
    for dvo in aws_acm_certificate.roboshop.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
#aws_acm_certificate.roboshop.domain_validation_options is a set
# Yes — this is a set of objects.

# Each element in the set is one object representing a domain validation option.

# So it’s a set<object> type, not a simple list of strings.

# { for item in var.list : item => length(item) }

# {
#   "apple"  = 5
#   "banana" = 6
# }
# Both create a map/object, where:

# Left side of => is key

# Right side is value


# *****So now the********** for_each = {"*.believeinyou.fun" =  {
    
#     "name" = "_4cf8814e4dcb58943fcaa540a127f0b3.believeinyou.fun."
#     "type" = "CNAME"
#     "value" = "_a964e14775a2854611fa012a7f51aa79.jkddzztszm.acm-validations.aws."
#   } }

# So each value is as below 
# "*.believeinyou.fun"(key) =  {(value)
    
#     "name" = "_4cf8814e4dcb58943fcaa540a127f0b3.believeinyou.fun."
#     "type" = "CNAME"
#     "value" = "_a964e14775a2854611fa012a7f51aa79.jkddzztszm.acm-validations.aws."
#   }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = var.zone_id
}


# aws_acm_certificate.roboshop.domain_validation_options = toset([
#   {
#     "domain_name" = "*.believeinyou.fun"
#     "resource_record_name" = "_4cf8814e4dcb58943fcaa540a127f0b3.believeinyou.fun."
#     "resource_record_type" = "CNAME"
#     "resource_record_value" = "_a964e14775a2854611fa012a7f51aa79.jkddzztszm.acm-validations.aws."
#   },
# ])

#Now validating - like hitting validation button to validate
resource "aws_acm_certificate_validation" "roboshop" {
  certificate_arn         = aws_acm_certificate.roboshop.arn
  validation_record_fqdns = [for record in aws_route53_record.roboshop : record.fqdn]
#   [for item in var.list : item.upper()]
# If var.list = ["a", "b", "c"],
# ✅ Result → ["A", "B", "C"]

}