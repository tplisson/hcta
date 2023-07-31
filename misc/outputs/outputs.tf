### Sample outputs

output "vpc" {
  value = aws_vpc.outputs
}

output "vpc_name" {
  value = aws_vpc.outputs.tags[*].Name
}

output "vpc_arn" {
  value = aws_vpc.outputs.arn
}

output "vpc_id" {
  value = aws_vpc.outputs.id
}

output "vpc_cidr_block" {
  value = aws_vpc.outputs.cidr_block
}

# output "instance_ip_addr" {
#   value = aws_instance.server.private_ip
# }