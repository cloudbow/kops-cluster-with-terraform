resource "aws_ebs_volume" "a-etcd-events-#cluster_name_hyphenated#" {
  availability_zone = "us-east-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "a.etcd-events.#cluster_name#"
    "k8s.io/etcd/events"                           = "a/a"
    "k8s.io/role/master"                           = "1"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}

resource "aws_ebs_volume" "a-etcd-main-#cluster_name_hyphenated#" {
  availability_zone = "us-east-2a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                              = "#cluster_name#"
    Name                                           = "a.etcd-main.#cluster_name#"
    "k8s.io/etcd/main"                             = "a/a"
    "k8s.io/role/master"                           = "1"
    "kubernetes.io/cluster/#cluster_name#" = "owned"
  }
}