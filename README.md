# Strapi Deployment on AWS using Terraform

This repository contains Terraform configuration to deploy Strapi CMS on AWS EC2 instance.

##  Prerequisites

- AWS Account
- Terraform installed (v1.0+)
- AWS CLI configured with credentials
- SSH key pair created in AWS EC2

##  Architecture

- **VPC**: Custom VPC with public subnet
- **EC2**: t2.micro instance (Free tier eligible)
- **Security Group**: Allows SSH (22), HTTP (80), and Strapi (1337)
- **OS**: Ubuntu 22.04 LTS
- **Application**: Strapi v4 with SQLite database
- **Process Manager**: PM2 for automatic restart

##  Quick Start

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd aws-terraform-strapi
```

### 2. Configure AWS Credentials

```bash
aws configure
```

Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Output format (json)

### 3. Create SSH Key Pair

Go to AWS Console → EC2 → Key Pairs → Create Key Pair
- Name: `strapi-key` (or your choice)
- Download the `.pem` file
- Save it securely

```bash
chmod 400 strapi-key.pem
```

### 4. Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
aws_region     = "us-east-1"
instance_type  = "t2.micro"
ami_id         = "ami-0866a3c8686eaeeba" # Ubuntu 22.04 LTS
key_name       = "strapi-key" # Your SSH key name
strapi_version = "4.25.0"
use_elastic_ip = false
```

### 5. Initialize Terraform

```bash
terraform init
```

### 6. Plan Deployment

```bash
terraform plan
```

### 7. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

### 8. Access Strapi

Wait 5-10 minutes for Strapi to install and start.

Terraform will output:
```
strapi_url = "http://XX.XX.XX.XX:1337"
strapi_admin_url = "http://XX.XX.XX.XX:1337/admin"
```

Visit the admin URL to create your admin account.

##  Project Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── user-data.sh              # EC2 bootstrap script
├── terraform.tfvars.example  # Example variables file
└── README.md                 # This file
```

##  Configuration

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `ami_id` | Ubuntu AMI ID | Region-specific |
| `instance_type` | EC2 instance type | `t2.micro` |
| `key_name` | SSH key pair name | Required |
| `strapi_version` | Strapi version | `4.25.0` |
| `use_elastic_ip` | Allocate Elastic IP | `false` |

### AMI IDs by Region

Ubuntu 22.04 LTS:
- **us-east-1**: `ami-0866a3c8686eaeeba`
- **us-west-2**: `ami-05134c8ef96964280`
- **eu-west-1**: `ami-0d64bb532e0502c46`
- **ap-south-1**: `ami-0dee22c13ea7a9a67`

##  Security

- Security group allows access from `0.0.0.0/0` (all IPs)
- For production, restrict SSH access to your IP:
  ```hcl
  cidr_blocks = ["YOUR_IP/32"]
  ```

##  Management

### SSH into Instance

```bash
ssh -i strapi-key.pem ubuntu@<instance-public-ip>
```

### Check Strapi Status

```bash
sudo su - strapi
pm2 status
pm2 logs strapi
```

### Restart Strapi

```bash
sudo su - strapi
pm2 restart strapi
```

### Stop Strapi

```bash
sudo su - strapi
pm2 stop strapi
```

##  Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted.


##  Troubleshooting

### Issue: Strapi not accessible

**Solution**: Wait 5-10 minutes for installation to complete.

Check logs:
```bash
ssh -i strapi-key.pem ubuntu@<ip>
sudo su - strapi
pm2 logs strapi
```

### Issue: SSH connection refused

**Solution**: 
1. Check security group allows SSH from your IP
2. Verify key pair name matches
3. Ensure `.pem` file has correct permissions (400)

### Issue: Instance not starting

**Solution**:
1. Check AWS service health
2. Verify AMI ID is correct for your region
3. Check AWS quotas/limits

##  Notes

- First deployment takes 5-10 minutes for Strapi installation
- Strapi uses SQLite database (stored on instance)
- For production, consider:
  - Using RDS for database
  - Adding Application Load Balancer
  - Implementing HTTPS with ACM/Let's Encrypt
  - Using Elastic IP for static IP
  - Implementing backups





