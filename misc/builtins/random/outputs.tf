output "id" {
  description = "Random ID"
  value = random_id.rid.hex
}

output "str" {
  description = "Random string"
  value = random_string.rstring.result
}
