# DevContainer
This directory contains a `Dockerfile` and `devcontainer.json` file for building and using a Docker image as your development environment.

The `Dockerfile` will build an image with the following software installed:
- AWS CLI v2
- eksctl
- aws-shell
- OpenTofu (1.7)
- terragrunt
- Prowler
- Trivy
- shellcheck
- Docker CE CLI + Compose plugin
- Python 3 + `pip`
- `make`, `wget`, `curl`, `git`


## Pulling the image
To pull the image from the GitHub container registry, use the below command:
```bash
docker pull <insert registry + url here>
```

## Building the Image
To build the image, run the below command:
```bash
# Make sure you're in the .devcontainer folder
cd .devcontainer

# Run the build
docker build . -t the-model-enterprise-dev-container:1.0.0
```

## Pushing the image
If you're a contributor who has made a new dev container image, push it with the below command:
```bash
docker push <insert registry + url here>
```