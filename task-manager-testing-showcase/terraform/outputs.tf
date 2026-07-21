output "load_balancer_dns_name" {
  description = "Public DNS name of the Application Load Balancer fronting the Task Manager API."
  value       = aws_lb.app.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster running the service."
  value       = aws_ecs_cluster.app.name
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.app.name
}
