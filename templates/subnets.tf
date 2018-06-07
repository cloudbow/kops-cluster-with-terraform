resource "aws_route_table_association" "us-east-2a-#cluster_name_hyphenated#" {
  subnet_id      = "${aws_subnet.us-east-2a-#cluster_name_hyphenated#.id}"
  route_table_id = "${aws_route_table.#cluster_name_hyphenated#.id}"
}

resource "aws_route_table_association" "us-east-2b-#cluster_name_hyphenated#" {
  subnet_id      = "${aws_subnet.us-east-2b-#cluster_name_hyphenated#.id}"
  route_table_id = "${aws_route_table.#cluster_name_hyphenated#.id}"
}

resource "aws_subnet" "us-east-2a-#cluster_name_hyphenated#" {
  vpc_id            = "${aws_vpc.#cluster_name_hyphenated#.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-east-2a"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "us-east-2a.#cluster_name#"
    SubnetType                                     = "Public"
    "kubernetes.io/cluster/#cluster_name#" = "shared"
    "kubernetes.io/role/alb-ingress"               = ""
    "kubernetes.io/role/elb"                       = "1"
  }
}

resource "aws_subnet" "us-east-2b-#cluster_name_hyphenated#" {
  vpc_id            = "${aws_vpc.#cluster_name_hyphenated#.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "us-east-2b"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "us-east-2b.#cluster_name#"
    SubnetType                                     = "Public"
    "kubernetes.io/cluster/#cluster_name#" = "shared"
    "kubernetes.io/role/alb-ingress"               = ""
    "kubernetes.io/role/elb"                       = "1"
  }
}