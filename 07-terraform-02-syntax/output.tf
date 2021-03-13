output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "private_ip" {
  value = aws_network_interface.local.private_ips
}

output "network_interface_id" {
  value = aws_network_interface.local.subnet_id
}
