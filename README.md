# tf-beamMP-server-module
Terraform module to deploy a BeamMP server to AWS

# Usage

Simple example:
```hcl
module "beamMP_server" {
  source  = "Harry-Moore-dev/beamMP-server-module/aws"
  version = "1.2.1"

  beamMP_auth_key           = var.beamMP_auth_key # Should be loaded in as a secret and kept out of source control
}
```

Detailed example:
```hcl
module "beamMP_server" {
  source  = "Harry-Moore-dev/beamMP-server-module/aws"
  version = "1.2.1"

  region              = "eu-west-1
  ec2_instance_type   = "t3.large"
  ec2_ebs_volume_size = 8

  ec2_spot_instance_price   = "0.01"
  ec2_spot_instance_enabled = true

  beamMP_port               = 42069
  beamMP_auth_key           = var.beamMP_auth_key # Should be loaded in as a secret and kept out of source control
  beamMP_map                = "italy"
  beamMP_server_name        = "Yet Another BeamMP Server"
  beamMP_server_description = "Yet Another Server Description"
  beamMP_max_cars           = 2
  beamMP_max_players        = 10
  beamMP_private            = false
  beamMP_modded             = true
  beamMP_mod_s3_bucket_path = "examplebucket/mods"
}
```

### Loading mods

Create an S3 bucket in your AWS account and load the mod zip files to a path of your choice. When mods are enabled in the server build and the path is provided, all mod files in that path will be copied over to the server on creation so sufficient ebs volume size should be specified depending on the size of the mods loaded.

## Pre-commit config

Install dependencies for pre-commit.
```
brew install pre-commit terraform-docs tflint tfsec
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | terraform-aws-modules/ec2-instance/aws | 5.6.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_default_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_iam_instance_profile.ssm_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.s3_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3_read_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
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
| <a name="input_beamMP_mod_s3_bucket_path"></a> [beamMP\_mod\_s3\_bucket\_path](#input\_beamMP\_mod\_s3\_bucket\_path) | S3 bucket name and path containing the zipped mod files (Potential security risk, only specify buckets in your control!) | `string` | `""` | no |
| <a name="input_beamMP_modded"></a> [beamMP\_modded](#input\_beamMP\_modded) | BeamMP server enable mods | `bool` | `false` | no |
| <a name="input_beamMP_port"></a> [beamMP\_port](#input\_beamMP\_port) | BeamMP config server port, also used in the security group rules | `number` | `30814` | no |
| <a name="input_beamMP_private"></a> [beamMP\_private](#input\_beamMP\_private) | BeamMP config set the server to private or not | `bool` | `true` | no |
| <a name="input_beamMP_server_description"></a> [beamMP\_server\_description](#input\_beamMP\_server\_description) | BeamMP config server description | `string` | `"BeamMP Server created by Terraform"` | no |
| <a name="input_beamMP_server_name"></a> [beamMP\_server\_name](#input\_beamMP\_server\_name) | BeamMP config server name | `string` | `"BeamMP Server created by Terraform"` | no |
| <a name="input_ec2_ebs_volume_size"></a> [ec2\_ebs\_volume\_size](#input\_ec2\_ebs\_volume\_size) | ec2 ebs volume size | `number` | `8` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | ec2 instance type | `string` | `"t3.small"` | no |
| <a name="input_ec2_spot_instance_enabled"></a> [ec2\_spot\_instance\_enabled](#input\_ec2\_spot\_instance\_enabled) | use ec2 spot instances (cheaper but can be terminated at any time) | `bool` | `false` | no |
| <a name="input_ec2_spot_instance_price"></a> [ec2\_spot\_instance\_price](#input\_ec2\_spot\_instance\_price) | ec2 spot instance price (adjust this for the instance type if using spot instances) | `string` | `"0.01"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_vpc_subnet_cidr_block"></a> [vpc\_subnet\_cidr\_block](#input\_vpc\_subnet\_cidr\_block) | value of the vpc cidr block for the public subnet | `string` | `"172.31.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_ip"></a> [server\_ip](#output\_server\_ip) | public IP of the EC2 instance used for direct connect |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
