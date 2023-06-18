# Dockerfile
FROM mcr.microsoft.com/azure-pipelines/vsts-agent

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    gcc \
    make \
    bash \
    sudo \
    nodejs \
    npm \
    yarn

# Install Ansible
RUN pip3 install ansible

RUN ansible-galaxy collection install azure.azcollection
RUN pip3 install --no-cache-dir --prefer-binary azure-cli==2.34.0
RUN pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

# https://docs.ansible.com/ansible/latest/collections/community/general/
RUN ansible-galaxy collection install community.general

WORKDIR /ansible
COPY entry-point.sh /entry-point.sh

# Add /ansible to PATH
ENV PATH="/ansible:${PATH}"

ENTRYPOINT [ "/entry-point.sh" ]
