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