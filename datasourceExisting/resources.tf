resource "aws_instance" "data_source_web_server" {
  ami                         = "ami-0cfde0ea8edd312d4"
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.public_subnet.id
  vpc_security_group_ids      = [data.aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
echo "<h1>Hello from NEW EC2 using Terraform Data Sources</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name        = "dev-data-source-web-server"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
