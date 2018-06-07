resource "aws_elb" "api-#cluster_name_hyphenated#" {
  name = "api-#cluster_name_trimmed_elb#"

  listener = {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api-elb-#cluster_name_hyphenated#.id}"]
  subnets         = ["${aws_subnet.us-east-2a-#cluster_name_hyphenated#.id}", "${aws_subnet.us-east-2b-#cluster_name_hyphenated#.id}"]

  health_check = {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300

  tags = {
    KubernetesCluster = "#cluster_name#"
    Name              = "api.#cluster_name#"
  }
}