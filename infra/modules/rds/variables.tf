variable "workload" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "master_user_secret_kms_key_id" {
  type = string
}
