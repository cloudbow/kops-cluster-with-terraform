output "cluster_name" {
  value = "#cluster_name#"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-#cluster_name_hyphenated#.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-#cluster_name_hyphenated#.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-#cluster_name_hyphenated#.name}"
}

output "elb_security_group_ids" {
  value = ["${aws_security_group.nodes-#cluster_name_hyphenated#.id}"]
}

output "node_security_group_ids" {
  value = ["${aws_security_group.api-elb-#cluster_name_hyphenated#.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-2a-#cluster_name_hyphenated#.id}", "${aws_subnet.us-east-2b-#cluster_name_hyphenated#.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-#cluster_name_hyphenated#.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-#cluster_name_hyphenated#.name}"
}

output "region" {
  value = "us-east-2"
}

output "vpc_id" {
  value = "${aws_vpc.#cluster_name_hyphenated#.id}"
}

