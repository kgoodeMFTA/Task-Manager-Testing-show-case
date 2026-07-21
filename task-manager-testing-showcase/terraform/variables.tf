variable "aws_region" {
  description = "AWS region to deploy the Task Manager API into."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod). Used for tagging and naming."
  type        = string
  default     = "dev"
}

variable "app_image" {
  description = "Container image for the Task Manager API (e.g. from ECR: <account>.dkr.ecr.<region>.amazonaws.com/task-manager-api:latest)."
  type        = string
  default     = "task-manager-api:latest"
}

variable "container_port" {
  description = "Port the Task Manager API listens on inside the container."
  type        = number
  default     = 3000
}

variable "desired_count" {
  description = "Number of Fargate task replicas to run behind the load balancer."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common tags applied to all resources. Enforced by the Sentinel policy in ./sentinel."
  type        = map(string)
  default = {
    Project     = "task-manager-showcase"
    Owner       = "qa-automation-team"
    Environment = "dev"
  }
}
