output "vpc1-name" {
  description = "VPC1 tag name"
  # type        = string
  value = aws_vpc.vpc1.tags.Name
}

output "vpc1-date" {
  description = "VPC1 create date"
  # type        = string
  value = aws_vpc.vpc1.tags.Create-Date
}

output "vpc2-name" {
  description = "VPC2 tag name"
  # type        = string
  value = aws_vpc.vpc2.tags.Name
}

output "vpc2-date" {
  description = "VPC2 create date"
  # type        = string
  value = aws_vpc.vpc2.tags.Create-Date
}