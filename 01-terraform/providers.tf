terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  ##token for cloud, тут лучше делать через service_account_id, предварительно выдав ему права на создание кластера и прочее
  token = var.yc_token_id
  cloud_id = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone = var.yc_zone_1a 
}
