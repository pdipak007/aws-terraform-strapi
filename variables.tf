variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS (update based on your region)"
  type        = string
  default     = "ami-0866a3c8686eaeeba" # Ubuntu 22.04 LTS in us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" # Free tier eligible
}

variable "key_name" {
  description = "Name of the SSH key pair (must already exist in AWS)"
  type        = string
  default     = ""
}

variable "strapi_version" {
  description = "Strapi version to install"
  type        = string
  default     = "4.25.0"
}

variable "use_elastic_ip" {
  description = "Whether to allocate an Elastic IP"
  type        = bool
  default     = false
}
