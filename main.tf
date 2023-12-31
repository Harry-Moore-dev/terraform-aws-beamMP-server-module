locals {
  name = "BeamMP-server"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Terraform = "true"
    Project   = "BeamMP"
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = var.vpc_subnet_cidr_block
  availability_zone       = element(local.azs, 2)
  map_public_ip_on_launch = true

  tags = local.tags
}

data "aws_availability_zones" "available" {}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name = local.name

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  availability_zone           = element(local.azs, 2)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  create_spot_instance      = var.ec2_spot_instance_enabled
  spot_price                = var.ec2_spot_instance_enabled ? var.ec2_spot_instance_price : null
  spot_type                 = var.ec2_spot_instance_enabled ? "persistent" : null
  spot_wait_for_fulfillment = var.ec2_spot_instance_enabled ? true : null

  user_data = templatefile("${path.module}/server_setup.sh.tftpl", {
    beamMP_auth_key           = var.beamMP_auth_key, beamMP_map = var.beamMP_map,
    beamMP_server_name        = var.beamMP_server_name,
    beamMP_server_description = var.beamMP_server_description,
    beamMP_max_cars           = var.beamMP_max_cars,
    beamMP_max_players        = var.beamMP_max_players,
    beamMP_port               = var.beamMP_port,
    beamMP_private            = var.beamMP_private,
    beamMP_modded             = var.beamMP_modded,
    beamMP_mod_s3_bucket_path = var.beamMP_mod_s3_bucket_path
  })

  root_block_device = [
    {
      volume_size = var.ec2_ebs_volume_size
      volume_type = "gp3"
    }
  ]

  tags = local.tags

  iam_instance_profile = "ssm-instance-profile"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_read_policy_attachment" {
  count      = var.beamMP_modded ? 1 : 0
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.s3_read_policy[0].arn
}

resource "aws_iam_policy" "s3_read_policy" {
  count       = var.beamMP_modded ? 1 : 0
  name        = "s3-read-policy"
  description = "Policy for S3 read access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "S3ReadAccess"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["arn:aws:s3:::${var.beamMP_mod_s3_bucket_path}/*"]
      },
      {
        Sid      = "S3ListBucketAccess"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:aws:s3:::*"]
      }
    ]
  })
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = local.name
  description = "BeamMP server security group"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      from_port   = var.beamMP_port
      to_port     = var.beamMP_port
      protocol    = "tcp"
      description = "Allow ingress on port 30814 for TCP"
    },
    {
      from_port   = var.beamMP_port
      to_port     = var.beamMP_port
      protocol    = "udp"
      description = "Allow ingress on port 30814 for UDP"
    }
  ]
  tags = local.tags
}
