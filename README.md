# Ansible Execution Environment

This repository contains an Ansible Execution Environment that can be used with either Podman or Docker. It allows you to create and manage an Azure Container Registry (ACR) and run Ansible playbooks.

## Introduction

The Ansible Execution Environment relies on an ACR setup. Please ensure you have an Azure service connection or any necessary credentials to enable access to the ACR. Note that if you are using an arm64 PC, the resulting image won't be compatible with Azure DevOps.

**Note:**
This README assumes you are using CHANGELOG.md, following the conventions of [Keep a Changelog](https://keepachangelog.com/).

## Setup

To set up the Ansible Execution Environment, follow these steps:

1. Install Python3, the Azure CLI, Ansible, and Podman (or Docker) on your system.
2. Add the vault-encoded variables to the `vars.yml` file. Uncomment the required variables and provide the necessary values.
3. For macOS users, perform the following additional steps:
   - Initialize the Podman machine: `podman machine init`.
   - Start the Podman machine: `podman machine start`.
4. Build the image.

## Configuration (vars.yml)

The `vars.yml` file contains the configuration for the Ansible Execution Environment. You can set the following variables:

| Variable          | Description                                                                                      |
|-------------------|--------------------------------------------------------------------------------------------------|
| `subscription_id` | Azure subscription ID.                                                                           |
| `client_secret`   | Azure service principal client secret.                                                           |
| `client_id`       | Azure service principal client ID.                                                               |
| `client_tenant`   | Azure service principal tenant ID.                                                               |
| `resource_group`  | Azure resource group name for the container registry.                                            |
| `location`        | Azure region/location for the container registry.                                                |
| `sku`             | Azure container registry SKU (e.g., Basic, Standard, Premium).                                   |
| `acr_name`        | Name of the Azure container registry.                                                            |
| `build_dir`       | Directory where the Ansible playbook is located.                                                 |
| `image_name`      | Name of the Podman/Docker image to be built.                                                     |
| `image_tag`       | Tag for the Podman/Docker image.                                                                 |

Make sure to provide the necessary values for these variables based on your environment and requirements.

### Create an Azure Service Principle

To create an Azure service principal, run the following command:

```sh
az ad sp create-for-rbac --name "ansible-sp" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} --sdk-auth
```

### Automating your local setup

1. Store the password locally (Do not commit or share publicly!):

```bash
echo "Password" > passwd
```

2. Create vault-encrypted variables

Create Azure service principal secrets and copy the values into the vars section of the azure-setup playbook:

```bash
ansible-vault encrypt_string "client_id" --vault-id passwd
ansible-vault encrypt_string "secret" --vault-id passwd
ansible-vault encrypt_string "tenant" --vault-id passwd
```

## Usage

To use the Ansible Execution Environment, you can follow these examples:

- Build the container locally and use a password file for vault decryption:

```bash
ansible-playbook azure_setup.yml --vault-id passwd --skip-tags acr
```

- Build the container and upload it to the Azure ACR:
```bash
ansible-playbook azure-setup.yml --vault-id passwd
```

Feel free to modify the playbook and the inventory files to suit your specific use cases.

## Changelog

Please refer to the CHANGELOG.md file for information about the latest changes, updates, and release versions.

## Author

- Adam Fordyce (https://github.com/adamfordyce11)
