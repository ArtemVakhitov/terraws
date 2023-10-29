terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
 region = "us-east-1"
}

variable "cpu" {
  type = number
  default = 1
}

variable "ram" {
  type = number
  default = 2
}

locals {
  # Log metric to use as list index for RAM amount
  lram = (var.ram < 1) ? 0 : min(ceil(log(2, var.ram), 5)) + 1
  # Log metric to use as list index for CPU number
  lcpu = min(ceil(log(2, var.cpu), 3))
  # No. of CPUs for that amount of RAM in standard instance types
  cpu_for_lram = [1, 1, 1, 2, 2, 4, 8]
  # Instance types grouped by CPU number
  instance_types = [["t2.nano", "t2.micro", "t2.small"], ["t2.medium", "t2.large"], ["t2.xlarge"], ["t2.2xlarge"]]
}

resource "aws_instance" "example" {
  ami = "ami-0261755bbcb8c4a84"
  # If CPU requirement <= standard no. of CPUs for that RAM amount, select instance type based on RAM
  # If CPU requirement > standard no. of CPUs for that RAM amount, select instance type with that many CPUs and minimum RAM
  instance_type = (var.cpu <= cpu_for_lram[lram]) ? flatten(instance_types)[lram] : instance_types[lcpu][0]
}