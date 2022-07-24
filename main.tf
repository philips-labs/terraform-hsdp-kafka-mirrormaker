resource "random_id" "id" {
  byte_length = 8
}

resource "hsdp_container_host" "kafka_connect" {
  count         = var.nodes
  name          = var.host_name == "" ? "mm-${random_id.id.hex}-${count.index}.dev" : "mm-${var.host_name}-${count.index}.${var.tld}"
  iops          = var.iops
  volumes       = 1
  volume_size   = var.volume_size
  instance_type = var.instance_type
  subnet_type   = var.subnet_type

  user_groups     = var.user_groups
  security_groups = ["analytics"]

  lifecycle {
    ignore_changes = [
      volumes,
      volume_size,
      instance_type,
      iops
    ]
  }

  bastion_host = var.bastion_host
  user         = var.user
  private_key  = var.private_key
}

resource "ssh_resource" "cluster" {
  count = var.nodes

  triggers = {
    cluster_instance_ids = join(",", hsdp_container_host.kafka_connect.*.id)
    bash                 = file("${path.module}/scripts/bootstrap-cluster.sh")
  }

  bastion_host = var.bastion_host
  host         = element(hsdp_container_host.kafka_connect.*.private_ip, count.index)
  user         = var.user
  private_key  = var.private_key

  file {
    source      = "${path.module}/scripts/bootstrap-cluster.sh"
    destination = "/home/${var.user}/bootstrap-cluster.sh"
  }

  file {
    source      = var.trust_store.truststore
    destination = "/home/${var.user}/truststore.jks"
  }

  file {
    source      = var.key_store.keystore
    destination = "/home/${var.user}/mm.keystore.jks"
  }

  file {
    source      = var.mm2_properties
    destination = "/home/${var.user}/mm2.properties"
  }

  # Bootstrap script called with private_ip of each node in the cluster
  commands = [
    "docker volume create kafka || true",
    "chmod +x /home/${var.user}/bootstrap-cluster.sh",
    "/home/${var.user}/bootstrap-cluster.sh -d ${var.image} -t ${var.trust_store.password} -k ${var.key_store.password}"
  ]
}
