FROM ghcr.io/opentofu/opentofu:1.7.3
ARG ARCH=amd64
ARG ARCH_ALT=x86_64
ARG NONROOT_USER=vscode
ARG UID=1000
ARG GID=1000
ADD requirements.txt requirements.txt

RUN apk update && \
    # Install apk packages
    apk add --no-cache wget curl make py3-pip shellcheck aws-cli && \
    # Upgrade pip to the latest
    pip install --upgrade pip

# Download eksctl
RUN curl -LO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz" && \
    # Verify eksctl checksum
    curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "Linux_${ARCH}" | sha256sum -c && \
    # Extract and install eksctl
    tar -xzf "eksctl_Linux_${ARCH}.tar.gz" -C /tmp && rm eksctl_*.tar.gz && \
    mv /tmp/eksctl /usr/bin

# Install aws-shell and prowler via pip
RUN pip install -r requirements.txt

# Download and install Trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.53.0

# Download and install terragrunt
RUN curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v0.64.1/terragrunt_linux_${ARCH} && \
    mv terragrunt_linux_${ARCH} /usr/bin/terragrunt && \
    chmod +x /usr/bin/terragrunt

# Remove the requirements.txt file we added earlier
RUN rm requirements.txt

# Setup non-root user
RUN adduser -D -u ${UID} -h /home/${NONROOT_USER} ${NONROOT_USER}

USER ${NONROOT_USER}
WORKDIR /home/${NONROOT_USER}