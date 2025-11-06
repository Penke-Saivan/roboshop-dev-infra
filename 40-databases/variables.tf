variable "project" {
  default = "roboshop"
}
variable "environment" {
  default = "dev"
}
variable "sg_name" {
  default = ["mysql", "redis", "rabbitmq", "mongodb", "bastion", "fronted-lb", "frontend", "backend-alb"]
}

variable "zone_id" {
  default = "Z03460353RS4GS5RQB39D"
}

variable "zone_name" {
  default = "believeinyou.fun"
}