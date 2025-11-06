variable "project" {
  default = "roboshop"
}
variable "environment" {
  default = "dev"
}
variable "sg_name" {
  default = ["mysql", "redis", "rabbitmq", "mongodb",
    "bastion",
    "fronted-lb", "frontend",
    "backend-alb",
  "catalogue", "user", "cart", "shipping", "payment"]
}
