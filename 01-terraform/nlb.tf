##target group
resource "yandex_lb_target_group" "otus-nlb-tg" {
  name      = "otus-nlb-tg"
#observ node
  target {
    subnet_id = "${yandex_vpc_subnet.otus-subnet-1.id}"
    address   = "172.16.0.6"
  }
#cicd node
  target {
    subnet_id = "${yandex_vpc_subnet.otus-subnet-1.id}"
    address   = "172.16.0.14"
  }
#worker node
  target {
    subnet_id = "${yandex_vpc_subnet.otus-subnet-1.id}"
    address   = "172.16.0.12"
  }
}
##network load balancer
resource "yandex_lb_network_load_balancer" "otus-k8s-lb" {
  name = "otus-k8s-lb"

  listener {
    name = "observ-listener"
    port = 81
    target_port = 30081
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name = "cicd-listener"
    port = 82
    target_port = 30082
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  listener {
    name = "frontend-listener"
    port = 83
    target_port = 30083
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.otus-nlb-tg.id}"
    healthcheck {
      name = "otus-nlb-tg-tcp-check"
      tcp_options {
        port = 30081
      }
    }
  }
}