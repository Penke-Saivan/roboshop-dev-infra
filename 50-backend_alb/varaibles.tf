variable "project" {
  default = "roboshop"
}
variable "environment" {
  default = "dev"
}
variable "backend_tags" {
  type = map(any)
  default = {
    Backend_ALB = true
  }
}
