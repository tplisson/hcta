output "vpc1_name" {
  value = aws_vpc.vpc1.tags[*].Name
}