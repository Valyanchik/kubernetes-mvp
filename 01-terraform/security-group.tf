##nodes  section
resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "k8s-public-services"
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = yandex_vpc_network.otus-network-1.id
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера Managed Service for Kubernetes и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера Managed Service for Kubernetes и сервисов."
    v4_cidr_blocks    = [var.service_ipv4_range, var.cluster_ipv4_range, "172.16.0.0/16"]
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ICMP"
    description       = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks    = ["172.16.0.0/16", var.service_ipv4_range, var.cluster_ipv4_range,]
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 30000
    to_port           = 32767
  }
  ingress {
    protocol          = "TCP"
    description       = "Правило для проверок состояния бэкендов"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 10501
  }
  egress {
    protocol          = "ANY"
    description       = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
}
##cluster  section
resource "yandex_vpc_security_group" "k8s-cluster-traffic" {
  name        = "k8s-cluster-traffic"
  description = "Правила группы разрешают трафик для кластера. Примените ее к кластеру."
  network_id  = yandex_vpc_network.otus-network-1.id
  ingress {
    description    = "Правило для входящего трафика, разрешающее доступ к API Kubernetes (порт 443)."
    port           = 443
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Правило для входящего трафика, разрешающее доступ к API Kubernetes (порт 6443)."
    port           = 6443
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "Правило для исходящего трафика, разрешающее передачу трафика между мастером и подами metric-server."
    port           = 4443
    protocol       = "TCP"
    v4_cidr_blocks = concat(yandex_vpc_subnet.otus-subnet-1.v4_cidr_blocks)
  }
}

###ssh  section
#resource "yandex_vpc_security_group" "k8s-ssh-access" {
#  name        = "k8s-ssh-access"
#  description = "Правила группы разрешают подключение к узлам по SSH. Применимо к группам узлов."
#  network_id  = yandex_vpc_network.otus-network-1.id
#  ingress {
#    description    = "Правило для входящего трафика, разрешающее подключение к узлам по SSH."
#    port           = 22
#    protocol       = "TCP"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
###alb  section
#resource "yandex_vpc_security_group" "alb-traffic" {
#  name        = "alb-traffic"
#  description = "Правила alb"
#  network_id  = yandex_vpc_network.otus-network-1.id
#  ingress {
#    description    = "Правило для входящего трафика, извне на конечные точки балансировщика по 443 порту"
#    port           = 443
#    protocol       = "TCP"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#    description    = "Правило для входящего трафика, извне на конечные точки балансировщика по 80 порту"
#    port           = 80
#    protocol       = "TCP"
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#    protocol          = "TCP"
#    description       = "Правило проверки состояния балансировщика."
#    predefined_target = "loadbalancer_healthchecks"
#    port              = 30080
#  }
#  ingress {
#    protocol          = "TCP"
#    description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
#    v4_cidr_blocks    = ["0.0.0.0/0"]
#    from_port         = 30000
#    to_port           = 32767
#  }
#  egress {
#    protocol          = "TCP"
#    description       = "Правило для отправки трафика и проверки состояния узлов балансировщиком."
#    v4_cidr_blocks    = ["172.16.0.0/16","172.17.0.0/16","172.18.0.0/16"]
#    from_port         = 0
#    to_port           = 65535
#  }
#}


