# tf-beamMP-server-module
Terraform module to deploy a BeamMP server to AWS

# Usage

Simple example:
```hcl
module "beamMP_server" {
  source = "github.com/Harry-Moore-dev/tf-beamMP-server-module"

  beamMP_auth_key           = var.beamMP_auth_key # Should be loaded in as a secret and kept out of source control
}
```

Detailed example:
```hcl
module "beamMP_server" {
  source = "github.com/Harry-Moore-dev/tf-beamMP-server-module"

  region            = "eu-west-1
  ec2_instance_type = "t3.large"

  beamMP_port               = 42069
  beamMP_auth_key           = var.beamMP_auth_key # Should be loaded in as a secret and kept out of source control
  beamMP_map                = "italy"
  beamMP_server_name        = "Yet Another BeamMP Server"
  beamMP_server_description = "Yet Another Server Description"
  beamMP_max_cars           = 2
  beamMP_max_players        = 10
  beamMP_private            = false
}
```

## Pre-commit config

Install dependencies for pre-commit.
```
brew install pre-commit terraform-docs tflint tfsec
```

## To Do

- Add support for running on spot instances
- Add support for loading mods from s3

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | terraform-aws-modules/ec2-instance/aws | 5.5.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_default_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_iam_instance_profile.ssm_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_beamMP_auth_key"></a> [beamMP\_auth\_key](#input\_beamMP\_auth\_key) | BeamMP config auth key | `string` | n/a | yes |
| <a name="input_beamMP_map"></a> [beamMP\_map](#input\_beamMP\_map) | BeamMP config server map selected | `string` | `"gridmap_v2"` | no |
| <a name="input_beamMP_max_cars"></a> [beamMP\_max\_cars](#input\_beamMP\_max\_cars) | BeamMP config maximum number of cars per allowed person | `number` | `1` | no |
| <a name="input_beamMP_max_players"></a> [beamMP\_max\_players](#input\_beamMP\_max\_players) | BeamMP config maximum number of players | `number` | `5` | no |
| <a name="input_beamMP_port"></a> [beamMP\_port](#input\_beamMP\_port) | BeamMP config server port, also used in the security group rules | `number` | `30814` | no |
| <a name="input_beamMP_private"></a> [beamMP\_private](#input\_beamMP\_private) | BeamMP config set the server to private or not | `bool` | `true` | no |
| <a name="input_beamMP_server_description"></a> [beamMP\_server\_description](#input\_beamMP\_server\_description) | BeamMP config server description | `string` | `"BeamMP Server created by Terraform"` | no |
| <a name="input_beamMP_server_name"></a> [beamMP\_server\_name](#input\_beamMP\_server\_name) | BeamMP config server name | `string` | `"BeamMP Server created by Terraform"` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | ec2 instance type | `string` | `"t3.small"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_vpc_subnet_cidr_block"></a> [vpc\_subnet\_cidr\_block](#input\_vpc\_subnet\_cidr\_block) | value of the vpc cidr block for the public subnet | `string` | `"172.31.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_ip"></a> [server\_ip](#output\_server\_ip) | public IP of the EC2 instance used for direct connect |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
