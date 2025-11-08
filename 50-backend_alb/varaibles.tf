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

variable "zone_id" {
  default = "Z03460353RS4GS5RQB39D"
}

variable "zone_name" {
  default = "believeinyou.fun"
}