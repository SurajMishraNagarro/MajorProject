locals {
  cluster_name                 = "suraj-cluster.k8s.local"
  master_autoscaling_group_ids = [aws_autoscaling_group.control-plane-us-east-1a-masters-suraj-cluster-k8s-local.id]
  master_security_group_ids    = [aws_security_group.masters-suraj-cluster-k8s-local.id]
  masters_role_arn             = aws_iam_role.masters-suraj-cluster-k8s-local.arn
  masters_role_name            = aws_iam_role.masters-suraj-cluster-k8s-local.name
  node_autoscaling_group_ids   = [aws_autoscaling_group.nodes-us-east-1a-suraj-cluster-k8s-local.id]
  node_security_group_ids      = [aws_security_group.nodes-suraj-cluster-k8s-local.id]
  node_subnet_ids              = [aws_subnet.us-east-1a-suraj-cluster-k8s-local.id]
  nodes_role_arn               = aws_iam_role.nodes-suraj-cluster-k8s-local.arn
  nodes_role_name              = aws_iam_role.nodes-suraj-cluster-k8s-local.name
  region                       = "us-east-1"
  route_table_public_id        = aws_route_table.suraj-cluster-k8s-local.id
  subnet_us-east-1a_id         = aws_subnet.us-east-1a-suraj-cluster-k8s-local.id
  vpc_cidr_block               = aws_vpc.suraj-cluster-k8s-local.cidr_block
  vpc_id                       = aws_vpc.suraj-cluster-k8s-local.id
  vpc_ipv6_cidr_block          = aws_vpc.suraj-cluster-k8s-local.ipv6_cidr_block
  vpc_ipv6_cidr_length         = local.vpc_ipv6_cidr_block == "" ? null : tonumber(regex(".*/(\\d+)", local.vpc_ipv6_cidr_block)[0])
}

output "cluster_name" {
  value = "suraj-cluster.k8s.local"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.control-plane-us-east-1a-masters-suraj-cluster-k8s-local.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-suraj-cluster-k8s-local.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-suraj-cluster-k8s-local.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-suraj-cluster-k8s-local.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-us-east-1a-suraj-cluster-k8s-local.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-suraj-cluster-k8s-local.id]
}

output "node_subnet_ids" {
  value = [aws_subnet.us-east-1a-suraj-cluster-k8s-local.id]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-suraj-cluster-k8s-local.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-suraj-cluster-k8s-local.name
}

output "region" {
  value = "us-east-1"
}

output "route_table_public_id" {
  value = aws_route_table.suraj-cluster-k8s-local.id
}

output "subnet_us-east-1a_id" {
  value = aws_subnet.us-east-1a-suraj-cluster-k8s-local.id
}

output "vpc_cidr_block" {
  value = aws_vpc.suraj-cluster-k8s-local.cidr_block
}

output "vpc_id" {
  value = aws_vpc.suraj-cluster-k8s-local.id
}

output "vpc_ipv6_cidr_block" {
  value = aws_vpc.suraj-cluster-k8s-local.ipv6_cidr_block
}

output "vpc_ipv6_cidr_length" {
  value = local.vpc_ipv6_cidr_block == "" ? null : tonumber(regex(".*/(\\d+)", local.vpc_ipv6_cidr_block)[0])
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "files"
  region = "us-east-1"
}

resource "aws_autoscaling_group" "control-plane-us-east-1a-masters-suraj-cluster-k8s-local" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.control-plane-us-east-1a-masters-suraj-cluster-k8s-local.id
    version = aws_launch_template.control-plane-us-east-1a-masters-suraj-cluster-k8s-local.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "control-plane-us-east-1a.masters.suraj-cluster.k8s.local"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "suraj-cluster.k8s.local"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "control-plane-us-east-1a.masters.suraj-cluster.k8s.local"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/control-plane"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "control-plane-us-east-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/suraj-cluster.k8s.local"
    propagate_at_launch = true
    value               = "owned"
  }
  target_group_arns   = [aws_lb_target_group.tcp-suraj-cluster-k8s-loc-5adv57.id]
  vpc_zone_identifier = [aws_subnet.us-east-1a-suraj-cluster-k8s-local.id]
}

resource "aws_autoscaling_group" "nodes-us-east-1a-suraj-cluster-k8s-local" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.nodes-us-east-1a-suraj-cluster-k8s-local.id
    version = aws_launch_template.nodes-us-east-1a-suraj-cluster-k8s-local.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "nodes-us-east-1a.suraj-cluster.k8s.local"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "suraj-cluster.k8s.local"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-us-east-1a.suraj-cluster.k8s.local"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
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
    value               = "nodes-us-east-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/suraj-cluster.k8s.local"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.us-east-1a-suraj-cluster-k8s-local.id]
}

resource "aws_autoscaling_lifecycle_hook" "control-plane-us-east-1a-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.control-plane-us-east-1a-masters-suraj-cluster-k8s-local.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "control-plane-us-east-1a-NTHLifecycleHook"
}

resource "aws_autoscaling_lifecycle_hook" "nodes-us-east-1a-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.nodes-us-east-1a-suraj-cluster-k8s-local.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "nodes-us-east-1a-NTHLifecycleHook"
}

resource "aws_cloudwatch_event_rule" "suraj-cluster-k8s-local-ASGLifecycle" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_suraj-cluster.k8s.local-ASGLifecycle_event_pattern")
  name          = "suraj-cluster.k8s.local-ASGLifecycle"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local-ASGLifecycle"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "suraj-cluster-k8s-local-InstanceScheduledChange" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_suraj-cluster.k8s.local-InstanceScheduledChange_event_pattern")
  name          = "suraj-cluster.k8s.local-InstanceScheduledChange"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local-InstanceScheduledChange"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "suraj-cluster-k8s-local-InstanceStateChange" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_suraj-cluster.k8s.local-InstanceStateChange_event_pattern")
  name          = "suraj-cluster.k8s.local-InstanceStateChange"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local-InstanceStateChange"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "suraj-cluster-k8s-local-SpotInterruption" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_suraj-cluster.k8s.local-SpotInterruption_event_pattern")
  name          = "suraj-cluster.k8s.local-SpotInterruption"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local-SpotInterruption"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

# resource "aws_cloudwatch_event_target" "suraj-cluster-k8s-local-ASGLifecycle-Target" {
#   arn  = aws_sqs_queue.suraj-cluster-k8s-local-nth.arn
#   rule = aws_cloudwatch_event_rule.suraj-cluster-k8s-local-ASGLifecycle.id
# }

# resource "aws_cloudwatch_event_target" "suraj-cluster-k8s-local-InstanceScheduledChange-Target" {
#   arn  = aws_sqs_queue.suraj-cluster-k8s-local-nth.arn
#   rule = aws_cloudwatch_event_rule.suraj-cluster-k8s-local-InstanceScheduledChange.id
# }

# resource "aws_cloudwatch_event_target" "suraj-cluster-k8s-local-InstanceStateChange-Target" {
#   arn  = aws_sqs_queue.suraj-cluster-k8s-local-nth.arn
#   rule = aws_cloudwatch_event_rule.suraj-cluster-k8s-local-InstanceStateChange.id
# }

# resource "aws_cloudwatch_event_target" "suraj-cluster-k8s-local-SpotInterruption-Target" {
#   arn  = aws_sqs_queue.suraj-cluster-k8s-local-nth.arn
#   rule = aws_cloudwatch_event_rule.suraj-cluster-k8s-local-SpotInterruption.id
# }

resource "aws_ebs_volume" "a-etcd-events-suraj-cluster-k8s-local" {
  availability_zone = "us-east-1a"
  encrypted         = true
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "a.etcd-events.suraj-cluster.k8s.local"
    "k8s.io/etcd/events"                            = "a/a"
    "k8s.io/role/control-plane"                     = "1"
    "k8s.io/role/master"                            = "1"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_ebs_volume" "a-etcd-main-suraj-cluster-k8s-local" {
  availability_zone = "us-east-1a"
  encrypted         = true
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "a.etcd-main.suraj-cluster.k8s.local"
    "k8s.io/etcd/main"                              = "a/a"
    "k8s.io/role/control-plane"                     = "1"
    "k8s.io/role/master"                            = "1"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_iam_instance_profile" "masters-suraj-cluster-k8s-local" {
  name = "masters.suraj-cluster.k8s.local"
  role = aws_iam_role.masters-suraj-cluster-k8s-local.name
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "masters.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_iam_instance_profile" "nodes-suraj-cluster-k8s-local" {
  name = "nodes.suraj-cluster.k8s.local"
  role = aws_iam_role.nodes-suraj-cluster-k8s-local.name
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "nodes.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_iam_role" "masters-suraj-cluster-k8s-local" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_masters.suraj-cluster.k8s.local_policy")
  name               = "masters.suraj-cluster.k8s.local"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "masters.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_iam_role" "nodes-suraj-cluster-k8s-local" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_nodes.suraj-cluster.k8s.local_policy")
  name               = "nodes.suraj-cluster.k8s.local"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "nodes.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_iam_role_policy" "masters-suraj-cluster-k8s-local" {
  name   = "masters.suraj-cluster.k8s.local"
  policy = file("${path.module}/data/aws_iam_role_policy_masters.suraj-cluster.k8s.local_policy")
  role   = aws_iam_role.masters-suraj-cluster-k8s-local.name
}

resource "aws_iam_role_policy" "nodes-suraj-cluster-k8s-local" {
  name   = "nodes.suraj-cluster.k8s.local"
  policy = file("${path.module}/data/aws_iam_role_policy_nodes.suraj-cluster.k8s.local_policy")
  role   = aws_iam_role.nodes-suraj-cluster-k8s-local.name
}

resource "aws_internet_gateway" "suraj-cluster-k8s-local" {
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_key_pair" "kubernetes-suraj-cluster-k8s-local-0809316bc168fff64f4e64d7f8273f70" {
  key_name   = "kubernetes.suraj-cluster.k8s.local-08:09:31:6b:c1:68:ff:f6:4f:4e:64:d7:f8:27:3f:70"
  public_key = file("${path.module}/data/aws_key_pair_kubernetes.suraj-cluster.k8s.local-0809316bc168fff64f4e64d7f8273f70_public_key")
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_launch_template" "control-plane-us-east-1a-masters-suraj-cluster-k8s-local" {
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
    name = aws_iam_instance_profile.masters-suraj-cluster-k8s-local.id
  }
  image_id      = "ami-05c17b22914ce7378"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.kubernetes-suraj-cluster-k8s-local-0809316bc168fff64f4e64d7f8273f70.id
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
  name = "control-plane-us-east-1a.masters.suraj-cluster.k8s.local"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.masters-suraj-cluster-k8s-local.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                                                     = "suraj-cluster.k8s.local"
      "Name"                                                                                                  = "control-plane-us-east-1a.masters.suraj-cluster.k8s.local"
      "aws-node-termination-handler/managed"                                                                  = ""
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/control-plane"                                                                             = "1"
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "control-plane-us-east-1a"
      "kubernetes.io/cluster/suraj-cluster.k8s.local"                                                         = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                                                     = "suraj-cluster.k8s.local"
      "Name"                                                                                                  = "control-plane-us-east-1a.masters.suraj-cluster.k8s.local"
      "aws-node-termination-handler/managed"                                                                  = ""
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/control-plane"                                                                             = "1"
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "control-plane-us-east-1a"
      "kubernetes.io/cluster/suraj-cluster.k8s.local"                                                         = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                                                     = "suraj-cluster.k8s.local"
    "Name"                                                                                                  = "control-plane-us-east-1a.masters.suraj-cluster.k8s.local"
    "aws-node-termination-handler/managed"                                                                  = ""
    "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
    "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
    "k8s.io/role/control-plane"                                                                             = "1"
    "k8s.io/role/master"                                                                                    = "1"
    "kops.k8s.io/instancegroup"                                                                             = "control-plane-us-east-1a"
    "kubernetes.io/cluster/suraj-cluster.k8s.local"                                                         = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_control-plane-us-east-1a.masters.suraj-cluster.k8s.local_user_data")
}

resource "aws_launch_template" "nodes-us-east-1a-suraj-cluster-k8s-local" {
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
    name = aws_iam_instance_profile.nodes-suraj-cluster-k8s-local.id
  }
  image_id      = "ami-05c17b22914ce7378"
  instance_type = "t3.small"
  key_name      = aws_key_pair.kubernetes-suraj-cluster-k8s-local-0809316bc168fff64f4e64d7f8273f70.id
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
  name = "nodes-us-east-1a.suraj-cluster.k8s.local"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.nodes-suraj-cluster-k8s-local.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                          = "suraj-cluster.k8s.local"
      "Name"                                                                       = "nodes-us-east-1a.suraj-cluster.k8s.local"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-us-east-1a"
      "kubernetes.io/cluster/suraj-cluster.k8s.local"                              = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                          = "suraj-cluster.k8s.local"
      "Name"                                                                       = "nodes-us-east-1a.suraj-cluster.k8s.local"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-us-east-1a"
      "kubernetes.io/cluster/suraj-cluster.k8s.local"                              = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                          = "suraj-cluster.k8s.local"
    "Name"                                                                       = "nodes-us-east-1a.suraj-cluster.k8s.local"
    "aws-node-termination-handler/managed"                                       = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
    "k8s.io/role/node"                                                           = "1"
    "kops.k8s.io/instancegroup"                                                  = "nodes-us-east-1a"
    "kubernetes.io/cluster/suraj-cluster.k8s.local"                              = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_nodes-us-east-1a.suraj-cluster.k8s.local_user_data")
}

resource "aws_lb" "api-suraj-cluster-k8s-local" {
  enable_cross_zone_load_balancing = false
  internal                         = false
  load_balancer_type               = "network"
  name                             = "api-suraj-cluster-k8s-loc-copafe"
  security_groups                  = [aws_security_group.api-elb-suraj-cluster-k8s-local.id]
  subnet_mapping {
    subnet_id = aws_subnet.us-east-1a-suraj-cluster-k8s-local.id
  }
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "api.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_lb_listener" "api-suraj-cluster-k8s-local-443" {
  default_action {
    target_group_arn = aws_lb_target_group.tcp-suraj-cluster-k8s-loc-5adv57.id
    type             = "forward"
  }
  load_balancer_arn = aws_lb.api-suraj-cluster-k8s-local.id
  port              = 443
  protocol          = "TCP"
}

resource "aws_lb_target_group" "tcp-suraj-cluster-k8s-loc-5adv57" {
  connection_termination = "true"
  deregistration_delay   = "30"
  health_check {
    healthy_threshold   = 2
    interval            = 10
    protocol            = "TCP"
    unhealthy_threshold = 2
  }
  name     = "tcp-suraj-cluster-k8s-loc-5adv57"
  port     = 443
  protocol = "TCP"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "tcp-suraj-cluster-k8s-loc-5adv57"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_route" "route-0-0-0-0--0" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.suraj-cluster-k8s-local.id
  route_table_id         = aws_route_table.suraj-cluster-k8s-local.id
}

resource "aws_route" "route-__--0" {
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.suraj-cluster-k8s-local.id
  route_table_id              = aws_route_table.suraj-cluster-k8s-local.id
}

resource "aws_route_table" "suraj-cluster-k8s-local" {
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
    "kubernetes.io/kops/role"                       = "public"
  }
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_route_table_association" "us-east-1a-suraj-cluster-k8s-local" {
  route_table_id = aws_route_table.suraj-cluster-k8s-local.id
  subnet_id      = aws_subnet.us-east-1a-suraj-cluster-k8s-local.id
}

resource "aws_s3_object" "cluster-completed-spec" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_cluster-completed.spec_content")
  key      = "suraj-cluster.k8s.local/cluster-completed.spec"
  provider = aws.files
}

resource "aws_s3_object" "etcd-cluster-spec-events" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_etcd-cluster-spec-events_content")
  key      = "suraj-cluster.k8s.local/backups/etcd/events/control/etcd-cluster-spec"
  provider = aws.files
}

resource "aws_s3_object" "etcd-cluster-spec-main" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_etcd-cluster-spec-main_content")
  key      = "suraj-cluster.k8s.local/backups/etcd/main/control/etcd-cluster-spec"
  provider = aws.files
}

resource "aws_s3_object" "kops-version-txt" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_kops-version.txt_content")
  key      = "suraj-cluster.k8s.local/kops-version.txt"
  provider = aws.files
}

resource "aws_s3_object" "manifests-etcdmanager-events-control-plane-us-east-1a" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_manifests-etcdmanager-events-control-plane-us-east-1a_content")
  key      = "suraj-cluster.k8s.local/manifests/etcd/events-control-plane-us-east-1a.yaml"
  provider = aws.files
}

resource "aws_s3_object" "manifests-etcdmanager-main-control-plane-us-east-1a" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_manifests-etcdmanager-main-control-plane-us-east-1a_content")
  key      = "suraj-cluster.k8s.local/manifests/etcd/main-control-plane-us-east-1a.yaml"
  provider = aws.files
}

resource "aws_s3_object" "manifests-static-kube-apiserver-healthcheck" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_manifests-static-kube-apiserver-healthcheck_content")
  key      = "suraj-cluster.k8s.local/manifests/static/kube-apiserver-healthcheck.yaml"
  provider = aws.files
}

resource "aws_s3_object" "nodeupconfig-control-plane-us-east-1a" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_nodeupconfig-control-plane-us-east-1a_content")
  key      = "suraj-cluster.k8s.local/igconfig/control-plane/control-plane-us-east-1a/nodeupconfig.yaml"
  provider = aws.files
}

resource "aws_s3_object" "nodeupconfig-nodes-us-east-1a" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_nodeupconfig-nodes-us-east-1a_content")
  key      = "suraj-cluster.k8s.local/igconfig/node/nodes-us-east-1a/nodeupconfig.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-aws-cloud-controller-addons-k8s-io-k8s-1-18" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-aws-cloud-controller.addons.k8s.io-k8s-1.18_content")
  key      = "suraj-cluster.k8s.local/addons/aws-cloud-controller.addons.k8s.io/k8s-1.18.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-aws-ebs-csi-driver-addons-k8s-io-k8s-1-17" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-aws-ebs-csi-driver.addons.k8s.io-k8s-1.17_content")
  key      = "suraj-cluster.k8s.local/addons/aws-ebs-csi-driver.addons.k8s.io/k8s-1.17.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-bootstrap" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-bootstrap_content")
  key      = "suraj-cluster.k8s.local/addons/bootstrap-channel.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-coredns-addons-k8s-io-k8s-1-12" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-coredns.addons.k8s.io-k8s-1.12_content")
  key      = "suraj-cluster.k8s.local/addons/coredns.addons.k8s.io/k8s-1.12.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-dns-controller-addons-k8s-io-k8s-1-12" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-dns-controller.addons.k8s.io-k8s-1.12_content")
  key      = "suraj-cluster.k8s.local/addons/dns-controller.addons.k8s.io/k8s-1.12.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-kops-controller-addons-k8s-io-k8s-1-16" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-kops-controller.addons.k8s.io-k8s-1.16_content")
  key      = "suraj-cluster.k8s.local/addons/kops-controller.addons.k8s.io/k8s-1.16.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-kubelet-api-rbac-addons-k8s-io-k8s-1-9" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-kubelet-api.rbac.addons.k8s.io-k8s-1.9_content")
  key      = "suraj-cluster.k8s.local/addons/kubelet-api.rbac.addons.k8s.io/k8s-1.9.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-limit-range-addons-k8s-io" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-limit-range.addons.k8s.io_content")
  key      = "suraj-cluster.k8s.local/addons/limit-range.addons.k8s.io/v1.5.0.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-node-termination-handler-aws-k8s-1-11" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-node-termination-handler.aws-k8s-1.11_content")
  key      = "suraj-cluster.k8s.local/addons/node-termination-handler.aws/k8s-1.11.yaml"
  provider = aws.files
}

resource "aws_s3_object" "suraj-cluster-k8s-local-addons-storage-aws-addons-k8s-io-v1-15-0" {
  bucket   = "surajkopsbucket"
  content  = file("${path.module}/data/aws_s3_object_suraj-cluster.k8s.local-addons-storage-aws.addons.k8s.io-v1.15.0_content")
  key      = "suraj-cluster.k8s.local/addons/storage-aws.addons.k8s.io/v1.15.0.yaml"
  provider = aws.files
}

resource "aws_security_group" "api-elb-suraj-cluster-k8s-local" {
  description = "Security group for api ELB"
  name        = "api-elb.suraj-cluster.k8s.local"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "api-elb.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_security_group" "masters-suraj-cluster-k8s-local" {
  description = "Security group for masters"
  name        = "masters.suraj-cluster.k8s.local"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "masters.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_security_group" "nodes-suraj-cluster-k8s-local" {
  description = "Security group for nodes"
  name        = "nodes.suraj-cluster.k8s.local"
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "nodes.suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-masters-suraj-cluster-k8s-local" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-nodes-suraj-cluster-k8s-local" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-443to443-api-elb-suraj-cluster-k8s-local" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-22to22-masters-suraj-cluster-k8s-local" {
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-22to22-nodes-suraj-cluster-k8s-local" {
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-443to443-api-elb-suraj-cluster-k8s-local" {
  from_port         = 443
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-api-elb-suraj-cluster-k8s-local-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-api-elb-suraj-cluster-k8s-local-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-suraj-cluster-k8s-local-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-suraj-cluster-k8s-local-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-suraj-cluster-k8s-local-ingress-all-0to0-masters-suraj-cluster-k8s-local" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-masters-suraj-cluster-k8s-local-ingress-all-0to0-nodes-suraj-cluster-k8s-local" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-ingress-all-0to0-nodes-suraj-cluster-k8s-local" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-ingress-tcp-1to2379-masters-suraj-cluster-k8s-local" {
  from_port                = 1
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port                  = 2379
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-ingress-tcp-2382to4000-masters-suraj-cluster-k8s-local" {
  from_port                = 2382
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port                  = 4000
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-ingress-tcp-4003to65535-masters-suraj-cluster-k8s-local" {
  from_port                = 4003
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-suraj-cluster-k8s-local-ingress-udp-1to65535-masters-suraj-cluster-k8s-local" {
  from_port                = 1
  protocol                 = "udp"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.nodes-suraj-cluster-k8s-local.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "https-elb-to-master" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3
  protocol          = "icmp"
  security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port           = 4
  type              = "ingress"
}

resource "aws_security_group_rule" "icmp-pmtu-cp-to-elb" {
  from_port                = 3
  protocol                 = "icmp"
  security_group_id        = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.masters-suraj-cluster-k8s-local.id
  to_port                  = 4
  type                     = "ingress"
}

resource "aws_security_group_rule" "icmp-pmtu-elb-to-cp" {
  from_port                = 3
  protocol                 = "icmp"
  security_group_id        = aws_security_group.masters-suraj-cluster-k8s-local.id
  source_security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port                  = 4
  type                     = "ingress"
}

resource "aws_security_group_rule" "icmpv6-pmtu-api-elb-__--0" {
  from_port         = -1
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "icmpv6"
  security_group_id = aws_security_group.api-elb-suraj-cluster-k8s-local.id
  to_port           = -1
  type              = "ingress"
}

# resource "aws_sqs_queue" "suraj-cluster-k8s-local-nth" {
#   message_retention_seconds = 300
#   name                      = "suraj-cluster-k8s-local-nth"
#   policy                    = file("${path.module}/data/aws_sqs_queue_suraj-cluster-k8s-local-nth_policy")
#   tags = {
#     "KubernetesCluster"                             = "suraj-cluster.k8s.local"
#     "Name"                                          = "suraj-cluster-k8s-local-nth"
#     "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
#   }
# }

resource "aws_subnet" "us-east-1a-suraj-cluster-k8s-local" {
  availability_zone                           = "us-east-1a"
  cidr_block                                  = "172.20.0.0/16"
  enable_resource_name_dns_a_record_on_launch = true
  private_dns_hostname_type_on_launch         = "resource-name"
  vpc_id = aws_vpc.suraj-cluster-k8s-local.id
}

resource "aws_vpc" "suraj-cluster-k8s-local" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = "172.20.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "suraj-cluster-k8s-local" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    "KubernetesCluster"                             = "suraj-cluster.k8s.local"
    "Name"                                          = "suraj-cluster.k8s.local"
    "kubernetes.io/cluster/suraj-cluster.k8s.local" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "suraj-cluster-k8s-local" {
  dhcp_options_id = aws_vpc_dhcp_options.suraj-cluster-k8s-local.id
  vpc_id          = aws_vpc.suraj-cluster-k8s-local.id
}

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      "configuration_aliases" = [aws.files]
      "source"                = "hashicorp/aws"
      "version"               = ">= 5.0.0"
    }
  }
}
