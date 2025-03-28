resource "yandex_kubernetes_node_group" "worker-ng" {
  name        = "worker-ng"
  description = "nodegroup for application workload"
  cluster_id  = "${yandex_kubernetes_cluster.otus-k8s-zonal.id}"
  version     = "1.29"
  instance_template {
    name = "worker-{instance.short_id}-{instance_group.id}"
    platform_id = "standard-v1"
    resources {
      cores         = 4
      core_fraction = 100
      memory        = 4
    }
    boot_disk {
      size = 32
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
    "node-role" = "worker"
  }
  labels = {
    node-role = "worker"
  }
  allowed_unsafe_sysctls = ["kernel.msg*", "net.core.somaxconn"]
}

