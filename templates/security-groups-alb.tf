resource "aws_security_group" "alb-#cluster_name_hyphenated#" {
  name        = "alb-#cluster_name#"
  vpc_id      = "${aws_vpc.#cluster_name_hyphenated#.id}"
  description = "Security group for alb"
  tags = {
    "ManagedBy"                              = "alb-ingress"
    "Name"                                   = "alb-#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_security_group_rule" "alb-#cluster_name_hyphenated#-80-rule" {
  type              = "ingress"
  security_group_id = "${aws_security_group.alb-#cluster_name_hyphenated#.id}"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-#cluster_name_hyphenated#-corporate-rule" {
  type              = "ingress"
  security_group_id = "${aws_security_group.alb-#cluster_name_hyphenated#.id}"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [#corporte_cidr#]
}

resource "aws_security_group_rule" "alb-#cluster_name_hyphenated#-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.alb-#cluster_name_hyphenated#.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}