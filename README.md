# the-model-enterprise
An OpenTofu template for creating and managing an enterprise in AWS.


## Platform Goals
- User self-service
- Secure
- Web based (ZTNA)
- Autoscale based on schedule and demand
- Serverless when possible
- Offers open source software services to enterprise users

## Setup and Bootstrap
After cloning this repo, make sure that you have an administrative IAM account configured in your AWS CLI and then run the below commands:
```bash
# Make sure you're in the repo
cd the-model-enterprise

# Bootstrap the S3 backend for OpenTofu
./bootstrap/bootstrap.sh [--region REGION] [--profile PROFILE] [--stage STAGE]
```

Supplying `--profile PROFILE` allows you to control the AWS CLI profile to assume when deploying the cloud formation stack.    
Supplying `--region REGION` allows you to override the profile's default region to deploy the cloud formation stack into.

Once you've run the bootstrap script, you can then initialize and deploy with OpenTofu:
```bash
# Enter the OpenTofu directory
cd tf

# Initialize OpenTofu
tofu init

# View resources to be deployed
tofu plan

# Deploy the resources
tofu apply
```

__TODO__: Add steps for pulling and using the dev container