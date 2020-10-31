output "kafka_connect_nodes" {
  description = "Container Host IP addresses of Kafka instances"
  value       = hsdp_container_host.kafka_connect.*.private_ip
}

output "kafka_connect_name_nodes" {
  description = "Container Host DNS names of Kafka instances"
  value       = hsdp_container_host.kafka_connect.*.name
}
