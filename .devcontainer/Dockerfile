FROM ubuntu:noble
ARG ARCH=amd64
ARG ARCH_ALT=x86_64
ARG NONROOT_USER=ubuntu
ADD requirements.txt requirements.txt

RUN apt-get update && \
    # Install apk packages
    apt-get install -y --no-install-recommends \
        apt-transport-https ca-certificates gnupg wget curl unzip make python3-pip shellcheck && \
    # Install opentofu
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://get.opentofu.org/opentofu.gpg | tee /etc/apt/keyrings/opentofu.gpg >/dev/null && \
    curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null &&\
    chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main \
    deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
    tee /etc/apt/sources.list.d/opentofu.list > /dev/null && \
    chmod a+r /etc/apt/sources.list.d/opentofu.list && \
    apt-get update && apt-get install -y --no-install-recommends tofu &&\
    # Clean up
    apt-get clean && rm -rf /var/apt/cache /tmp/*

# Install AWS CLI v3
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip && \
    ./aws/install

# Download eksctl
RUN curl -LO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${ARCH}.tar.gz" && \
    # Verify eksctl checksum
    curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "Linux_${ARCH}" | sha256sum -c && \
    # Extract and install eksctl
    tar -xzf "eksctl_Linux_${ARCH}.tar.gz" -C /tmp && rm eksctl_*.tar.gz && \
    mv /tmp/eksctl /usr/bin

# Install aws-shell and prowler via pip
RUN pip install --break-system-packages -r requirements.txt

# Download and install Trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.53.0

# Download and install terragrunt
RUN curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v0.64.1/terragrunt_linux_${ARCH} && \
    mv terragrunt_linux_${ARCH} /usr/bin/terragrunt && \
    chmod +x /usr/bin/terragrunt

# Remove the requirements.txt file we added earlier
RUN rm requirements.txt

USER ${NONROOT_USER}
WORKDIR /home/${NONROOT_USER}