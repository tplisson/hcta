output "sg_rules" {
  description = "Security Group Rules"
  value       = aws_security_group.example[*]
}
