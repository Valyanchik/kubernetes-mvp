resource "yandex_kubernetes_node_group" "observ-ng" {
  name        = "observ-ng"
  description = "nodegroup for observability components"
  cluster_id  = "${yandex_kubernetes_cluster.otus-k8s-zonal.id}"
  version     = "1.28"
  instance_template {
    name = "observ-{instance.short_id}-{instance_group.id}"
    platform_id = "standard-v1"
    resources {
      cores         = 4
      core_fraction = 100
      memory        = 8
    }
    boot_disk {
      size = 64
      type = "network-hdd"
    }
    network_acceleration_type = "standard"
    network_interface {
      security_group_ids = [yandex_vpc_security_group.k8s-public-services.id]
      subnet_ids         = ["${yandex_vpc_subnet.otus-subnet-1.id}"]
      nat                = true
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
  deploy_policy {
    max_expansion   = 3
    max_unavailable = 1
  }
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
    maintenance_window {
      start_time = "22:00"
      duration   = "10h"
    }
  }
  node_labels = {
    "node-role" = "observ"
  }
  labels = {
    node-role = "observ"
  }
  allowed_unsafe_sysctls = ["kernel.msg*", "net.core.somaxconn"]
}

