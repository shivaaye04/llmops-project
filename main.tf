terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Security Group for LLM API (Port 8000 and SSH 22)
resource "aws_security_group" "llm_sg" {
  name        = "qwen-llm-sg"
  description = "Allow inbound traffic for LLM API and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
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

# 2. AWS EC2 Instance (t3.micro - New Free Tier Certified)
resource "aws_instance" "llm_server" {
  ami           = "ami-0866a3c8686eaeeba" # Latest Ubuntu 22.04 LTS AMI in us-east-1
  instance_type = "t3.micro"             # 100% Free Tier Eligible

  vpc_security_group_ids = [aws_security_group.llm_sg.id]

  tags = {
    Name = "Qwen-LLMOps-Server"
  }
}