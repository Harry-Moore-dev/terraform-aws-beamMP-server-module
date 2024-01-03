variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "ec2_instance_type" {
  type        = string
  description = "ec2 instance type"
  default     = "t3.small"
}

variable "ec2_ebs_volume_size" {
  type        = number
  description = "ec2 ebs volume size"
  default     = 8
}

variable "ec2_spot_instance_price" {
  type        = string
  description = "ec2 spot instance price (adjust this for the instance type if using spot instances)"
  default     = "0.01"
}

variable "ec2_spot_instance_enabled" {
  type        = bool
  description = "use ec2 spot instances (cheaper but can be terminated at any time)"
  default     = false
}

variable "vpc_subnet_cidr_block" {
  type        = string
  description = "value of the vpc cidr block for the public subnet"
  default     = "172.31.0.0/16"
}

variable "beamMP_auth_key" {
  type        = string
  description = "BeamMP config auth key"
  sensitive   = true
}

variable "beamMP_map" {
  type        = string
  description = "BeamMP config server map selected"
  default     = "gridmap_v2"
}

variable "beamMP_server_name" {
  type        = string
  description = "BeamMP config server name"
  default     = "BeamMP Server created by Terraform"
}

variable "beamMP_server_description" {
  type        = string
  description = "BeamMP config server description"
  default     = "BeamMP Server created by Terraform"
}

variable "beamMP_max_cars" {
  type        = number
  description = "BeamMP config maximum number of cars per allowed person"
  default     = 1
}

variable "beamMP_max_players" {
  type        = number
  description = "BeamMP config maximum number of players"
  default     = 5
}

variable "beamMP_port" {
  type        = number
  description = "BeamMP config server port, also used in the security group rules"
  default     = 30814
}

variable "beamMP_private" {
  type        = bool
  description = "BeamMP config set the server to private or not"
  default     = true
}

variable "beamMP_modded" {
  type        = bool
  description = "BeamMP server enable mods"
  default     = false
}

variable "beamMP_mod_s3_bucket_path" {
  type        = string
  description = "S3 bucket name and path containing the zipped mod files (Potential security risk, only specify buckets in your control!)"
  default     = ""
}
