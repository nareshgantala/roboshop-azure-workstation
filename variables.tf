variable "resource_group_name" {
  default = "denmark-east"
}

variable "location" {
  default = "Denmark East"
}

variable "component" {
  default= {
  workstation = "Standard_B1s"
  jenkins = "Standard_B2s"
  }
}