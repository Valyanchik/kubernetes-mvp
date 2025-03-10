
variable "yc_token_id" {
  type = string
  default = ""
  description = "cloud-id"
}
# yc resource-manager cloud get <CLOUD_NAME>
variable "yc_cloud_id" {
  type = string
  default = ""
  description = "cloud-id"
}
# yc resource-manager folder get <FOLDER_NAME>
variable "yc_folder_id" {
  type = string
  default = ""
  description = "folder_id"
}

# yc iam service-account create --name <account_name>
variable "yc_sa_account" {
  type = string
  default = ""
  description = "valyan-otus"
}

variable "yc_zone_1a" {
  type = string
  default = "ru-central1-a"
  description = "Зона доступности"
}

# yc iam key create --service-account-name <SERVICE_ACCOUNT_NAME> --output <PATH/TO/KEY/FILE>
variable "yc_sa_key_path" {
  type = string
  default = "/home/valyan/proj/valyan-otus"
  description = "Путь к ключу сервисного аккаунта"
}

variable "service_ipv4_range" {
  description = <<EOF
    CIDR block. IP range from which Kubernetes service cluster IP addresses 
    will be allocated from. It should not overlap with
    any subnet in the network the Kubernetes cluster located in
    EOF
  type        = string
  default     = "172.18.0.0/16"
}

variable "cluster_ipv4_range" {
  description = <<EOF
  CIDR block. IP range for allocating pod addresses.
  It should not overlap with any subnet in the network
  the Kubernetes cluster located in. Static routes will
  be set up for this CIDR blocks in node subnets.
  EOF
  type        = string
  default     = "172.17.0.0/16"
}

#yc iam access-key create --service-account-name <sa_name>
variable "s3_access_key_id" {
  type = string
  default = ""
  description = "valyan-otus s3 key id"
}

variable "s3_access_key_secret" {
  type = string
  default = ""
  description = "valyan-otus s3 key ssecret"
}
