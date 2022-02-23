packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_access_key_id" {
  type    = string
  default = ""
}

variable "aws_secret_access_key" {
  type    = string
  default = ""
}

variable "aws_session_token" {
  type    = string
  default = ""
}

variable "timezone" {
  type    = string
  default = "Asia/Shanghai"
}

source "amazon-ebs" "ecsctm" {
  region                      = "us-east-1"
  access_key                  = var.aws_access_key_id
  secret_key                  = var.aws_secret_access_key
  instance_type               = "t2.micro"
  token                       = var.aws_session_token
  source_ami                  = "ami-5e414e24"
  ami_name                    = "docker-in-aws-ecs {{timestamp}}"
  ssh_username                = "ec2-user"
  associate_public_ip_address = true
  tags = {
    Name            = "Docker in AWS ECS Base Image 2017.09.h"
    SourceAMI       = "{{ .SourceAMI }}"
    DockerVersion   = "20.10.7-ce"
    ECSAgentVersion = "1.59.0-1"
  }
}

build {
  sources = [
    "source.amazon-ebs.ecsctm"
  ]

  provisioner "shell" {
    inline = ["sudo yum -y -x docker\\* -x ecs\\* update"]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}

