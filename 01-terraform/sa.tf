resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "k8s.clusters.agent".
  folder_id = local.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${var.yc_sa_account}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  # Сервисному аккаунту назначается роль "vpc.publicAdmin".
  folder_id = local.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${var.yc_sa_account}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = local.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${var.yc_sa_account}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = local.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${var.yc_sa_account}"
}

resource "yandex_resourcemanager_folder_iam_member" "storageAdmin" {
  # Сервисному аккаунту назначается роль "storage.admin".
  folder_id = local.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${var.yc_sa_account}"
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  # Сервисному аккаунту назначается роль "editor".
  folder_id = local.folder_id
  role      = "editor"
  member    = "serviceAccount:${var.yc_sa_account}"
}

#resource "yandex_resourcemanager_folder_iam_member" "certificate-manager-certificates-downloader" {
#  # Сервисному аккаунту назначается роль "editor".
#  folder_id = local.folder_id
#  role      = "certificate-manager.certificates.downloader"
#  member    = "serviceAccount:${var.yc_sa_account}"
#}
#
#resource "yandex_resourcemanager_folder_iam_member" "compute-viewer" {
#  # Сервисному аккаунту назначается роль "editor".
#  folder_id = local.folder_id
#  role      = "compute.viewer"
#  member    = "serviceAccount:${var.yc_sa_account}"
#}
#
#resource "yandex_resourcemanager_folder_iam_member" "alb-editor" {
#  # Сервисному аккаунту назначается роль "editor".
#  folder_id = local.folder_id
#  role      = "alb.editor"
#  member    = "serviceAccount:${var.yc_sa_account}"
#}