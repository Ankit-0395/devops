provider "aws" {
  region = "ap-south-1"
}

# Generate Private Key
resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "devops-key"
  public_key = tls_private_key.devops_key.public_key_openssh
}

# Save PEM File Locally
resource "local_file" "private_key" {
  content  = tls_private_key.devops_key.private_key_pem
  filename = "devops-key.pem"
}

# Latest Ubuntu AMI
data "aws_ami" "ubuntu" {

  most_recent = true
  owners       = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Security Group
resource "aws_security_group" "devops_sg" {

  name = "devops-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "devops_server" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"

  key_name = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [
    aws_security_group.devops_sg.id
  ]

  tags = {
    Name = "DevOps-Server"
  }
}
