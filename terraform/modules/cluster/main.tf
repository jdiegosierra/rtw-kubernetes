provider "aws" {
  region = var.region
  profile = var.profile
}
resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Cluster"
  }
}
// Public Resources
resource "aws_subnet" "cluster_public_subnet" {
  vpc_id = "${aws_vpc.cluster_vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "Cluster Public"
  }
  depends_on = [
    aws_vpc.cluster_vpc
  ]
}
resource "aws_internet_gateway" "cluster_internet_gateway" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = {
    Name = "Cluster"
  }
  depends_on = [
    aws_vpc.cluster_vpc
  ]
}
resource "aws_route_table" "cluster_public_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster_internet_gateway.id
  }
  tags = {
    Name = "Cluster Public"
  }
  depends_on = [
    aws_vpc.cluster_vpc,
    aws_internet_gateway.cluster_internet_gateway
  ]
}
resource "aws_route_table_association" "cluster_public_subnet_to_route_table" {
  subnet_id = aws_subnet.cluster_public_subnet.id
  route_table_id = aws_route_table.cluster_public_route_table.id
  depends_on = [
    aws_subnet.cluster_public_subnet,
    aws_route_table.cluster_public_route_table
  ]
}
resource "aws_eip" "cluster_nat_gateway_elastic_ip" {
  vpc   = true
}
resource "aws_nat_gateway" "cluster_nat_gateway" {
  allocation_id = aws_eip.cluster_nat_gateway_elastic_ip.id
  subnet_id     = aws_subnet.cluster_public_subnet.id
  tags = {
    Name = "Cluster"
  }
  depends_on = [
    aws_eip.cluster_nat_gateway_elastic_ip,
    aws_subnet.cluster_public_subnet
  ]
}
resource "aws_key_pair" "cluster_key_pair" {
  key_name   = "ClusterKeyPair"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_security_group" "cluster_security_group" {
  vpc_id               = aws_vpc.cluster_vpc.id
  egress               = [
    {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0" ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
    # {
    #   cidr_blocks      = [ "0.0.0.0/0" ]
    #   description      = ""
    #   from_port        = 22
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "tcp"
    #   security_groups  = []
    #   self             = false
    #   to_port          = 22
    # },
    # {
    #   cidr_blocks      = [ "0.0.0.0/0" ]
    #   description      = ""
    #   from_port        = 6443
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "tcp"
    #   security_groups  = []
    #   self             = false
    #   to_port          = 6443
    # },
    # {
    #   cidr_blocks      = [ "0.0.0.0/0" ]
    #   description      = ""
    #   from_port        = 2379
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "tcp"
    #   security_groups  = []
    #   self             = false
    #   to_port          = 2379
    # },
    # {
    #   cidr_blocks      = [ "0.0.0.0/0" ]
    #   description      = ""
    #   from_port        = 2380
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   protocol         = "tcp"
    #   security_groups  = []
    #   self             = false
    #   to_port          = 2380
    # }
  ]
  tags = {
    Name = "Cluster"
  }
  depends_on = [
    aws_vpc.cluster_vpc
  ]
}
# resource "aws_elb" "cluster_load_balancer" {
#   name               = "Cluster Load Balancer"
#   availability_zones = ["eu-west-1a"]

#   access_logs {
#     bucket        = "foo"
#     bucket_prefix = "bar"
#     interval      = 60
#   }
#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#   listener {
#     instance_port      = 8000
#     instance_protocol  = "http"
#     lb_port            = 443
#     lb_protocol        = "https"
#     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
#   }
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }
#   instances                   = [aws_instance.foo.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400
# }
resource "aws_instance" "kubernetes_control_plane" {
  count                       = 2
  ami                         = "ami-081ff4b9aa4e81a08"
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.cluster_key_pair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [ aws_security_group.cluster_security_group.id ]
  subnet_id                   = aws_subnet.cluster_public_subnet.id
  tags = {
    Name = "kubernetes_control_plane"
  }
  depends_on = [
    aws_key_pair.cluster_key_pair,
    aws_security_group.cluster_security_group,
    aws_subnet.cluster_public_subnet
  ]
}

// Private Resources
resource "aws_subnet" "cluster_private_subnet" {
  vpc_id = "${aws_vpc.cluster_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "Cluster Private"
  }
  depends_on = [
    aws_vpc.cluster_vpc
  ]
}
resource "aws_route_table" "cluster_private_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cluster_nat_gateway.id
  }
  tags = {
    Name = "Cluster Private"
  }
  depends_on = [
    aws_vpc.cluster_vpc,
    aws_nat_gateway.cluster_nat_gateway
  ]
}
resource "aws_route_table_association" "cluster_private_subnet_to_route_table" {
  subnet_id = aws_subnet.cluster_private_subnet.id
  route_table_id = aws_route_table.cluster_private_route_table.id
  depends_on = [
    aws_subnet.cluster_private_subnet,
    aws_route_table.cluster_private_route_table
  ]
}
resource "aws_instance" "kubernetes_worker_node" {
  ami                         = "ami-081ff4b9aa4e81a08"
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.cluster_key_pair.key_name
  vpc_security_group_ids      = [ aws_security_group.cluster_security_group.id ]
  subnet_id                   = aws_subnet.cluster_private_subnet.id
  tags = {
    Name = "kubernetes_worker_node"
  }
  depends_on = [
    aws_key_pair.cluster_key_pair,
    aws_security_group.cluster_security_group,
    aws_subnet.cluster_public_subnet
  ]
}