module "mysql_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for mysql instances in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = var.sg_name
}
  

module "bastion_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for bastion instances in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "bastion"
}

module "ingress_alb_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for backend Alb in expense dev"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "app-alb"
}


module "eks_control_plane_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for eks-control-plane"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name  = "eks-control-plane"
}

module "eks_node_sg" {
    source = "git::https://github.com/Lakshmanp145/terraform-sg-module.git?ref=main"
    project = var.project
    environment = var.environment
    description = "Created for eks-nodes"
    common_tags = var.common_tags
    vpc_id = local.vpc_id
    sg_name = "eks-node"
}

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_node_sg.sg_id
  security_group_id = module.eks_control_plane_sg.sg_id
}

resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_control_plane_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}

#App ALB accetping traffic from bastion host or jump host
resource "aws_security_group_rule" "ingress_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.ingress_alb_sg.sg_id
}

#App ALB accetping traffic from bastion host or jump host
resource "aws_security_group_rule" "ingress_alb_bastion_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.ingress_alb_sg.sg_id
}

resource "aws_security_group_rule" "ingress_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb_sg.sg_id
}

resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}

# JDOPS143(jeera ticket) bastian should be connected from office network
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

# resource "aws_security_group_rule" "node_ingress_alb" {
#   type              = "ingress"
#   from_port         = 30000
#   to_port           = 32767
#   protocol          = "tcp"
#   source_security_group_id = module.ingress_alb_sg.sg_id
#   security_group_id = module.eks_node_sg.sg_id
#}

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "mysql_eks_node" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.eks_node_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.eks_control_plane_sg.sg_id
}

resource "aws_security_group_rule" "eks_node_ingress_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.ingress_alb_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}