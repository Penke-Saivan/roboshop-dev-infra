variable "component" {
  default = "catalogue"
}
variable "rule_priority" {
  default = 10
}
variable "components" {
  default = {
    catalogue = {
      rule_priority = 10
      #if you want to add any input ike instance type we can add from here
    }
    # user = {
    #   rule_priority = 20
    # }
    # cart = {
    #   rule_priority = 30
    # }
    # shipping = {
    #   rule_priority = 40
    # }
    # payment = {
    #   rule_priority = 50
    # }
    # frontend = {
    #   rule_priority = 10 #Frontend load balancer is different
    # }
  }
}
