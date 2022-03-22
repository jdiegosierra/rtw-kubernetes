locals {
  cluster_name                                = "talento.k8s.local"
  iam_openid_connect_provider_arn             = aws_iam_openid_connect_provider.talento-k8s-local.arn
  iam_openid_connect_provider_issuer          = "talento-development-kops-oidc.s3.us-east-1.amazonaws.com//discovery/talento.k8s.local"
  kube-system-ebs-csi-controller-sa_role_arn  = aws_iam_role.ebs-csi-controller-sa-kube-system-sa-talento-k8s-local.arn
  kube-system-ebs-csi-controller-sa_role_name = aws_iam_role.ebs-csi-controller-sa-kube-system-sa-talento-k8s-local.name
  master_autoscaling_group_ids                = [aws_autoscaling_group.master-eu-west-1a-masters-talento-k8s-local.id]
  master_security_group_ids                   = [aws_security_group.masters-talento-k8s-local.id]
  masters_role_arn                            = aws_iam_role.masters-talento-k8s-local.arn
  masters_role_name                           = aws_iam_role.masters-talento-k8s-local.name
  node_autoscaling_group_ids                  = [aws_autoscaling_group.nodes-eu-west-1a-talento-k8s-local.id]
  node_security_group_ids                     = [aws_security_group.nodes-talento-k8s-local.id]
  node_subnet_ids                             = [aws_subnet.eu-west-1a-talento-k8s-local.id]
  nodes_role_arn                              = aws_iam_role.nodes-talento-k8s-local.arn
  nodes_role_name                             = aws_iam_role.nodes-talento-k8s-local.name
  region                                      = "eu-west-1"
  route_table_public_id                       = aws_route_table.talento-k8s-local.id
  subnet_eu-west-1a_id                        = aws_subnet.eu-west-1a-talento-k8s-local.id
  vpc_cidr_block                              = aws_vpc.talento-k8s-local.cidr_block
  vpc_id                                      = aws_vpc.talento-k8s-local.id
}

output "cluster_name" {
  value = "talento.k8s.local"
}

output "iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.talento-k8s-local.arn
}

output "iam_openid_connect_provider_issuer" {
  value = "talento-development-kops-oidc.s3.us-east-1.amazonaws.com//discovery/talento.k8s.local"
}

output "kube-system-ebs-csi-controller-sa_role_arn" {
  value = aws_iam_role.ebs-csi-controller-sa-kube-system-sa-talento-k8s-local.arn
}

output "kube-system-ebs-csi-controller-sa_role_name" {
  value = aws_iam_role.ebs-csi-controller-sa-kube-system-sa-talento-k8s-local.name
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.master-eu-west-1a-masters-talento-k8s-local.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-talento-k8s-local.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-talento-k8s-local.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-talento-k8s-local.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-eu-west-1a-talento-k8s-local.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-talento-k8s-local.id]
}

output "node_subnet_ids" {
  value = [aws_subnet.eu-west-1a-talento-k8s-local.id]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-talento-k8s-local.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-talento-k8s-local.name
}

output "region" {
  value = "eu-west-1"
}

output "route_table_public_id" {
  value = aws_route_table.talento-k8s-local.id
}

output "subnet_eu-west-1a_id" {
  value = aws_subnet.eu-west-1a-talento-k8s-local.id
}

output "vpc_cidr_block" {
  value = aws_vpc.talento-k8s-local.cidr_block
}

output "vpc_id" {
  value = aws_vpc.talento-k8s-local.id
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "files"
  region = "us-east-1"
}

resource "aws_autoscaling_group" "master-eu-west-1a-masters-talento-k8s-local" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.master-eu-west-1a-masters-talento-k8s-local.id
    version = aws_launch_template.master-eu-west-1a-masters-talento-k8s-local.latest_version
  }
  load_balancers        = [aws_elb.api-talento-k8s-local.id]
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "master-eu-west-1a.masters.talento.k8s.local"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "talento.k8s.local"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "master-eu-west-1a.masters.talento.k8s.local"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-eu-west-1a"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"
    propagate_at_launch = true
    value               = "master"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/master"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-eu-west-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/talento.k8s.local"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.eu-west-1a-talento-k8s-local.id]
}

resource "aws_autoscaling_group" "nodes-eu-west-1a-talento-k8s-local" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.nodes-eu-west-1a-talento-k8s-local.id
    version = aws_launch_template.nodes-eu-west-1a-talento-k8s-local.latest_version
  }
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "nodes-eu-west-1a.talento.k8s.local"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "talento.k8s.local"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-eu-west-1a.talento.k8s.local"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-eu-west-1a"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"
    propagate_at_launch = true
    value               = "node"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-eu-west-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/talento.k8s.local"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.eu-west-1a-talento-k8s-local.id]
}

resource "aws_ebs_volume" "a-etcd-events-talento-k8s-local" {
  availability_zone = "eu-west-1a"
  encrypted         = true
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "a.etcd-events.talento.k8s.local"
    "k8s.io/etcd/events"                      = "a/a"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_ebs_volume" "a-etcd-main-talento-k8s-local" {
  availability_zone = "eu-west-1a"
  encrypted         = true
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "a.etcd-main.talento.k8s.local"
    "k8s.io/etcd/main"                        = "a/a"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_elb" "api-talento-k8s-local" {
  connection_draining         = true
  connection_draining_timeout = 300
  cross_zone_load_balancing   = false
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "SSL:443"
    timeout             = 5
    unhealthy_threshold = 2
  }
  idle_timeout = 300
  listener {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }
  name            = "api-talento-k8s-local-q3u0pn"
  security_groups = [aws_security_group.api-elb-talento-k8s-local.id]
  subnets         = [aws_subnet.eu-west-1a-talento-k8s-local.id]
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "api.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-talento-k8s-local" {
  name = "masters.talento.k8s.local"
  role = aws_iam_role.masters-talento-k8s-local.name
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "masters.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_iam_instance_profile" "nodes-talento-k8s-local" {
  name = "nodes.talento.k8s.local"
  role = aws_iam_role.nodes-talento-k8s-local.name
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "nodes.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_iam_openid_connect_provider" "talento-k8s-local" {
  client_id_list = ["amazonaws.com"]
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280", "a9d53002e97e00e043244f3d170d6f4c414104fd"]
  url             = "https://talento-development-kops-oidc.s3.us-east-1.amazonaws.com//discovery/talento.k8s.local"
}

resource "aws_iam_role" "ebs-csi-controller-sa-kube-system-sa-talento-k8s-local" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_ebs-csi-controller-sa.kube-system.sa.talento.k8s.local_policy")
  name               = "ebs-csi-controller-sa.kube-system.sa.talento.k8s.local"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "ebs-csi-controller-sa.kube-system.sa.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_iam_role" "masters-talento-k8s-local" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_masters.talento.k8s.local_policy")
  name               = "masters.talento.k8s.local"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "masters.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_iam_role" "nodes-talento-k8s-local" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_nodes.talento.k8s.local_policy")
  name               = "nodes.talento.k8s.local"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "nodes.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_iam_role_policy" "ebs-csi-controller-sa-kube-system-sa-talento-k8s-local" {
  name   = "ebs-csi-controller-sa.kube-system.sa.talento.k8s.local"
  policy = file("${path.module}/data/aws_iam_role_policy_ebs-csi-controller-sa.kube-system.sa.talento.k8s.local_policy")
  role   = aws_iam_role.ebs-csi-controller-sa-kube-system-sa-talento-k8s-local.name
}

resource "aws_iam_role_policy" "masters-talento-k8s-local" {
  name   = "masters.talento.k8s.local"
  policy = file("${path.module}/data/aws_iam_role_policy_masters.talento.k8s.local_policy")
  role   = aws_iam_role.masters-talento-k8s-local.name
}

resource "aws_iam_role_policy" "nodes-talento-k8s-local" {
  name   = "nodes.talento.k8s.local"
  policy = file("${path.module}/data/aws_iam_role_policy_nodes.talento.k8s.local_policy")
  role   = aws_iam_role.nodes-talento-k8s-local.name
}

resource "aws_internet_gateway" "talento-k8s-local" {
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.talento-k8s-local.id
}

resource "aws_key_pair" "kubernetes-talento-k8s-local-ab41772cb355e3ec6a757a04ad19136d" {
  key_name   = "kubernetes.talento.k8s.local-ab:41:77:2c:b3:55:e3:ec:6a:75:7a:04:ad:19:13:6d"
  public_key = file("${path.module}/data/aws_key_pair_kubernetes.talento.k8s.local-ab41772cb355e3ec6a757a04ad19136d_public_key")
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_launch_template" "master-eu-west-1a-masters-talento-k8s-local" {
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 64
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.masters-talento-k8s-local.id
  }
  image_id      = "ami-0ef38d2cfb7fd2d03"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.kubernetes-talento-k8s-local-ab41772cb355e3ec6a757a04ad19136d.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 3
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "master-eu-west-1a.masters.talento.k8s.local"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.masters-talento-k8s-local.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                                                     = "talento.k8s.local"
      "Name"                                                                                                  = "master-eu-west-1a.masters.talento.k8s.local"
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"                               = "master-eu-west-1a"
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"                                      = "master"
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/master"                          = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "master-eu-west-1a"
      "kubernetes.io/cluster/talento.k8s.local"                                                               = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                                                     = "talento.k8s.local"
      "Name"                                                                                                  = "master-eu-west-1a.masters.talento.k8s.local"
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"                               = "master-eu-west-1a"
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"                                      = "master"
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/master"                          = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "master-eu-west-1a"
      "kubernetes.io/cluster/talento.k8s.local"                                                               = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                                                     = "talento.k8s.local"
    "Name"                                                                                                  = "master-eu-west-1a.masters.talento.k8s.local"
    "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"                               = "master-eu-west-1a"
    "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
    "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"                                      = "master"
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/master"                          = ""
    "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
    "k8s.io/role/master"                                                                                    = "1"
    "kops.k8s.io/instancegroup"                                                                             = "master-eu-west-1a"
    "kubernetes.io/cluster/talento.k8s.local"                                                               = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_master-eu-west-1a.masters.talento.k8s.local_user_data")
}

resource "aws_launch_template" "nodes-eu-west-1a-talento-k8s-local" {
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 128
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.nodes-talento-k8s-local.id
  }
  image_id      = "ami-0ef38d2cfb7fd2d03"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.kubernetes-talento-k8s-local-ab41772cb355e3ec6a757a04ad19136d.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "nodes-eu-west-1a.talento.k8s.local"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.nodes-talento-k8s-local.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                          = "talento.k8s.local"
      "Name"                                                                       = "nodes-eu-west-1a.talento.k8s.local"
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"    = "nodes-eu-west-1a"
      "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"           = "node"
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-eu-west-1a"
      "kubernetes.io/cluster/talento.k8s.local"                                    = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                          = "talento.k8s.local"
      "Name"                                                                       = "nodes-eu-west-1a.talento.k8s.local"
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"    = "nodes-eu-west-1a"
      "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"           = "node"
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-eu-west-1a"
      "kubernetes.io/cluster/talento.k8s.local"                                    = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                          = "talento.k8s.local"
    "Name"                                                                       = "nodes-eu-west-1a.talento.k8s.local"
    "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"    = "nodes-eu-west-1a"
    "k8s.io/cluster-autoscaler/node-template/label/kubernetes.io/role"           = "node"
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
    "k8s.io/role/node"                                                           = "1"
    "kops.k8s.io/instancegroup"                                                  = "nodes-eu-west-1a"
    "kubernetes.io/cluster/talento.k8s.local"                                    = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_nodes-eu-west-1a.talento.k8s.local_user_data")
}

resource "aws_route" "route-0-0-0-0--0" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.talento-k8s-local.id
  route_table_id         = aws_route_table.talento-k8s-local.id
}

resource "aws_route" "route-__--0" {
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.talento-k8s-local.id
  route_table_id              = aws_route_table.talento-k8s-local.id
}

resource "aws_route_table" "talento-k8s-local" {
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
    "kubernetes.io/kops/role"                 = "public"
  }
  vpc_id = aws_vpc.talento-k8s-local.id
}

resource "aws_route_table_association" "eu-west-1a-talento-k8s-local" {
  route_table_id = aws_route_table.talento-k8s-local.id
  subnet_id      = aws_subnet.eu-west-1a-talento-k8s-local.id
}

resource "aws_s3_bucket_object" "cluster-completed-spec" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_cluster-completed.spec_content")
  key                    = "talento.k8s.local/cluster-completed.spec"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "discovery-json" {
  acl                    = "public-read"
  bucket                 = "talento-development-kops-oidc"
  content                = file("${path.module}/data/aws_s3_bucket_object_discovery.json_content")
  key                    = "/discovery/talento.k8s.local/.well-known/openid-configuration"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "etcd-cluster-spec-events" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_etcd-cluster-spec-events_content")
  key                    = "talento.k8s.local/backups/etcd/events/control/etcd-cluster-spec"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "etcd-cluster-spec-main" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_etcd-cluster-spec-main_content")
  key                    = "talento.k8s.local/backups/etcd/main/control/etcd-cluster-spec"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "keys-json" {
  acl                    = "public-read"
  bucket                 = "talento-development-kops-oidc"
  content                = file("${path.module}/data/aws_s3_bucket_object_keys.json_content")
  key                    = "/discovery/talento.k8s.local/openid/v1/jwks"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "kops-version-txt" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_kops-version.txt_content")
  key                    = "talento.k8s.local/kops-version.txt"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "manifests-etcdmanager-events" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_manifests-etcdmanager-events_content")
  key                    = "talento.k8s.local/manifests/etcd/events.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "manifests-etcdmanager-main" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_manifests-etcdmanager-main_content")
  key                    = "talento.k8s.local/manifests/etcd/main.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "manifests-static-kube-apiserver-healthcheck" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_manifests-static-kube-apiserver-healthcheck_content")
  key                    = "talento.k8s.local/manifests/static/kube-apiserver-healthcheck.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "nodeupconfig-master-eu-west-1a" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_nodeupconfig-master-eu-west-1a_content")
  key                    = "talento.k8s.local/igconfig/master/master-eu-west-1a/nodeupconfig.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "nodeupconfig-nodes-eu-west-1a" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_nodeupconfig-nodes-eu-west-1a_content")
  key                    = "talento.k8s.local/igconfig/node/nodes-eu-west-1a/nodeupconfig.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-aws-ebs-csi-driver-addons-k8s-io-k8s-1-17" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-aws-ebs-csi-driver.addons.k8s.io-k8s-1.17_content")
  key                    = "talento.k8s.local/addons/aws-ebs-csi-driver.addons.k8s.io/k8s-1.17.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-bootstrap" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-bootstrap_content")
  key                    = "talento.k8s.local/addons/bootstrap-channel.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-core-addons-k8s-io" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-core.addons.k8s.io_content")
  key                    = "talento.k8s.local/addons/core.addons.k8s.io/v1.4.0.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-coredns-addons-k8s-io-k8s-1-12" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-coredns.addons.k8s.io-k8s-1.12_content")
  key                    = "talento.k8s.local/addons/coredns.addons.k8s.io/k8s-1.12.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-dns-controller-addons-k8s-io-k8s-1-12" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-dns-controller.addons.k8s.io-k8s-1.12_content")
  key                    = "talento.k8s.local/addons/dns-controller.addons.k8s.io/k8s-1.12.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-kops-controller-addons-k8s-io-k8s-1-16" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-kops-controller.addons.k8s.io-k8s-1.16_content")
  key                    = "talento.k8s.local/addons/kops-controller.addons.k8s.io/k8s-1.16.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-kubelet-api-rbac-addons-k8s-io-k8s-1-9" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-kubelet-api.rbac.addons.k8s.io-k8s-1.9_content")
  key                    = "talento.k8s.local/addons/kubelet-api.rbac.addons.k8s.io/k8s-1.9.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-leader-migration-rbac-addons-k8s-io-k8s-1-23" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-leader-migration.rbac.addons.k8s.io-k8s-1.23_content")
  key                    = "talento.k8s.local/addons/leader-migration.rbac.addons.k8s.io/k8s-1.23.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-limit-range-addons-k8s-io" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-limit-range.addons.k8s.io_content")
  key                    = "talento.k8s.local/addons/limit-range.addons.k8s.io/v1.5.0.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "talento-k8s-local-addons-storage-aws-addons-k8s-io-v1-15-0" {
  bucket                 = "talento-development-kops-state"
  content                = file("${path.module}/data/aws_s3_bucket_object_talento.k8s.local-addons-storage-aws.addons.k8s.io-v1.15.0_content")
  key                    = "talento.k8s.local/addons/storage-aws.addons.k8s.io/v1.15.0.yaml"
  provider               = aws.files
  server_side_encryption = "AES256"
}

resource "aws_security_group" "api-elb-talento-k8s-local" {
  description = "Security group for api ELB"
  name        = "api-elb.talento.k8s.local"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "api-elb.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.talento-k8s-local.id
}

resource "aws_security_group" "masters-talento-k8s-local" {
  description = "Security group for masters"
  name        = "masters.talento.k8s.local"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "masters.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.talento-k8s-local.id
}

resource "aws_security_group" "nodes-talento-k8s-local" {
  description = "Security group for nodes"
  name        = "nodes.talento.k8s.local"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "nodes.talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.talento-k8s-local.id
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-masters-talento-k8s-local" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-talento-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-nodes-talento-k8s-local" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-443to443-api-elb-talento-k8s-local" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-22to22-masters-talento-k8s-local" {
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-talento-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-22to22-nodes-talento-k8s-local" {
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-443to443-api-elb-talento-k8s-local" {
  from_port         = 443
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-api-elb-talento-k8s-local-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-api-elb-talento-k8s-local-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-talento-k8s-local-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.masters-talento-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-talento-k8s-local-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.masters-talento-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-talento-k8s-local-ingress-all-0to0-masters-talento-k8s-local" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-talento-k8s-local.id
  source_security_group_id = aws_security_group.masters-talento-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-masters-talento-k8s-local-ingress-all-0to0-nodes-talento-k8s-local" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-talento-k8s-local.id
  source_security_group_id = aws_security_group.masters-talento-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-ingress-all-0to0-nodes-talento-k8s-local" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-talento-k8s-local.id
  source_security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-ingress-tcp-1to2379-masters-talento-k8s-local" {
  from_port                = 1
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-talento-k8s-local.id
  source_security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port                  = 2379
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-ingress-tcp-2382to4000-masters-talento-k8s-local" {
  from_port                = 2382
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-talento-k8s-local.id
  source_security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port                  = 4000
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-ingress-tcp-4003to65535-masters-talento-k8s-local" {
  from_port                = 4003
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-talento-k8s-local.id
  source_security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-talento-k8s-local-ingress-udp-1to65535-masters-talento-k8s-local" {
  from_port                = 1
  protocol                 = "udp"
  security_group_id        = aws_security_group.masters-talento-k8s-local.id
  source_security_group_id = aws_security_group.nodes-talento-k8s-local.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "https-elb-to-master" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-talento-k8s-local.id
  source_security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3
  protocol          = "icmp"
  security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port           = 4
  type              = "ingress"
}

resource "aws_security_group_rule" "icmpv6-pmtu-api-elb-__--0" {
  from_port         = -1
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "icmpv6"
  security_group_id = aws_security_group.api-elb-talento-k8s-local.id
  to_port           = -1
  type              = "ingress"
}

resource "aws_subnet" "eu-west-1a-talento-k8s-local" {
  availability_zone = "eu-west-1a"
  cidr_block        = "172.20.32.0/19"
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "eu-west-1a.talento.k8s.local"
    "SubnetType"                              = "Public"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
    "kubernetes.io/role/elb"                  = "1"
    "kubernetes.io/role/internal-elb"         = "1"
  }
  vpc_id = aws_vpc.talento-k8s-local.id
}

resource "aws_vpc" "talento-k8s-local" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = "172.20.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "talento-k8s-local" {
  domain_name         = "eu-west-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    "KubernetesCluster"                       = "talento.k8s.local"
    "Name"                                    = "talento.k8s.local"
    "kubernetes.io/cluster/talento.k8s.local" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "talento-k8s-local" {
  dhcp_options_id = aws_vpc_dhcp_options.talento-k8s-local.id
  vpc_id          = aws_vpc.talento-k8s-local.id
}

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      "configuration_aliases" = [aws.files]
      "source"                = "hashicorp/aws"
      "version"               = ">= 3.59.0"
    }
  }
}
