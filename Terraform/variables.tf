variable "aws-access-key" {
  type = string
}

variable "aws-secret-key" {
  type = string
}

variable "aws-region" {
  type = string
}

variable "admin-username" {
  type = string
}

variable "admin-password" {
  type = string
}

variable "admin-fullname" {
  type = string
}

variable "admin-email" {
  type = string
}

variable "remote-repo" {
  type = string
}

variable "job-name" {
  type = string
}

variable "secrets" {
  type = map(string)
}