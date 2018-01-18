#
# singleton module
# Creates a single config-managed host (hidden behind a bastion)
# See docs/credits.md for contact/support details; hacked together by Alex Stanhope
#

# set up the AWS environment
module "aws_background" {
  source = "../../aws_background"
  aws_region = "${var.aws_region}"
  key_name = "${var.key_name}"
}

# create an ansible-managed host
# @requires module "aws_background"
module "singleton" {
  source = "../../ansible"
  host_name = "singleton"
  # use the main playbook to define the config
  manifest_name = "site.yml"
  aws_region = "${var.aws_region}"
  # use the fields passed back from aws_background for guaranteed consistency
  aws_ami = "${module.aws_background.aws_ami_id}"
  bastion_host = "${module.aws_background.aws_bastion_public_ip}"
  key_name = "${module.aws_background.aws_key_pair_id}"
  aws_security_group_id = "${module.aws_background.aws_security_group_id}"
  aws_subnet_id = "${module.aws_background.aws_subnet_id}"
}
# output command for accessing ansiblelocal by SSH (with no prompts)
output "ssh_command_singleton" {
  value = "${module.singleton.instantiated_host_ssh_command}"
}
