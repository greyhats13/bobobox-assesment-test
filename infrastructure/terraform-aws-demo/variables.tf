/* ======================= VARIABLE PROVIDER AWS ======================= */
variable "profile_network" {
  description = "AWS User account Profile"
  default     = "network"
}

variable "profile_staging" {
  description = "AWS User account Profile"
  default     = "staging"
}

variable "profile_production" {
  description = "AWS User account Profile"
  default     = "production"
}

variable "region" {
  default = "us-east-2"
}

variable "aws_credentials" {
  default = "./.aws/credentials"
}

/* ======================= END PROVIDER ======================= */

/* ======================= VARIABLE TGW ======================= */

# variable "tgw_description" {
#   default = "exercise Transit Gateway Network"
# }

# variable "amazon_side_asn" {
#   default = 64512
# }

# variable "auto_accept_shared_attachments" {
#   default = "enable"
# }

# variable "default_route_table_association " {
#   default = "enable"
# }

# variable "default_route_table_propagation " {
#   default = "enable"
# }

# variable "dns_support  " {
#   default = "enable"
# }

# variable "vpn_ecmp_support   " {
#   default = "enable"
# }

# variable "tgw_tags" {
#   default = {
#     Name = "TGW Network TF",
#     Env  = "Network"
#   }
# }

/* ======================= END TGW ======================= */

/* ======================= VARIABLE RAM NETWORK ======================= */


/* ======================= END RAM NETWORK ======================= */

/* ======================= VARIABLE VPC ======================= */

variable "apps-cidr" {
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "cache-cidr" {
  default = ["10.10.0.0/28", "10.10.0.16/28", "10.10.0.32/28"]
}

variable "nodes-cidr" {
  default = ["10.43.192.128/28", "10.43.192.144/28", "10.43.192.160/28"]
}

variable "public-cidr" {
  default = ["10.43.192.176/28", "10.43.192.192/28", "10.43.192.208/28"]
}

variable "vpc_name" {
  description = "VPC name"
  default     = "exercise VPC STG"
}

variable "vpc-cidr-block" {
  default = "10.0.0.0/16"
}

variable "eip-nat" {
  default = "eipalloc-0e7833a4e79faa96f"
}

/* ======================= END VPC ======================= */

# variable "key" {
#   description = "Enter Key name"
#   default     = "stg"
# }

variable "sub_ids" {
  default = []
}

variable "instance-ami" {
  default = "ami-0d6bbb3973f07760c" # AMI of Singapore Region
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance-autoscaling-type" {
  default = "m5.large"
}

variable "cluster-name" {
  description = "Cluster Name"
  default     = "exercise-staging-cluster"
}

variable "server-name" {
  description = "Ec2 Server Name"
  default     = "exercise-staging"
}

variable "eip-instance" {
  default = "eipalloc-044ff77e62cd0f5da"
}
/* ======================= VARIABLE REDIS ======================= */
variable "redis-engine" {
  default = "redis"
}

variable "redis-engine-ver" {
  default = "5.0.6"
}

variable "redis-node-type" {
  default = "cache.t2.micro"
}

variable "redis-parameter" {
  default = "default.redis5.0"
}

variable "redis-name" {
  default = "exercise-staging-redis"
}

variable "redis-port" {
  type    = number
  default = 6739
}

variable "redis-subnet-name" {
  default = "cache-staging-group"
}
/* ======================= END REDIS ======================= */

# variable "ecr_name" {
#   type    = list(string)
#   default = [
#     "axis-auth-access",
#     "axis-auth-otp",
#     "axis-auth-profile",
#     "axis-auth-token",
#     "axis-balance",
#     "axis-extras-lockunlock",
#     "axis-notif-inbox",
#     "axis-packages",
#     "axis-promo-pushnotif",
#     "axis-quota",
#     "axis-trans"
#   ]
# }

# variable "image_tag" {
#   default = "MUTABLE"
# }


