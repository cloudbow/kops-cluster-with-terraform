resource "aws_launch_configuration" "master-us-east-2a-masters-#cluster_name_hyphenated#" {
  name_prefix                 = "master-us-east-2a.masters.#cluster_name#-"
  image_id                    = "${lookup(var.aws_image_id_per_region, var.aws_region)}"
  instance_type               = "${var.aws_master_instance_type}"
  key_name                    = "${aws_key_pair.kubernetes-keypair-#cluster_name_hyphenated#.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-#cluster_name_hyphenated#.id}"
  security_groups             = ["${aws_security_group.masters-#cluster_name_hyphenated#.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-2a.masters.#cluster_name#_user_data")}"

  root_block_device = {
    volume_type           = "${var.aws_disk_type}"
    volume_size           = "${var.aws_master_instance_ebs_size}"
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-#cluster_name_hyphenated#" {
  name_prefix                 = "nodes.#cluster_name#-"
  image_id                    = "${lookup(var.aws_image_id_per_region, var.aws_region)}"
  instance_type               = "${var.aws_node_instance_type}"
  key_name                    = "${aws_key_pair.kubernetes-keypair-#cluster_name_hyphenated#.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-#cluster_name_hyphenated#.id}"
  security_groups             = ["${aws_security_group.nodes-#cluster_name_hyphenated#.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.#cluster_name#_user_data")}"

  root_block_device = {
    volume_type           = "${var.aws_disk_type}"
    volume_size           = "${var.aws_node_instance_ebs_size}"
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}