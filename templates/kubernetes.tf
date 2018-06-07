/* 
 The provider selection . Can we externalize this to another file? or generate it? 
*/
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "kubernetes-keypair-#cluster_name_hyphenated#" {
  key_name   = "kubernetes-keypair-#cluster_name_hyphenated#"
  public_key = "${file("${var.aws_public_key_pem_path}")}"
}

terraform = {
  required_version = ">= 0.9.3"
}
