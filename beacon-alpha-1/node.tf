# Inputs
variable "project" {
  type        = string
  description = "Project name"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

# AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Instance
resource "aws_instance" "beacon" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t3.micro"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ""
  subnet_id              = ""
  iam_instance_profile   = ""

  tags = {
    project = "${var.project}"
    role    = "beacon"
  }

  volume_tags = {
    project = "${var.project}"
    role    = "beacon"
  }
}
