## Command to geenrate the docker compose file

## Input is defined in INPUT_SERVER_EP env variable which define the rest layer host
## Input can be one of rest, loader, all

set -xe
### Assumptions

### Assumes that the data dir contains the public key in the format required
### aws_key_pair_kubernetes.{{CLUSTER_NAME}}-{{FINGER_PRINT_WITHOUT_COLON}}_public_key


## Just add the environment variables that is required here. 
## A list can be create by appending TF_VAR_<varname> from variables.tf

echo 'Requirements 

- Install kops from https://github.com/kubernetes/kops (1.9.0)
- Install terraform from terraform site (v0.11.7)
- Install aws cli
- Do aws configure
- Obtain a key pair from aws 
- Save the pem for yourself

'
 

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac
echo ${MACHINE}

if [ "$MACHINE" != "Mac" ] && [ "$MACHINE" != "Linux" ]
then
    echo "Cannot execute in other os"
    exit 1
else
    echo "Running in ${MACHINE}"
fi


## Don't continue if clustername is not given
if [ -z "${CLUSTER_NAME}" ]
then
    echo "ClusterName is required"
    exit 1
else
    echo "Using clustername ${CLUSTER_NAME}"
fi

## Don't continue if clustername is not given
if [ -z "${BASE_PRIVATE_HOSTED_DOMAIN}" ]
then
    echo "Registry Base Host name is required"
    exit 1
else
    echo "Using Base Host name ${BASE_PRIVATE_HOSTED_DOMAIN}"
fi

if [ -z "${DOCKER_REGISTRY_NAME}" ]
then
    echo "Registry name is required"
    exit 1
else
    echo "Using registry name ${DOCKER_REGISTRY_NAME}"
fi

if [ -z "${ARTIFACT_SERVER_NAME}" ]
then
    echo "Artifact server  name"
    exit 1
else
    echo "Using registry name ${ARTIFACT_SERVER_NAME}"
fi

if [ -z "${CORPORATE_CIDR_BLOCKS}" ]
then
    echo "Provide your cidr group correctly. Otherwise you will be attacked"
    exit 1
else
    echo "Using registry name ${CORPORATE_CIDR_BLOCKS}"
fi

## Don't continue if clustername is not given
if [ -z "$1" ]
then
    echo "Please specify the directory to generate the final output"
    echo "The terraform state maintenance will be your responsibility"
    echo "Generally terraform state will be updated in this directory"
    exit 1
else
    echo "Using directory $1"
fi


KOPS_COMMAND=`which kops`
if [ -z "${KOPS_COMMAND}" ]
then
    echo "Install kops from github"
    exit 1
else
    echo "Using kops"
fi

if [ "$MACHINE" == "Mac" ]
then
	GSED_HELP=`gsed --help`
	if [ -z "${GSED_HELP}" ]
	then
	    echo "Install gsed from brew"
	    exit 1
	else
	    echo "Using gsed"
	fi	
else
	alias gsed="sed $@"
	echo "Aliasing sed to gsed"
fi

RENAME_CMD=`which rename`
if [ -z "${RENAME_CMD}" ]
then
    echo "Install rename from brew"
    exit 1
else
    echo "Using rename"
fi

###
GEN_DIR=$1
if [ -z "${GEN_DIR}" ]
then
    echo "Provide the output directory as commandline arg."
    exit 1
else
    echo "Using GEN_DIR ${GEN_DIR}"
fi  

### Delete old files and copy newer one
### Dont change this to rm -rf 
rm -rf "$GEN_DIR/data"


mkdir -p $GEN_DIR/data
cp -r templates/* $GEN_DIR
cd $GEN_DIR



## Replace all cluster name with correct values
FILES=`find . -type f \( ! -iname "terraform.tfstate*"  \)`
while read -r line; do
	gsed -i "s/#cluster_name#/${CLUSTER_NAME}/g" $line
done <<< "$FILES"

## Replace all cluster name hyphenated with correct values
CLUSTER_NAME_HYPHENATED=`echo ${CLUSTER_NAME} | gsed 's/\.k8s\.local/-k8s-local/g'`
while read -r line; do
	gsed -i "s/#cluster_name_hyphenated#/${CLUSTER_NAME_HYPHENATED}/g" $line
done <<< "$FILES"

## Replace all clustername trimmed format
CLUSTER_NAME_HYPHENATED_TRIMMED="$(printf $CLUSTER_NAME_HYPHENATED|cut -c 1-28)"
while read -r line; do
	gsed -i "s/#cluster_name_trimmed_elb#/${CLUSTER_NAME_HYPHENATED_TRIMMED}/g" $line
done <<< "$FILES"

## Replace all docker registry hostnames
DOCKER_REGISTRY_HOST_NAME="${DOCKER_REGISTRY_NAME}.${BASE_PRIVATE_HOSTED_DOMAIN}"
while read -r line; do
    gsed -i "s/#docker_registry_host#/${DOCKER_REGISTRY_HOST_NAME}/g" $line
done <<< "$FILES"

ARTIFACT_SERVER_HOST_NAME="${ARTIFACT_SERVER_NAME}.${BASE_PRIVATE_HOSTED_DOMAIN}"
while read -r line; do
    gsed -i "s/#artifact_server_host#/${ARTIFACT_SERVER_HOST_NAME}/g" $line
done <<< "$FILES"

while read -r line; do
    gsed -i "s/#private_base_host#/${BASE_PRIVATE_HOSTED_DOMAIN}/g" $line
done <<< "$FILES"

while read -r line; do
    gsed -i "s/#corporte_cidr#/${CORPORATE_CIDR_BLOCKS}/g" $line
done <<< "$FILES"

## Replace default region
DEFAULT_REGION="us-east-2"
while read -r line; do
    gsed -i "s/#default_region#/${DEFAULT_REGION}/g" $line
done <<< "$FILES"


## Replace default region
DEFAULT_REGION="us-east-2"
while read -r line; do
    gsed -i "s/#default_region#/${DEFAULT_REGION}/g" $line
done <<< "$FILES"

## Replace all nod einstance types
NODE_INSTANCE_TYPE="m4.large"
while read -r line; do
    gsed -i "s/#default_node_instance_type#/${NODE_INSTANCE_TYPE}/g" $line
done <<< "$FILES"

## Replace all nod einstance types
MASTER_INSTANCE_TYPE="c4.large"
while read -r line; do
    gsed -i "s/#default_master_instance_type#/${MASTER_INSTANCE_TYPE}/g" $line
done <<< "$FILES"



rename 's/#cluster_name#/'$CLUSTER_NAME'/g' data/*.*




## Create S3 state store and generate and update config to S3.
KOPS_S3_BUCKET=k8s-state-${CLUSTER_NAME_HYPHENATED}
export KOPS_STATE_STORE=s3://${KOPS_S3_BUCKET}
if aws s3 ls "s3://${KOPS_S3_BUCKET}" 2>&1 | grep -q 'NoSuchBucket'
then
    aws s3api create-bucket \
        --bucket ${KOPS_S3_BUCKET} \
        --region ${DEFAULT_REGION}
fi

###
echo "Below will remove the state store from s3"
echo "This will mean you cannot edit some things through kops."
read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        aws s3 rm s3://${KOPS_S3_BUCKET} --recursive
        AVAILABILITY_ZONES="us-east-2a,us-east-2b"
        #DEFAULT_NODE_INSTANCE_TYPE#
        FIRST_NODE_COUNT=3
        KUBERNETES_VERSION="1.8.7"
        kops create cluster \
            --zones ${AVAILABILITY_ZONES} \
            --node-size "${NODE_INSTANCE_TYPE}" \
            --master-size "${MASTER_INSTANCE_TYPE}" \
            --kubernetes-version=${KUBERNETES_VERSION} \
            --node-count=${FIRST_NODE_COUNT} \
            ${CLUSTER_NAME}

        kops update cluster ${CLUSTER_NAME} --yes \
        --out=/tmp/terraform-"$(date +%F%T)" \
        --target=terraform

        ##----------Create Docker registry related things ------------###

        ## Create s3 bucket to store root cert 
        ## Remove it first
        cd /tmp
        rm -rf domain.key domain.crt
        ### Create key for docker registry 
        openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 3650 -out domain.crt -subj "/C=US/ST=NY/L=NYC/O=SlingMedia/OU=Backend/CN=registry.sports-cloud.com"
        ### Upload to s3
        STATE_FOLDER="${CLUSTER_NAME}/docker-state"
        mkdir -p /tmp/${STATE_FOLDER}
        mv domain.key /tmp/${STATE_FOLDER}
        mv domain.crt /tmp/${STATE_FOLDER}
        aws s3 sync ${STATE_FOLDER} s3://${KOPS_S3_BUCKET}/${STATE_FOLDER}
        rm -rf /tmp/${STATE_FOLDER}
        ;;
    *)
        echo "Not deleing state store"
        ;;
esac









