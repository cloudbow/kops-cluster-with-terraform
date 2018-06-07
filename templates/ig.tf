resource "aws_internet_gateway" "#cluster_name_hyphenated#" {
  vpc_id = "${aws_vpc.#cluster_name_hyphenated#.id}"

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "#cluster_name#"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}
