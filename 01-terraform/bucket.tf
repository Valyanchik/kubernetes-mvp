resource "yandex_storage_bucket" "valyan-otus-ru" {
  access_key            = var.s3_access_key_id
  secret_key            = var.s3_access_key_secret
  bucket                = "valyan-otus.ru"
  max_size              = 50179869184
  acl                   = "public-read"
  default_storage_class = "standard"
  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
#  # Сертификат Certificate Manager
#  https {
#    certificate_id = data.yandex_cm_certificate.example.id
#  }
}

resource "yandex_storage_object" "index-html" {
  access_key = var.s3_access_key_id
  secret_key = var.s3_access_key_secret
  bucket     = yandex_storage_bucket.valyan-otus-ru.id
  key        = "index.html"
  source     = "index.html"
}

resource "yandex_storage_object" "error-html" {
  access_key = var.s3_access_key_id
  secret_key = var.s3_access_key_secret
  bucket     = yandex_storage_bucket.valyan-otus-ru.id
  key        = "error.html"
  source     = "error.html"
}

#resource "yandex_cm_certificate" "otus-cert-1" {
#  name    = "otus-cert-1"
#  domains = ["valyan-otus.ru"]
#
#  managed {
#  challenge_type = "DNS_CNAME"
#  }
#}
#resource "yandex_dns_zone" "otus-zone-1" {
#  name        = "otus-zone-1"
#  description = "Public zone"
#  zone        = "valyan-otus.ru."
#  public      = true
#}
#resource "yandex_dns_recordset" "validation-record" {
#  zone_id = yandex_dns_zone.otus-zone-1.id
#  name    = yandex_cm_certificate.otus-cert-1.challenges[0].dns_name
#  type    = yandex_cm_certificate.otus-cert-1.challenges[0].dns_type
#  data    = [yandex_cm_certificate.otus-cert-1.challenges[0].dns_value]
#  ttl     = 600
#}
#data "yandex_cm_certificate" "example" {
#  depends_on      = [yandex_dns_recordset.validation-record]
#  certificate_id  = yandex_cm_certificate.otus-cert-1.id
#  #wait_validation = true
#}
#
#resource "yandex_dns_recordset" "rs2" {
#  zone_id = yandex_dns_zone.otus-zone-1.id
#  name    = "valyan-otus.ru."
#  type    = "ANAME"
#  ttl     = 600
#  data    = ["valyan-otus.ru.website.yandexcloud.net"]
#}


