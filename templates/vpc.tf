resource "aws_vpc" "#cluster_name_hyphenated#" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "#cluster_name_hyphenated#" {
  domain_name         = "us-east-2.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "#cluster_name_hyphenated#" {
  vpc_id          = "${aws_vpc.#cluster_name_hyphenated#.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.#cluster_name_hyphenated#.id}"
}

resource "aws_route" "all-#cluster_name_hyphenated#" {
  route_table_id         = "${aws_route_table.#cluster_name_hyphenated#.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.#cluster_name_hyphenated#.id}"
}

resource "aws_route_table" "#cluster_name_hyphenated#" {
  vpc_id = "${aws_vpc.#cluster_name_hyphenated#.id}"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
    "kubernetes.io/kops/role"                      = "public"
  }
}