resource "aws_security_group" "api-elb-#cluster_name_hyphenated#" {
  name        = "api-elb.#cluster_name#"
  vpc_id      = "${aws_vpc.#cluster_name_hyphenated#.id}"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "api-elb.#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_security_group" "masters-#cluster_name_hyphenated#" {
  name        = "masters.#cluster_name#"
  vpc_id      = "${aws_vpc.#cluster_name_hyphenated#.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "masters.#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_security_group" "nodes-#cluster_name_hyphenated#" {
  name        = "nodes.#cluster_name#"
  vpc_id      = "${aws_vpc.#cluster_name_hyphenated#.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "nodes.#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress-#cluster_name_hyphenated#" {
  type              = "egress"
  security_group_id = "${aws_security_group.api-elb-#cluster_name_hyphenated#.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-api-elb-#cluster_name_hyphenated#" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-#cluster_name_hyphenated#.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [#corporte_cidr#]
}

resource "aws_security_group_rule" "https-elb-to-master-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.api-elb-#cluster_name_hyphenated#.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "master-egress-#cluster_name_hyphenated#" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress-#cluster_name_hyphenated#" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535-#cluster_name_hyphenated#" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  source_security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-#cluster_name_hyphenated#" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-#cluster_name_hyphenated#.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-#cluster_name_hyphenated#" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-#cluster_name_hyphenated#.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}