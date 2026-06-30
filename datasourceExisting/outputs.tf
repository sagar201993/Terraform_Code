output "existing_vpc_id" {
  value = data.aws_vpc.dev_vpc.id

}

output "existing_subnet_id" {
  value = data.aws_subnet.public_subnet.id
}

output "existing_security_group_id" {
  value = data.aws_security_group.web_sg.id
}

output "new_ec2_public_ip" {
  value = aws_instance.data_source_web_server.public_ip
}

output "new_ec2_id" {
  value = aws_instance.data_source_web_server.id
}
