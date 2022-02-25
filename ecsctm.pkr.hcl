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
  source_ami                  = "ami-0a5e7c9183d1cea27"
  ami_name                    = "docker-in-aws-ecs {{timestamp}}"
  ssh_username                = "ec2-user"
  associate_public_ip_address = true
  tags = {
    Name            = "Docker in AWS ECS Base Image 20220209"
    SourceAMI       = "{{ .SourceAMI }}"
    DockerVersion   = "20.10.7-ce"
    ECSAgentVersion = "1.59.0-1"
  }
  #launch_block_device_mappings {
  #  device_name           = "/dev/xvdcy"
  #  encrypted             = false
  #  volume_size           = 20
  #  volume_type           = "gp2"
  #  delete_on_termination = true
  #}
}

build {
  sources = [
    "source.amazon-ebs.ecsctm"
  ]

  provisioner "shell" {
    script = "scripts/storage.sh"
  }
  provisioner "shell" {
    script = "scripts/cloudinit.sh"
  }
  provisioner "shell" {
    script = "scripts/package.sh"
  }
  provisioner "shell" {
    script = "scripts/time.sh"
    environment_vars = [
      "TIMEZONE=${var.timezone}"
    ]
  }
  provisioner "shell" {
    script = "scripts/cleanup.sh"
  }

  provisioner "file" {
    source      = "files/firstrun.sh"
    destination = "/home/ec2-user/firstrun.sh"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}

