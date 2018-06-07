resource "aws_route53_zone" "#cluster_name_hyphenated#" {
  name = "#private_base_host#"
  comment = "#cluster_name# Internal zone"
  vpc_id = "${aws_vpc.#cluster_name_hyphenated#.id}"
  vpc_region = "${var.aws_region}"
}

resource "aws_route53_record" "#cluster_name_hyphenated#-artifact-server" {
  zone_id = "${aws_route53_zone.#cluster_name_hyphenated#.id}"
  name    = "#artifact_server_host#"
  type    = "A"
  ttl     = "300"
  records = ["100.68.16.196"]
}

resource "aws_route53_record" "#cluster_name_hyphenated#-docker-registry-server" {
  zone_id = "${aws_route53_zone.#cluster_name_hyphenated#.id}"
  name    = "#docker_registry_host#"
  type    = "A"
  ttl     = "300"
  records = ["100.69.212.32"]
}