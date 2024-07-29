#!/bin/bash
set -e
stage="dev"
region=""
REGION_FLAGS=""
profile=""
PROFILE_FLAGS=""

usage() {
    echo "Usage: ${0} [--help] [--region REGION] [--stage STAGE] [--profile PROFILE]"
    echo ""
    echo "Where:"
    echo "    REGION            The AWS region to create the S3 bucket and Dynamo DB tables"
    echo "    STAGE             The deployment type. Default: ${stage}"
    echo "    PROFILE           The AWS CLI profile to assume when calling AWS CLI v2."
    echo ""
    echo "This script will deploy the cloud formation template at ./bootstrap.yaml to the specified region."
    echo "This bootstrap template has settings to create and configure an S3 Bucket, DynamoDB table, and KMS key for OpenTofu's S3 backend."
    echo "This script requires OpenTofu to be installed and available via the PATH."
    echo ""
}

if [[ "${1}" == "-h" ]] || [[ "${1}" == "--help" ]] || [[ "${1}" == "help" ]]; then
    usage;
    exit 0
fi

while [ $# -gt 0 ]; do
    case ${1} in
        "--profile")
        profile=${2}
        PROFILE_FLAGS="--profile ${profile}"
        shift
        shift
        ;;
        "--region")
        region=${2}
        REGION_FLAGS="--region ${region}"
        shift
        shift
        ;;
        "--stage")
        stage=${2}
        shift
        shift
        ;;
        *) 
        echo "ERROR: Unrecognized option ${1} !"
        usage;
        exit 1;
        ;;
    esac 
done

# Check if open-tofu (tofu) is installed
if ! command -v tofu &> /dev/null
then
    echo "Error: open-tofu (tofu) is not installed. Please install it and try again."
    exit 1
fi

# Check for valid AWS credentials
if ! aws sts get-caller-identity &> /dev/null
then
    echo "Error: Invalid AWS credentials. Please configure your AWS credentials and try again."
    exit 1
fi

if [ ! -d bootstrap ] || [ ! -f bootstrap/bootstrap.yaml ]; then
    echo "Error: This script must be run from the top level directory of this repo!"
    exit 1
fi

stackName="${stage}-open-tofu-remote-backend"

echo "--- CloudFormation deploy ---"
aws cloudformation deploy --template-file ./bootstrap/bootstrap.yaml --stack "$stackName" ${PROFILE_FLAGS} ${REGION_FLAGS}

echo "--- Get S3 bucket & DynamoDB table name for OpenTofu backend ---"
bucket=$(aws cloudformation describe-stacks ${PROFILE_FLAGS} ${REGION_FLAGS} --query "Stacks[?StackName=='$stackName'][].Outputs[?OutputKey=='OpenTofuBackendBucketName'].OutputValue" --output text)
dbtable=$(aws cloudformation describe-stacks ${PROFILE_FLAGS} ${REGION_FLAGS} --query "Stacks[?StackName=='$stackName'][].Outputs[?OutputKey=='OpenTofuBackendDynamoDBName'].OutputValue" --output text)

echo "S3 Bucket: $bucket"
echo "DynamoDB table: $dbtable"

echo "aws_region=\"${region}\"" > tf/terraform.tfvars
echo "state_s3_bucket_name=\"${bucket}\"" >> tf/terraform.tfvars