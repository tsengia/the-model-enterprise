FROM ghcr.io/opentofu/opentofu:1.7.3
ARG ARCH=amd64
ARG ARCH_ALT=x86_64
ARG NONROOT_USER=vscode
ARG UID=1000
ARG GID=1000
ADD requirements.txt requirements.txt

RUN apk update && \
    # Install apk packages
    apk add --no-cache wget curl make docker-cli docker-cli-compose docker-cli-buildx py3-pip shellcheck aws-cli && \
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

# Setup non-root user and docker access
RUN apk add --no-cache socat

RUN adduser -D -u ${UID} -h /home/${NONROOT_USER} ${NONROOT_USER}

# socat based proxy from these instructions: https://github.com/microsoft/vscode-dev-containers/tree/main/containers/docker-from-docker#final-fallback-socat
# Default to root only access to the Docker socket, set up non-root init script
RUN touch /var/run/docker-host.sock && ln -s /var/run/docker-host.sock /var/run/docker.sock

# Create docker-init.sh to spin up socat
RUN echo "#!/bin/sh\n\
    sudoIf() { if [ \"\$(id -u)\" -ne 0 ]; then sudo \"\$@\"; else \"\$@\"; fi }\n\
    sudoIf rm -rf /var/run/docker.sock\n\
    ((sudoIf socat UNIX-LISTEN:/var/run/docker.sock,fork,mode=660,user=${NONROOT_USER} UNIX-CONNECT:/var/run/docker-host.sock) 2>&1 >> /tmp/vscr-docker-from-docker.log) & > /dev/null\n\
    \"\$@\"" >> /usr/local/share/docker-init.sh \
    && chmod +x /usr/local/share/docker-init.sh

# VS Code overrides ENTRYPOINT and CMD when executing `docker run` by default.
# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]

USER ${NONROOT_USER}
WORKDIR /home/${NONROOT_USER}