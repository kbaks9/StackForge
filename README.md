# StackForge

A modular three-tier Azure network architecture provisioned entirely with Terraform. StackForge deploys segmented virtual networks, subnet-specific NSGs, and Linux VMs across web, application, and data tiers, with tightly controlled traffic flows enforced between each layer.

---

## Architecture

![Architecture Diagram](images/01_Architectural_diagram.png)

Traffic flows strictly downward through the tiers. The web tier is the only layer exposed to the internet. App and data VMs have no public IP and are reachable only from the tier directly above them.

| Tier | Subnet | Allowed Inbound |
|---|---|---|
| Web | 10.0.1.0/24 | HTTP (80), HTTPS (443) from Internet; SSH (22) from admin IP only |
| App | 10.0.2.0/24 | TCP 8080 from Web subnet only |
| Data | 10.0.3.0/24 | TCP 1433 from App subnet only |

---

## Features

- Modular Terraform structure with reusable `network`, `nsg`, and `vm` modules
- Three isolated subnets with dedicated NSGs enforcing least-privilege inbound rules
- SSH access to the web tier locked to a single admin IP via `my_ip` variable
- App and data VMs provisioned with no public IP — not reachable from the internet
- VMs deployed via `for_each` for consistent, repeatable provisioning
- ED25519 SSH key authentication; passwords marked `sensitive = true` in variables
- `terraform.tfvars.example` included — no secrets committed to the repo

---

## Module Structure

```
StackForge/
├── main.tf                    # Root config — wires all modules together
├── provider.tf                # AzureRM provider configuration
├── variables.tf               # Input variable declarations
├── terraform.tfvars.example   # Example vars file (no secrets)
├── .gitignore
└── modules/
    ├── network/               # VNet + three subnets
    ├── nsg/                   # Reusable NSG + rules + subnet association
    └── vm/                    # Linux VM + NIC + optional public IP
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3
- An active Azure subscription
- Azure CLI authenticated (`az login`) or a service principal configured
- An SSH key pair at `~/.ssh/id_ed25519`

---

## Getting Started

**1. Clone the repository**

```bash
git clone https://github.com/kbaks9/StackForge.git
cd StackForge
```

**2. Create your tfvars file**

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill in `terraform.tfvars` with your values. Set `my_ip` to your public IP in CIDR notation (e.g. `203.0.113.10/32`) to restrict SSH access to the web tier.

**3. Initialise and apply**

```bash
terraform init
terraform plan
terraform apply
```

---

## Variables

| Variable | Description |
|---|---|
| `resource_group` | Name of the Azure resource group |
| `location` | Azure region (e.g. `uksouth`) |
| `subscription_id` | Azure subscription ID |
| `network_name` | Name of the VNet |
| `vnet_address_space` | VNet CIDR (e.g. `10.0.0.0/16`) |
| `subnet_web_name` | Name for the web subnet |
| `subnet_app_name` | Name for the app subnet |
| `subnet_data_name` | Name for the data subnet |
| `prefix_web` | CIDR for web subnet (e.g. `10.0.1.0/24`) |
| `prefix_app` | CIDR for app subnet (e.g. `10.0.2.0/24`) |
| `prefix_data` | CIDR for data subnet (e.g. `10.0.3.0/24`) |
| `nsg_web_name` | Name of the web NSG |
| `nsg_app_name` | Name of the app NSG |
| `nsg_data_name` | Name of the data NSG |
| `my_ip` | Your public IP in CIDR notation — restricts SSH to admin only |
| `web01_admin_password` | Admin password for vm-web01 (sensitive) |
| `web02_admin_password` | Admin password for vm-web02 (sensitive) |

---

## Deployed Infrastructure

### Resource Group

All resources deployed into a single resource group in UK South.

![Resource Group](images/02_Resource_group.png)

---

### VNet & Subnets

Three isolated subnets provisioned within the VNet, each with 249 available IPs.

![VNet Subnets](images/03_Vnet_subnets.png)

---

### NSG Rules

**NSG Web** — 3 custom inbound rules: SSH restricted to admin IP, HTTP and HTTPS open from the internet.

![NSG Web](images/04_NSG_web.png)

**NSG App** — 1 custom inbound rule: TCP 8080 allowed from the web subnet only.

![NSG App](images/05_NSG_app.png)

**NSG Data** — 1 custom inbound rule: TCP 1433 allowed from the app subnet only.

![NSG Data](images/06_NSG_data.png)

---

### Virtual Machines

Web tier VMs are assigned a public IP via NIC. App and data tier VMs have no public IP.

![VM NIC Connection](images/07_VM_NIC_Connection.png)

![VM Web01 Deployed](images/08_VM_web01_deployed.png)

---

### SSH Access Verified

Successful SSH session into `vm-web01` as user `steve`, confirming end-to-end deployment and NSG rule enforcement.

![SSH into vm-web01](images/09_Vm_ssh.png)

---

## Technologies

- Terraform (HCL)
- Microsoft Azure — VNet, NSG, Linux VM (Ubuntu 22.04), NIC, Public IP
- AzureRM Terraform Provider
- SSH / ED25519 key authentication