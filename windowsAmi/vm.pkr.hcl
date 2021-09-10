packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "subnet_id" {
  type    = string
  default = "YOURSUBNETID"
}

variable "region" {
  type    = string
  default = "us-east-1"
}


locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "windowsAmi" {
  ami_name      = "windowsAmi-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 250
  }
  source_ami_filter {
    filters = {
          virtualization-type = "hvm",
          name = "Windows_Server-2019-English-Full-Base*",
          root-device-type = "ebs"
        }
        owners = ["801119661308"]
        most_recent = true
  }
  associate_public_ip_address = false
  subnet_id    = "${var.subnet_id}"
  user_data_file = "provisioners/ansible/roles/windowsAmi/bootstrap_win.txt"
  winrm_insecure = true
  winrm_timeout = "10m"
  winrm_username = "Administrator"
  communicator = "winrm"
  skip_profile_validation = true
  ami_regions  = ["eu-west-1"]
}

build {
  sources = [
      "source.amazon-ebs.windowsAmi"
      ]
  provisioner "ansible" {
    use_proxy = false
    user = "Administrator"
    playbook_file = "./provisioners/ansible/windowsAmi.yml"
    extra_arguments = [
        "-e",
        "ansible_winrm_server_cert_validation=ignore"
      ]
  }

}