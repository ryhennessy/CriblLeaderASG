variable "AWS_VPC" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "NUMOFINST" {
  type    = number
  default = 2
}

variable "CRIBL_LIC" {
  type = string
}

variable "SSHKEYNAME" {
  type = string
}
