resource "aws_iam_instance_profile" "masters-#cluster_name_hyphenated#" {
  name = "masters.#cluster_name#"
  role = "${aws_iam_role.masters-#cluster_name_hyphenated#.name}"
}

resource "aws_iam_instance_profile" "nodes-#cluster_name_hyphenated#" {
  name = "nodes.#cluster_name#"
  role = "${aws_iam_role.nodes-#cluster_name_hyphenated#.name}"
}

resource "aws_iam_role" "masters-#cluster_name_hyphenated#" {
  name               = "masters.#cluster_name#"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.#cluster_name#_policy")}"
}

resource "aws_iam_role" "nodes-#cluster_name_hyphenated#" {
  name               = "nodes.#cluster_name#"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.#cluster_name#_policy")}"
}

resource "aws_iam_role_policy" "masters-#cluster_name_hyphenated#" {
  name   = "masters.#cluster_name#"
  role   = "${aws_iam_role.masters-#cluster_name_hyphenated#.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.#cluster_name#_policy")}"
}

resource "aws_iam_role_policy" "nodes-#cluster_name_hyphenated#" {
  name   = "nodes.#cluster_name#"
  role   = "${aws_iam_role.nodes-#cluster_name_hyphenated#.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.#cluster_name#_policy")}"
}