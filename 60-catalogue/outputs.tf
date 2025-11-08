output "vpc_id_output-id" {
  value = data.aws_ssm_parameter.vpc_id.id
}
output "vpc_id_output-value" {
  value = data.aws_ssm_parameter.vpc_id.value
}
output "vpc_id_output-name" {
  value = data.aws_ssm_parameter.vpc_id.name
}
