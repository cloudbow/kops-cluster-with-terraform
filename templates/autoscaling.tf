resource "aws_autoscaling_attachment" "master-us-east-2a-masters-#cluster_name_hyphenated#" {
  elb                    = "${aws_elb.api-#cluster_name_hyphenated#.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-east-2a-masters-#cluster_name_hyphenated#.id}"
}

resource "aws_autoscaling_group" "master-us-east-2a-masters-#cluster_name_hyphenated#" {
  name                 = "master-us-east-2a.masters.#cluster_name#"
  launch_configuration = "${aws_launch_configuration.master-us-east-2a-masters-#cluster_name_hyphenated#.id}"
  max_size             = "${var.aws_master_instance_nos}"
  min_size             = "${var.aws_master_instance_nos}"
  vpc_zone_identifier  = ["${aws_subnet.us-east-2a-#cluster_name_hyphenated#.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "#cluster_name#"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-2a.masters.#cluster_name#"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-east-2a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-#cluster_name_hyphenated#" {
  name                 = "nodes.#cluster_name#"
  launch_configuration = "${aws_launch_configuration.nodes-#cluster_name_hyphenated#.id}"
  max_size             = "${var.aws_node_instance_nos}"
  min_size             = "${var.aws_node_instance_nos}"
  vpc_zone_identifier  = ["${aws_subnet.us-east-2a-#cluster_name_hyphenated#.id}", "${aws_subnet.us-east-2b-#cluster_name_hyphenated#.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "#cluster_name#"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.#cluster_name#"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}