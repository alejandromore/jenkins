output "ecs_name" {
  value = var.ecs_public_name
}

output "ecs_public_ip" {
  value = module.eip_ecs_publico.address
}
