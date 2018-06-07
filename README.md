Running the project
==================

NOTE: DONT RUN THE COMMANDS HERE WITHOUT LOOKING AT last_built_command.sh . 

OTHERWISE YOU MIGHT END UP IN TEARING DOWN THE CLUSTER OR REDUCING ITS CAPACITY 

ALSO UPDATE THE last_built_command.sh ONCE YOU UPDATE THE TERRAFORM IMAGE

# What you get

You get a full k8s cluster of version 1.8.7
Self signed TLS enabled docker registry under registry.xyz.com:5000



## Generate the configuration

Note: CLUSTER_NAME SHOULD END WITH .k8s.local
NOTE: Need to be in bash to run the following

```
OUTPUT_DIR="k8s-cluster"
CORPORATE_CIDR_BLOCKS='"0.0.0.0/0"' \
BASE_PRIVATE_HOSTED_DOMAIN="xyz.com" \
ARTIFACT_SERVER_NAME="artifact-server" \
DOCKER_REGISTRY_NAME="registry" \
CLUSTER_NAME="my-cloud.k8s.local" \
./build.sh ${OUTPUT_DIR}

```
## Run the terraform file
NOTE: DONT RUN THIS COMMAND AS IT IS A TEMPLATE. USE THE last_built_command.sh
```
cd ${OUTPUT_DIR}
terraform init
TF_VAR_aws_node_instance_type="m4.xlarge" \
TF_VAR_aws_node_instance_nos=4  \
TF_VAR_aws_master_instance_nos=1 \
TF_VAR_aws_public_key_pem_path="/Volumes/Data/Documents/backend/projects/docs/aws_key_pair" \
terraform plan

TF_VAR_aws_node_instance_type="m4.xlarge" \
TF_VAR_aws_node_instance_nos=4  \
TF_VAR_aws_master_instance_nos=1 \
TF_VAR_aws_public_key_pem_path="/Volumes/Data/Documents/backend/projects/docs/aws_key_pair" \
terraform apply

```


## Uses

Create as many clusters as you want . 