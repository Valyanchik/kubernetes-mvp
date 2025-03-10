locals {
  folder_id = var.yc_folder_id
}

resource "yandex_kubernetes_cluster" "otus-k8s-zonal" {
  name = "otus-k8s-zonal"
  network_id = yandex_vpc_network.otus-network-1.id
  master {
    master_location {
      zone      = yandex_vpc_subnet.otus-subnet-1.zone
      subnet_id = yandex_vpc_subnet.otus-subnet-1.id
    }
    security_group_ids = [yandex_vpc_security_group.k8s-public-services.id,yandex_vpc_security_group.k8s-cluster-traffic.id]
    version = "1.28"
    public_ip = true
  }
  cluster_ipv4_range = var.cluster_ipv4_range
  service_ipv4_range = var.service_ipv4_range
  service_account_id      = var.yc_sa_account
  node_service_account_id = var.yc_sa_account
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
}

resource "yandex_vpc_network" "otus-network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "otus-subnet-1" {
  name = "subnet-1"
  v4_cidr_blocks = ["172.16.0.0/16"]  ##с этим нужно аккуратно, лучше проделать через веб-консоль, чтоб понять. какие cidr сюда вставлять и прописать явно
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.otus-network-1.id
}


