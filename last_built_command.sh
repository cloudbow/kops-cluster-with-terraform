##-- Build command (RUN ONLY ONCE) ---
OUTPUT_DIR="k8s-cluster"
CORPORATE_CIDR_BLOCKS='"0.0.0.0/0"' \
BASE_PRIVATE_HOSTED_DOMAIN="xyz.com" \
ARTIFACT_SERVER_NAME="artifact-server" \
DOCKER_REGISTRY_NAME="registry" \
CLUSTER_NAME="my-cloud.k8s.local" \
./build.sh ${OUTPUT_DIR}

##-- Following command can be run as and when scale up , scale down is required --
cd ${OUTPUT_DIR}

TF_VAR_aws_node_instance_type="m4.xlarge" \
TF_VAR_aws_node_instance_nos=4  \
TF_VAR_aws_master_instance_nos=1 \
TF_VAR_aws_public_key_pem_path="/Volumes/Data/Documents/backend/projects/docs/aws_key_public_key" \
terraform plan

TF_VAR_aws_node_instance_type="m4.xlarge" \
TF_VAR_aws_node_instance_nos=4  \
TF_VAR_aws_master_instance_nos=1 \
TF_VAR_aws_public_key_pem_path="/Volumes/Data/Documents/backend/projects/docs/aws_key_public_key" \
terraform apply