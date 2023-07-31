resource "random_id" "rid" {
  byte_length = 4
}

resource "random_string" "rstring" {
  length           = 8
  special          = true
  override_special = "/@£$"
}
