# packer-windows-ami

A generic template for generating a Windows Server 2019 AMI with Packer

## Installation

Clone this repo

Reference Hashicorp's CLI instructions for Packer in your chosen OS [here](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)

Note: This template uses WinRM to configure the EC2 Instance used to generate the AMI. If you are using MacOS (and probably Linux) you will need to install a couple of things for this to work.

1. pywinrm. This is a python WinRM client, you can read more about it [here](https://github.com/diyan/pywinrm)

```bash
pip install pywinrm
```
2. If you're on a newer revision of MacOS, you will need to make these changes as well. pywinrm is a multithreaded application which will make your shell puke unless you already have these in place.

```bash
python3 -m pip install --user --ignore-installed pywinrm
```

And add the following to your .bashrc or .zshrc:

```bash
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```

## Usage

Update the default value of the Subnet in the vm.pkr.hcl file

If you wish to store your credential files in SSM instead of plaintext (and you should!) create the SSM Parameter, windowsPassword. It is contained in /packer-windows-ami/packer-windows/provisioners/ansible/roles/windowsAmi/tasks/main.yml

Alternatively, you can just replace it with a plaintext value to test.

When you're ready to execute, run:

```bash
packer build windowsAmi/vm.pkr.hcl
```






