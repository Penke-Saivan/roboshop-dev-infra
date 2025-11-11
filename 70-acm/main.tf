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

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 1
  type            = each.value.type
  zone_id         = var.zone_id
}

#Now validating - like hitting validation button to validate
resource "aws_acm_certificate_validation" "roboshop" {
  certificate_arn         = aws_acm_certificate.roboshop.arn
  validation_record_fqdns = [for record in aws_route53_record.roboshop : record.fqdn]
}